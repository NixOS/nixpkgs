from __future__ import annotations

import argparse
import html
import json
import xml.sax.saxutils as xml

from abc import abstractmethod
from collections.abc import Mapping, Sequence
from markdown_it.token import Token
from pathlib import Path
from typing import Any, Generic, Optional
from urllib.parse import quote


from . import md
from . import parallel
from .asciidoc import AsciiDocRenderer, asciidoc_escape
from .commonmark import CommonMarkRenderer
from .html import HTMLRenderer
from .manpage import ManpageRenderer, man_escape
from .manual_structure import make_xml_id, XrefTarget
from .md import Converter, md_escape, md_make_code
from .types import OptionLoc, Option, RenderedOption, AnchorStyle

def option_is(option: Option, key: str, typ: str) -> Optional[dict[str, str]]:
    if key not in option:
        return None
    if type(option[key]) != dict:
        return None
    if option[key].get('_type') != typ: # type: ignore[union-attr]
        return None
    return option[key] # type: ignore[return-value]

class BaseConverter(Converter[md.TR], Generic[md.TR]):
    __option_block_separator__: str

    _options: dict[str, RenderedOption]

    def __init__(self, revision: str):
        super().__init__()
        self._options = {}
        self._revision = revision

    def _sorted_options(self) -> list[tuple[str, RenderedOption]]:
        keys = list(self._options.keys())
        keys.sort(key=lambda opt: [ (0 if p.startswith("enable") else 1 if p.startswith("package") else 2, p)
                                    for p in self._options[opt].loc ])
        return [ (k, self._options[k]) for k in keys ]

    def _format_decl_def_loc(self, loc: OptionLoc) -> tuple[Optional[str], str]:
        # locations can be either plain strings (specific to nixpkgs), or attrsets
        # { name = "foo/bar.nix"; url = "https://github.com/....."; }
        if isinstance(loc, str):
            # Hyperlink the filename either to the NixOS github
            # repository (if it’s a module and we have a revision number),
            # or to the local filesystem.
            if not loc.startswith('/'):
                if self._revision == 'local':
                    href = f"https://github.com/NixOS/nixpkgs/blob/master/{loc}"
                else:
                    href = f"https://github.com/NixOS/nixpkgs/blob/{self._revision}/{loc}"
            else:
                href = f"file://{loc}"
            # Print the filename and make it user-friendly by replacing the
            # /nix/store/<hash> prefix by the default location of nixos
            # sources.
            if not loc.startswith('/'):
                name = f"<nixpkgs/{loc}>"
            elif 'nixops' in loc and '/nix/' in loc:
                name = f"<nixops/{loc[loc.find('/nix/') + 5:]}>"
            else:
                name = loc
            return (href, name)
        else:
            return (loc['url'] if 'url' in loc else None, loc['name'])

    @abstractmethod
    def _decl_def_header(self, header: str) -> list[str]: raise NotImplementedError()

    @abstractmethod
    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]: raise NotImplementedError()

    @abstractmethod
    def _decl_def_footer(self) -> list[str]: raise NotImplementedError()

    def _render_decl_def(self, header: str, locs: list[OptionLoc]) -> list[str]:
        result = []
        result += self._decl_def_header(header)
        for loc in locs:
            href, name = self._format_decl_def_loc(loc)
            result += self._decl_def_entry(href, name)
        result += self._decl_def_footer()
        return result

    def _render_code(self, option: Option, key: str) -> list[str]:
        if lit := option_is(option, key, 'literalMD'):
            return [ self._render(f"*{key.capitalize()}:*\n{lit['text']}") ]
        elif lit := option_is(option, key, 'literalExpression'):
            code = md_make_code(lit['text'])
            return [ self._render(f"*{key.capitalize()}:*\n{code}") ]
        elif key in option:
            raise Exception(f"{key} has unrecognized type", option[key])
        else:
            return []

    def _render_description(self, desc: str | dict[str, str]) -> list[str]:
        if isinstance(desc, str):
            return [ self._render(desc) ] if desc else []
        elif isinstance(desc, dict) and desc.get('_type') == 'mdDoc':
            return [ self._render(desc['text']) ] if desc['text'] else []
        else:
            raise Exception("description has unrecognized type", desc)

    @abstractmethod
    def _related_packages_header(self) -> list[str]: raise NotImplementedError()

    def _convert_one(self, option: dict[str, Any]) -> list[str]:
        blocks: list[list[str]] = []

        if desc := option.get('description'):
            blocks.append(self._render_description(desc))
        if typ := option.get('type'):
            ro = " *(read only)*" if option.get('readOnly', False) else ""
            blocks.append([ self._render(f"*Type:*\n{md_escape(typ)}{ro}") ])

        if option.get('default'):
            blocks.append(self._render_code(option, 'default'))
        if option.get('example'):
            blocks.append(self._render_code(option, 'example'))

        if related := option.get('relatedPackages'):
            blocks.append(self._related_packages_header())
            blocks[-1].append(self._render(related))
        if decl := option.get('declarations'):
            blocks.append(self._render_decl_def("Declared by", decl))
        if defs := option.get('definitions'):
            blocks.append(self._render_decl_def("Defined by", defs))

        for part in [ p for p in blocks[0:-1] if p ]:
            part.append(self.__option_block_separator__)

        return [ l for part in blocks for l in part ]

    # this could return a TState parameter, but that does not allow dependent types and
    # will cause headaches when using BaseConverter as a type bound anywhere. Any is the
    # next best thing we can use, and since this is internal it will be mostly safe.
    @abstractmethod
    def _parallel_render_prepare(self) -> Any: raise NotImplementedError()
    # this should return python 3.11's Self instead to ensure that a prepare+finish
    # round-trip ends up with an object of the same type. for now we'll use BaseConverter
    # since it's good enough so far.
    @classmethod
    @abstractmethod
    def _parallel_render_init_worker(cls, a: Any) -> BaseConverter[md.TR]: raise NotImplementedError()

    def _render_option(self, name: str, option: dict[str, Any]) -> RenderedOption:
        try:
            return RenderedOption(option['loc'], self._convert_one(option))
        except Exception as e:
            raise Exception(f"Failed to render option {name}") from e

    @classmethod
    def _parallel_render_step(cls, s: BaseConverter[md.TR], a: Any) -> RenderedOption:
        return s._render_option(*a)

    def add_options(self, options: dict[str, Any]) -> None:
        mapped = parallel.map(self._parallel_render_step, options.items(), 100,
                              self._parallel_render_init_worker, self._parallel_render_prepare())
        for (name, option) in zip(options.keys(), mapped):
            self._options[name] = option

    @abstractmethod
    def finalize(self) -> str: raise NotImplementedError()

