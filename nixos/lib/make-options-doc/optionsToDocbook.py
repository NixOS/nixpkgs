import collections
import json
import os
import sys
from typing import Any, Dict, List
from collections.abc import MutableMapping, Sequence
import inspect

# for MD conversion
import markdown_it
import markdown_it.renderer
from markdown_it.token import Token
from markdown_it.utils import OptionsDict
from mdit_py_plugins.container import container_plugin
from mdit_py_plugins.deflist import deflist_plugin
from mdit_py_plugins.myst_role import myst_role_plugin
from xml.sax.saxutils import escape, quoteattr

manpage_urls = json.load(open(os.getenv('MANPAGE_URLS')))

class Renderer(markdown_it.renderer.RendererProtocol):
    __output__ = "docbook"
    def __init__(self, parser=None):
        self.rules = {
            k: v
            for k, v in inspect.getmembers(self, predicate=inspect.ismethod)
            if not (k.startswith("render") or k.startswith("_"))
        } | {
            "container_{.note}_open": self._note_open,
            "container_{.note}_close": self._note_close,
            "container_{.important}_open": self._important_open,
            "container_{.important}_close": self._important_close,
            "container_{.warning}_open": self._warning_open,
            "container_{.warning}_close": self._warning_close,
        }
    def render(self, tokens: Sequence[Token], options: OptionsDict, env: MutableMapping) -> str:
        assert '-link-tag-stack' not in env
        env['-link-tag-stack'] = []
        assert '-deflist-stack' not in env
        env['-deflist-stack'] = []
        def do_one(i, token):
            if token.type == "inline":
                assert token.children is not None
                return self.renderInline(token.children, options, env)
            elif token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i, options, env)
            else:
                raise NotImplementedError("md token not supported yet", token)
        return "".join(map(lambda arg: do_one(*arg), enumerate(tokens)))
    def renderInline(self, tokens: Sequence[Token], options: OptionsDict, env: MutableMapping) -> str:
        # HACK to support docbook links and xrefs. link handling is only necessary because the docbook
        # manpage stylesheet converts - in urls to a mathematical minus, which may be somewhat incorrect.
        for i, token in enumerate(tokens):
            if token.type != 'link_open':
                continue
            token.tag = 'link'
            # turn [](#foo) into xrefs
            if token.attrs['href'][0:1] == '#' and tokens[i + 1].type == 'link_close':
                token.tag = "xref"
            # turn <x> into links without contents
            if tokens[i + 1].type == 'text' and tokens[i + 1].content == token.attrs['href']:
                tokens[i + 1].content = ''

        def do_one(i, token):
            if token.type in self.rules:
                return self.rules[token.type](tokens[i], tokens, i, options, env)
            else:
                raise NotImplementedError("md node not supported yet", token)
        return "".join(map(lambda arg: do_one(*arg), enumerate(tokens)))

    def text(self, token, tokens, i, options, env):
        return escape(token.content)
    def paragraph_open(self, token, tokens, i, options, env):
        return "<para>"
    def paragraph_close(self, token, tokens, i, options, env):
        return "</para>"
    def hardbreak(self, token, tokens, i, options, env):
        return "<literallayout>\n</literallayout>"
    def softbreak(self, token, tokens, i, options, env):
        # should check options.breaks() and emit hard break if so
        return "\n"
    def code_inline(self, token, tokens, i, options, env):
        return f"<literal>{escape(token.content)}</literal>"
    def code_block(self, token, tokens, i, options, env):
        return f"<programlisting>{escape(token.content)}</programlisting>"
    def link_open(self, token, tokens, i, options, env):
        env['-link-tag-stack'].append(token.tag)
        (attr, start) = ('linkend', 1) if token.attrs['href'][0] == '#' else ('xlink:href', 0)
        return f"<{token.tag} {attr}={quoteattr(token.attrs['href'][start:])}>"
    def link_close(self, token, tokens, i, options, env):
        return f"</{env['-link-tag-stack'].pop()}>"
    def list_item_open(self, token, tokens, i, options, env):
        return "<listitem>"
    def list_item_close(self, token, tokens, i, options, env):
        return "</listitem>\n"
    # HACK open and close para for docbook change size. remove soon.
    def bullet_list_open(self, token, tokens, i, options, env):
        return "<para><itemizedlist>\n"
    def bullet_list_close(self, token, tokens, i, options, env):
        return "\n</itemizedlist></para>"
    def em_open(self, token, tokens, i, options, env):
        return "<emphasis>"
    def em_close(self, token, tokens, i, options, env):
        return "</emphasis>"
    def strong_open(self, token, tokens, i, options, env):
        return "<emphasis role=\"strong\">"
    def strong_close(self, token, tokens, i, options, env):
        return "</emphasis>"
    def fence(self, token, tokens, i, options, env):
        info = f" language={quoteattr(token.info)}" if token.info != "" else ""
        return f"<programlisting{info}>{escape(token.content)}</programlisting>"
    def blockquote_open(self, token, tokens, i, options, env):
        return "<para><blockquote>"
    def blockquote_close(self, token, tokens, i, options, env):
        return "</blockquote></para>"
    def _note_open(self, token, tokens, i, options, env):
        return "<para><note>"
    def _note_close(self, token, tokens, i, options, env):
        return "</note></para>"
    def _important_open(self, token, tokens, i, options, env):
        return "<para><important>"
    def _important_close(self, token, tokens, i, options, env):
        return "</important></para>"
    def _warning_open(self, token, tokens, i, options, env):
        return "<para><warning>"
    def _warning_close(self, token, tokens, i, options, env):
        return "</warning></para>"
    # markdown-it emits tokens based on the html syntax tree, but docbook is
    # slightly different. html has <dl>{<dt/>{<dd/>}}</dl>,
    # docbook has <variablelist>{<varlistentry><term/><listitem/></varlistentry>}<variablelist>
    # we have to reject multiple definitions for the same term for time being.
    def dl_open(self, token, tokens, i, options, env):
        env['-deflist-stack'].append({})
        return "<para><variablelist>"
    def dl_close(self, token, tokens, i, options, env):
        env['-deflist-stack'].pop()
        return "</variablelist></para>"
    def dt_open(self, token, tokens, i, options, env):
        env['-deflist-stack'][-1]['has-dd'] = False
        return "<varlistentry><term>"
    def dt_close(self, token, tokens, i, options, env):
        return "</term>"
    def dd_open(self, token, tokens, i, options, env):
        if env['-deflist-stack'][-1]['has-dd']:
            raise Exception("multiple definitions per term not supported")
        env['-deflist-stack'][-1]['has-dd'] = True
        return "<listitem>"
    def dd_close(self, token, tokens, i, options, env):
        return "</listitem></varlistentry>"
    def myst_role(self, token, tokens, i, options, env):
        if token.meta['name'] == 'command':
            return f"<command>{escape(token.content)}</command>"
        if token.meta['name'] == 'file':
            return f"<filename>{escape(token.content)}</filename>"
        if token.meta['name'] == 'var':
            return f"<varname>{escape(token.content)}</varname>"
        if token.meta['name'] == 'env':
            return f"<envar>{escape(token.content)}</envar>"
        if token.meta['name'] == 'option':
            return f"<option>{escape(token.content)}</option>"
        if token.meta['name'] == 'manpage':
            [page, section] = [ s.strip() for s in token.content.rsplit('(', 1) ]
            section = section[:-1]
            man = f"{page}({section})"
            title = f"<refentrytitle>{escape(page)}</refentrytitle>"
            vol = f"<manvolnum>{escape(section)}</manvolnum>"
            ref = f"<citerefentry>{title}{vol}</citerefentry>"
            if man in manpage_urls:
                return f"<link xlink:href={quoteattr(manpage_urls[man])}>{ref}</link>"
            else:
                return ref
        raise NotImplementedError("md node not supported yet", token)

