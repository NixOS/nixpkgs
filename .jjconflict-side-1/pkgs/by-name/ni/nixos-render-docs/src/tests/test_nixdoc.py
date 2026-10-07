import pytest

from nixos_render_docs import nixdoc


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


def _export() -> dict[str, object]:
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
                "description": "Maps over attrs.\n\n# Example\n\n```nix\n# a comment\nmapAttrs' f s\n```\n",
                "groups": ["strings"],
                "source": {"file": "lib/attrsets.nix", "line": 42, "column": 3},
            },
            {
                "id": "lib.strings.optionalString",
                "attrPath": "lib.strings.optionalString",
                "description": "Return a string if a condition holds.",
                "groups": ["strings"],
                "source": {"file": "lib/strings.nix", "line": 238, "column": 3},
            },
            {
                "id": "lib.fileset.toSource",
                "attrPath": "lib.fileset.toSource",
                "description": "Add files to the store.",
                "groups": ["fileset"],
                "source": {"file": "lib/fileset/default.nix", "line": 10, "column": 3},
            },
        ],
    }


def _sections() -> dict[str, str]:
    return dict(nixdoc.render_sections(_export(), _REVISION))


def test_one_section_per_group_in_declared_order() -> None:
    sections = nixdoc.render_sections(_export(), _REVISION)
    assert [group_id for group_id, _src in sections] == ["strings", "fileset"]


def test_group_heading_carries_anchor() -> None:
    assert _sections()["strings"].startswith(
        "# strings {#sec-functions-library-strings}\n")


def test_group_description_headings_are_shifted() -> None:
    fileset = _sections()["fileset"]
    # authored anchors survive, the authored '# Overview' becomes a subheading
    assert "[]{#sec-anchor-compat}" in fileset
    assert "## Overview {#sec-fileset-overview}" in fileset


def test_entry_heading_carries_attr_path_and_anchor() -> None:
    assert (
        "## `lib.strings.optionalString` {#function-library-lib.strings.optionalString}"
        in _sections()["strings"]
    )


def test_entry_anchor_drops_characters_an_anchor_cannot_hold() -> None:
    # lib.trivial."or" is a real attribute. an unescaped quote would break the anchor
    # syntax and leak the literal '{#...}' into the heading text.
    export = _export()
    export["entries"] = [{
        "id": 'lib.trivial."or"',
        "attrPath": 'lib.trivial."or"',
        "description": "Boolean or.",
        "groups": ["strings"],
        "source": {"file": "lib/trivial.nix", "line": 212},
    }]
    section = dict(nixdoc.render_sections(export, _REVISION))["strings"]
    assert '## `lib.trivial."or"` {#function-library-lib.trivial.or}' in section


def test_entry_description_headings_are_shifted_below_entry() -> None:
    # the entry heading is h2, so an authored '# Example' must land on h3
    assert "### Example" in _sections()["strings"]


def test_fenced_nix_comment_is_not_shifted() -> None:
    assert "```nix\n# a comment\nmapAttrs' f s\n```" in _sections()["strings"]


def test_entries_are_grouped_by_declared_group() -> None:
    sections = _sections()
    assert "lib.fileset.toSource" in sections["fileset"]
    assert "lib.fileset.toSource" not in sections["strings"]


def test_located_at_links_to_the_revision() -> None:
    assert (
        "Located at [lib/strings.nix:238]"
        f"(https://github.com/NixOS/nixpkgs/blob/{_REVISION}/lib/strings.nix#L238)"
        " in `<nixpkgs>`."
    ) in _sections()["strings"]


def test_unsupported_schema_version_raises() -> None:
    export = _export() | {"schemaVersion": 2}
    with pytest.raises(nixdoc.NixdocExportError) as excinfo:
        nixdoc.render_sections(export, _REVISION)
    assert "schemaVersion 2" in str(excinfo.value)


def test_missing_required_field_raises() -> None:
    export = _export()
    del export["entries"][0]["attrPath"]  # type: ignore[index]
    with pytest.raises(nixdoc.NixdocExportError) as excinfo:
        nixdoc.render_sections(export, _REVISION)
    assert "missing required field 'attrPath'" in str(excinfo.value)
