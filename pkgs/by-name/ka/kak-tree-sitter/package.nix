{
  lib,
  makeWrapper,
  symlinkJoin,
  tinycc,
  kak-tree-sitter-unwrapped,
}:

symlinkJoin rec {
  pname = lib.replaceStrings [ "-unwrapped" ] [ "" ] kak-tree-sitter-unwrapped.pname;
  inherit (kak-tree-sitter-unwrapped) version;
  name = "${pname}-${version}";

  paths = [ kak-tree-sitter-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];

  # Tree-Sitter grammars are C programs that need to be compiled
  # Use tinycc as cc to reduce closure size
  postBuild = ''
    mkdir -p $out/libexec/tinycc/bin
    ln -s ${lib.getExe tinycc} $out/libexec/tinycc/bin/cc
    wrapProgram "$out/bin/ktsctl" \
      --suffix PATH : $out/libexec/tinycc/bin
  '';

  inherit (kak-tree-sitter-unwrapped) meta;
}
