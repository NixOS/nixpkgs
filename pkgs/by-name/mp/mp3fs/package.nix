{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  flac,
  fuse3,
  lame,
  libid3tag,
  libvorbis,
  autoreconfHook,
  pkg-config,
  pandoc,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mp3fs";
  version = "1.1.1-unstable-2023-01-29";

  src = fetchFromGitHub {
    owner = "khenriks";
    repo = "mp3fs";
    rev = "cd2ca80eb3912ff8385e6d537df10d9a768a3a96";
    hash = "sha256-lueF8fEV+0LQOxf2MhK9dPWkfsTF4nP3PijqjJvDPzo=";
  };

  patches = [
    (fetchpatch2 {
      name = "Enable fuse3 support.patch";
      # https://github.com/khenriks/mp3fs/pull/81
      url = "https://github.com/khenriks/mp3fs/commit/6e1326de4a19b236eef88b89599755adf394526f.patch?full_index=1";
      hash = "sha256-V2HZy0jiXAHGAjre+QtCdGev7maWJ8hW3F2e/87CEKA=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pandoc
  ];

  buildInputs = [
    flac
    fuse3
    lame
    libid3tag
    libvorbis
    zlib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "FUSE file system that transparently transcodes to MP3";
    longDescription = ''
      A read-only FUSE filesystem which transcodes between audio formats
      (currently FLAC and Ogg Vorbis to MP3) on the fly when opened and read.
      This can let you use a FLAC or Ogg Vorbis collection with software
      and/or hardware which only understands the MP3 format, or transcode
      files through simple drag-and-drop in a file browser.
    '';
    homepage = "https://khenriks.github.io/mp3fs/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Luflosi ];
    mainProgram = "mp3fs";
  };
})
