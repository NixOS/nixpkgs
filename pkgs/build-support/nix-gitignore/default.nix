# https://github.com/siers/nix-gitignore/

{ lib, runCommand }:

# An interesting bit from the gitignore(5):
# - A slash followed by two consecutive asterisks then a slash matches
# - zero or more directories. For example, "a/**/b" matches "a/b",
# - "a/x/b", "a/x/y/b" and so on.

with builtins;

let
  debug = a: trace a a;
  last = l: elemAt l ((length l) - 1);

  throwIfOldNix = let required = "2.0"; in
    if compareVersions nixVersion required == -1
    then throw "nix (v${nixVersion} =< v${required}) is too old for nix-gitignore"
    else true;
in rec {
  # [["good/relative/source/file" true] ["bad.tmpfile" false]] -> root -> path
  filterPattern = patterns: root:
    (name: _type:
      let
        relPath = lib.removePrefix ((toString root) + "/") name;
        matches = pair: (match (head pair) relPath) != null;
        matched = map (pair: [(matches pair) (last pair)]) patterns;
      in
        last (last ([[true true]] ++ (filter head matched)))
    );

  # string -> [[regex bool]]
  gitignoreToPatterns = gitignore:
    assert throwIfOldNix;
    let
      # ignore -> bool
      isComment = i: (match "^(#.*|$)" i) != null;

      # ignore -> [ignore bool]
      computeNegation = l:
        let split = match "^(!?)(.*)" l;
        in [(elemAt split 1) (head split == "!")];

      # ignore -> regex
      substWildcards =
        let
          special = "^$.+{}()";
          escs = "\\*?";
          splitString =
            let recurse = str : [(substring 0 1 str)] ++
                                 (if str == "" then [] else (recurse (substring 1 (stringLength(str)) str) ));
            in str : recurse str;
          chars = s: filter (c: c != "" && !isList c) (splitString s);
          escape = s: map (c: "\\" + c) (chars s);
        in
          replaceStrings
            ((chars special)  ++ (escape escs) ++ ["**/"    "**" "*"     "?"])
            ((escape special) ++ (escape escs) ++ ["(.*/)?" ".*" "[^/]*" "[^/]"]);

      # (regex -> regex) -> regex -> regex
      mapAroundCharclass = f: r: # rl = regex or list
        let slightFix = replaceStrings ["\\]"] ["]"];
        in
          concatStringsSep ""
          (map (rl: if isList rl then slightFix (elemAt rl 0) else f rl)
          (split "(\\[([^\\\\]|\\\\.)+])" r));

      # regex -> regex
      handleSlashPrefix = l:
        let
          split = (match "^(/?)(.*)" l);
          findSlash = l: if (match ".+/.+" l) != null then "" else l;
          hasSlash = mapAroundCharclass findSlash l != l;
        in
          (if (elemAt split 0) == "/" || hasSlash
          then "^"
          else "(^|.*/)"
          ) + (elemAt split 1);

      # regex -> regex
      handleSlashSuffix = l:
        let split = (match "^(.*)/$" l);
        in if split != null then (elemAt split 0) + "($|/.*)" else l;

      # (regex -> regex) -> [regex, bool] -> [regex, bool]
      mapPat = f: l: [(f (head l)) (last l)];
    in
      map (l: # `l' for "line"
        mapPat (l: handleSlashSuffix (handleSlashPrefix (mapAroundCharclass substWildcards l)))
        (computeNegation l))
      (filter (l: !isList l && !isComment l)
      (split "\n" gitignore));

  gitignoreFilter = ign: root: filterPattern (gitignoreToPatterns ign) root;

  # string|[string|file] (→ [string|file] → [string]) -> string
  gitignoreCompileIgnore = file_str_patterns: root:
    let
      onPath = f: a: if typeOf a == "path" then f a else a;
      str_patterns = map (onPath readFile) (lib.toList file_str_patterns);
    in concatStringsSep "\n" str_patterns;

  gitignoreFilterPure = filter: patterns: root: name: type:
    gitignoreFilter (gitignoreCompileIgnore patterns root) root name type
    && filter name type;

  # This is a very hacky way of programming this!
  # A better way would be to reuse existing filtering by making multiple gitignore functions per each root.
  # Then for each file find the set of roots with gitignores (and functions).
  # This would make gitignoreFilterSource very different from gitignoreFilterPure.
  # rootPath → gitignoresConcatenated
  compileRecursiveGitignore = root:
    let
      dirOrIgnore = file: type: baseNameOf file == ".gitignore" || type == "directory";
      ignores = builtins.filterSource dirOrIgnore root;
    in readFile (
      runCommand "${baseNameOf root}-recursive-gitignore" {} ''
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
      '');

  withGitignoreFile = patterns: root:
    lib.toList patterns ++ [(root + "/.gitignore")];

  withRecursiveGitignoreFile = patterns: root:
    lib.toList patterns ++ [(compileRecursiveGitignore root)];

  # filterSource derivatives

  gitignoreFilterSourcePure = filter: patterns: root:
    filterSource (gitignoreFilterPure filter patterns root) root;

  gitignoreFilterSource = filter: patterns: root:
    gitignoreFilterSourcePure filter (withGitignoreFile patterns root) root;

  gitignoreFilterRecursiveSource = filter: patterns: root:
    gitignoreFilterSourcePure filter (withRecursiveGitignoreFile patterns root) root;

  # "Filter"-less alternatives

  gitignoreSourcePure = gitignoreFilterSourcePure (_: _: true);
  gitignoreSource = patterns: let type = typeOf patterns; in
    if (type == "string" && pathExists patterns) || type == "path"
    then throw
      "type error in gitignoreSource(patterns -> source -> path), "
      "use [] or \"\" if there are no additional patterns"
    else gitignoreFilterSource (_: _: true) patterns;

  gitignoreRecursiveSource = gitignoreFilterSourcePure (_: _: true);
}
