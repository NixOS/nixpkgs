from pathlib import Path

from nixos_render_docs.manual import HTMLConverter, HTMLParameters


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
        HTMLParameters("test-gen", [], [], sidebar_depth, Path("media"), sidebar_open),
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
    # ids listed in the nav "open" set render as <details open>
    html = _build(tmp_path, sidebar_depth=3, sidebar_open=frozenset({"chap-fpa"}))
    assert '<details open><summary><a href="#chap-fpa"' in html
    assert '<details><summary><a href="#part-builders"' in html


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
