# Contributing to this manual {#chap-contributing}

::: {.warning}
Do not edit the XML files in `./from_md/`!

The backend system generating the documentation is in the process of switching
from DocBook XML to CommonMark, a flavor of Markdown
(see [RFC0072](https://github.com/NixOS/rfcs/blob/master/rfcs/0072-commonmark-docs.md)).
:::

As NixOS grows, so too does the need for a catalogue and explanation of its
extensive functionality. Collecting pertinent information from disparate sources
and presenting it in an accessible style would be a worthy contribution to the
project.

## Directory structure of the manual {#sec-writing-docs-structure-of-the-manual}

The DocBook and CommonMark sources of NixOS' manual are in the [nixos/doc/manual](https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual) subdirectory of the [Nixpkgs](https://github.com/NixOS/nixpkgs) repository.
At the moment of writing, most of the documentation is written in CommonMark and
DocBook is used as the glue between the various CommonMark files containing
chapters and sections.

The documentation as a whole is split into multiple parts, split into chapters
with subchapters, which again are split into sections. Each part has its own
subdirectory containing the CommonMark files of its chapters and sections and
one DocBook XML file gluing the CommonMark files together. The only exception
is this chapter on contributing; it remains in the root folder of the manual.

The file structure is mirrored in the automatically generated table of contents,
though sections are excluded from the table of content.

## Editing CommonMark {#sec-writing-docs-editing-commonmark}

Please refer to the website of [CommonMark](https://commonmark.org/) for an
introduction into the CommonMark language.

## Creating a topic file {#sec-writing-docs-creating-a-topic}

You can use an existing topic as a basis for the new topic or create a
topic from scratch.

Keep the following guidelines in mind when you create and add a topic:

-   Store the topic file in the same directory as the `part` to which it
    belongs.

-   If you include multiple words in the file name, separate the words
    with a dash. For example: `ipv6-config.md` (or `ipv6-config.xml`
    when using `meta.doc`).

-   If the topic is about configuring a NixOS module, then the documentation
    file can be stored alongside the module definition `nix` file. The file can
    be automatically included in the manual by using the `meta.doc` attribute.
    See [](#sec-meta-attributes) This part of the documentation has to be
    written in DocBook XML as this feature has not transitioned to CommonMark,
    yet.

-   Determine whether your topic is a chapter, subchapter or a section. Chapters
    get a `.chapter.md` suffix, subchapters are part of the chapter file and
    sections get their separate `.section.md` file.

## Adding a topic file to the book {#sec-writing-docs-adding-a-topic}

:::{.warning}
Even though you created a `.md` file in the previous step, all references to a
topic file are to the corresponding `.xml` files, which are automatically
generated as shown in [](#sec-writing-docs-building-the-manual).
:::

If you created a chapter, open the DocBook XML file in the subdirectory of the
part it belongs to.

Here we add the chapter "Foo" in `some-part/foo.chapter.md` to the part
"Some Part" in `some-part/some-part.xml`:

```
 <xi:include href="../from_md/some-part/foo.chapter.xml" />
```

If you created a section, you add the file to the chapter's `.md` file in the
same directory. Keep in mind, that a section is a direct descendant of a
subchapter (indicated by `##` in the chapter file), not a chapter (indicated by
`#`).

Here we add the section "Bar" in `some-part/bar.section.md` to the chapter "Foo"
in `some-part/foo.chapter.md`:

````
```{=docbook}
<xi:include href="bar.section.xml" />
```
````

## Building the manual {#sec-writing-docs-building-the-manual}

You can quickly check your edits with the following:

```ShellSession
$ cd /path/to/nixpkgs
$ ./nixos/doc/manual/md-to-db.sh
$ nix-build nixos/release.nix -A manual.x86_64-linux
```

If the build succeeds, the manual will be in `./result/share/doc/nixos/index.html`.

## Publishing your changes {#sec-writing-docs-publishing-your-changes}

Once you are done making modifications to the manual, it is important to build
it one last time before committing and reviewing that your changes to the final
product were incorporated as you intended. Please regard
[CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md)
in [Nixpkgs](https://github.com/NixOS/nixpkgs) before creating a Pull Request.
