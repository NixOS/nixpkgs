{
  lib,
  buildNimPackage,
  fetchFromGitHub,

  ffmpeg-full,
  yt-dlp,
  lame,
  libopus,
  x264,
  dav1d,
  zlib,

  python3,
  python3Packages,
}:

buildNimPackage rec {
  pname = "auto-editor";
  version = "31.0.0";

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    tag = version;
    hash = "sha256-25xzVaG9seu4hE5rc776lvNucf8lsEDvjkQPbFzjgII=";
  };

  lockFile = ./lock.json;

  buildInputs = [
    ffmpeg-full
    lame
    libopus
    x264
    dav1d
    zlib
  ];

  env = {
    # Nothing should be dynamically linked, as ffmpeg should already link it.
    DISABLE_HEVC = "1";
    DISABLE_WHISPER = "1";
    DISABLE_VPX = "1";
    DISABLE_SVTAV1 = "1";
    DISABLE_VPL = "1";
  };

  postPatch = ''
    substituteInPlace src/log.nim \
      --replace-fail '"yt-dlp"' '"${lib.getExe yt-dlp}"'

    # buildNimPackage hack
    substituteInPlace ae.nimble \
      --replace-fail '"main=auto-editor"' '"main"'
  '';

  nativeCheckInputs = [
    python3
    python3Packages.av
  ];

  postInstall = ''
    mv $out/bin/main $out/bin/auto-editor
  '';

  meta = {
    changelog = "https://github.com/WyattBlue/auto-editor/releases/tag/${src.tag}";
    description = "Command line application for automatically editing video and audio by analyzing a variety of methods, most notably audio loudness";
    homepage = "https://auto-editor.com/";
    license = lib.licenses.unlicense;
    mainProgram = "auto-editor";
    maintainers = with lib.maintainers; [
      tomasajt
      utopiatopia
    ];
    platforms = lib.platforms.unix;
  };
}
