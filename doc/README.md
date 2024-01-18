# Contributing to the Nixpkgs reference manual

This directory houses the sources files for the Nixpkgs reference manual.

Going forward, it should only contain [reference](https://nix.dev/contributing/documentation/diataxis#reference) documentation.
For tutorials, guides and explanations, contribute to <https://nix.dev/> instead.

For documentation only relevant for contributors, use Markdown files and code comments in the source code.

Rendered documentation:
- [Unstable (from master)](https://nixos.org/manual/nixpkgs/unstable/)
- [Stable (from latest release)](https://nixos.org/manual/nixpkgs/stable/)

The rendering tool is [nixos-render-docs](../pkgs/tools/nix/nixos-render-docs/src/nixos_render_docs), sometimes abbreviated `nrd`.

## Contributing to this documentation

You can quickly check your edits with `nix-build`:

```ShellSession
$ cd /path/to/nixpkgs
$ nix-build doc
```

If the build succeeds, the manual will be in `./result/share/doc/nixpkgs/manual.html`.

### devmode

The shell in the manual source directory makes available a command, `devmode`.
It is a daemon, that:
1. watches the manual's source for changes and when they occur — rebuilds
2. HTTP serves the manual, injecting a script that triggers reload on changes
3. opens the manual in the default browser

## Syntax

As per [RFC 0072](https://github.com/NixOS/rfcs/pull/72), all new documentation content should be written in [CommonMark](https://commonmark.org/) Markdown dialect.

Additional syntax extensions are available, all of which can be used in NixOS option documentation. The following extensions are currently used:

#### Tables

Tables, using the [GitHub-flavored Markdown syntax](https://github.github.com/gfm/#tables-extension-).

#### Anchors

Explicitly defined **anchors** on headings, to allow linking to sections. These should be always used, to ensure the anchors can be linked even when the heading text changes, and to prevent conflicts between [automatically assigned identifiers](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/auto_identifiers.md).

It uses the widely compatible [header attributes](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/attributes.md) syntax:

```markdown
## Syntax {#sec-contributing-markup}
```

> [!Note]
> NixOS option documentation does not support headings in general.

#### Inline Anchors

Allow linking arbitrary place in the text (e.g. individual list items, sentences…).

They are defined using a hybrid of the link syntax with the attributes syntax known from headings, called [bracketed spans](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/bracketed_spans.md):

```markdown
- []{#ssec-gnome-hooks-glib} `glib` setup hook will populate `GSETTINGS_SCHEMAS_PATH` and then `wrapGAppsHook` will prepend it to `XDG_DATA_DIRS`.
```

#### Automatic links

If you **omit a link text** for a link pointing to a section, the text will be substituted automatically. For example `[](#chap-contributing)`.

This syntax is taken from [MyST](https://myst-parser.readthedocs.io/en/latest/using/syntax.html#targets-and-cross-referencing).

#### Roles

If you want to link to a man page, you can use `` {manpage}`nix.conf(5)` ``. The references will turn into links when a mapping exists in [`doc/manpage-urls.json`](./manpage-urls.json).

A few markups for other kinds of literals are also available:

- `` {command}`rm -rfi` ``
- `` {env}`XDG_DATA_DIRS` ``
- `` {file}`/etc/passwd` ``
- `` {option}`networking.useDHCP` ``
- `` {var}`/etc/passwd` ``

These literal kinds are used mostly in NixOS option documentation.

This syntax is taken from [MyST](https://myst-parser.readthedocs.io/en/latest/syntax/syntax.html#roles-an-in-line-extension-point). Though, the feature originates from [reStructuredText](https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#role-manpage) with slightly different syntax.

#### Admonitions

Set off from the text to bring attention to something.

It uses pandoc’s [fenced `div`s syntax](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/fenced_divs.md):

```markdown
::: {.warning}
This is a warning
:::
```

The following are supported:

- [`caution`](https://tdg.docbook.org/tdg/5.0/caution.html)
- [`important`](https://tdg.docbook.org/tdg/5.0/important.html)
- [`note`](https://tdg.docbook.org/tdg/5.0/note.html)
- [`tip`](https://tdg.docbook.org/tdg/5.0/tip.html)
- [`warning`](https://tdg.docbook.org/tdg/5.0/warning.html)
- [`example`](https://tdg.docbook.org/tdg/5.0/example.html)

Example admonitions require a title to work.
If you don't provide one, the manual won't be built.

```markdown
::: {.example #ex-showing-an-example}

# Title for this example

Text for the example.
:::
```

#### [Definition lists](https://github.com/jgm/commonmark-hs/blob/master/commonmark-extensions/test/definition_lists.md)

For defining a group of terms:

```markdown
pear
:   green or yellow bulbous fruit

watermelon
:   green fruit with red flesh
```

## Commit conventions

- Make sure you read about the [commit conventions](../CONTRIBUTING.md#commit-conventions) common to Nixpkgs as a whole.

- If creating a commit purely for documentation changes, format the commit message in the following way:

  ```
  doc: (documentation summary)

  (Motivation for change, relevant links, additional information.)
  ```

  Examples:

  * doc: update the kernel config documentation to use `nix-shell`
  * doc: add information about `nix-update-script`

    Closes #216321.

- If the commit contains more than just documentation changes, follow the commit message format relevant for the rest of the changes.

## Documentation conventions

In an effort to keep the Nixpkgs manual in a consistent style, please follow the conventions below, unless they prevent you from properly documenting something.
In that case, please open an issue about the particular documentation convention and tag it with a "needs: documentation" label.

- Put each sentence in its own line.
  This makes reviews and suggestions much easier, since GitHub's review system is based on lines.
  It also helps identifying long sentences at a glance.

- Use the [admonition syntax](#admonitions) for callouts and examples.

- Provide at least one example per function, and make examples self-contained.
  This is easier to understand for beginners.
  It also helps with testing that it actually works – especially once we introduce automation.

  Example code should be such that it can be passed to `pkgs.callPackage`.
  Instead of something like:

  ```nix
  pkgs.dockerTools.buildLayeredImage {
    name = "hello";
    contents = [ pkgs.hello ];
  }
  ```

  Write something like:

  ```nix
  { dockerTools, hello }:
  dockerTools.buildLayeredImage {
    name = "hello";
    contents = [ hello ];
  }
  ```

- Use [definition lists](#definition-lists) to document function arguments, and the attributes of such arguments. For example:

  ```markdown
  # pkgs.coolFunction

  Description of what `coolFunction` does.
  `coolFunction` expects a single argument which should be an attribute set, with the following possible attributes:

  `name`

  : The name of the resulting image.

  `tag` _optional_

  : Tag of the generated image.

    _Default value:_ the output path's hash.

  ```

## Getting help

If you need documentation-specific help or reviews, ping [@NixOS/documentation-reviewers](https://github.com/orgs/nixos/teams/documentation-reviewers) on your pull request.
