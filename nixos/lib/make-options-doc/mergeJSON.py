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
import re
from xml.sax.saxutils import escape, quoteattr

JSON = Dict[str, Any]

class Key:
    def __init__(self, path: List[str]):
        self.path = path
    def __hash__(self):
        result = 0
        for id in self.path:
            result ^= hash(id)
        return result
    def __eq__(self, other):
        return type(self) is type(other) and self.path == other.path

Option = collections.namedtuple('Option', ['name', 'value'])

# pivot a dict of options keyed by their display name to a dict keyed by their path
def pivot(options: Dict[str, JSON]) -> Dict[Key, Option]:
    result: Dict[Key, Option] = dict()
    for (name, opt) in options.items():
        result[Key(opt['loc'])] = Option(name, opt)
    return result

# pivot back to indexed-by-full-name
# like the docbook build we'll just fail if multiple options with differing locs
# render to the same option name.
def unpivot(options: Dict[Key, Option]) -> Dict[str, JSON]:
    result: Dict[str, Dict] = dict()
    for (key, opt) in options.items():
        if opt.name in result:
            raise RuntimeError(
                'multiple options with colliding ids found',
                opt.name,
                result[opt.name]['loc'],
                opt.value['loc'],
            )
        result[opt.name] = opt.value
    return result

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
    def convertString(path: str, text: str) -> str:
        try:
            rendered = md.render(text)
            return rendered
        except:
            print(f"error in {path}")
            raise

    def optionIs(option: Dict[str, Any], key: str, typ: str) -> bool:
        if key not in option: return False
        if type(option[key]) != dict: return False
        if '_type' not in option[key]: return False
        return option[key]['_type'] == typ

    def convertCode(name: str, option: Dict[str, Any], key: str):
        rendered = f"{key}-db"
        if optionIs(option, key, 'literalMD'):
            option[rendered] = convertString(name, f"*{key.capitalize()}:*\n{option[key]['text']}")
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
            option[rendered] = convertString(name, f"*{key.capitalize()}:*\n{code}")
        elif optionIs(option, key, 'literalDocBook'):
            option[rendered] = f"<para><emphasis>{key.capitalize()}:</emphasis> {option[key]['text']}</para>"
        elif key in option:
            raise Exception(f"{name} {key} has unrecognized type", option[key])

    for (name, option) in options.items():
        try:
            if optionIs(option, 'description', 'mdDoc'):
                option['description'] = convertString(name, option['description']['text'])
            elif markdownByDefault:
                option['description'] = convertString(name, option['description'])
            else:
                option['description'] = ("<nixos:option-description><para>" +
                                         option['description'] +
                                         "</para></nixos:option-description>")

            convertCode(name, option, 'example')
            convertCode(name, option, 'default')

            if 'relatedPackages' in option:
                option['relatedPackages'] = convertString(name, option['relatedPackages'])
        except Exception as e:
            raise Exception(f"Failed to render option {name}: {str(e)}")


    return options

warningsAreErrors = False
warnOnDocbook = False
errorOnDocbook = False
markdownByDefault = False
optOffset = 0
for arg in sys.argv[1:]:
    if arg == "--warnings-are-errors":
        optOffset += 1
        warningsAreErrors = True
    if arg == "--warn-on-docbook":
        optOffset += 1
        warnOnDocbook = True
    elif arg == "--error-on-docbook":
        optOffset += 1
        errorOnDocbook = True
    if arg == "--markdown-by-default":
        optOffset += 1
        markdownByDefault = True

options = pivot(json.load(open(sys.argv[1 + optOffset], 'r')))
overrides = pivot(json.load(open(sys.argv[2 + optOffset], 'r')))

# fix up declaration paths in lazy options, since we don't eval them from a full nixpkgs dir
for (k, v) in options.items():
    # The _module options are not declared in nixos/modules
    if v.value['loc'][0] != "_module":
        v.value['declarations'] = list(map(lambda s: f'nixos/modules/{s}' if isinstance(s, str) else s, v.value['declarations']))