class OptionDocsRestrictions:
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported in options doc", token)
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported in options doc", token)
    def attr_span_begin(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported in options doc", token)
    def example_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise RuntimeError("md token not supported in options doc", token)

class OptionsManpageRenderer(OptionDocsRestrictions, ManpageRenderer):
    pass

class ManpageConverter(BaseConverter[OptionsManpageRenderer]):
    __option_block_separator__ = ".sp"

    _options_by_id: dict[str, str]
    _links_in_last_description: Optional[list[str]] = None

    def __init__(self, revision: str,
                 header: list[str] | None,
                 footer: list[str] | None,
                 *,
                 # only for parallel rendering
                 _options_by_id: Optional[dict[str, str]] = None):
        super().__init__(revision)
        self._options_by_id = _options_by_id or {}
        self._renderer = OptionsManpageRenderer({}, self._options_by_id)
        self._header = header
        self._footer = footer

    def _parallel_render_prepare(self) -> Any:
        return (
            self._revision,
            self._header,
            self._footer,
            { '_options_by_id': self._options_by_id },
        )
    @classmethod
    def _parallel_render_init_worker(cls, a: Any) -> ManpageConverter:
        return cls(a[0], a[1], a[2], **a[3])

    def _render_option(self, name: str, option: dict[str, Any]) -> RenderedOption:
        links = self._renderer.link_footnotes = []
        result = super()._render_option(name, option)
        self._renderer.link_footnotes = None
        return result._replace(links=links)

    def add_options(self, options: dict[str, Any]) -> None:
        for (k, v) in options.items():
            self._options_by_id[f'#{make_xml_id(f"opt-{k}")}'] = k
        return super().add_options(options)

    def _render_code(self, option: dict[str, Any], key: str) -> list[str]:
        try:
            self._renderer.inline_code_is_quoted = False
            return super()._render_code(option, key)
        finally:
            self._renderer.inline_code_is_quoted = True

    def _related_packages_header(self) -> list[str]:
        return [
            '\\fIRelated packages:\\fP',
            '.sp',
        ]

    def _decl_def_header(self, header: str) -> list[str]:
        return [
            f'\\fI{man_escape(header)}:\\fP',
        ]

    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]:
        return [
            '.RS 4',
            f'\\fB{man_escape(name)}\\fP',
            '.RE'
        ]

    def _decl_def_footer(self) -> list[str]:
        return []

    def finalize(self) -> str:
        result = []

        if self._header is not None:
            result += self._header
        else:
            result += [
                r'''.TH "CONFIGURATION\&.NIX" "5" "01/01/1980" "NixOS" "NixOS Reference Pages"''',
                r'''.\" disable hyphenation''',
                r'''.nh''',
                r'''.\" disable justification (adjust text to left margin only)''',
                r'''.ad l''',
                r'''.\" enable line breaks after slashes''',
                r'''.cflags 4 /''',
                r'''.SH "NAME"''',
                self._render('{file}`configuration.nix` - NixOS system configuration specification'),
                r'''.SH "DESCRIPTION"''',
                r'''.PP''',
                self._render('The file {file}`/etc/nixos/configuration.nix` contains the '
                            'declarative specification of your NixOS system configuration. '
                            'The command {command}`nixos-rebuild` takes this file and '
                            'realises the system configuration specified therein.'),
                r'''.SH "OPTIONS"''',
                r'''.PP''',
                self._render('You can use the following options in {file}`configuration.nix`.'),
            ]

        for (name, opt) in self._sorted_options():
            result += [
                ".PP",
                f"\\fB{man_escape(name)}\\fR",
                ".RS 4",
            ]
            result += opt.lines
            if links := opt.links:
                result.append(self.__option_block_separator__)
                md_links = ""
                for i in range(0, len(links)):
                    md_links += "\n" if i > 0 else ""
                    if links[i].startswith('#opt-'):
                        md_links += f"{i+1}. see the {{option}}`{self._options_by_id[links[i]]}` option"
                    else:
                        md_links += f"{i+1}. " + md_escape(links[i])
                result.append(self._render(md_links))

            result.append(".RE")

        if self._footer is not None:
            result += self._footer
        else:
            result += [
                r'''.SH "AUTHORS"''',
                r'''.PP''',
                r'''Eelco Dolstra and the Nixpkgs/NixOS contributors''',
            ]

        return "\n".join(result)

