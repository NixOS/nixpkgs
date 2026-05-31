import nixos_render_docs as nrd
import pytest

from markdown_it.token import Token

class Converter(nrd.md.Converter[nrd.html.HTMLRenderer]):
    # actual renderer doesn't matter, we're just parsing.
    def __init__(self, manpage_urls: dict[str, str]) -> None:
        super().__init__()
        self._renderer = nrd.html.HTMLRenderer(manpage_urls, {})

@pytest.mark.parametrize("ordered", [True, False])
def test_list_wide(ordered: bool) -> None:
    t, tag, m, e1, e2, i1, i2 = (
        ("ordered", "ol", ".", "1.", "2.", "1", "2") if ordered else ("bullet", "ul", "-", "-", "-", "", "")
    )
    c = Converter({})
    meta = { 'end': int(e2[:-1]) } if ordered else {}
    meta['compact'] = False
    assert c._parse(f"{e1} a\n\n{e2} b") == [
        Token(type=f'{t}_list_open', tag=tag, nesting=1, attrs={}, map=[0, 3], level=0,
              children=None, content='', markup=m, info='', meta=meta, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[0, 2], level=1, children=None,
              content='', markup=m, info=i1, meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=3,
              content='a', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[2, 3], level=1, children=None,
              content='', markup=m, info=i2, meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[2, 3], level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[2, 3], level=3,
              content='b', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='b', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=False),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type=f'{t}_list_close', tag=tag, nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False)
    ]

@pytest.mark.parametrize("ordered", [True, False])
def test_list_narrow(ordered: bool) -> None:
    t, tag, m, e1, e2, i1, i2 = (
        ("ordered", "ol", ".", "1.", "2.", "1", "2") if ordered else ("bullet", "ul", "-", "-", "-", "", "")
    )
    c = Converter({})
    meta = { 'end': int(e2[:-1]) } if ordered else {}
    meta['compact'] = True
    assert c._parse(f"{e1} a\n{e2} b") == [
        Token(type=f'{t}_list_open', tag=tag, nesting=1, attrs={}, map=[0, 2], level=0,
              children=None, content='', markup=m, info='', meta=meta, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[0, 1], level=1, children=None,
              content='', markup=m, info=i1, meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=3,
              content='a', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[1, 2], level=1, children=None,
              content='', markup=m, info=i2, meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[1, 2], level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[1, 2], level=3,
              content='b', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='b', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type=f'{t}_list_close', tag=tag, nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse(f"{e1} - a\n{e2} b") == [
        Token(type=f'{t}_list_open', tag=tag, nesting=1, attrs={}, map=[0, 2], level=0,
              children=None, content='', markup=m, info='', meta=meta, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[0, 1], level=1, children=None,
              content='', markup=m, info=i1, meta={}, block=True, hidden=False),
        Token(type='bullet_list_open', tag='ul', nesting=1, attrs={}, map=[0, 1], level=2,
              children=None, content='', markup='-', info='', meta={'compact': True}, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[0, 1], level=3, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=4, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=5,
              content='a', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=4, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=3, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='bullet_list_close', tag='ul', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[1, 2], level=1, children=None,
              content='', markup=m, info=i2, meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[1, 2], level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[1, 2], level=3,
              content='b', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='b', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type=f'{t}_list_close', tag=tag, nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False)
    ]
    assert c._parse(f"{e1} - a\n{e2} - b") == [
        Token(type=f'{t}_list_open', tag=tag, nesting=1, attrs={}, map=[0, 2], level=0,
              children=None, content='', markup=m, info='', meta=meta, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[0, 1], level=1, children=None,
              content='', markup=m, info=i1, meta={}, block=True, hidden=False),
        Token(type='bullet_list_open', tag='ul', nesting=1, attrs={}, map=[0, 1], level=2,
              children=None, content='', markup='-', info='', meta={'compact': True}, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[0, 1], level=3, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[0, 1], level=4, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[0, 1], level=5,
              content='a', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='a', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=4, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=3, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='bullet_list_close', tag='ul', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[1, 2], level=1, children=None,
              content='', markup=m, info=i2, meta={}, block=True, hidden=False),
        Token(type='bullet_list_open', tag='ul', nesting=1, attrs={}, map=[1, 2], level=2,
              children=None, content='', markup='-', info='', meta={'compact': True}, block=True, hidden=False),
        Token(type='list_item_open', tag='li', nesting=1, attrs={}, map=[1, 2], level=3, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='paragraph_open', tag='p', nesting=1, attrs={}, map=[1, 2], level=4, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='inline', tag='', nesting=0, attrs={}, map=[1, 2], level=5,
              content='b', markup='', info='', meta={}, block=True, hidden=False,
              children=[
                  Token(type='text', tag='', nesting=0, attrs={}, map=None, level=0, children=None,
                        content='b', markup='', info='', meta={}, block=False, hidden=False)
              ]),
        Token(type='paragraph_close', tag='p', nesting=-1, attrs={}, map=None, level=4, children=None,
              content='', markup='', info='', meta={}, block=True, hidden=True),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=3, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='bullet_list_close', tag='ul', nesting=-1, attrs={}, map=None, level=2, children=None,
              content='', markup='-', info='', meta={}, block=True, hidden=False),
        Token(type='list_item_close', tag='li', nesting=-1, attrs={}, map=None, level=1, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False),
        Token(type=f'{t}_list_close', tag=tag, nesting=-1, attrs={}, map=None, level=0, children=None,
              content='', markup=m, info='', meta={}, block=True, hidden=False)
    ]
