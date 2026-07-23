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
  version = "0.6.2";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "reproducible-builds";
    repo = "disorderfs";
    tag = finalAttrs.version;
    hash = "sha256-1ehGbNYbOewnDrQ1JhozKMvfVaCH7sDCxrD0dvwAfw0=";
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
    mainProgram = "disorderfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
