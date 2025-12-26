# nixos-render-docs

A [CommonMark](https://commonmark.org/) and [`man-pages`](https://www.man7.org/linux/man-pages/man7/man-pages.7.html) renderer for the NixOS and Nixpkgs manuals.

## Summary

`nixos-render-docs` implements [RFC 72](https://github.com/NixOS/rfcs/pull/72) and has enabled a lossless port of Nixpkgs and NixOS documentation, which was originally written in the [DocBook](https://docbook.org/whatis) format, to [CommonMark](https://commonmark.org/) with [custom extensions](../../../../doc/README.md#syntax).

Maintaining our own documentation rendering framework may appear extreme but has practical advantages:
- We never have to work around existing tools made under different assumptions
- We don't have to deal with unexpected breakage
- We can grow the framework with our evolving requirements without relying on external support or approval or the need to maintain a small diff to upstream
- The amount of code involved is minimal because it's single-purpose

Several alternatives to `nixos-render-docs` were discussed in the past.
A detailed analysis can be found in a [table comparing documentation rendering framework](https://ethercalc.net/dc4vcnnl8zv0).

## Redirects system

Moving contents around can cause links to break.

Since we have our own markdown parser, we can hook into the rendering process to extract all of the metadata around each content identifier.
The [mechanism for checking correctness of redirects](./src/nixos_render_docs/redirects.py) takes the collection of identifiers and a mapping of the identified content to its historical locations in the output.
It validates them against a set of rules, and creates a client-side redirect mapping for each output file, as well as a `_redirects` file for server-side redirects in [Netlify syntax](https://docs.netlify.com/routing/redirects/#syntax-for-the-redirects-file).

This allows us to catch:
- Identifiers that were removed or renamed
- Content that was moved from one location to another
- Various consistency errors in the redirects mapping

### Design considerations

The creation, movement, and removal of every identifier is captured in the Git history.
However, analysing hundreds of thousands of commits during the build process is impractical.

The chosen design is a trade-off between speed, repository size, and contributor friction:
- Stricter checks always require more attention from contributors
    - Checks should be reasonably fast and ideally happen locally, e.g. as part of the build, as anything else will substantially lengthen the feedback cycle.
- Computing redirects against previous revisions of the repository would be more space-efficient, but impractically slow.
    - It would also require keeping an impure or otherwise continuously updated reference to those other revisions.
    - The static mapping acts like a semi-automatically updated cache that we drag along with version history.
    - Other setups, such as a dedicated service to cache a history of moved content, are more complicated and would still be impure.
- Checking in large amounts of data that is touched often bears a risk of more merge conflicts or related build failures.

The solution picked here is to have a static mapping of the historical locations checked into the Git tree, such that it can be read during the build process.
This also ensures that an improper redirect mapping will cause `nixos-render-docs` to fail the build and thus enforce that redirects stay up-to-date with every commit.

### Redirects Mapping Structure

Here's an overview of this mapping:

```json
{
  "<identifier>": [
    "index.html#<identifier>",
    "foo.html#foo",
    "bar.html#foo"
  ]
}
```

- The keys of this mapping _must_ be an exhaustive list of all identifiers in the source files.
- The first element of the value of this mapping _must_ be the current output location (path and anchor) of the content signified by the identifier in the mapping key.
  - While the order of the remaining elements is unconstrained, please only prepend to this list when the content under the identifier moves in order to keep the diffs readable.

In case this identifier is renamed, the mapping would change into:

```json
{
  "<identifier-new>": [
    "index.html#<identifier-new>",
    "foo.html#<identifier>",
    "bar.html#foo",
    "index.html#<identifier>"
  ]
}
```

## Rendering multiple pages

The `include` directive accepts an argument `into-file` to specify the file into which the imported markdown should be rendered to. We can use this argument to set up multipage rendering of the manuals.

For example

~~~
```{=include=} appendix html:into-file=//release-notes.html
release-notes/release-notes.md
```
~~~

will render the release notes into a `release-notes.html` file, instead of making it a section within the default `index.html`.
