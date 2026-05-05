{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  flex,
  libedit,
  pcre2,
  sqlite,
  runCommand,
  dieHook,
}:

let

  link-grammar = stdenv.mkDerivation (finalAttrs: {
    pname = "link-grammar";
    version = "5.13.0";

    outputs = [
      "bin"
      "out"
      "dev"
      "man"
    ];

    src = fetchurl {
      url = "https://www.gnucash.org/link-grammar/downloads/${finalAttrs.version}/link-grammar-${finalAttrs.version}.tar.gz";
      hash = "sha256-5qDJBd+xdfNZefA1CgzzxnyzimgZ2fK3PGhN/nKpQd8=";
    };

    nativeBuildInputs = [
      pkg-config
      python3
      flex
    ];

    buildInputs = [
      libedit
      pcre2
      sqlite
    ];

    configureFlags = [
      "--disable-java-bindings"
    ];

    doCheck = true;

    passthru.tests = {
      quick =
        runCommand "link-grammar-quick-test"
          {
            buildInputs = [
              link-grammar
              dieHook
            ];
          }
          ''
            echo "Furiously sleep ideas green colorless." | link-parser en | grep "No complete linkages found." || die "Grammaticaly invalid sentence was parsed."
            echo "Colorless green ideas sleep furiously." | link-parser en | grep "Found .* linkages." || die "Grammaticaly valid sentence was not parsed."
            touch $out
          '';
    };

    meta = {
      description = "Grammar Checking library";
      homepage = "https://opencog.github.io/link-grammar-website/";
      changelog = "https://github.com/opencog/link-grammar/blob/link-grammar-${finalAttrs.version}/ChangeLog";
      license = lib.licenses.lgpl21Only;
      maintainers = with lib.maintainers; [ jtojnar ];
      platforms = lib.platforms.unix;
    };
  });

in
link-grammar
