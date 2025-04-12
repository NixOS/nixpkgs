{
  lib,
  runCommand,
  junicode,
  texliveBasic,
}:
let
  texliveWithJunicode = texliveBasic.withPackages (p: [
    p.xetex
    junicode
  ]);

  texTest =
    {
      package,
      tex,
      fonttype,
      file,
    }:
    lib.attrsets.nameValuePair "${package}-${tex}-${fonttype}" (
      runCommand "${package}-test-${tex}-${fonttype}.pdf"
        {
          nativeBuildInputs = [ texliveWithJunicode ];
          inherit tex fonttype file;
        }
        ''
          substituteAll $file test.tex
          HOME=$PWD $tex test.tex
          cp test.pdf $out
        ''
    );
in
builtins.listToAttrs (
  lib.mapCartesianProduct texTest {
    tex = [
      "xelatex"
      "lualatex"
    ];
    fonttype = [
      "ttf"
      "otf"
    ];
    package = [ "junicode" ];
    file = [ ./test.tex ];
  }
  ++ [
    (texTest {
      package = "junicodevf";
      fonttype = "ttf";
      tex = "lualatex";
      file = ./test-vf.tex;
    })
  ]
)