# merge both descriptions
for (k, v) in overrides.items():
    cur = options.setdefault(k, v).value
    for (ok, ov) in v.value.items():
        if ok == 'declarations':
            decls = cur[ok]
            for d in ov:
                if d not in decls:
                    decls += [d]
        elif ok == "type":
            # ignore types of placeholder options
            if ov != "_unspecified" or cur[ok] == "_unspecified":
                cur[ok] = ov
        elif ov is not None or cur.get(ok, None) is None:
            cur[ok] = ov

severity = "error" if warningsAreErrors else "warning"

def is_docbook(o, key):
    val = o.get(key, {})
    if not isinstance(val, dict):
        return False
    return val.get('_type', '') == 'literalDocBook'

# check that every option has a description
hasWarnings = False
hasErrors = False
hasDocBook = False
for (k, v) in options.items():
    if warnOnDocbook or errorOnDocbook:
        kind = "error" if errorOnDocbook else "warning"
        if isinstance(v.value.get('description', {}), str):
            hasErrors |= errorOnDocbook
            hasDocBook = True
            print(
                f"\x1b[1;31m{kind}: option {v.name} description uses DocBook\x1b[0m",
                file=sys.stderr)
        elif is_docbook(v.value, 'defaultText'):
            hasErrors |= errorOnDocbook
            hasDocBook = True
            print(
                f"\x1b[1;31m{kind}: option {v.name} default uses DocBook\x1b[0m",
                file=sys.stderr)
        elif is_docbook(v.value, 'example'):
            hasErrors |= errorOnDocbook
            hasDocBook = True
            print(
                f"\x1b[1;31m{kind}: option {v.name} example uses DocBook\x1b[0m",
                file=sys.stderr)

    if v.value.get('description', None) is None:
        hasWarnings = True
        print(f"\x1b[1;31m{severity}: option {v.name} has no description\x1b[0m", file=sys.stderr)
        v.value['description'] = "This option has no description."
    if v.value.get('type', "unspecified") == "unspecified":
        hasWarnings = True
        print(
            f"\x1b[1;31m{severity}: option {v.name} has no type. Please specify a valid type, see " +
            "https://nixos.org/manual/nixos/stable/index.html#sec-option-types\x1b[0m", file=sys.stderr)

if hasDocBook:
    (why, what) = (
        ("disallowed for in-tree modules", "contribution") if errorOnDocbook
        else ("deprecated for option documentation", "module")
    )
    print("Explanation: The documentation contains descriptions, examples, or defaults written in DocBook. " +
        "NixOS is in the process of migrating from DocBook to Markdown, and " +
        f"DocBook is {why}. To change your {what} to "+
        "use Markdown, apply mdDoc and literalMD and use the *MD variants of option creation " +
        "functions where they are available. For example:\n" +
        "\n" +
        "  example.foo = mkOption {\n" +
        "    description = lib.mdDoc ''your description'';\n" +
        "    defaultText = lib.literalMD ''your description of default'';\n" +
        "  };\n" +
        "\n" +
        "  example.enable = mkEnableOption (lib.mdDoc ''your thing'');\n" +
        "  example.package = mkPackageOptionMD pkgs \"your-package\" {};\n" +
        "  imports = [ (mkAliasOptionModuleMD [ \"example\" \"args\" ] [ \"example\" \"settings\" ]) ];",
        file = sys.stderr)
    with open(os.getenv('TOUCH_IF_DB'), 'x'):
        # just make sure it exists
        pass

if hasErrors:
    sys.exit(1)
if hasWarnings and warningsAreErrors:
    print(
        "\x1b[1;31m" +
        "Treating warnings as errors. Set documentation.nixos.options.warningsAreErrors " +
        "to false to ignore these warnings." +
        "\x1b[0m",
        file=sys.stderr)
    sys.exit(1)

json.dump(convertMD(unpivot(options)), fp=sys.stdout)
