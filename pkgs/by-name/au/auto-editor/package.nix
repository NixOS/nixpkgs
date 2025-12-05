{
  lib,
  buildNimPackage,
  fetchFromGitHub,

  withHEVC ? true,
  withWhisper ? false,

  ffmpeg,
  yt-dlp,
  lame,
  libopus,
  libvpx,
  x264,
  x265,
  dav1d,
  svt-av1,
  whisper-cpp,

  python3,
  python3Packages,
  nimble,
  nim,
}:

buildNimPackage rec {
  pname = "auto-editor";
  version = "29.3.1";

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    tag = version;
    hash = "sha256-Nne6niGnhaEQNvvFURmF0N9oyuG1ZvJ4NzxddJdSQtY=";
  };

  lockFile = ./lock.json;

  buildInputs = [
    ffmpeg
    lame
    libopus
    libvpx
    x264
    dav1d
    svt-av1
  ]
  ++ lib.optionals withHEVC [
    x265
  ]
  ++ lib.optionals withWhisper [
    whisper-cpp
  ];

  nimFlags = [
    "--passc:-Wno-incompatible-pointer-types"
  ]
  ++ lib.optionals withHEVC [
    "-d:enable_hevc"
  ]
  ++ lib.optionals withWhisper [
    "-d:enable_whisper"
  ];

  postPatch = ''
    substituteInPlace src/log.nim \
      --replace-fail '"yt-dlp"' '"${lib.getExe yt-dlp}"'

    # buildNimPackage hack
    substituteInPlace ae.nimble \
      --replace-fail '"main=auto-editor"' '"main"'
  '';

  # TODO: Fix checks
  /*
    nativeCheckInputs = [
      python3Packages.av
      python3
    ];

    checkPhase = ''
      runHook preCheck

      nim c \
      ${if withHEVC then "-d:enable_hevc" else ""} \
      ${if withWhisper then "-d:enable_whisper" else ""} \
      -r $src/src/rationals

      python3 $src/tests/test.py

      runHook postCheck
    '';
  */

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
