{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  perlPackages,
  libminc,
  octave,
  coreutils,
  minc_tools,
}:

stdenv.mkDerivation {
  pname = "minc-widgets";
  version = "1.0.0-unstable-2016-04-20";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "minc-widgets";
    rev = "f08b643894c81a1a2e0fbfe595a17a42ba8906db";
    hash = "sha256-dY3hU5Qi/IF/4Ax7mivriWZyXCZRqhlDEPfyMxw1L60=";
  };

  patches = [
    (fetchpatch {
      name = "cmake4-fix.patch";
      url = "https://github.com/BIC-MNI/minc-widgets/commit/9f5bc1996d2f9b4702efdb010834e2c7f1e3fbf1.patch";
      hash = "sha256-qqMKbxQS+HTRQaOP2DH/m8Z3DqoCMGLFp1AEKaQ6l5s=";
    })
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [ libminc ];
  propagatedBuildInputs =
    (with perlPackages; [
      perl
      GetoptTabular
      MNI-Perllib
    ])
    ++ [
      octave
      coreutils
      minc_tools
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
    homepage = "https://github.com/BIC-MNI/minc-widgets";
    description = "Collection of Perl and shell scripts for processing MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
  };
}