md = (
    markdown_it.MarkdownIt(renderer_cls=Renderer)
    # TODO maybe fork the plugin and have only a single rule for all?
    .use(container_plugin, name="{.note}")
    .use(container_plugin, name="{.important}")
    .use(container_plugin, name="{.warning}")
    .use(deflist_plugin)
    .use(myst_role_plugin)
)

# converts in-place!
def convertMD(options: Dict[str, Any]) -> str:
    def optionIs(option: Dict[str, Any], key: str, typ: str) -> bool:
        if key not in option: return False
        if type(option[key]) != dict: return False
        if '_type' not in option[key]: return False
        return option[key]['_type'] == typ

    def convertCode(name: str, option: Dict[str, Any], key: str):
        if optionIs(option, key, 'literalMD'):
            option[key] = md.render(f"*{key.capitalize()}:*\n{option[key]['text']}")
        elif optionIs(option, key, 'literalExpression'):
            code = option[key]['text']
            # for multi-line code blocks we only have to count ` runs at the beginning
            # of a line, but this is much easier.
            multiline = '\n' in code
            longest, current = (0, 0)
            for c in code:
                current = current + 1 if c == '`' else 0
                longest = max(current, longest)
            # inline literals need a space to separate ticks from content, code blocks
            # need newlines. inline literals need one extra tick, code blocks need three.
            ticks, sep = ('`' * (longest + (3 if multiline else 1)), '\n' if multiline else ' ')
            code = f"{ticks}{sep}{code}{sep}{ticks}"
            option[key] = md.render(f"*{key.capitalize()}:*\n{code}")
        elif optionIs(option, key, 'literalDocBook'):
            option[key] = f"<para><emphasis>{key.capitalize()}:</emphasis> {option[key]['text']}</para>"
        elif key in option:
            raise Exception(f"{name} {key} has unrecognized type", option[key])

    for (name, option) in options.items():
        try:
            if optionIs(option, 'description', 'mdDoc'):
                option['description'] = md.render(option['description']['text'])
            elif markdownByDefault:
                option['description'] = md.render(option['description'])
            else:
                option['description'] = ("<nixos:option-description><para>" +
                                         option['description'] +
                                         "</para></nixos:option-description>")

            convertCode(name, option, 'example')
            convertCode(name, option, 'default')

            if 'relatedPackages' in option:
                option['relatedPackages'] = md.render(option['relatedPackages'])
        except Exception as e:
            raise Exception(f"Failed to render option {name}") from e

    return options

