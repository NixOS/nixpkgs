{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse,
  libmtp,
  glib,
  libmad,
  libid3tag,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtpfs";
  version = "0-unstable-2024-12-10";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    fuse
    libmtp
    glib
    libid3tag
    libmad
  ];

  src = fetchFromGitHub {
    owner = "cjd";
    repo = "mtpfs";
    rev = "1177d6cfd8916915f5db7d9b5c6fc9e6eafae6e6";
    hash = "sha256-/84C8FUW+7U7u7yOzVB6ROoIUKtyIBG0wdD5t53yays=";
  };

  # Use unstable version to pull in gcc-15 fix until the next release
  # is out: https://github.com/cjd/mtpfs/pull/28
  passthru.updateScript = unstableGitUpdater {
  };

  meta = {
    homepage = "https://github.com/cjd/mtpfs";
    description = "FUSE Filesystem providing access to MTP devices";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.qknight ];
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/mtpfs.x86_64-darwin
    mainProgram = "mtpfs";
  };
})
