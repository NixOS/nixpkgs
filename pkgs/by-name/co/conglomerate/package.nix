{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  coreutils,
  perlPackages,
  bicpl,
  libminc,
  zlib,
  minc_tools,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "conglomerate";
  version = "unstable-2023-01-19";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "6fb26084f2871a85044e2e4afc868982702b40ed";
    hash = "sha256-Inr4b2bxguzkcRQBURObsQQ0Rb3H/Zz6hEzNRd+IX3w=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    libminc
    zlib
    bicpl
  ];
  propagatedBuildInputs =
    [
      coreutils
      minc_tools
    ]
    ++ (with perlPackages; [
      perl
      GetoptTabular
      MNI-Perllib
    ]);

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DBICPL_DIR=${bicpl}/lib"
  ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB --set PATH "${
        lib.makeBinPath [
          coreutils
          minc_tools
        ]
      }";
    done
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/conglomerate";
    description = "More command-line utilities for working with MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.hpndUc;
  };
}
