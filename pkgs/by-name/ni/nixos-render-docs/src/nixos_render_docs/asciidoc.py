from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from typing import cast
from urllib.parse import quote

from .md import Renderer

from markdown_it.token import Token

_asciidoc_escapes = {
    # escape all dots, just in case one is pasted at SOL
    ord('.'): "{zwsp}.",
    # may be replaced by typographic variants
    ord("'"): "{apos}",
    ord('"'): "{quot}",
    # passthrough character
    ord('+'): "{plus}",
    # table marker
    ord('|'): "{vbar}",
    # xml entity reference
    ord('&'): "{amp}",
    # crossrefs. < needs extra escaping because links break in odd ways if they start with it
    ord('<'): "{zwsp}+<+{zwsp}",
    ord('>'): "{gt}",
    # anchors, links, block attributes
    ord('['): "{startsb}",
    ord(']'): "{endsb}",
    # superscript, subscript
    ord('^'): "{caret}",
    ord('~'): "{tilde}",
    # bold
    ord('*'): "{asterisk}",
    # backslash
    ord('\\'): "{backslash}",
    # inline code
    ord('`'): "{backtick}",
}
def asciidoc_escape(s: str) -> str:
    s = s.translate(_asciidoc_escapes)
    # :: is deflist item, ;; is has a replacement but no idea why
    return s.replace("::", "{two-colons}").replace(";;", "{two-semicolons}")

@dataclass(kw_only=True)
class List:
    head: str

@dataclass()
class Par:
    sep: str
    block_delim: str
    continuing: bool = False

class AsciiDocRenderer(Renderer):
    __output__ = "asciidoc"

    _parstack: list[Par]
    _list_stack: list[List]
    _attrspans: list[str]

    def __init__(self, manpage_urls: Mapping[str, str]):
        super().__init__(manpage_urls)
        self._parstack = [ Par("\n\n", "====") ]
        self._list_stack = []
        self._attrspans = []

    def _enter_block(self, is_list: bool) -> None:
        self._parstack.append(Par("\n+\n" if is_list else "\n\n", self._parstack[-1].block_delim + "="))
    def _leave_block(self) -> None:
        self._parstack.pop()
    def _break(self, force: bool = False) -> str:
        result = self._parstack[-1].sep if force or self._parstack[-1].continuing else ""
        self._parstack[-1].continuing = True
        return result

    def _admonition_open(self, kind: str) -> str:
        pbreak = self._break()
        self._enter_block(False)
        return f"{pbreak}[{kind}]\n{self._parstack[-2].block_delim}\n"
    def _admonition_close(self) -> str:
        self._leave_block()
        return f"\n{self._parstack[-1].block_delim}\n"

    def _list_open(self, token: Token, head: str) -> str:
        attrs = []
        if (idx := token.attrs.get('start')) is not None:
            attrs.append(f"start={idx}")
        if token.meta['compact']:
            attrs.append('options="compact"')
        if self._list_stack:
            head *= len(self._list_stack[0].head) + 1
        self._list_stack.append(List(head=head))
        return f"{self._break()}[{','.join(attrs)}]"
    def _list_close(self) -> str:
        self._list_stack.pop()
        return ""

    def text(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        return asciidoc_escape(token.content)
    def paragraph_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._break()
    def paragraph_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def hardbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return " +\n"
    def softbreak(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return " "
    def code_inline(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        return f"``{asciidoc_escape(token.content)}``"
    def code_block(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self.fence(token, tokens, i)
    def link_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        return f"link:{quote(cast(str, token.attrs['href']), safe='/:')}["
    def link_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "]"
    def list_item_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._enter_block(True)
        # allow the next token to be a block or an inline.
        return f'\n{self._list_stack[-1].head} {{empty}}'
    def list_item_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return "\n"
    def bullet_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._list_open(token, '*')
    def bullet_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._list_close()
    def em_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "__"
    def em_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "__"
    def strong_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "**"
    def strong_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "**"
    def fence(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        attrs = f"[source,{token.info}]\n" if token.info else ""
        code = token.content
        if code.endswith('\n'):
            code = code[:-1]
        return f"{self._break(True)}{attrs}----\n{code}\n----"
    def blockquote_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        pbreak = self._break(True)
        self._enter_block(False)
        return f"{pbreak}[quote]\n{self._parstack[-2].block_delim}\n"
    def blockquote_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return f"\n{self._parstack[-1].block_delim}"
    def note_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("NOTE")
    def note_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def caution_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("CAUTION")
    def caution_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def important_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("IMPORTANT")
    def important_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def tip_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("TIP")
    def tip_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def warning_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_open("WARNING")
    def warning_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._admonition_close()
    def dl_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return f"{self._break()}[]"
    def dl_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def dt_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._break()
    def dt_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._enter_block(True)
        return ":: {empty}"
    def dd_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return ""
    def dd_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._leave_block()
        return "\n"
    def myst_role(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        # NixOS-specific roles are documented at <nixpkgs>/doc/README.md (with reverse reference)
        self._parstack[-1].continuing = True
        content = asciidoc_escape(token.content)
        if token.meta['name'] == 'manpage' and (url := self._manpage_urls.get(token.content)):
            return f"link:{quote(url, safe='/:')}[{content}]"
        return f"[.{token.meta['name']}]``{asciidoc_escape(token.content)}``"
    def inline_anchor(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        return f"[[{token.attrs['id']}]]"
    def attr_span_begin(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        self._parstack[-1].continuing = True
        (id_part, class_part) = ("", "")
        if id := token.attrs.get('id'):
            id_part = f"[[{id}]]"
        if s := token.attrs.get('class'):
            if s == 'keycap':
                class_part = "kbd:["
                self._attrspans.append("]")
            else:
                return super().attr_span_begin(token, tokens, i)
        else:
            self._attrspans.append("")
        return id_part + class_part
    def attr_span_end(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._attrspans.pop()
    def heading_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return token.markup.replace("#", "=") + " "
    def heading_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return "\n"
    def ordered_list_open(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._list_open(token, '.')
    def ordered_list_close(self, token: Token, tokens: Sequence[Token], i: int) -> str:
        return self._list_close()
