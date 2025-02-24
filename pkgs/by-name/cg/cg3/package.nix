{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  dieHook,
  cmake,
  icu,
  boost,
}:

let
  cg3 = stdenv.mkDerivation rec {
    pname = "cg3";
    version = "1.3.9";

    src = fetchFromGitHub {
      owner = "GrammarSoft";
      repo = "${pname}";
      rev = "v${version}";
      sha256 = "sha256-TiEhhk90w5GibGZ4yalIf+4qLA8NoU6+GIPN6QNTz2A=";
    };

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      icu
      boost
    ];

    doCheck = true;

    postFixup = ''
      substituteInPlace "$out"/lib/pkgconfig/cg3.pc \
        --replace '=''${prefix}//' '=/'
    '';

    passthru.tests.minimal =
      runCommand "${pname}-test"
        {
          buildInputs = [
            cg3
            dieHook
          ];
        }
        ''
          echo 'DELIMITERS = "."; ADD (tag) (*);' >grammar.cg3
          printf '"<a>"\n\t"a" tag\n\n' >want.txt
          printf '"<a>"\n\t"a"\n\n' | vislcg3 -g grammar.cg3 >got.txt
          diff -s want.txt got.txt || die "Grammar application did not produce expected parse"
          touch $out
        '';

    # TODO, consider optionals:
    # - Enable tcmalloc unless darwin?
    # - Enable python bindings?

    meta = with lib; {
      homepage = "https://github.com/GrammarSoft/cg3";
      description = "Constraint Grammar interpreter, compiler and applicator vislcg3";
      maintainers = with maintainers; [ unhammer ];
      license = licenses.gpl3Plus;
      platforms = platforms.all;
    };
  };

in
cg3
