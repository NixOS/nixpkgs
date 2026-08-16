# https://github.com/siers/nix-gitignore/

{ lib, runCommand }:

# An interesting bit from the gitignore(5):
# - A slash followed by two consecutive asterisks then a slash matches
# - zero or more directories. For example, "a/**/b" matches "a/b",
# - "a/x/b", "a/x/y/b" and so on.

let
  inherit (builtins) filterSource;

  inherit (lib)
    concatStringsSep
    elemAt
    filter
    head
    isList
    length
    optionals
    optionalString
    pathExists
    readFile
    removePrefix
    replaceStrings
    stringLength
    sub
    substring
    toList
    trace
    ;

  inherit (lib.strings) match split typeOf;

  debug = a: trace a a;
  last = l: elemAt l ((length l) - 1);
in
rec {
  # [["good/relative/source/file" true] ["bad.tmpfile" false]] -> root -> path
  filterPattern =
    patterns: root:
    (
      name: _type:
      let
        relPath = removePrefix ((toString root) + "/") name;
        matches = pair: (match (head pair) relPath) != null;
        matched = map (pair: [
          (matches pair)
          (last pair)
        ]) patterns;
      in
      last (
        last (
          [
            [
              true
              true
            ]
          ]
          ++ (filter head matched)
        )
      )
    );

  # string -> [[regex bool]]
  gitignoreToPatterns =
    gitignore:
    let
      # ignore -> bool
      isComment = i: (match "^(#.*|$)" i) != null;

      # ignore -> [ignore bool]
      computeNegation =
        l:
        let
          split = match "^(!?)(.*)" l;
        in
        [
          (elemAt split 1)
          (head split == "!")
        ];

      # regex -> regex
      handleHashesBangs = replaceStrings [ "\\#" "\\!" ] [ "#" "!" ];

      # ignore -> regex
      substWildcards =
        let
          special = "^$.+{}()";
          escs = "\\*?";
          splitString =
            let
              recurse =
                str:
                [ (substring 0 1 str) ] ++ (optionals (str != "") (recurse (substring 1 (stringLength str) str)));
            in
            str: recurse str;
          chars = s: filter (c: c != "" && !isList c) (splitString s);
          escape = s: map (c: "\\" + c) (chars s);
        in
        replaceStrings
          (
            (chars special)
            ++ (escape escs)
            ++ [
              "**/"
              "**"
              "*"
              "?"
            ]
          )
          (
            (escape special)
            ++ (escape escs)
            ++ [
              "(.*/)?"
              ".*"
              "[^/]*"
              "[^/]"
            ]
          );

      # (regex -> regex) -> regex -> regex
      mapAroundCharclass =
        f: r: # rl = regex or list
        let
          slightFix = replaceStrings [ "\\]" ] [ "]" ];
        in
        concatStringsSep "" (
          map (rl: if isList rl then slightFix (elemAt rl 0) else f rl) (split "(\\[([^\\\\]|\\\\.)+])" r)
        );

      # regex -> regex
      handleSlashPrefix =
        l:
        let
          split = (match "^(/?)(.*)" l);
          findSlash = l: optionalString ((match ".+/.+" l) == null) l;
          hasSlash = mapAroundCharclass findSlash l != l;
        in
        (if (elemAt split 0) == "/" || hasSlash then "^" else "(^|.*/)") + (elemAt split 1);

      # regex -> regex
      handleSlashSuffix =
        l:
        let
          split = (match "^(.*)/$" l);
        in
        if split != null then (elemAt split 0) + "($|/.*)" else l;

      # (regex -> regex) -> [regex, bool] -> [regex, bool]
      mapPat = f: l: [
        (f (head l))
        (last l)
      ];
    in
    map (
      l: # `l' for "line"
      mapPat (
        l: handleSlashSuffix (handleSlashPrefix (handleHashesBangs (mapAroundCharclass substWildcards l)))
      ) (computeNegation l)
    ) (filter (l: !isList l && !isComment l) (split "\n" gitignore));

  gitignoreFilter = ign: root: filterPattern (gitignoreToPatterns ign) root;

  # string|[string|file] (→ [string|file] → [string]) -> string
  gitignoreCompileIgnore =
    file_str_patterns: root:
    let
      onPath = f: a: if typeOf a == "path" then f a else a;
      str_patterns = map (onPath readFile) (toList file_str_patterns);
    in
    concatStringsSep "\n" str_patterns;

  gitignoreFilterPure =
    predicate: patterns: root: name: type:
    gitignoreFilter (gitignoreCompileIgnore patterns root) root name type && predicate name type;

  # This is a very hacky way of programming this!
  # A better way would be to reuse existing filtering by making multiple gitignore functions per each root.
  # Then for each file find the set of roots with gitignores (and functions).
  # This would make gitignoreFilterSource very different from gitignoreFilterPure.
  # rootPath → gitignoresConcatenated
  compileRecursiveGitignore =
    root:
    let
      dirOrIgnore = file: type: baseNameOf file == ".gitignore" || type == "directory";
      ignores = builtins.filterSource dirOrIgnore root;
    in
    readFile (
      runCommand "${baseNameOf root}-recursive-gitignore" { } ''
        cd ${ignores}

        find -type f -exec sh -c '
          rel="$(realpath --relative-to=. "$(dirname "$1")")/"
          if [ "$rel" = "./" ]; then rel=""; fi

          awk -v prefix="$rel" -v root="$1" -v top="$(test -z "$rel" && echo 1)" "
            BEGIN { print \"# \"root }

            /^!?[^\\/]+\/?$/ {
              match(\$0, /^!?/, negation)
              sub(/^!?/, \"\")

              if (top) { middle = \"\" } else { middle = \"**/\" }

              print negation[0] prefix middle \$0
            }

            /^!?(\\/|.*\\/.+$)/ {
              match(\$0, /^!?/, negation)
              sub(/^!?/, \"\")

              if (!top) sub(/^\//, \"\")

              print negation[0] prefix \$0
            }

            END { print \"\" }
          " "$1"
        ' sh {} \; > $out
      ''
    );

  withGitignoreFile = patterns: root: toList patterns ++ [ ".git" ] ++ [ (root + "/.gitignore") ];

  withRecursiveGitignoreFile =
    patterns: root: toList patterns ++ [ ".git" ] ++ [ (compileRecursiveGitignore root) ];

  # filterSource derivatives

  gitignoreFilterSourcePure =
    predicate: patterns: root:
    filterSource (gitignoreFilterPure predicate patterns root) root;

  gitignoreFilterSource =
    predicate: patterns: root:
    gitignoreFilterSourcePure predicate (withGitignoreFile patterns root) root;

  gitignoreFilterRecursiveSource =
    predicate: patterns: root:
    gitignoreFilterSourcePure predicate (withRecursiveGitignoreFile patterns root) root;

  # "Predicate"-less alternatives

  gitignoreSourcePure = gitignoreFilterSourcePure (_: _: true);
  gitignoreSource =
    patterns:
    let
      type = typeOf patterns;
    in
    if (type == "string" && pathExists patterns) || type == "path" then
      throw "type error in gitignoreSource(patterns -> source -> path), " "use [] or \"\" if there are no additional patterns"
    else
      gitignoreFilterSource (_: _: true) patterns;

  gitignoreRecursiveSource = gitignoreFilterRecursiveSource (_: _: true);
}
