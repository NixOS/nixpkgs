# Contributing to the Nixpkgs reference manual

This directory houses the sources files for the Nixpkgs reference manual.

> [!IMPORTANT]
> We are actively restructuring our documentation to follow the [Diátaxis framework](https://diataxis.fr/)
>
> Going forward, this directory should **only** contain [reference documentation](https://nix.dev/contributing/documentation/diataxis#reference).
> For tutorials, guides and explanations, contribute to <https://nix.dev/> instead.
>
> We are actively working to generate **all** reference documentation from the [doc-comments](https://github.com/NixOS/rfcs/blob/master/rfcs/0145-doc-strings.md) present in code.
> This also provides the benefit of using `:doc` in the `nix repl` to view reference documentation locally on the fly.

For documentation only relevant for contributors, use Markdown files next to the source and regular code comments.

> [!TIP]
> Feedback for improving support for parsing and rendering doc-comments is highly appreciated.
> [Open an issue](https://github.com/NixOS/nixpkgs/issues/new?labels=6.topic%3A+documentation&title=Doc%3A+) to request bugfixes or new features.

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
- []{#ssec-gnome-hooks-glib} `glib` setup hook will populate `GSETTINGS_SCHEMAS_PATH` and then `wrapGApps*` hook will prepend it to `XDG_DATA_DIRS`.
```

#### Automatic links

If you **omit a link text** for a link pointing to a section, the text will be substituted automatically. For example `[](#chap-contributing)`.

This syntax is taken from [MyST](https://myst-parser.readthedocs.io/en/latest/using/syntax.html#targets-and-cross-referencing).


#### HTML

Inlining HTML is not allowed. Parts of the documentation gets rendered to various non-HTML formats, such as man pages in the case of NixOS manual.

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

- `caution`
- `important`
- `note`
- `tip`
- `warning`
- `example`

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
When needed, each convention explain why it exists, so you can make a decision whether to follow it or not based on your particular case.
Note that these conventions are about the **structure** of the manual (and its source files), not about the content that goes in it.
You, as the writer of documentation, are still in charge of its content.

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

- When showing inputs/outputs of any [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop), such as a shell or the Nix REPL, use a format as you'd see in the REPL, while trying to visually separate inputs from outputs.
  This means that for a shell, you should use a format like the following:
  ```shell
  $ nix-build -A hello '<nixpkgs>' \
    --option require-sigs false \
    --option trusted-substituters file:///tmp/hello-cache \
    --option substituters file:///tmp/hello-cache
  /nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1
  ```
  Note how the input is preceded by `$` on the first line and indented on subsequent lines, and how the output is provided as you'd see on the shell.

  For the Nix REPL, you should use a format like the following:
  ```shell
  nix-repl> builtins.attrNames { a = 1; b = 2; }
  [ "a" "b" ]
  ```
  Note how the input is preceded by `nix-repl>` and the output is provided as you'd see on the Nix REPL.

- When documenting functions or anything that has inputs/outputs and example usage, use nested headings to clearly separate inputs, outputs, and examples.
  Keep examples as the last nested heading, and link to the examples wherever applicable in the documentation.

  The purpose of this convention is to provide a familiar structure for navigating the manual, so any reader can expect to find content related to inputs in an "inputs" heading, examples in an "examples" heading, and so on.
  An example:
  ```
  ## buildImage

  Some explanation about the function here.
  Describe a particular scenario, and point to [](#ex-dockerTools-buildImage), which is an example demonstrating it.

  ### Inputs

  Documentation for the inputs of `buildImage`.
  Perhaps even point to [](#ex-dockerTools-buildImage) again when talking about something specifically linked to it.

  ### Passthru outputs

  Documentation for any passthru outputs of `buildImage`.

  ### Examples

  Note that this is the last nested heading in the `buildImage` section.

  :::{.example #ex-dockerTools-buildImage}

  # Using `buildImage`

  Example of how to use `buildImage` goes here.

  :::
  ```

- Use [definition lists](#definition-lists) to document function arguments, and the attributes of such arguments as well as their [types](https://nixos.org/manual/nix/stable/language/values).
  For example:

  ```markdown
  # pkgs.coolFunction {#pkgs.coolFunction}

  `pkgs.coolFunction` *`name`* *`config`*

  Description of what `callPackage` does.


  ## Inputs {#pkgs-coolFunction-inputs}

  If something's special about `coolFunction`'s general argument handling, you can say so here.
  Otherwise, just describe the single argument or start the arguments' definition list without introduction.

  *`name`* (String)

  : The name of the resulting image.

  *`config`* (Attribute set)

  : Introduce the parameter. Maybe you have a test to make sure `{ }` is a sensible default; then you can say: these attributes are optional; `{ }` is a valid argument.

    `outputHash` (String; _optional_)

    : A brief explanation including when and when not to pass this attribute.

    : _Default:_ the output path's hash.
  ```

  Checklist:
  - Start with a synopsis, to show the order of positional arguments.
  - Metavariables are in emphasized code spans: ``` *`arg1`* ```. Metavariables are placeholders where users may write arbitrary expressions. This includes positional arguments.
  - Attribute names are regular code spans: ``` `attr1` ```. These identifiers can _not_ be picked freely by users, so they are _not_ metavariables.
  - _optional_ attributes have a _`Default:`_ if it's easily described as a value.
  - _optional_ attributes have a _`Default behavior:`_ if it's not easily described using a value.
  - Nix types aren't in code spans, because they are not code
  - Nix types are capitalized, to distinguish them from the camelCase Module System types, which _are_ code and behave like functions.

#### Examples

To define a referenceable figure use the following fencing:

```markdown
:::{.example #an-attribute-set-example}
# An attribute set example

You can add text before

    ```nix
    { a = 1; b = 2;}
    ```

and after code fencing
:::
```

Defining examples through the `example` fencing class adds them to a "List of Examples" section after the Table of Contents.
Though this is not shown in the rendered documentation on nixos.org.

#### Figures

To define a referenceable figure use the following fencing:

```markdown
::: {.figure #nixos-logo}
# NixOS Logo
![NixOS logo](./nixos_logo.png)
:::
```

Defining figures through the `figure` fencing class adds them to a `List  of Figures` after the `Table of Contents`.
Though this is not shown in the rendered documentation on nixos.org.

#### Footnotes

To add a foonote explanation, use the following syntax:

```markdown
Sometimes it's better to add context [^context] in a footnote.

[^context]: This explanation will be rendered at the end of the chapter.
```

#### Inline comments

Inline comments are supported with following syntax:

```markdown
<!-- This is an inline comment -->
```

The comments will not be rendered in the rendered HTML.

#### Link reference definitions

Links can reference a label, for example, to make the link target reusable:

```markdown
::: {.note}
Reference links can also be used to [shorten URLs][url-id] and keep the markdown readable.
:::

[url-id]: https://github.com/NixOS/nixpkgs/blob/19d4f7dc485f74109bd66ef74231285ff797a823/doc/README.md
```

This syntax is taken from [CommonMark](https://spec.commonmark.org/0.30/#link-reference-definitions).

#### Typographic replacements

Typographic replacements are enabled. Check the [list of possible replacement patterns check](https://github.com/executablebooks/markdown-it-py/blob/3613e8016ecafe21709471ee0032a90a4157c2d1/markdown_it/rules_core/replacements.py#L1-L15).

## Getting help

If you need documentation-specific help or reviews, ping [@NixOS/documentation-team](https://github.com/orgs/nixos/teams/documentation-team) on your pull request.
