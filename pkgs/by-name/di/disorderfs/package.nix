{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  fuse3,
  attr,
  asciidoc-full,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "disorderfs";
  version = "0.7.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "reproducible-builds";
    repo = "disorderfs";
    tag = finalAttrs.version;
    hash = "sha256-5eW5/fZesRvgXUANtbDCTDHiBvFiTQ32BPJSqoW/yYc=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoc-full
  ];

  buildInputs = [
    fuse3
    attr
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Overlay FUSE filesystem that introduces non-determinism into filesystem metadata";
    homepage = "https://salsa.debian.org/reproducible-builds/disorderfs";
    mainProgram = "disorderfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
