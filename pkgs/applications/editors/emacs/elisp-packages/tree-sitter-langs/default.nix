{ lib
, pkgs
, symlinkJoin
, fetchzip
, melpaBuild
, stdenv
, fetchFromGitHub
, writeText
}:

let
  version = "0.10.14";

  tree-sitter-grammars = stdenv.mkDerivation {
    name = "tree-sitter-grammars";

    inherit version;

    src = fetchzip rec {
      name = "tree-sitter-grammars-linux-${version}.tar.gz";
      url = "https://github.com/emacs-tree-sitter/tree-sitter-langs/releases/download/${version}/${name}";
      sha256 = "sha256-J8VplZWhyWN8ur74Ep0CTl4nPtESzfs2Gh6MxfY5Zqc=";
      stripRoot = false;
    };

    installPhase = ''
      install -d $out/langs/bin
      echo -n $version > $out/langs/bin/BUNDLE-VERSION
      install -m444 * $out/langs/bin
    '';
  };

in melpaBuild {
  inherit version;

  pname = "tree-sitter-langs";
  commit = version;

  src = fetchFromGitHub {
    owner = "emacs-tree-sitter";
    repo = "tree-sitter-langs";
    rev = version;
    sha256 = "sha256-uKfkhcm1k2Ov4fSr7ALVnpQoX/l9ssEWMn761pa7Y/c=";
  };

  recipe = writeText "recipe" ''
    (tree-sitter-langs
    :repo "emacs-tree-sitter/tree-sitter-langs"
    :fetcher github
    :files (:defaults "queries"))
  '';

  postPatch = ''
    substituteInPlace ./tree-sitter-langs-build.el \
    --replace "tree-sitter-langs-grammar-dir tree-sitter-langs--dir"  "tree-sitter-langs-grammar-dir \"${tree-sitter-grammars}/langs\""
  '';
}
