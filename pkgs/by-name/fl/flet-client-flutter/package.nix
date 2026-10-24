{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  flutter341,
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

flutter341.buildFlutterApplication rec {
  pname = "flet-client-flutter";
  version = "0.85.3";

  src = fetchFromGitHub {
    owner = "flet-dev";
    repo = "flet";
    tag = "v${version}";
    hash = "sha256-aLDb8TJgegYM1CFm3N33fa2EcY57Lgz5XGWxB13SUYI=";
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
    gst_all_1.gst-plugins-bad
    gst_all_1.gstreamer
    libunwind
    orc
    mimalloc
  ]
  ++ mpv-unwrapped.buildInputs
  ++ libplacebo.buildInputs;

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=nontrivial-memcall"
  ];

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater {
        rev-prefix = "v";
        # Exclude prerelease tags like v0.86.0.dev2 (gitUpdater ranks them "newer").
        allowedVersions = "^[0-9\\.]+$";
      })
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
    ];
    mainProgram = "flet";
    # Linux target pulls rive_native prebuilts that are currently x86_64-only.
    broken = fletTarget == "linux" && stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
}
