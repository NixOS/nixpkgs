import json
import xml.parsers.expat as expat
from html.entities import name2codepoint
from pathlib import Path

import pytest
from nixos_render_docs.manual import HTMLConverter, HTMLParameters


def _parse_xhtml(text: str) -> None:
    parser = expat.ParserCreate()
    # Use offline html entity definitions
    # and enble to use them (XML_PARAM_ENTITY_PARSING_ALWAYS)
    parser.UseForeignDTD(True)
    parser.SetParamEntityParsing(expat.XML_PARAM_ENTITY_PARSING_ALWAYS)

    def external_entity_ref(context: str | None, base: str | None,
                            system_id: str | None, public_id: str | None) -> int:
        sub = parser.ExternalEntityParserCreate(context)
        sub.Parse("".join(f'<!ENTITY {name} "&#{cp};">'
                          for name, cp in name2codepoint.items()), True)
        return 1

    parser.ExternalEntityRefHandler = external_entity_ref
    parser.Parse(text, True)


def _build(tmp_path: Path, sidebar_depth: int = 2, sidebar_open: frozenset[str] = frozenset()) -> str:
    (tmp_path / "part.md").write_text(
        "# Build helpers {#part-builders}\n\n" # -> h2
        "```{=include=} chapters\nchapter.md\n```\n"
    )
    (tmp_path / "chapter.md").write_text(
        "# Fixed-point arguments {#chap-fpa}\n\n" # -> h2
        "Intro.\n\n"
        "## First section {#sec-first}\n\n" # -> h3
        "Body.\n\n"
        "### A subsection {#sub-a}\n\n"
        "Deep.\n\n"
        "#### Deeper {#d4}\n\n"
        "More.\n\n"
        "##### Deepest {#d5}\n\n"
        "Most.\n"
    )
    (tmp_path / "index.md").write_text(
        "# Test manual {#book-test}\n\n" # -> h1 (book title)
        "## Version 1\n\n" # -> h2
        "```{=include=} parts\npart.md\n```\n"
    )
    out = tmp_path / "out"
    out.mkdir(exist_ok=True)
    conv = HTMLConverter(
        "1.0.0",
        HTMLParameters("test-gen", [], [], sidebar_depth, Path("media")),
        {},
    )
    conv.convert(tmp_path / "index.md", out / "index.html")
    return (out / "index.html").read_text()


def test_single_h1_and_flat_heading_levels(tmp_path: Path) -> None:
    html = _build(tmp_path)
    # There should be only one h1 on an html for acessibility and semantic reasons
    assert html.count("<h1") == 1
    assert '<h1 class="title">' in html
    assert '<h2 id="part-builders" class="title"' in html
    assert '<h2 id="chap-fpa" class="title"' in html
    assert '<h3 id="sec-first" class="title"' in html
    assert '<h4 id="sub-a" class="title"' in html
    assert '<h5 id="d4" class="title"' in html
    assert '<h6 id="d5" class="title"' in html
    # nothing overflows the h6 ceiling.
    assert "<h7" not in html


def test_sidebar_is_collapsible_tree(tmp_path: Path) -> None:
    html = _build(tmp_path)
    assert '<nav id="manual-toc" class="toc-sidebar" popover="auto">' in html
    assert 'popovertarget="manual-toc"' in html  # the toggle button
    assert '<ol class="toc">' in html
    # Entries with children collapse into <details>; closed by default.
    assert "<details><summary>" in html
    assert "<details open>" not in html  # nothing opens without nav metadata
    # No more inline TOCs, this makes the output visually hard to parse
    assert "Table of Contents" not in html
    # Sidebar links to structural entries
    assert 'href="#part-builders"' in html
    assert 'href="#chap-fpa"' in html
    assert 'href="#sec-first"' in html


def test_nav_metadata_opens_selected_entries(tmp_path: Path) -> None:
    # the 'open' array expands a config group and an --infile heading.
    html = _render_with_config(
        tmp_path,
        {
            "items": [
                {"label": "Guides", "id": "guides", "children": [
                    {"label": "Intro", "file": "intro.md"},
                ]},
            ],
            "open": ["guides", "manual-chap"],
        },
        {"intro.md": "# Introduction {#intro}\n\nBody.\n"},
        manual_chapter="# Manual chapter {#manual-chap}\n\n## Sub {#manual-sub}\n\nText.\n",
    )
    # the group opens by its own id. its link points at the child.
    assert '<details open><summary><a href="#intro">Guides</a>' in html
    assert '<details open><summary><a href="#manual-chap"' in html


