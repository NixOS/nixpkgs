# Writing NixOS Documentation {#sec-writing-documentation}

As NixOS grows, so too does the need for a catalogue and explanation of
its extensive functionality. Collecting pertinent information from
disparate sources and presenting it in an accessible style would be a
worthy contribution to the project.

## Building the Manual {#sec-writing-docs-building-the-manual}

The DocBook sources of the [](#book-nixos-manual) are in the
[`nixos/doc/manual`](https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual)
subdirectory of the Nixpkgs repository.

You can quickly validate your edits with `make`:

```ShellSession
$ cd /path/to/nixpkgs/nixos/doc/manual
$ nix-shell
nix-shell$ make
```

Once you are done making modifications to the manual, it's important to
build it before committing. You can do that as follows:

```ShellSession
nix-build nixos/release.nix -A manual.x86_64-linux
```

When this command successfully finishes, it will tell you where the
manual got generated. The HTML will be accessible through the `result`
symlink at `./result/share/doc/nixos/index.html`.

## Editing DocBook XML {#sec-writing-docs-editing-docbook-xml}

For general information on how to write in DocBook, see [DocBook 5: The
Definitive Guide](http://www.docbook.org/tdg5/en/html/docbook.html).

Emacs nXML Mode is very helpful for editing DocBook XML because it
validates the document as you write, and precisely locates errors. To
use it, see [](#sec-emacs-docbook-xml).

[Pandoc](http://pandoc.org) can generate DocBook XML from a multitude of
formats, which makes a good starting point. Here is an example of Pandoc
invocation to convert GitHub-Flavoured MarkDown to DocBook 5 XML:

```ShellSession
pandoc -f markdown_github -t docbook5 docs.md -o my-section.md
```

Pandoc can also quickly convert a single `section.xml` to HTML, which is
helpful when drafting.

Sometimes writing valid DocBook is simply too difficult. In this case,
submit your documentation updates in a [GitHub
Issue](https://github.com/NixOS/nixpkgs/issues/new) and someone will
handle the conversion to XML for you.

## Creating a Topic {#sec-writing-docs-creating-a-topic}

You can use an existing topic as a basis for the new topic or create a
topic from scratch.

Keep the following guidelines in mind when you create and add a topic:

-   The NixOS [`book`](http://www.docbook.org/tdg5/en/html/book.html)
    element is in `nixos/doc/manual/manual.xml`. It includes several
    [`parts`](http://www.docbook.org/tdg5/en/html/book.html) which are in
    subdirectories.

-   Store the topic file in the same directory as the `part` to which it
    belongs. If your topic is about configuring a NixOS module, then the
    XML file can be stored alongside the module definition `nix` file.

-   If you include multiple words in the file name, separate the words
    with a dash. For example: `ipv6-config.xml`.

-   Make sure that the `xml:id` value is unique. You can use abbreviations
    if the ID is too long. For example: `nixos-config`.

-   Determine whether your topic is a chapter or a section. If you are
    unsure, open an existing topic file and check whether the main
    element is chapter or section.

## Adding a Topic to the Book {#sec-writing-docs-adding-a-topic}

Open the parent XML file and add an `xi:include` element to the list of
chapters with the file name of the topic that you created. If you
created a `section`, you add the file to the `chapter` file. If you created
a `chapter`, you add the file to the `part` file.

If the topic is about configuring a NixOS module, it can be
automatically included in the manual by using the `meta.doc` attribute.
See [](#sec-meta-attributes) for an explanation.
