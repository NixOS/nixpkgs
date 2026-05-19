{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  deadbeef,
  vgmstream,
  mpg123,
  libvorbis,
  ffmpeg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deadbeef-vgmstream-plugin";
  version = "2026-05-09.1";

  src = fetchFromGitHub {
    owner = "jchv";
    repo = "deadbeef-vgmstream";
    rev = finalAttrs.version;
    hash = "sha256-dR1TEx61jnprEQokHRX/mi3WvbS+CVp4VIMlutX6uS8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    deadbeef
    mpg123
    libvorbis
    ffmpeg.dev
  ];

  enableParallelBuilding = true;

  makeFlags = [ "DEADBEEF_ROOT=${deadbeef}" ];
  installFlags = [ "DEADBEEF_ROOT=$(out)" ];

  postUnpack = ''
    rm -rf $sourceRoot/vgmstream
    cp --no-preserve=mode,ownership -LR ${vgmstream.src} $sourceRoot/vgmstream
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Streaming video game music decoder plugin for the DeaDBeeF music player";
    homepage = "https://github.com/jchv/deadbeef-vgmstream";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.jchw ];
    platforms = lib.platforms.linux;
  };
})