def test_config_group_without_id_is_not_openable(tmp_path: Path) -> None:
    # the config lists 'intro' in 'open'.
    # the group has no id, so its key is empty. the group stays closed.
    html = _render_with_config(
        tmp_path,
        {
            "items": [
                {"label": "Guides", "children": [
                    {"file": "intro.md"},
                ]},
            ],
            "open": ["intro"],
        },
        {"intro.md": "# Introduction {#intro}\n\nBody.\n"},
    )
    assert '<details><summary><a href="#intro">Guides</a>' in html
    assert "<details open>" not in html


def test_sidebar_depth_caps_the_tree(tmp_path: Path) -> None:
    # sub-a is h3 in a .chapter.md
    # with depth=3, it gets listed
    deep = _build(tmp_path, sidebar_depth=3)
    assert 'href="#sub-a"' in deep

    # with depth=2, its not listed
    shallow = _build(tmp_path, sidebar_depth=2)
    assert 'href="#sub-a"' not in shallow



def test_chunked_pages_carry_the_sidebar(tmp_path: Path) -> None:
    # the user may need to navigate
    # between different chunks
    # every chunk page carries the same sidebar entries
    # So navigation between chunks is possible
    (tmp_path / "chapter.md").write_text(
        "# Fixed-point arguments {#chap-fpa}\n\n"
        "Intro.\n\n"
        "## First section {#sec-first}\n\n"
        "Body.\n\n"
        "### A subsection {#sub-a}\n\n"
        "Deep.\n"
    )
    (tmp_path / "index.md").write_text(
        "# Test manual {#book-test}\n\n"
        "## Version 1\n\n"
        "```{=include=} chapters html:into-file=//chapter.html\nchapter.md\n```\n"
    )
    out = tmp_path / "out"
    out.mkdir(exist_ok=True)
    conv = HTMLConverter(
        "1.0.0",
        HTMLParameters("test-gen", [], [], 3, Path("media")),
        {},
    )
    conv.convert(tmp_path / "index.md", out / "index.html")
    chunk = (out / "chapter.html").read_text()
    assert '<nav id="manual-toc" class="toc-sidebar" popover="auto">' in chunk
    assert '<ol class="toc">' in chunk
    assert 'href="chapter.html#sec-first"' in chunk
    # All headings visible in the chunk sidebar
    assert '<h2 id="chap-fpa" class="title"' in chunk
    assert '<h3 id="sec-first" class="title"' in chunk
    assert '<h4 id="sub-a" class="title"' in chunk
    assert chunk.count("<h1") <= 1
    assert "Table of Contents" not in chunk


def test_output_is_well_formed_xhtml(tmp_path: Path) -> None:
    (tmp_path / "chapter.md").write_text(
        "# Fixed-point arguments {#chap-fpa}\n\n"
        "Intro.\n\n"
        "## First section {#sec-first}\n\n"
        "Body.\n"
    )
    (tmp_path / "index.md").write_text(
        "# Test manual {#book-test}\n\n"
        "## Version 1\n\n"
        "```{=include=} chapters html:into-file=//chapter.html\nchapter.md\n```\n"
    )
    out = tmp_path / "out"
    out.mkdir(exist_ok=True)
    conv = HTMLConverter(
        "1.0.0",
        HTMLParameters("test-gen", [], [], 3, Path("media")),
        {},
    )
    conv.convert(tmp_path / "index.md", out / "index.html")
    pages = sorted(out.glob("*.html"))
    # Test that pages produced orderly with into-file
    assert {p.name for p in pages} == {"index.html", "chapter.html"}
    for page in pages:
        _parse_xhtml(page.read_text())


_DEFAULT_INDEX = (
    "# Test manual {#book-test}\n\n"
    "## Version 1\n\n"
    "```{=include=} chapters\nmanual-chapter.md\n```\n"
)
_DEFAULT_MANUAL_CHAPTER = "# Manual chapter {#manual-chap}\n\nManual body.\n"


def _render_with_config(
    tmp_path: Path,
    config: object,
    files: dict[str, str],
    *,
    index: str = _DEFAULT_INDEX,
    manual_chapter: str = _DEFAULT_MANUAL_CHAPTER,
    sidebar_depth: int = 6,
) -> str:
    (tmp_path / "config.json").write_text(json.dumps(config))
    (tmp_path / "manual-chapter.md").write_text(manual_chapter)
    for name, content in files.items():
        path = tmp_path / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)

    (tmp_path / "index.md").write_text(index)
    out = tmp_path / "out"
    out.mkdir(exist_ok=True)

    conv = HTMLConverter(
        "1.0.0",
        HTMLParameters("test-gen", [], [], sidebar_depth, Path("media")),
        {},
        config_path=tmp_path / "config.json",
    )
    conv.convert(tmp_path / "index.md", out / "index.html")
    return (out / "index.html").read_text()