class OptionsCommonMarkRenderer(OptionDocsRestrictions, CommonMarkRenderer):
    pass

class CommonMarkConverter(BaseConverter[OptionsCommonMarkRenderer]):
    __option_block_separator__ = ""
    _anchor_style: AnchorStyle
    _anchor_prefix: str


    def __init__(self, manpage_urls: Mapping[str, str], revision: str, anchor_style: AnchorStyle = AnchorStyle.NONE, anchor_prefix: str = ""):
        super().__init__(revision)
        self._renderer = OptionsCommonMarkRenderer(manpage_urls)
        self._anchor_style = anchor_style
        self._anchor_prefix = anchor_prefix

    def _parallel_render_prepare(self) -> Any:
        return (self._renderer._manpage_urls, self._revision)
    @classmethod
    def _parallel_render_init_worker(cls, a: Any) -> CommonMarkConverter:
        return cls(*a)

    def _related_packages_header(self) -> list[str]:
        return [ "*Related packages:*" ]

    def _decl_def_header(self, header: str) -> list[str]:
        return [ f"*{header}:*" ]

    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]:
        if href is not None:
            return [ f" - [{md_escape(name)}]({href})" ]
        return [ f" - {md_escape(name)}" ]

    def _decl_def_footer(self) -> list[str]:
        return []

    def _make_anchor_suffix(self, loc: list[str]) -> str:
        if self._anchor_style == AnchorStyle.NONE:
            return ""
        elif self._anchor_style == AnchorStyle.LEGACY:
            sanitized = ".".join(map(make_xml_id, loc))
            return f" {{#{self._anchor_prefix}{sanitized}}}"
        else:
            raise RuntimeError("unhandled anchor style", self._anchor_style)

    def finalize(self) -> str:
        result = []

        for (name, opt) in self._sorted_options():
            anchor_suffix = self._make_anchor_suffix(opt.loc)
            result.append(f"## {md_escape(name)}{anchor_suffix}\n")
            result += opt.lines
            result.append("\n\n")

        return "\n".join(result)

