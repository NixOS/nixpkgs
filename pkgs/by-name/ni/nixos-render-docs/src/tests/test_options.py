import json
from pathlib import Path
import pytest
from markdown_it.token import Token

import nixos_render_docs
from nixos_render_docs.options import AnchorStyle

def test_option_headings() -> None:
    c = nixos_render_docs.options.HTMLConverter({}, 'local', 'vars', 'opt-', {})
    with pytest.raises(RuntimeError) as exc:
        c._render("# foo")
    assert exc.value.args[0] == 'md token not supported in options doc'
    assert exc.value.args[1] == Token(
        type='heading_open', tag='h1', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
        content='', markup='#', info='', meta={}, block=True, hidden=False
    )

def test_options_commonmark() -> None:
    c = nixos_render_docs.options.CommonMarkConverter({}, 'local')
    with Path('tests/sample_options_simple.json').open() as f:
        opts = json.load(f)
    assert opts is not None
    with Path('tests/sample_options_simple_default.md').open() as f:
        expected = f.read()

    c.add_options(opts)
    s = c.finalize()
    assert s == expected

def test_options_commonmark_legacy_anchors() -> None:
    c = nixos_render_docs.options.CommonMarkConverter({}, 'local', anchor_style = AnchorStyle.LEGACY, anchor_prefix = 'opt-')
    with Path('tests/sample_options_simple.json').open() as f:
        opts = json.load(f)
    assert opts is not None
    with Path('tests/sample_options_simple_legacy.md').open() as f:
        expected = f.read()

    c.add_options(opts)
    s = c.finalize()
    assert s == expected
