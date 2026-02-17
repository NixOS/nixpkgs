{
  lib,
  stdenv,
  config,
  buildNimPackage,
  fetchFromGitHub,

  withHEVC ? true,
  withWhisper ? false, # TODO: Investigate linker failure. See PR 476678
  withVpx ? true,
  withSvtAv1 ? true,
  withCuda ? false,
  withVpl ? stdenv.hostPlatform.isLinux,

  ffmpeg-full,
  yt-dlp,
  lame,
  libopus,
  libvpx,
  x264,
  x265,
  dav1d,
  svt-av1,
  libvpl,
  whisper-cpp,

  python3,
  python3Packages,
}:

buildNimPackage rec {
  pname = "auto-editor";
  version = "29.7.0";

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    tag = version;
    hash = "sha256-R1GnvFjC/nq/gIiX6rUxP7qR3IfpGfc4Ci28AIk4CfQ=";
  };

  lockFile = ./lock.json;

  buildInputs = [
    ffmpeg-full
    lame
    libopus
    x264
    dav1d
  ]
  ++ lib.optionals withHEVC [ x265 ]
  ++ lib.optionals withWhisper [ whisper-cpp ]
  ++ lib.optionals withVpx [ libvpx ]
  ++ lib.optionals withSvtAv1 [ svt-av1 ]
  ++ lib.optionals withVpl [ libvpl ];

  nimFlags =
    lib.optionals withHEVC [ "-d:enable_hevc" ]
    ++ lib.optionals withWhisper [ "-d:enable_whisper" ]
    ++ lib.optionals withVpx [ "-d:enable_vpx" ]
    ++ lib.optionals withSvtAv1 [ "-d:enable_svtav1" ]
    ++ lib.optionals withCuda [ "-d:enable_cuda" ]
    ++ lib.optionals withVpl [ "-d:enable_vpl" ];

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

  checkPhase = ''
    runHook preCheck

    eval "nim r --nimcache:$NIX_BUILD_TOP/nimcache $nimFlags $src/tests/unit.nim"

    substituteInPlace tests/test.py \
      --replace-fail '"./auto-editor"' "\"$out/bin/main\""

    python3 tests/test.py

    runHook postCheck
  '';

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
