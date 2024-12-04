import nixos_render_docs

from markdown_it.token import Token
import pytest

def test_option_headings() -> None:
    c = nixos_render_docs.options.HTMLConverter({}, 'local', 'vars', 'opt-', {})
    with pytest.raises(RuntimeError) as exc:
        c._render("# foo")
    assert exc.value.args[0] == 'md token not supported in options doc'
    assert exc.value.args[1] == Token(
        type='heading_open', tag='h1', nesting=1, attrs={}, map=[0, 1], level=0, children=None,
        content='', markup='#', info='', meta={}, block=True, hidden=False
    )
