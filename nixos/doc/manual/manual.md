# NixOS Manual {#book-nixos-manual}
## Version @NIXOS_VERSION@

<!--
  this is the top-level structure file for the nixos manual.

  the manual structure extends the nixpkgs commonmark further with include
  blocks to allow better organization of input text. there are six types of
  include blocks: preface, parts, chapters, sections, appendix, and options.
  each type except `options`` corresponds to the docbook elements of (roughly)
  the same name, and can itself can further include blocks to denote its
  substructure.

  non-`options`` include blocks are fenced code blocks that list a number of
  files to include, in the form

     ```{=include=} <type>
     <file-name-1>
     <file-name-2>
     <...>
     ```

  `options` include blocks do not list file names but contain a list of key-value
  pairs that describe the options to be included and how to convert them into
  elements of the manual output type:

      ```{=include=} options
      id-prefix: <options id prefix>
      list-id: <variable list element id>
      source: <path to options.json>
      ```

-->

```{=include=} preface
preface.md
```

```{=include=} parts
installation/installation.md
configuration/configuration.md
administration/running.md
development/development.md
```

```{=include=} chapters
contributing-to-this-manual.chapter.md
```

```{=include=} appendix html:into-file=//options.html
nixos-options.md
```

```{=include=} appendix html:into-file=//release-notes.html
release-notes/release-notes.md
```
