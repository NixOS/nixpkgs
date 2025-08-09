{
  lib,
  fetchFromGitHub,
  pkg-config,
  flutter329,
  gst_all_1,
  libunwind,
  makeWrapper,
  mimalloc,
  orc,
  python3,
  nix,
  gitUpdater,
  nix-prefetch-git,
  mpv-unwrapped,
  libplacebo,
  _experimental-update-script-combinators,
  fletTarget ? "linux",
}:

flutter329.buildFlutterApplication rec {
  pname = "flet-client-flutter";
  version = "0.28.3";

  src = fetchFromGitHub {
    owner = "flet-dev";
    repo = "flet";
    tag = "v${version}";
    hash = "sha256-fD42AcfU3a/7sNvLE81pd1jdwUn5dEro3uKzaRBCWIU=";
  };

  sourceRoot = "${src.name}/client";

  gitHashes = lib.importJSON ./git_hashes.json;

  cmakeFlags = [
    "-DMIMALLOC_LIB=${mimalloc}/lib/mimalloc.o"
  ];

  targetFlutterPlatform = fletTarget;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    makeWrapper
    mimalloc
    pkg-config
  ];

  buildInputs = [
    mpv-unwrapped
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    libunwind
    orc
    mimalloc
  ]
  ++ mpv-unwrapped.buildInputs
  ++ libplacebo.buildInputs;

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      {
        command = [
          "env"
          "PATH=${
            lib.makeBinPath [
              (python3.withPackages (p: [ p.pyyaml ]))
              nix-prefetch-git
              nix
            ]
          }"
          "python3"
          ./update-lockfiles.py
        ];
        supportedFeatures = [ "silent" ];
      }
    ];
  };

  meta = {
    description = "Framework that enables you to easily build realtime web, mobile, and desktop apps in Python. The frontend part";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
      lucasew
    ];
    mainProgram = "flet";
  };
}
