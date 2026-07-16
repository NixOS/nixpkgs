import json
from pathlib import Path

import pytest
from nixos_render_docs import nixdoc
from nixos_render_docs.manual import HTMLConverter, HTMLParameters


def test_shift_headings_basic() -> None:
    assert nixdoc.shift_headings("# H1", 2) == "### H1"
    assert nixdoc.shift_headings("## H2", 2) == "#### H2"


def test_shift_headings_caps_at_h6() -> None:
    assert nixdoc.shift_headings("###### H6", 2) == "###### H6"
    assert nixdoc.shift_headings("##### H5", 2) == "###### H5"


def test_shift_headings_preserves_multiline_and_endings() -> None:
    src = "# One\n\nbody\n\n## Two\n"
    assert nixdoc.shift_headings(src, 2) == "### One\n\nbody\n\n#### Two\n"


def test_shift_headings_ignores_fenced_nix_comments() -> None:
    src = "# Real heading\n\n```nix\n# not a heading\nfoo = 1;\n```\n"
    out = nixdoc.shift_headings(src, 2)
    assert out == "### Real heading\n\n```nix\n# not a heading\nfoo = 1;\n```\n"


def test_shift_headings_tilde_fence() -> None:
    src = "~~~\n# fenced\n~~~\n# heading\n"
    out = nixdoc.shift_headings(src, 2)
    assert out == "~~~\n# fenced\n~~~\n### heading\n"


def test_shift_headings_indented_heading_shifted() -> None:
    # up to 3 leading spaces is still a heading
    assert nixdoc.shift_headings("   # H1", 2) == "### H1"


def test_shift_headings_four_space_indent_not_a_heading() -> None:
    # 4+ spaces is an indented code block, not a heading
    assert nixdoc.shift_headings("    # code", 2) == "    # code"



_REVISION = "abc123revision"


def _fixture_export() -> dict[str, object]:
    return {
        "schemaVersion": 1,
        "groups": [
            {"id": "strings", "description": "string manipulation functions"},
            {
                "id": "fileset",
                "description": (
                    "[]{#sec-anchor-compat}\n\n"
                    "Intro prose for the file set library.\n\n"
                    "# Overview {#sec-fileset-overview}\n\n"
                    "Some overview text.\n"
                ),
            },
        ],
        "entries": [
            {
                "id": "lib.attrsets.mapAttrs-prime",
                "attrPath": "lib.attrsets.mapAttrs'",
                "name": "mapAttrs'",
                "description": "Maps over attrs.\n\n# Example\n\n```nix\n# a comment\nmapAttrs' f s\n```\n",
                "groups": ["strings"],
                "source": {"file": "lib/attrsets.nix", "line": 42, "column": 3},
            },
            {
                "id": "lib.strings.optionalString",
                "attrPath": "lib.strings.optionalString",
                "name": "optionalString",
                "description": "Return a string if a condition holds.",
                "groups": ["strings"],
                "source": {"file": "lib/strings.nix", "line": 238, "column": 3},
            },
            {
                "id": "lib.fileset.toSource",
                "attrPath": "lib.fileset.toSource",
                "name": "toSource",
                "description": "Add files to the store.",
                "groups": ["fileset"],
                "source": {"file": "lib/fileset/default.nix", "line": 10, "column": 3},
            },
        ],
    }


def _build(tmp_path: Path) -> str:
    (tmp_path / "lib-functions.json").write_text(json.dumps(_fixture_export()))
    (tmp_path / "library.md").write_text(
        "# Nixpkgs Library Functions {#sec-functions-library}\n\n"
        "```{=include=} nixdoc\nlib-functions.json\n```\n"
    )
    (tmp_path / "functions.md").write_text(
        "# Functions reference {#chap-functions}\n\n"
        "```{=include=} sections\nlibrary.md\n```\n"
    )
    (tmp_path / "index.md").write_text(
        "# Test manual {#book-test}\n\n"
        "## Version 1\n\n"
        "```{=include=} chapters\nfunctions.md\n```\n"
    )
    out = tmp_path / "out"
    out.mkdir(exist_ok=True)
    conv = HTMLConverter(
        _REVISION,
        HTMLParameters("test-gen", [], [], 2, Path("media")),
        {},
    )
    conv.convert(tmp_path / "index.md", out / "index.html")
    return (out / "index.html").read_text()


def test_group_heading_anchor(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert '<h2 id="sec-functions-library-strings" class="title"' in html
    assert '<h2 id="sec-functions-library-fileset" class="title"' in html


def test_group_description_rendered_as_block(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert "string manipulation functions" in html


def test_group_header_block_preserves_authored_anchors(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert '<h3 id="sec-fileset-overview" class="title"' in html
    assert 'id="sec-anchor-compat"' in html
    assert "Intro prose for the file set library." in html


def test_function_heading_anchor(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert '<h3 id="function-library-lib.strings.optionalString" class="title"' in html


def test_primed_name_anchor_and_title(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert '<h3 id="function-library-lib.attrsets.mapAttrs-prime" class="title"' in html
    assert "lib.attrsets.mapAttrs&#x27;" in html


def test_doc_comment_heading_shifted_and_auto_id(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert '<h4 id="auto-generated-strings' in html
    assert ">Example" in html


def test_located_at_link(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert (
        f"https://github.com/NixOS/nixpkgs/blob/{_REVISION}/lib/strings.nix#L238"
        in html
    )
    assert "lib/strings.nix:238" in html


def test_fenced_nix_comment_survives_render(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert "# a comment" in html


def test_unsupported_schema_version_raises(tmp_path: Path) -> None:

    (tmp_path / "lib-functions.json").write_text(json.dumps({"schemaVersion": 2, "groups": [], "entries": []}))
    (tmp_path / "library.md").write_text(
        "# Nixpkgs Library Functions {#sec-functions-library}\n\n"
        "```{=include=} nixdoc\nlib-functions.json\n```\n"
    )
    (tmp_path / "functions.md").write_text(
        "# Functions reference {#chap-functions}\n\n"
        "```{=include=} sections\nlibrary.md\n```\n"
    )
    (tmp_path / "index.md").write_text(
        "# Test manual {#book-test}\n\n## Version 1\n\n"
        "```{=include=} chapters\nfunctions.md\n```\n"
    )
    out = tmp_path / "out"
    out.mkdir(exist_ok=True)
    conv = HTMLConverter(
        _REVISION,
        HTMLParameters("test-gen", [], [], 2, Path("media")),
        {},
    )
    with pytest.raises(Exception):
        conv.convert(tmp_path / "index.md", out / "index.html")