class OptionsAsciiDocRenderer(OptionDocsRestrictions, AsciiDocRenderer):
    pass

class AsciiDocConverter(BaseConverter[OptionsAsciiDocRenderer]):
    __option_block_separator__ = ""

    def __init__(self, manpage_urls: Mapping[str, str], revision: str):
        super().__init__(revision)
        self._renderer = OptionsAsciiDocRenderer(manpage_urls)

    def _parallel_render_prepare(self) -> Any:
        return (self._renderer._manpage_urls, self._revision)
    @classmethod
    def _parallel_render_init_worker(cls, a: Any) -> AsciiDocConverter:
        return cls(*a)

    def _related_packages_header(self) -> list[str]:
        return [ "__Related packages:__" ]

    def _decl_def_header(self, header: str) -> list[str]:
        return [ f"__{header}:__\n" ]

    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]:
        if href is not None:
            return [ f"* link:{quote(href, safe='/:')}[{asciidoc_escape(name)}]" ]
        return [ f"* {asciidoc_escape(name)}" ]

    def _decl_def_footer(self) -> list[str]:
        return []

    def finalize(self) -> str:
        result = []

        for (name, opt) in self._sorted_options():
            result.append(f"== {asciidoc_escape(name)}\n")
            result += opt.lines
            result.append("\n\n")

        return "\n".join(result)

class OptionsHTMLRenderer(OptionDocsRestrictions, HTMLRenderer):
    # TODO docbook compat. must be removed together with the matching docbook handlers.
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        token.meta['compact'] = False
        return super().ordered_list_open(token, tokens, i)
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        token.meta['compact'] = False
        return super().bullet_list_open(token, tokens, i)
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        info = f" {html.escape(token.info, True)}" if token.info != "" else ""
        return f'<pre><code class="programlisting{info}">{html.escape(token.content)}</code></pre>'

class HTMLConverter(BaseConverter[OptionsHTMLRenderer]):
    __option_block_separator__ = ""

    def __init__(self, manpage_urls: Mapping[str, str], revision: str,
                 varlist_id: str, id_prefix: str, xref_targets: Mapping[str, XrefTarget]):
        super().__init__(revision)
        self._xref_targets = xref_targets
        self._varlist_id = varlist_id
        self._id_prefix = id_prefix
        self._renderer = OptionsHTMLRenderer(manpage_urls, self._xref_targets)

    def _parallel_render_prepare(self) -> Any:
        return (self._renderer._manpage_urls, self._revision,
                self._varlist_id, self._id_prefix, self._xref_targets)
    @classmethod
    def _parallel_render_init_worker(cls, a: Any) -> HTMLConverter:
        return cls(*a)

    def _related_packages_header(self) -> list[str]:
        return [
            '<p><span class="emphasis"><em>Related packages:</em></span></p>',
        ]

    def _decl_def_header(self, header: str) -> list[str]:
        return [
            f'<p><span class="emphasis"><em>{header}:</em></span></p>',
            '<table border="0" summary="Simple list" class="simplelist">'
        ]

    def _decl_def_entry(self, href: Optional[str], name: str) -> list[str]:
        if href is not None:
            href = f' href="{html.escape(href, True)}"'
        return [
            "<tr><td>",
            f'<code class="filename"><a class="filename" {href} target="_top">',
            f'{html.escape(name)}',
            '</a></code>',
            "</td></tr>"
        ]

    def _decl_def_footer(self) -> list[str]:
        return [ "</table>" ]

    def finalize(self) -> str:
        result = []

        result += [
            '<div class="variablelist">',
            f'<a id="{html.escape(self._varlist_id, True)}"></a>',
            ' <dl class="variablelist">',
        ]

        for (name, opt) in self._sorted_options():
            id = make_xml_id(self._id_prefix + name)
            target = self._xref_targets[id]
            result += [
                '<dt>',
                ' <span class="term">',
                # docbook compat, these could be one tag
                f' <a id="{html.escape(id, True)}"></a><a class="term" href="{target.href()}">'
                # no spaces here (and string merging) for docbook output compat
                f'<code class="option">{html.escape(name)}</code>',
                '  </a>',
                ' </span>',
                '</dt>',
                '<dd>',
            ]
            result += opt.lines
            result += [
                "</dd>",
            ]

        result += [
            " </dl>",
            "</div>"
        ]

        return "\n".join(result)

