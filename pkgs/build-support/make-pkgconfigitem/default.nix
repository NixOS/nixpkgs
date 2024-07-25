{ lib, writeTextFile, buildPackages }:

# See https://people.freedesktop.org/~dbn/pkg-config-guide.html#concepts
{ name # The name of the pc file
  # keywords
  # provide a default description for convenience. it's not important but still required by pkg-config.
, description ? "Pkg-config file for ${name}"
, url ? ""
, version ? ""
, requires ? [ ]
, requiresPrivate ? [ ]
, conflicts ? [ ]
, cflags ? [ ]
, libs ? [ ]
, libsPrivate ? [ ]
, variables ? { }
}:

let
  # only 'out' has to be changed, otherwise it would be replaced by the out of the writeTextFile
  placeholderToSubstVar = builtins.replaceStrings [ "${placeholder "out"}" ] [ "@out@" ];

  replacePlaceholderAndListToString = x:
    if builtins.isList x
    then placeholderToSubstVar (builtins.concatStringsSep " " x)
    else placeholderToSubstVar x;

  keywordsSection =
    let
      mustBeAList = attr: attrName: lib.throwIfNot (lib.isList attr) "'${attrName}' must be a list" attr;
    in
    {
      "Name" = name;
      "Description" = description;
      "URL" = url;
      "Version" = version;
      "Requires" = mustBeAList requires "requires";
      "Requires.private" = mustBeAList requiresPrivate "requiresPrivate";
      "Conflicts" = mustBeAList conflicts "conflicts";
      "Cflags" = mustBeAList cflags "cflags";
      "Libs" = mustBeAList libs "libs";
      "Libs.private" = mustBeAList libsPrivate "libsPrivate";
    };

  renderVariable = name: value:
    lib.optionalString (value != "" && value != [ ]) "${name}=${replacePlaceholderAndListToString value}";
  renderKeyword = name: value:
    lib.optionalString (value != "" && value != [ ]) "${name}: ${replacePlaceholderAndListToString value}";

  renderSomething = renderFunc: attrs:
    lib.pipe attrs [
      (lib.mapAttrsToList renderFunc)
      (builtins.filter (v: v != ""))
      (builtins.concatStringsSep "\n")
      (section: ''${section}
      '')
    ];

  variablesSectionRendered = renderSomething renderVariable variables;
  keywordsSectionRendered = renderSomething renderKeyword keywordsSection;

  content = [ variablesSectionRendered keywordsSectionRendered ];
in
writeTextFile {
  name = "${name}.pc";
  destination = "/lib/pkgconfig/${name}.pc";
  text = builtins.concatStringsSep "\n" content;
  checkPhase = ''${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config --validate "$target"'';
}
