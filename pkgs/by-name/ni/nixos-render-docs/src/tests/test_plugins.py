import nixos_render_docs as nrd
import pytest

from markdown_it.token import Token

class Converter(nrd.md.Converter[nrd.html.HTMLRenderer]):
    # actual renderer doesn't matter, we're just parsing.
    def __init__(self, manpage_urls: dict[str, str]) -> None:
        super().__init__()
        self._renderer = nrd.html.HTMLRenderer(manpage_urls, {})

def test_attr_span_parsing() -> None:
    c = Converter({})
    assert c._parse("[]{#test}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1, content='[]{#test}',
              markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'id': 'test'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("[]{.test}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1, content='[]{.test}',
              markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'class': 'test'}, map=None,
                        level=0, children=None, content='', markup='', info='', meta={}, block=False,
                        hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("[]{.test1 .test2 #foo .test3 .test4}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='[]{.test1 .test2 #foo .test3 .test4}',
              markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='attr_span_begin', tag='span', nesting=1,
                        attrs={'class': 'test1 test2 test3 test4', 'id': 'foo'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("[]{#a #a}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='[]{#a #a}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='[]{#a #a}', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("[]{foo}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='[]{foo}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='[]{foo}', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_attr_span_formatted() -> None:
    c = Converter({})
    assert c._parse("a[b c `d` ***e***]{#test}f") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a[b c `d` ***e***]{#test}f', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0,
                        children=None, content='a', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'id': 'test'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='b c ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='code_inline', tag='code', nesting=0, attrs={}, map=None, level=1,
                        children=None, content='d', markup='`', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_open', tag='em', nesting=1, attrs={}, map=None, level=1, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=2, children=None,
                        content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='strong_open', tag='strong', nesting=1, attrs={}, map=None, level=2,
                        children=None, content='', markup='**', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=3, children=None,
                        content='e', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='strong_close', tag='strong', nesting=-1, attrs={}, map=None, level=2,
                        children=None, content='', markup='**', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=2, children=None,
                        content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_close', tag='em', nesting=-1, attrs={}, map=None, level=1, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='f', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_attr_span_in_heading() -> None:
    c = Converter({})
    # inline anchors in headers are allowed, but header attributes should be preferred
    assert c._parse("# foo []{#bar} baz") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo []{#bar} baz', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'id': 'bar'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                   Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                         children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content=' baz', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]

def test_attr_span_on_links() -> None:
    c = Converter({})
    assert c._parse("[ [a](#bar) ]{#foo}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1, content='[ [a](#bar) ]{#foo}',
              markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'id': 'foo'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='link_open', tag='a', nesting=1, attrs={'href': '#bar'}, map=None, level=1,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=2, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='link_close', tag='a', nesting=-1, attrs={}, map=None, level=1, children=None,
                        content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_attr_span_nested() -> None:
    # inline anchors may contain more anchors (even though this is a bit pointless)
    c = Converter({})
    assert c._parse("[ [a]{#bar} ]{#foo}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='[ [a]{#bar} ]{#foo}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'id': 'foo'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'id': 'bar'}, map=None, level=1,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=2, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=1,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content=' ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_attr_span_escaping() -> None:
    c = Converter({})
    assert c._parse("\\[a]{#bar}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='\\[a]{#bar}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='[a]{#bar}', markup='\\[', info='escape', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("\\\\[a]{#bar}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='\\\\[a]{#bar}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='\\', markup='\\\\', info='escape', meta={}, block=False, hidden=False),
                  Token(type='attr_span_begin', tag='span', nesting=1, attrs={'id': 'bar'}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='attr_span_end', tag='span', nesting=-1, attrs={}, map=None, level=0,
                        children=None, content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("\\\\\\[a]{#bar}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='\\[a]{#bar}', markup='\\\\', info='escape', meta={}, block=False, hidden=False)
              ],
              content='\\\\\\[a]{#bar}', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_basic() -> None:
    c = Converter({})
    assert c._parse("a <!-- foo --><!----> b") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a <!-- foo --><!----> b', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a  b', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("a<!-- b -->") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a<!-- b -->', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_does_not_nest_in_code() -> None:
    c = Converter({})
    assert c._parse("`a<!-- b -->c`") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='`a<!-- b -->c`', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='code_inline', tag='code', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a<!-- b -->c', markup='`', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_does_not_nest_elsewhere() -> None:
    c = Converter({})
    assert c._parse("*a<!-- b -->c*") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='*a<!-- b -->c*', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='em_open', tag='em', nesting=1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='ac', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_close', tag='em', nesting=-1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_inline_comment_can_be_escaped() -> None:
    c = Converter({})
    assert c._parse("a\\<!-- b -->c") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='a\\<!-- b -->c', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a<!-- b -->c', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("a\\\\<!-- b -->c") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a\\c', markup='', info='', meta={}, block=False, hidden=False)
              ],
              content='a\\\\<!-- b -->c', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("a\\\\\\<!-- b -->c") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a\\<!-- b -->c', markup='', info='', meta={}, block=False, hidden=False)
              ],
              content='a\\\\\\<!-- b -->c', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]

def test_block_comment() -> None:
    c = Converter({})
    assert c._parse("<!-- a -->") == []
    assert c._parse("<!-- a\n-->") == []
    assert c._parse("<!--\na\n-->") == []
    assert c._parse("<!--\n\na\n\n-->") == []
    assert c._parse("<!--\n\n```\n\n\n```\n\n-->") == []

def test_heading_attributes() -> None:
    c = Converter({})
    assert c._parse("# foo *bar* {#hid}") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={'id': 'hid'}, map=[0, 1], level=0,
              children=None, content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo *bar* {#hid}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo ', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_open', tag='em', nesting=1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=1, children=None,
                        content='bar', markup='', info='', meta={}, block=False, hidden=False),
                  Token(type='em_close', tag='em', nesting=-1, attrs={}, map=None, level=0, children=None,
                        content='', markup='*', info='', meta={}, block=False, hidden=False),
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("# foo--bar {#id-with--double-dashes}") == [
        Token(type='heading_open', tag='h1', nesting=1, attrs={'id': 'id-with--double-dashes'}, map=[0, 1],
              level=0, children=None, content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='foo--bar {#id-with--double-dashes}', markup='', info='', meta={}, block=True,
              hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo–bar', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='heading_close', tag='h1', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False)
    ]

def test_admonitions() -> None:
    c = Converter({})
    assert c._parse("::: {.note}") == [
        Token(type='admonition_open', tag='div', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup=':::', info=' {.note}', meta={'kind': 'note'}, block=True,
              hidden=False),
        Token(type='admonition_close', tag='div', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup=':::', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("::: {.caution}") == [
        Token(type='admonition_open', tag='div', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup=':::', info=' {.caution}', meta={'kind': 'caution'},
              block=True, hidden=False),
        Token(type='admonition_close', tag='div', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup=':::', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("::: {.tip}") == [
        Token(type='admonition_open', tag='div', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup=':::', info=' {.tip}', meta={'kind': 'tip'}, block=True,
              hidden=False),
        Token(type='admonition_close', tag='div', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup=':::', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("::: {.important}") == [
        Token(type='admonition_open', tag='div', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup=':::', info=' {.important}', meta={'kind': 'important'},
              block=True, hidden=False),
        Token(type='admonition_close', tag='div', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup=':::', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("::: {.warning}") == [
        Token(type='admonition_open', tag='div', nesting=1, attrs={}, map=[0, 1], level=0,
              children=None, content='', markup=':::', info=' {.warning}', meta={'kind': 'warning'},
              block=True, hidden=False),
        Token(type='admonition_close', tag='div', nesting=-1, attrs={}, map=None, level=0,
              children=None, content='', markup=':::', info='', meta={}, block=True, hidden=False)
    ]

def test_example() -> None:
    c = Converter({})
    assert c._parse("::: {.example}\n# foo") == [
        Token(type='example_open', tag='div', nesting=1, attrs={}, map=[0, 2], level=0, children=None,
              content='', markup=':::', info=' {.example}', meta={}, block=True, hidden=False),
        Token(type='example_title_open', tag='h1', nesting=1, attrs={}, map=[1, 2], level=1, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[1, 2], level=2,
              content='foo', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='example_title_close', tag='h1', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='example_close', tag='div', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("::: {#eid .example}\n# foo") == [
        Token(type='example_open', tag='div', nesting=1, attrs={'id': 'eid'}, map=[0, 2], level=0,
              children=None, content='', markup=':::', info=' {#eid .example}', meta={}, block=True,
              hidden=False),
        Token(type='example_title_open', tag='h1', nesting=1, attrs={}, map=[1, 2], level=1, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[1, 2], level=2,
              content='foo', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='foo', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='example_title_close', tag='h1', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup='#', info='', meta={}, block=True, hidden=False),
        Token(type='example_close', tag='div', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("::: {.example .note}") == [
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=1,
              content='::: {.example .note}', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='::: {.example .note}', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse("::: {.example}\n### foo: `code`\nbar\n:::\nbaz") == [
        Token(type='example_open', tag='div', nesting=1, map=[0, 3], markup=':::', info=' {.example}',
              block=True),
        Token(type='example_title_open', tag='h3', nesting=1, map=[1, 2], level=1, markup='###', block=True),
        Token(type='inline', tag='', nesting=0, map=[1, 2], level=2, content='foo: `code`', block=True,
              children=[
                  Token(type='text', tag='', nesting=0, content='foo: '),
                  Token(type='code_inline', tag='code', nesting=0, content='code', markup='`')
              ]),
        Token(type='example_title_close', tag='h3', nesting=-1, level=1, markup='###', block=True),
        Token(type='paragraph_open', tag='p', nesting=1, map=[2, 3], level=1, block=True),
        Token(type='inline', tag='', nesting=0, map=[2, 3], level=2, content='bar', block=True,
              children=[
                  Token(type='text', tag='', nesting=0, content='bar')
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, level=1, block=True),
        Token(type='example_close', tag='div', nesting=-1, markup=':::', block=True),
        Token(type='paragraph_open', tag='p', nesting=1, map=[4, 5], block=True),
        Token(type='inline', tag='', nesting=0, map=[4, 5], level=1, content='baz', block=True,
              children=[
                  Token(type='text', tag='', nesting=0, content='baz')
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, block=True)
    ]

    with pytest.raises(RuntimeError) as exc:
        c._parse("::: {.example}\n### foo\n### bar\n:::")
    assert exc.value.args[0] == 'unexpected non-title heading in example in line 3'

def test_footnotes() -> None:
    c = Converter({})
    assert c._parse("text [^foo]\n\n[^foo]: bar") == [
        Token(type='paragraph_open', tag='p', nesting=1, map=[0, 1], block=True),
        Token(type='inline', tag='', nesting=0, map=[0, 1], level=1, content='text [^foo]', block=True,
              children=[
                  Token(type='text', tag='', nesting=0, content='text '),
                  Token(type='footnote_ref', tag='', nesting=0, attrs={'id': 'foo.__back.0'},
                        meta={'id': 0, 'subId': 0, 'label': 'foo', 'target': 'foo'})
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, block=True),
        Token(type='footnote_block_open', tag='', nesting=1),
        Token(type='footnote_open', tag='', nesting=1, attrs={'id': 'foo'}, meta={'id': 0, 'label': 'foo'}),
        Token(type='paragraph_open', tag='p', nesting=1, map=[2, 3], level=1, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, map=[2, 3], level=2, content='bar', block=True,
              children=[
                  Token(type='text', tag='', nesting=0, content='bar')
              ]),
        Token(type='footnote_anchor', tag='', nesting=0,
              meta={'id': 0, 'label': 'foo', 'subId': 0, 'target': 'foo.__back.0'}),
        Token(type='paragraph_close', tag='p', nesting=-1, level=1, block=True),
        Token(type='footnote_close', tag='', nesting=-1),
        Token(type='footnote_block_close', tag='', nesting=-1),
    ]
