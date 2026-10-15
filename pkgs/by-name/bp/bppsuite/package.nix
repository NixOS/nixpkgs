{
  stdenv,
  fetchFromGitHub,
  cmake,
  texinfo,
  bpp-core,
  bpp-seq,
  bpp-phyl,
  bpp-popgen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bppsuite";

  inherit (bpp-core) version postPatch;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = "bppsuite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ut1MTdycKot3PMyxYSlTo/IkAoh7qm1CqIMt/NljvPE=";
  };

  nativeBuildInputs = [
    cmake
    texinfo
  ];
  buildInputs = [
    bpp-core
    bpp-seq
    bpp-phyl
    bpp-popgen
  ];

  meta = bpp-core.meta // {
    homepage = "https://github.com/BioPP/bppsuite";
    changelog = "https://github.com/BioPP/bppsuite/blob/master/ChangeLog";
  };
})
