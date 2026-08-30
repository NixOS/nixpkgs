{
  lib,
  runCommandCC,
  kak-tree-sitter-unwrapped,
  yq,
  configFile ? "${kak-tree-sitter-unwrapped.src}/kak-tree-sitter-config/default-config.toml",
}:
{
  grammarSrc,
  queriesSrc,
  grammarPin,
  queriesPin,
  lang,
}:

assert grammarSrc != null || queriesSrc != null;
assert grammarSrc != null -> grammarPin != null;
assert queriesSrc != null -> queriesPin != null;

runCommandCC "kak-tree-sitter-parser-${lang}"
  {
    nativeBuildInputs = [ yq ];
  }
  (
    ''
      mkdir -p $out/share/kak-tree-sitter
    ''
    + lib.optionalString (grammarSrc != null) ''
      mkdir -p $TMP/grammar-build
      cd $TMP/grammar-build
      cp -r ${grammarSrc} ./source
      chmod -R +w ./source

      build_dir="./source/$(tomlq -r '.grammar["${lang}"].path? // "src"' "${configFile}")/build"
      compile="$(tomlq -r '.grammar["${lang}"].compile? // "cc"' "${configFile}")"
      compile_args="$(tomlq -r '.grammar["${lang}"].compile_args? // ["-c", "-fpic", "../parser.c", "-I", ".."] | join(" ")' "${configFile}")"
      compile_flags="$(tomlq -r '.grammar["${lang}"].compile_flags? // ["-O3"] | join(" ")' "${configFile}")"
      link="$(tomlq -r '.grammar["${lang}"].link? // "cc"' "${configFile}")"
      link_args="$(tomlq -r '.grammar["${lang}"].link_args? // ["-shared", "-fpic", "parser.o", "-o", "${lang}.so"] | join(" ")' "${configFile}")"
      link_flags="$(tomlq -r '.grammar["${lang}"].link_flags? // ["-O3"] | join(" ")' "${configFile}")"

      mkdir -p "$build_dir"
      cd "$build_dir"
      "$compile" $compile_args $compile_flags
      "$link" $link_args $link_flags

      mkdir -p $out/share/kak-tree-sitter/grammars/${lang}
      cp ${lang}.so $out/share/kak-tree-sitter/grammars/${lang}/${grammarPin}.so
    ''
    + lib.optionalString (queriesSrc != null) ''
      queries_dir="${queriesSrc}/$(tomlq -r '.language["${lang}"].queries?.path? // "runtime/queries/${lang}"' "${configFile}")"
      mkdir -p $out/share/kak-tree-sitter/queries/${lang}
      cp -r "$queries_dir" "$out/share/kak-tree-sitter/queries/${lang}/${queriesPin}"
    ''
  )