def _build_cli_manpage(p: argparse.ArgumentParser) -> None:
    p.add_argument('--revision', required=True)
    p.add_argument("--header", type=Path)
    p.add_argument("--footer", type=Path)
    p.add_argument("infile")
    p.add_argument("outfile")

def parse_anchor_style(value: str|AnchorStyle) -> AnchorStyle:
    if isinstance(value, AnchorStyle):
        # Used by `argparse.add_argument`'s `default`
        return value
    try:
        return AnchorStyle(value.lower())
    except ValueError:
        raise argparse.ArgumentTypeError(f"Invalid value {value}\nExpected one of {', '.join(style.value for style in AnchorStyle)}")

def _build_cli_commonmark(p: argparse.ArgumentParser) -> None:
    p.add_argument('--manpage-urls', required=True)
    p.add_argument('--revision', required=True)
    p.add_argument(
        '--anchor-style',
        required=False,
        default=AnchorStyle.NONE.value,
        choices = [style.value for style in AnchorStyle],
        help = "(default: %(default)s) Anchor style to use for links to options. \nOnly none is standard CommonMark."
    )
    p.add_argument('--anchor-prefix',
        required=False,
        default="",
        help="(default: no prefix) String to prepend to anchor ids. Not used when anchor style is none."
    )
    p.add_argument("infile")
    p.add_argument("outfile")

def _build_cli_asciidoc(p: argparse.ArgumentParser) -> None:
    p.add_argument('--manpage-urls', required=True)
    p.add_argument('--revision', required=True)
    p.add_argument("infile")
    p.add_argument("outfile")

def _run_cli_manpage(args: argparse.Namespace) -> None:
    header = None
    footer = None

    if args.header is not None:
        with args.header.open() as f:
            header = f.read().splitlines()

    if args.footer is not None:
        with args.footer.open() as f:
            footer = f.read().splitlines()

    md = ManpageConverter(
        revision = args.revision,
        header = header,
        footer = footer,
    )

    with open(args.infile, 'r') as f:
        md.add_options(json.load(f))
    with open(args.outfile, 'w') as f:
        f.write(md.finalize())

def _run_cli_commonmark(args: argparse.Namespace) -> None:
    with open(args.manpage_urls, 'r') as manpage_urls:
        md = CommonMarkConverter(json.load(manpage_urls),
            revision = args.revision,
            anchor_style = parse_anchor_style(args.anchor_style),
            anchor_prefix = args.anchor_prefix)

        with open(args.infile, 'r') as f:
            md.add_options(json.load(f))
        with open(args.outfile, 'w') as f:
            f.write(md.finalize())

def _run_cli_asciidoc(args: argparse.Namespace) -> None:
    with open(args.manpage_urls, 'r') as manpage_urls:
        md = AsciiDocConverter(json.load(manpage_urls), revision = args.revision)

        with open(args.infile, 'r') as f:
            md.add_options(json.load(f))
        with open(args.outfile, 'w') as f:
            f.write(md.finalize())

def build_cli(p: argparse.ArgumentParser) -> None:
    formats = p.add_subparsers(dest='format', required=True)
    _build_cli_manpage(formats.add_parser('manpage'))
    _build_cli_commonmark(formats.add_parser('commonmark'))
    _build_cli_asciidoc(formats.add_parser('asciidoc'))

def run_cli(args: argparse.Namespace) -> None:
    if args.format == 'manpage':
        _run_cli_manpage(args)
    elif args.format == 'commonmark':
        _run_cli_commonmark(args)
    elif args.format == 'asciidoc':
        _run_cli_asciidoc(args)
    else:
        raise RuntimeError('format not hooked up', args)
