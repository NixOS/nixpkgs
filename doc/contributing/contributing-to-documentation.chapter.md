# Contributing to this documentation {#chap-contributing}

The sources of the Nixpkgs manual are in the [doc](https://github.com/NixOS/nixpkgs/tree/master/doc) subdirectory of the Nixpkgs repository. The manual is still partially written in DocBook but it is progressively being converted to [Markdown](#sec-contributing-markup).

You can quickly check your edits with `make`:

```ShellSession
$ cd /path/to/nixpkgs/doc
$ nix-shell
[nix-shell]$ make
```

If you experience problems, run `make debug` to help understand the docbook errors.

After making modifications to the manual, it's important to build it before committing. You can do that as follows:

```ShellSession
$ cd /path/to/nixpkgs/doc
$ nix-shell
[nix-shell]$ make clean
[nix-shell]$ nix-build .
```

If the build succeeds, the manual will be in `./result/share/doc/nixpkgs/manual.html`.

## Syntax {#sec-contributing-markup}

As per [RFC 0072](https://github.com/NixOS/rfcs/pull/72), all new documentation content should be written in [CommonMark](https://commonmark.org/) Markdown dialect.

Additional syntax extensions are available, though not all extensions can be used in NixOS option documentation. The following extensions are currently used:

- []{#ssec-contributing-markup-anchors}
  Explicitly defined **anchors** on headings, to allow linking to sections. These should be always used, to ensure the anchors can be linked even when the heading text changes, and to prevent conflicts between [automatically assigned identifiers](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/auto_identifiers.md).

  It uses the widely compatible [header attributes](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/attributes.md) syntax:

  ```markdown
  ## Syntax {#sec-contributing-markup}
  ```

- []{#ssec-contributing-markup-anchors-inline}
  **Inline anchors**, which allow linking arbitrary place in the text (e.g. individual list items, sentences…).

  They are defined using a hybrid of the link syntax with the attributes syntax known from headings, called [bracketed spans](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/bracketed_spans.md):

  ```markdown
  - []{#ssec-gnome-hooks-glib} `glib` setup hook will populate `GSETTINGS_SCHEMAS_PATH` and then `wrapGAppsHook` will prepend it to `XDG_DATA_DIRS`.
  ```

- []{#ssec-contributing-markup-automatic-links}
  If you **omit a link text** for a link pointing to a section, the text will be substituted automatically. For example, `[](#chap-contributing)` will result in [](#chap-contributing).

  This syntax is taken from [MyST](https://myst-parser.readthedocs.io/en/latest/using/syntax.html#targets-and-cross-referencing).

- []{#ssec-contributing-markup-inline-roles}
  If you want to link to a man page, you can use `` {manpage}`nix.conf(5)` ``, which will turn into {manpage}`nix.conf(5)`. The references will turn into links when a mapping exists in {file}`doc/build-aux/pandoc-filters/link-unix-man-references.lua`.

  A few markups for other kinds of literals are also available:

  - `` {command}`rm -rfi` `` turns into {command}`rm -rfi`
  - `` {option}`networking.useDHCP` `` turns into {option}`networking.useDHCP`
  - `` {file}`/etc/passwd` `` turns into {file}`/etc/passwd`

  These literal kinds are used mostly in NixOS option documentation.

  This syntax is taken from [MyST](https://myst-parser.readthedocs.io/en/latest/syntax/syntax.html#roles-an-in-line-extension-point). Though, the feature originates from [reStructuredText](https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#role-manpage) with slightly different syntax.

  ::: {.note}
  Inline roles are available for option documentation.
  :::

- []{#ssec-contributing-markup-admonitions}
  **Admonitions**, set off from the text to bring attention to something.

  It uses pandoc’s [fenced `div`s syntax](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/fenced_divs.md):

  ```markdown
  ::: {.warning}
  This is a warning
  :::
  ```

  which renders as

  > ::: {.warning}
  > This is a warning.
  > :::

  The following are supported:

    - [`caution`](https://tdg.docbook.org/tdg/5.0/caution.html)
    - [`important`](https://tdg.docbook.org/tdg/5.0/important.html)
    - [`note`](https://tdg.docbook.org/tdg/5.0/note.html)
    - [`tip`](https://tdg.docbook.org/tdg/5.0/tip.html)
    - [`warning`](https://tdg.docbook.org/tdg/5.0/warning.html)

  ::: {.note}
  Admonitions are available for option documentation.
  :::

- []{#ssec-contributing-markup-definition-lists}
  [**Definition lists**](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/definition_lists.md), for defining a group of terms:

  ```markdown
  pear
  :   green or yellow bulbous fruit

  watermelon
  :   green fruit with red flesh
  ```

  which renders as

  > pear
  > :   green or yellow bulbous fruit
  >
  > watermelon
  > :   green fruit with red flesh

For contributing to the legacy parts, please see [DocBook: The Definitive Guide](https://tdg.docbook.org/) or the [DocBook rocks! primer](https://web.archive.org/web/20200816233747/https://docbook.rocks/).
