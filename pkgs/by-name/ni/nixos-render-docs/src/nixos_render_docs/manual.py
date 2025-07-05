import argparse
import hashlib
import html
import json
import re
import xml.sax.saxutils as xml

from abc import abstractmethod
from collections.abc import Mapping, Sequence
from pathlib import Path
from typing import Any, Callable, cast, ClassVar, Generic, get_args, NamedTuple

from markdown_it.token import Token

from . import md, options
from .html import HTMLRenderer, UnresolvedXrefError
from .manual_structure import check_structure, FragmentType, is_include, make_xml_id, TocEntry, TocEntryType, XrefTarget
from .md import Converter, Renderer
from .redirects import Redirects

class BaseConverter(Converter[md.TR], Generic[md.TR]):
    # per-converter configuration for ns:arg=value arguments to include blocks, following
    # the include type. html converters need something like this to support chunking, or
    # another external method like the chunktocs docbook uses (but block options seem like
    # a much nicer of doing this).
    INCLUDE_ARGS_NS: ClassVar[str]
    INCLUDE_FRAGMENT_ALLOWED_ARGS: ClassVar[set[str]] = set()
    INCLUDE_OPTIONS_ALLOWED_ARGS: ClassVar[set[str]] = set()

    _base_paths: list[Path]
    _current_type: list[TocEntryType]

    def convert(self, infile: Path, outfile: Path) -> None:
        self._base_paths = [ infile ]
        self._current_type = ['book']
        try:
            tokens = self._parse(infile.read_text())
            self._postprocess(infile, outfile, tokens)
            converted = self._renderer.render(tokens)
            outfile.write_text(converted)
        except Exception as e:
            raise RuntimeError(f"failed to render manual {infile}") from e

    def _postprocess(self, infile: Path, outfile: Path, tokens: Sequence[Token]) -> None:
        pass

    def _handle_headings(self, tokens: list[Token], *, on_heading: Callable[[Token,str],None]) -> None:
        # Headings in a globally numbered order
        # h1 to h6
        curr_heading_pos: list[int] = []
        for token in tokens:
            if token.type == "heading_open":
                if token.tag not in ["h1", "h2", "h3", "h4", "h5", "h6"]:
                    raise RuntimeError(f"Got invalid heading tag {token.tag} in line {token.map[0] + 1 if token.map else 'NOT FOUND'}. Only h1 to h6 headings are allowed.")

                idx = int(token.tag[1:]) - 1

                if idx >= len(curr_heading_pos):
                    # extend the list if necessary
                    curr_heading_pos.extend([0 for _i in range(idx+1 - len(curr_heading_pos))])

                curr_heading_pos = curr_heading_pos[:idx+1]
                curr_heading_pos[-1] += 1


                ident = ".".join(f"{a}" for a in curr_heading_pos)
                on_heading(token,ident)



    def _parse(self, src: str, *, auto_id_prefix: None | str = None) -> list[Token]:
        tokens = super()._parse(src)
        if auto_id_prefix:
            def set_token_ident(token: Token, ident: str) -> None:
                if "id" not in token.attrs:
                    token.attrs["id"] = f"{auto_id_prefix}-{ident}"

            self._handle_headings(tokens, on_heading=set_token_ident)


        check_structure(self._current_type[-1], tokens)
        for token in tokens:
            if not is_include(token):
                continue
            directive = token.info[12:].split()
            if not directive:
                continue
            args = { k: v for k, _sep, v in map(lambda s: s.partition('='), directive[1:]) }
            typ = directive[0]
            if typ == 'options':
                token.type = 'included_options'
                self._process_include_args(token, args, self.INCLUDE_OPTIONS_ALLOWED_ARGS)
                self._parse_options(token, args)
            else:
                fragment_type = typ.removesuffix('s')
                if fragment_type not in get_args(FragmentType):
                    raise RuntimeError(f"unsupported structural include type '{typ}'")
                self._current_type.append(cast(FragmentType, fragment_type))
                token.type = 'included_' + typ
                self._process_include_args(token, args, self.INCLUDE_FRAGMENT_ALLOWED_ARGS)
                self._parse_included_blocks(token, args)
                self._current_type.pop()
        return tokens

    def _process_include_args(self, token: Token, args: dict[str, str], allowed: set[str]) -> None:
        ns = self.INCLUDE_ARGS_NS + ":"
        args = { k[len(ns):]: v for k, v in args.items() if k.startswith(ns) }
        if unknown := set(args.keys()) - allowed:
            assert token.map
            raise RuntimeError(f"unrecognized include argument in line {token.map[0] + 1}", unknown)
        token.meta['include-args'] = args

    def _parse_included_blocks(self, token: Token, block_args: dict[str, str]) -> None:
        assert token.map
        included = token.meta['included'] = []
        for (lnum, line) in enumerate(token.content.splitlines(), token.map[0] + 2):
            line = line.strip()
            path = self._base_paths[-1].parent / line
            if path in self._base_paths:
                raise RuntimeError(f"circular include found in line {lnum}")
            try:
                self._base_paths.append(path)
                with open(path, 'r') as f:
                    prefix = None
                    if "auto-id-prefix" in block_args:
                        # include the current file number to prevent duplicate ids within include blocks
                        prefix = f"{block_args.get('auto-id-prefix')}-{lnum}"

                    tokens = self._parse(f.read(), auto_id_prefix=prefix)
                    included.append((tokens, path))
                self._base_paths.pop()
            except Exception as e:
                raise RuntimeError(f"processing included file {path} from line {lnum}") from e

    def _parse_options(self, token: Token, block_args: dict[str, str]) -> None:
        assert token.map

        items = {}
        for (lnum, line) in enumerate(token.content.splitlines(), token.map[0] + 2):
            if len(args := line.split(":", 1)) != 2:
                raise RuntimeError(f"options directive with no argument in line {lnum}")
            (k, v) = (args[0].strip(), args[1].strip())
            if k in items:
                raise RuntimeError(f"duplicate options directive {k} in line {lnum}")
            items[k] = v
        try:
            id_prefix = items.pop('id-prefix')
            varlist_id = items.pop('list-id')
            source = items.pop('source')
        except KeyError as e:
            raise RuntimeError(f"options directive {e} missing in block at line {token.map[0] + 1}")
        if items.keys():
            raise RuntimeError(
                f"unsupported options directives in block at line {token.map[0] + 1}",
                " ".join(items.keys()))

        try:
            with open(self._base_paths[-1].parent / source, 'r') as f:
                token.meta['id-prefix'] = id_prefix
                token.meta['list-id'] = varlist_id
                token.meta['source'] = json.load(f)
        except Exception as e:
            raise RuntimeError(f"processing options block in line {token.map[0] + 1}") from e

