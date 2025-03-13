{
  lib,
  stdenv,
  fetchFromGitHub,
  flac,
  fuse,
  lame,
  libid3tag,
  libvorbis,
  autoreconfHook,
  pkg-config,
  pandoc,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "mp3fs";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "khenriks";
    repo = "mp3fs";
    rev = "v${version}";
    sha256 = "sha256-dF+DfkNKvYOucS6KjYR1MMGxayM+1HVS8mbmaavmgKM=";
  };

  postPatch = ''
    substituteInPlace src/mp3fs.cc \
      --replace-fail "#include <fuse_darwin.h>" "" \
      --replace-fail "osxfuse_version()" "fuse_version()"
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pandoc
  ];

  buildInputs = [
    flac
    fuse
    lame
    libid3tag
    libvorbis
    zlib
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "FUSE file system that transparently transcodes to MP3";
    longDescription = ''
      A read-only FUSE filesystem which transcodes between audio formats
      (currently FLAC and Ogg Vorbis to MP3) on the fly when opened and read.
      This can let you use a FLAC or Ogg Vorbis collection with software
      and/or hardware which only understands the MP3 format, or transcode
      files through simple drag-and-drop in a file browser.
    '';
    homepage = "https://khenriks.github.io/mp3fs/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Luflosi ];
    mainProgram = "mp3fs";
  };
}