id_translate_table = {
    ord('*'): ord('_'),
    ord('<'): ord('_'),
    ord(' '): ord('_'),
    ord('>'): ord('_'),
    ord('['): ord('_'),
    ord(']'): ord('_'),
    ord(':'): ord('_'),
    ord('"'): ord('_'),
}

def need_env(n):
    if n not in os.environ:
        raise RuntimeError("required environment variable not set", n)
    return os.environ[n]

OTD_REVISION = need_env('OTD_REVISION')
OTD_DOCUMENT_TYPE = need_env('OTD_DOCUMENT_TYPE')
OTD_VARIABLE_LIST_ID = need_env('OTD_VARIABLE_LIST_ID')
OTD_OPTION_ID_PREFIX = need_env('OTD_OPTION_ID_PREFIX')

def print_decl_def(header, locs):
    print(f"""<para><emphasis>{header}:</emphasis></para>""")
    print(f"""<simplelist>""")
    for loc in locs:
        # locations can be either plain strings (specific to nixpkgs), or attrsets
        # { name = "foo/bar.nix"; url = "https://github.com/....."; }
        if isinstance(loc, str):
            # Hyperlink the filename either to the NixOS github
            # repository (if it’s a module and we have a revision number),
            # or to the local filesystem.
            if not loc.startswith('/'):
                if OTD_REVISION == 'local':
                    href = f"https://github.com/NixOS/nixpkgs/blob/master/{loc}"
                else:
                    href = f"https://github.com/NixOS/nixpkgs/blob/{OTD_REVISION}/{loc}"
            else:
                href = f"file://{loc}"
            # Print the filename and make it user-friendly by replacing the
            # /nix/store/<hash> prefix by the default location of nixos
            # sources.
            if not loc.startswith('/'):
                name = f"<nixpkgs/{loc}>"
            elif loc.contains('nixops') and loc.contains('/nix/'):
                name = f"<nixops/{loc[loc.find('/nix/') + 5:]}>"
            else:
                name = loc
            print(f"""<member><filename xlink:href={quoteattr(href)}>""")
            print(escape(name))
            print(f"""</filename></member>""")
        else:
            href = f" xlink:href={quoteattr(loc['url'])}" if 'url' in loc else ""
            print(f"""<member><filename{href}>{escape(loc['name'])}</filename></member>""")
    print(f"""</simplelist>""")

markdownByDefault = False
optOffset = 0
for arg in sys.argv[1:]:
    if arg == "--markdown-by-default":
        optOffset += 1
        markdownByDefault = True

options = convertMD(json.load(open(sys.argv[1 + optOffset], 'r')))

keys = list(options.keys())
keys.sort(key=lambda opt: [ (0 if p.startswith("enable") else 1 if p.startswith("package") else 2, p)
                            for p in options[opt]['loc'] ])

print(f"""<?xml version="1.0" encoding="UTF-8"?>""")
if OTD_DOCUMENT_TYPE == 'appendix':
    print("""<appendix xmlns="http://docbook.org/ns/docbook" xml:id="appendix-configuration-options">""")
    print("""  <title>Configuration Options</title>""")
print(f"""<variablelist xmlns:xlink="http://www.w3.org/1999/xlink"
                        xmlns:nixos="tag:nixos.org"
                        xmlns="http://docbook.org/ns/docbook"
             xml:id="{OTD_VARIABLE_LIST_ID}">""")

for name in keys:
    opt = options[name]
    id = OTD_OPTION_ID_PREFIX + name.translate(id_translate_table)
    print(f"""<varlistentry>""")
    # NOTE adding extra spaces here introduces spaces into xref link expansions
    print(f"""<term xlink:href={quoteattr("#" + id)} xml:id={quoteattr(id)}>""", end='')
    print(f"""<option>{escape(name)}</option>""", end='')
    print(f"""</term>""")
    print(f"""<listitem>""")
    print(opt['description'])
    if typ := opt.get('type'):
        ro = " <emphasis>(read only)</emphasis>" if opt.get('readOnly', False) else ""
        print(f"""<para><emphasis>Type:</emphasis> {escape(typ)}{ro}</para>""")
    if default := opt.get('default'):
        print(default)
    if example := opt.get('example'):
        print(example)
    if related := opt.get('relatedPackages'):
        print(f"""<para>""")
        print(f"""  <emphasis>Related packages:</emphasis>""")
        print(f"""</para>""")
        print(related)
    if decl := opt.get('declarations'):
        print_decl_def("Declared by", decl)
    if defs := opt.get('definitions'):
        print_decl_def("Defined by", defs)
    print(f"""</listitem>""")
    print(f"""</varlistentry>""")

print("""</variablelist>""")
if OTD_DOCUMENT_TYPE == 'appendix':
    print("""</appendix>""")
