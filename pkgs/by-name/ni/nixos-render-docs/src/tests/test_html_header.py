from pathlib import Path

import pytest
from nixos_render_docs.manual import HTMLConverter, HTMLParameters

SAMPLE_BOOK = "# Title {#book-title}\n## Subtitle\n"

def render(tmp_path: Path, header: Path | None) -> str:
    infile = tmp_path / "index.md"
    infile.write_text(SAMPLE_BOOK)
    outfile = tmp_path / "index.html"
    params = HTMLParameters("", [], [], 2, 2, 2, tmp_path, header)
    HTMLConverter("1.0.0", params, {}).convert(infile, outfile)
    return outfile.read_text()


def test_html_header_injected_at_start_of_body(tmp_path: Path) -> None:
    fragment = '<header class="corp-nav">corporate navigation</header>'
    header = tmp_path / "header.html"
    header.write_text(fragment)

    out = render(tmp_path, header)
    assert fragment in out
    # verify markers appear in this order
    assert out.index(" <body>") < out.index(fragment) < out.index('<main class="content">')


def test_html_header_absent_when_not_given(tmp_path: Path) -> None:
    out = render(tmp_path, None)
    assert "corp-nav" not in out