def test_config_content_renders_before_manual(tmp_path: Path) -> None:
    html = _render_with_config(
        tmp_path,
        {"items": [{"label": "Intro", "file": "intro.md"}]},
        {"intro.md": "# Introduction {#intro}\n\nConfig intro body.\n"},
    )
    assert "Config intro body." in html
    assert "Manual body." in html
    assert html.index("Config intro body.") < html.index("Manual body.")


def test_config_grouping_node_is_sidebar_only(tmp_path: Path) -> None:
    html = _render_with_config(
        tmp_path,
        {
            "items": [
                {
                    "label": "Guides", "children": [
                        {"label": "Install", "file": "install.md"},
                    ]
                }
            ]
        },
        {"install.md": "# Install {#install}\n\nInstall body.\n"},
    )
    # the group adds no heading and no anchor to the body.
    assert "Guides</h2>" not in html
    assert 'id="guides"' not in html
    # the child renders as a page.
    assert '<h2 id="install" class="title" >Install' in html
    assert "Install body." in html
    # the sidebar nests the child under the group.
    assert '<details><summary><a href="#install">Guides</a></summary>' in html
    assert '<a href="#install">Install</a>' in html


def test_config_leaf_derives_id_and_label_from_file(tmp_path: Path) -> None:
    # the sidebar link reuses the heading id. the label reuses the heading title.
    html = _render_with_config(
        tmp_path,
        {"items": [{"file": "intro.md"}]},
        {"intro.md": "# Introduction {#intro}\n\nBody.\n"},
    )
    assert '<h2 id="intro" class="title" >Introduction' in html
    assert '<a href="#intro">Introduction</a>' in html


def test_config_leaf_label_differs_from_file_title(tmp_path: Path) -> None:
    html = _render_with_config(
        tmp_path,
        {
            "items": [
                {"label": "Sidebar Label", "file": "leaf1.md"}
            ]
        },
        {"leaf1.md": "# File Title {#leaf1}\n\nBody.\n"},
    )
    assert '<h2 id="leaf1" class="title" >File Title' in html
    assert '<a href="#leaf1">Sidebar Label</a>' in html


def test_config_tree_nests_arbitrarily_deep(tmp_path: Path) -> None:
    html = _render_with_config(
        tmp_path,
        {
            "items": [
                {"label": "A", "children": [
                    {"label": "B", "children": [
                        {"label": "C", "file": "c.md"},
                    ]},
                ]}
            ]
        },
        {"c.md": "# C File {#leaf-c}\n\nDeep body.\n"},
    )
    # only the leaf renders a heading. the groups A and B add no anchor.
    assert '<h2 id="leaf-c" class="title"' in html
    assert 'id="ga"' not in html and 'id="gb"' not in html
    # the sidebar nests the groups.
    # every group links to its first descendant page, #leaf-c.
    assert '<details><summary><a href="#leaf-c">A</a></summary>' in html
    assert '<details><summary><a href="#leaf-c">B</a></summary>' in html
    assert '<a href="#leaf-c">C</a></li>' in html
    assert html.index('>A</a>') < html.index('>B</a>') < html.index('>C</a>')


def test_config_id_is_cross_referenceable(tmp_path: Path) -> None:
    html = _render_with_config(
        tmp_path,
        {
            "items": [{"label": "Intro", "file": "intro.md"}]
        },
        {"intro.md": "# Introduction {#intro}\n\nBody.\n"},
        manual_chapter="# Manual chapter {#manual-chap}\n\nSee [](#intro).\n",
    )
    assert '<a class="xref" href="#intro"' in html
    assert ">Introduction</a>" in html


def test_config_duplicate_id_fails(tmp_path: Path) -> None:
    with pytest.raises(RuntimeError) as excinfo:
        _render_with_config(
            tmp_path,
            {
                "items": [{"label": "Dup", "file": "dup.md"}]
            },
            {"dup.md": "# Dup file {#dup}\n\nBody.\n"},
            manual_chapter="# Manual {#dup}\n\nBody.\n",
        )
    assert "duplicate id" in str(excinfo.value.__cause__)


def test_config_malformed_node_fails(tmp_path: Path) -> None:
    with pytest.raises(RuntimeError) as excinfo:
        _render_with_config(
            tmp_path,
            {"items": [{"label": "Bad", "file": "x.md", "children": []}]},
            {},
        )
    assert "exactly one of" in str(excinfo.value.__cause__)

    with pytest.raises(RuntimeError) as excinfo:
        _render_with_config(
            tmp_path,
            {"items": [{"file": 123}]},
            {},
        )
    assert "'file' must be a string" in str(excinfo.value.__cause__)

    with pytest.raises(RuntimeError) as excinfo:
        _render_with_config(
            tmp_path,
            {"items": [{"children": [{"file": "x.md"}]}]},
            {"x.md": "# X {#x}\n\nB.\n"},
        )
    assert "a group requires a non-empty 'label'" in str(excinfo.value.__cause__)