class RendererMixin(Renderer):
    _toplevel_tag: str
    _revision: str

    def __init__(self, toplevel_tag: str, revision: str, *args: Any, **kwargs: Any):
        super().__init__(*args, **kwargs)
        self._toplevel_tag = toplevel_tag
        self._revision = revision
        self.rules |= {
            'included_sections': lambda *args: self._included_thing("section", *args),
            'included_chapters': lambda *args: self._included_thing("chapter", *args),
            'included_preface': lambda *args: self._included_thing("preface", *args),
            'included_parts': lambda *args: self._included_thing("part", *args),
            'included_appendix': lambda *args: self._included_thing("appendix", *args),
            'included_options': self.included_options,
        }

    def render(self, tokens: Sequence[Token]) -> str:
        # books get special handling because they have *two* title tags. doing this with
        # generic code is more complicated than it's worth. the checks above have verified
        # that both titles actually exist.
        if self._toplevel_tag == 'book':
            return self._render_book(tokens)

        return super().render(tokens)

    @abstractmethod
    def _render_book(self, tokens: Sequence[Token]) -> str:
        raise NotImplementedError()

    @abstractmethod
    def _included_thing(self, tag: str, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise NotImplementedError()

    @abstractmethod
    def included_options(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        raise NotImplementedError()


class HTMLParameters(NamedTuple):
    generator: str
    stylesheets: Sequence[str]
    scripts: Sequence[str]
    # number of levels in the rendered table of contents. tables are prepended to
    # the content they apply to (entire document / document chunk / top-level section
    # of a chapter), setting a depth of 0 omits the respective table.
    toc_depth: int
    chunk_toc_depth: int
    section_toc_depth: int
    media_dir: Path

class ManualHTMLRenderer(RendererMixin, HTMLRenderer):
    _base_path: Path
    _in_dir: Path
    _html_params: HTMLParameters
    _redirects: Redirects | None

    def __init__(self, toplevel_tag: str, revision: str, html_params: HTMLParameters,
                 manpage_urls: Mapping[str, str], xref_targets: dict[str, XrefTarget],
                 redirects: Redirects | None, in_dir: Path, base_path: Path):
        super().__init__(toplevel_tag, revision, manpage_urls, xref_targets)
        self._in_dir = in_dir
        self._base_path = base_path.absolute()
        self._html_params = html_params
        self._redirects = redirects

    def _pull_image(self, src: str) -> str:
        src_path = Path(src)
        content = (self._in_dir / src_path).read_bytes()
        # images may be used more than once, but we want to store them only once and
        # in an easily accessible (ie, not input-file-path-dependent) location without
        # having to maintain a mapping structure. hashing the file and using the hash
        # as both the path of the final image provides both.
        content_hash = hashlib.sha3_256(content).hexdigest()
        target_name = f"{content_hash}{src_path.suffix}"
        target_path = self._base_path / self._html_params.media_dir / target_name
        target_path.write_bytes(content)
        return f"./{self._html_params.media_dir}/{target_name}"

    def _push(self, tag: str, hlevel_offset: int) -> Any:
        result = (self._toplevel_tag, self._headings, self._attrspans, self._hlevel_offset, self._in_dir)
        self._hlevel_offset += hlevel_offset
        self._toplevel_tag, self._headings, self._attrspans = tag, [], []
        return result

    def _pop(self, state: Any) -> None:
        (self._toplevel_tag, self._headings, self._attrspans, self._hlevel_offset, self._in_dir) = state

    def _render_book(self, tokens: Sequence[Token]) -> str:
        assert tokens[4].children
        title_id = cast(str, tokens[0].attrs.get('id', ""))
        title = self._xref_targets[title_id].title
        # subtitles don't have IDs, so we can't use xrefs to get them
        subtitle = self.renderInline(tokens[4].children)

        toc = TocEntry.of(tokens[0])
        return "\n".join([
            self._file_header(toc),
            ' <div class="book">',
            '  <div class="titlepage">',
            '   <div>',
            f'   <div><h1 class="title"><a id="{html.escape(title_id, True)}"></a>{title}</h1></div>',
            f'   <div><h2 class="subtitle">{subtitle}</h2></div>',
            '   </div>',
            "   <hr />",
            '  </div>',
            self._build_toc(tokens, 0),
            super(HTMLRenderer, self).render(tokens[6:]),
            ' </div>',
            self._file_footer(toc),
        ])

    def _file_header(self, toc: TocEntry) -> str:
        prev_link, up_link, next_link = "", "", ""
        prev_a, next_a, parent_title = "", "", "&nbsp;"
        nav_html = ""
        home = toc.root
        if toc.prev:
            prev_link = f'<link rel="prev" href="{toc.prev.target.href()}" title="{toc.prev.target.title}" />'
            prev_a = f'<a accesskey="p" href="{toc.prev.target.href()}">Prev</a>'
        if toc.parent:
            up_link = (
                f'<link rel="up" href="{toc.parent.target.href()}" '
                f'title="{toc.parent.target.title}" />'
            )
            if (part := toc.parent) and part.kind != 'book':
                assert part.target.title
                parent_title = part.target.title
        if toc.next:
            next_link = f'<link rel="next" href="{toc.next.target.href()}" title="{toc.next.target.title}" />'
            next_a = f'<a accesskey="n" href="{toc.next.target.href()}">Next</a>'
        if toc.prev or toc.parent or toc.next:
            nav_html = "\n".join([
                '  <div class="navheader">',
                '   <table width="100%" summary="Navigation header">',
                '    <tr>',
                f'    <th colspan="3" align="center">{toc.target.title}</th>',
                '    </tr>',
                '    <tr>',
                f'    <td width="20%" align="left">{prev_a}&nbsp;</td>',
                f'    <th width="60%" align="center">{parent_title}</th>',
                f'    <td width="20%" align="right">&nbsp;{next_a}</td>',
                '    </tr>',
                '   </table>',
                '   <hr />',
                '  </div>',
            ])

        scripts = self._html_params.scripts
        if self._redirects:
            redirects_name = f'{toc.target.path.split('.html')[0]}-redirects.js'
            with open(self._base_path / redirects_name, 'w') as file:
                file.write(self._redirects.get_redirect_script(toc.target.path))
            scripts.append(f'./{redirects_name}')

        return "\n".join([
            '<?xml version="1.0" encoding="utf-8" standalone="no"?>',
            '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"',
            '  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
            '<html xmlns="http://www.w3.org/1999/xhtml">',
            ' <head>',
            '  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />',
            f' <title>{toc.target.title}</title>',
            "".join((f'<link rel="stylesheet" type="text/css" href="{html.escape(style, True)}" />'
                     for style in self._html_params.stylesheets)),
            "".join((f'<script src="{html.escape(script, True)}" type="text/javascript"></script>'
                     for script in scripts)),
            f' <meta name="generator" content="{html.escape(self._html_params.generator, True)}" />',
            f' <link rel="home" href="{home.target.href()}" title="{home.target.title}" />' if home.target.href() else "",
            f' {up_link}{prev_link}{next_link}',
            ' </head>',
            ' <body>',
            nav_html,
        ])

    def _file_footer(self, toc: TocEntry) -> str:
        # prev, next = self._get_prev_and_next()
        prev_a, up_a, home_a, next_a = "", "&nbsp;", "&nbsp;", ""
        prev_text, up_text, next_text = "", "", ""
        nav_html = ""
        home = toc.root
        if toc.prev:
            prev_a = f'<a accesskey="p" href="{toc.prev.target.href()}">Prev</a>'
            assert toc.prev.target.title
            prev_text = toc.prev.target.title
        if toc.parent:
            home_a = f'<a accesskey="h" href="{home.target.href()}">Home</a>'
            if toc.parent != home:
                up_a = f'<a accesskey="u" href="{toc.parent.target.href()}">Up</a>'
        if toc.next:
            next_a = f'<a accesskey="n" href="{toc.next.target.href()}">Next</a>'
            assert toc.next.target.title
            next_text = toc.next.target.title
        if toc.prev or toc.parent or toc.next:
            nav_html = "\n".join([
                '  <div class="navfooter">',
                '   <hr />',
                '   <table width="100%" summary="Navigation footer">',
                '    <tr>',
                f'    <td width="40%" align="left">{prev_a}&nbsp;</td>',
                f'    <td width="20%" align="center">{up_a}</td>',
                f'    <td width="40%" align="right">&nbsp;{next_a}</td>',
                '    </tr>',
                '    <tr>',
                f'     <td width="40%" align="left" valign="top">{prev_text}&nbsp;</td>',
                f'     <td width="20%" align="center">{home_a}</td>',
                f'     <td width="40%" align="right" valign="top">&nbsp;{next_text}</td>',
                '    </tr>',
                '   </table>',
                '  </div>',
            ])
        return "\n".join([
            nav_html,
            ' </body>',
            '</html>',
        ])

    def _heading_tag(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        if token.tag == 'h1':
            return self._toplevel_tag
        return super()._heading_tag(token, tokens, i)
    def _build_toc(self, tokens: Sequence[Token], i: int) -> str:
        toc = TocEntry.of(tokens[i])
        if toc.kind == 'section' and self._html_params.section_toc_depth < 1:
            return ""
        def walk_and_emit(toc: TocEntry, depth: int) -> list[str]:
            if depth <= 0:
                return []
            result = []
            for child in toc.children:
                result.append(
                    f'<dt>'
                    f' <span class="{html.escape(child.kind, True)}">'
                    f'  <a href="{child.target.href()}">{child.target.toc_html}</a>'
                    f' </span>'
                    f'</dt>'
                )
                # we want to look straight through parts because docbook-xsl did too, but it
                # also makes for more uesful top-level tocs.
                next_level = walk_and_emit(child, depth - (0 if child.kind == 'part' else 1))
                if next_level:
                    result.append(f'<dd><dl>{"".join(next_level)}</dl></dd>')
            return result
        def build_list(kind: str, id: str, lst: Sequence[TocEntry]) -> str:
            if not lst:
                return ""
            entries = [
                f'<dt>{i}. <a href="{e.target.href()}">{e.target.toc_html}</a></dt>'
                for i, e in enumerate(lst, start=1)
            ]
            return (
                f'<div class="{id}">'
                f'<p><strong>List of {kind}</strong></p>'
                f'<dl>{"".join(entries)}</dl>'
                '</div>'
            )
        # we don't want to generate the "Title of Contents" header for sections,
        # docbook didn't and it's only distracting clutter unless it's the main table.
        # we also want to generate tocs only for a top-level section (ie, one that is
        # not itself contained in another section)
        print_title = toc.kind != 'section'
        if toc.kind == 'section':
            if toc.parent and toc.parent.kind == 'section':
                toc_depth = 0
            else:
                toc_depth = self._html_params.section_toc_depth
        elif toc.starts_new_chunk and toc.kind != 'book':
            toc_depth = self._html_params.chunk_toc_depth
        else:
            toc_depth = self._html_params.toc_depth
        if not (items := walk_and_emit(toc, toc_depth)):
            return ""
        figures = build_list("Figures", "list-of-figures", toc.figures)
        examples = build_list("Examples", "list-of-examples", toc.examples)
        return "".join([
            f'<div class="toc">',
            ' <p><strong>Table of Contents</strong></p>' if print_title else "",
            f' <dl class="toc">'
            f'  {"".join(items)}'
            f' </dl>'
            f'</div>'
            f'{figures}'
            f'{examples}'
        ])

    def _make_hN(self, level: int) -> tuple[str, str]:
        # for some reason chapters didn't increase the hN nesting count in docbook xslts.
        # originally this was duplicated here for consistency with docbook rendering, but
        # it could be reevaluated and changed now that docbook is gone.
        if self._toplevel_tag == 'chapter':
            level -= 1
        # this style setting is also for docbook compatibility only and could well go away.
        style = ""
        if level + self._hlevel_offset < 3 \
           and (self._toplevel_tag == 'section' or (self._toplevel_tag == 'chapter' and level > 0)):
            style = "clear: both"
        tag, hstyle = super()._make_hN(max(1, level))
        return tag, style

    def _included_thing(self, tag: str, token: Token, tokens: Sequence[Token], i: int) -> str:
        outer, inner = [], []
        # since books have no non-include content the toplevel book wrapper will not count
        # towards nesting depth. other types will have at least a title+id heading which
        # *does* count towards the nesting depth. chapters give a -1 to included sections
        # mirroring the special handing in _make_hN. sigh.
        hoffset = (
            0 if not self._headings
            else self._headings[-1].level - 1 if self._toplevel_tag == 'chapter'
            else self._headings[-1].level
        )
        outer.append(self._maybe_close_partintro())
        into = token.meta['include-args'].get('into-file')
        fragments = token.meta['included']
        state = self._push(tag, hoffset)
        if into:
            toc = TocEntry.of(fragments[0][0][0])
            inner.append(self._file_header(toc))
            # we do not set _hlevel_offset=0 because docbook didn't either.
        else:
            inner = outer
        in_dir = self._in_dir
        for included, path in fragments:
            try:
                self._in_dir = (in_dir / path).parent
                inner.append(self.render(included))
            except Exception as e:
                raise RuntimeError(f"rendering {path}") from e
        if into:
            inner.append(self._file_footer(toc))
            (self._base_path / into).write_text("".join(inner))
        self._pop(state)
        return "".join(outer)

    def included_options(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        conv = options.HTMLConverter(self._manpage_urls, self._revision,
                                     token.meta['list-id'], token.meta['id-prefix'],
                                     self._xref_targets)
        conv.add_options(token.meta['source'])
        return conv.finalize()

def _to_base26(n: int) -> str:
    return (_to_base26(n // 26) if n > 26 else "") + chr(ord("A") + n % 26)

class HTMLConverter(BaseConverter[ManualHTMLRenderer]):
    INCLUDE_ARGS_NS = "html"
    INCLUDE_FRAGMENT_ALLOWED_ARGS = { 'into-file' }

    _revision: str
    _html_params: HTMLParameters
    _manpage_urls: Mapping[str, str]
    _redirects: Redirects | None
    _xref_targets: dict[str, XrefTarget]
    _redirection_targets: set[str]
    _appendix_count: int = 0

    def _next_appendix_id(self) -> str:
        self._appendix_count += 1
        return _to_base26(self._appendix_count - 1)

    def __init__(self, revision: str, html_params: HTMLParameters, manpage_urls: Mapping[str, str], redirects: Redirects | None = None):
        super().__init__()
        self._revision, self._html_params, self._manpage_urls, self._redirects = revision, html_params, manpage_urls, redirects
        self._xref_targets = {}
        self._redirection_targets = set()
        # renderer not set on purpose since it has a dependency on the output path!

    def convert(self, infile: Path, outfile: Path) -> None:
        self._renderer = ManualHTMLRenderer(
            'book', self._revision, self._html_params, self._manpage_urls, self._xref_targets,
            self._redirects, infile.parent, outfile.parent)
        super().convert(infile, outfile)

    def _parse(self, src: str, *, auto_id_prefix: None | str = None) -> list[Token]:
        tokens = super()._parse(src,auto_id_prefix=auto_id_prefix)
        for token in tokens:
            if not token.type.startswith('included_') \
               or not (into := token.meta['include-args'].get('into-file')):
                continue
            assert token.map
            if len(token.meta['included']) == 0:
                raise RuntimeError(f"redirection target {into} in line {token.map[0] + 1} is empty!")
            # we use blender-style //path to denote paths relative to the origin file
            # (usually index.html). this makes everything a lot easier and clearer.
            if not into.startswith("//") or '/' in into[2:]:
                raise RuntimeError("html:into-file must be a relative-to-origin //filename", into)
            into = token.meta['include-args']['into-file'] = into[2:]
            if into in self._redirection_targets:
                raise RuntimeError(f"redirection target {into} in line {token.map[0] + 1} is already in use")
            self._redirection_targets.add(into)
        return tokens

    def _number_block(self, block: str, prefix: str, tokens: Sequence[Token], start: int = 1) -> int:
        title_open, title_close = f'{block}_title_open', f'{block}_title_close'
        for (i, token) in enumerate(tokens):
            if token.type == title_open:
                title = tokens[i + 1]
                assert title.type == 'inline' and title.children
                # the prefix is split into two tokens because the xref title_html will want
                # only the first of the two, but both must be rendered into the example itself.
                title.children = (
                    [
                        Token('text', '', 0, content=f'{prefix} {start}'),
                        Token('text', '', 0, content='. ')
                    ] + title.children
                )
                start += 1
            elif token.type.startswith('included_') and token.type != 'included_options':
                for sub, _path in token.meta['included']:
                    start = self._number_block(block, prefix, sub, start)
        return start

    # xref | (id, type, heading inlines, file, starts new file)
    def _collect_ids(self, tokens: Sequence[Token], target_file: str, typ: str, file_changed: bool
                     ) -> list[XrefTarget | tuple[str, str, Token, str, bool]]:
        result: list[XrefTarget | tuple[str, str, Token, str, bool]] = []
        # collect all IDs and their xref substitutions. headings are deferred until everything
        # has been parsed so we can resolve links in headings. if that's even used anywhere.
        for (i, bt) in enumerate(tokens):
            if bt.type == 'heading_open' and (id := cast(str, bt.attrs.get('id', ''))):
                result.append((id, typ if bt.tag == 'h1' else 'section', tokens[i + 1], target_file,
                               i == 0 and file_changed))
            elif bt.type == 'included_options':
                id_prefix = bt.meta['id-prefix']
                for opt in bt.meta['source'].keys():
                    id = make_xml_id(f"{id_prefix}{opt}")
                    name = html.escape(opt)
                    result.append(XrefTarget(id, f'<code class="option">{name}</code>', name, None, target_file))
            elif bt.type.startswith('included_'):
                sub_file = bt.meta['include-args'].get('into-file', target_file)
                subtyp = bt.type.removeprefix('included_').removesuffix('s')
                for si, (sub, _path) in enumerate(bt.meta['included']):
                    result += self._collect_ids(sub, sub_file, subtyp, si == 0 and sub_file != target_file)
            elif bt.type == 'example_open' and (id := cast(str, bt.attrs.get('id', ''))):
                result.append((id, 'example', tokens[i + 2], target_file, False))
            elif bt.type == 'figure_open' and (id := cast(str, bt.attrs.get('id', ''))):
                result.append((id, 'figure', tokens[i + 2], target_file, False))
            elif bt.type == 'footnote_open' and (id := cast(str, bt.attrs.get('id', ''))):
                result.append(XrefTarget(id, "???", None, None, target_file))
            elif bt.type == 'footnote_ref' and (id := cast(str, bt.attrs.get('id', ''))):
                result.append(XrefTarget(id, "???", None, None, target_file))
            elif bt.type == 'inline':
                assert bt.children is not None
                result += self._collect_ids(bt.children, target_file, typ, False)
            elif id := cast(str, bt.attrs.get('id', '')):
                # anchors and examples have no titles we could use, but we'll have to put
                # *something* here to communicate that there's no title.
                result.append(XrefTarget(id, "???", None, None, target_file))
        return result

    def _render_xref(self, id: str, typ: str, inlines: Token, path: str, drop_fragment: bool) -> XrefTarget:
        assert inlines.children
        title_html = self._renderer.renderInline(inlines.children)
        if typ == 'appendix':
            # NOTE the docbook compat is strong here
            n = self._next_appendix_id()
            prefix = f"Appendix\u00A0{n}.\u00A0"
            # HACK for docbook compat: prefix the title inlines with appendix id if
            # necessary. the alternative is to mess with titlepage rendering in headings,
            # which seems just a lot worse than this
            prefix_tokens = [Token(type='text', tag='', nesting=0, content=prefix)]
            inlines.children = prefix_tokens + list(inlines.children)
            title = prefix + title_html
            toc_html = f"{n}. {title_html}"
            title_html = f"Appendix&nbsp;{n}"
        elif typ in ['example', 'figure']:
            # skip the prepended `{Example,Figure} N. ` from numbering
            toc_html, title = self._renderer.renderInline(inlines.children[2:]), title_html
            # xref title wants only the prepended text, sans the trailing colon and space
            title_html = self._renderer.renderInline(inlines.children[0:1])
        else:
            toc_html, title = title_html, title_html
            title_html = (
                f"<em>{title_html}</em>"
                if typ == 'chapter'
                else title_html if typ in [ 'book', 'part' ]
                else f'the section called “{title_html}”'
            )
        return XrefTarget(id, title_html, toc_html, re.sub('<.*?>', '', title), path, drop_fragment)

    def _postprocess(self, infile: Path, outfile: Path, tokens: Sequence[Token]) -> None:
        self._number_block('example', "Example", tokens)
        self._number_block('figure', "Figure", tokens)
        xref_queue = self._collect_ids(tokens, outfile.name, 'book', True)

        failed = False
        deferred = []
        while xref_queue:
            for item in xref_queue:
                try:
                    target = item if isinstance(item, XrefTarget) else self._render_xref(*item)
                except UnresolvedXrefError:
                    if failed:
                        raise
                    deferred.append(item)
                    continue

                if target.id in self._xref_targets:
                    raise RuntimeError(f"found duplicate id #{target.id}")
                self._xref_targets[target.id] = target
            if len(deferred) == len(xref_queue):
                failed = True # do another round and report the first error
            xref_queue = deferred

        paths_seen = set()
        for t in self._xref_targets.values():
            paths_seen.add(t.path)

        if len(paths_seen) == 1:
            for (k, t) in self._xref_targets.items():
                self._xref_targets[k] = XrefTarget(
                    t.id,
                    t.title_html,
                    t.toc_html,
                    t.title,
                    t.path,
                    t.drop_fragment,
                    drop_target=True
                )

        TocEntry.collect_and_link(self._xref_targets, tokens)
        if self._redirects:
            self._redirects.validate(self._xref_targets)
            server_redirects = self._redirects.get_server_redirects()
            with open(outfile.parent / '_redirects', 'w') as server_redirects_file:
                formatted_server_redirects = []
                for from_path, to_path in server_redirects.items():
                    formatted_server_redirects.append(f"{from_path} {to_path} 301")
                server_redirects_file.write("\n".join(formatted_server_redirects))


def _build_cli_html(p: argparse.ArgumentParser) -> None:
    p.add_argument('--manpage-urls', required=True)
    p.add_argument('--revision', required=True)
    p.add_argument('--generator', default='nixos-render-docs')
    p.add_argument('--stylesheet', default=[], action='append')
    p.add_argument('--script', default=[], action='append')
    p.add_argument('--toc-depth', default=1, type=int)
    p.add_argument('--chunk-toc-depth', default=1, type=int)
    p.add_argument('--section-toc-depth', default=0, type=int)
    p.add_argument('--media-dir', default="media", type=Path)
    p.add_argument('--redirects', type=Path)
    p.add_argument('infile', type=Path)
    p.add_argument('outfile', type=Path)

def _run_cli_html(args: argparse.Namespace) -> None:
    with open(args.manpage_urls) as manpage_urls, open(Path(__file__).parent / "redirects.js") as redirects_script:
        redirects = None
        if args.redirects:
            with open(args.redirects) as raw_redirects:
                redirects = Redirects(json.load(raw_redirects), redirects_script.read())

        md = HTMLConverter(
            args.revision,
            HTMLParameters(args.generator, args.stylesheet, args.script, args.toc_depth,
                           args.chunk_toc_depth, args.section_toc_depth, args.media_dir),
            json.load(manpage_urls), redirects)
        md.convert(args.infile, args.outfile)

def build_cli(p: argparse.ArgumentParser) -> None:
    formats = p.add_subparsers(dest='format', required=True)
    _build_cli_html(formats.add_parser('html'))

def run_cli(args: argparse.Namespace) -> None:
    if args.format == 'html':
        _run_cli_html(args)
    else:
        raise RuntimeError('format not hooked up', args)
