{
  lib,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  replaceVars,
  makeWrapper,
  slimevr-server,
  nodejs,
  pnpm_9,
  rustPlatform,
  cargo-tauri,
  wrapGAppsHook3,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  gst_all_1,
  libayatana-appindicator,
}:

rustPlatform.buildRustPackage rec {
  pname = "slimevr";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "SlimeVR";
    repo = "SlimeVR-Server";
    rev = "v${version}";
    hash = "sha256-XQDbP+LO/brpl7viSxuV3H4ALN0yIkj9lwr5eS1txNs=";
    # solarxr
    fetchSubmodules = true;
  };

  buildAndTestSubdir = "gui/src-tauri";

  cargoHash = "sha256-jvt5x2Jr185XVSFjob4cusP/zYJklJ/eqZe47qUg58s=";

  pnpmDeps = pnpm_9.fetchDeps {
    pname = "${pname}-pnpm-deps";
    inherit version src;
    hash = "sha256-5IqIUwVvufrws6/xpCAilmgRNG4mUGX8NXajZcVZypM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs =
    [
      openssl
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      libayatana-appindicator
      webkitgtk_4_1
    ];

  patches = [
    # Upstream code uses Git to find the program version.
    (replaceVars ./gui-no-git.patch {
      inherit version;
    })
  ];

  cargoPatches = [
    # Fix Tauri dependencies issue.
    # FIXME: Remove with next package update.
    (fetchpatch {
      name = "enable-rustls-feature.patch";
      url = "https://github.com/SlimeVR/SlimeVR-Server/commit/2708b5a15b7c1b8af3e86d942c5e842d83cf078f.patch";
      hash = "sha256-UDVztPGPaKp2Hld3bMDuPMAu5s1OhvKEsTiXoDRK7cU=";
    })
  ];

  postPatch =
    ''
      # Tauri bundler expects slimevr.jar to exist.
      mkdir -p server/desktop/build/libs
      touch server/desktop/build/libs/slimevr.jar
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Both libappindicator-rs and SlimeVR need to know where Nix's appindicator lib is.
      pushd $cargoDepsCopy/libappindicator-sys
      oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
      substituteInPlace src/lib.rs \
        --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
      # Cargo doesn't like it when vendored dependencies are edited.
      substituteInPlace .cargo-checksum.json \
        --replace-warn $oldHash $(sha256sum src/lib.rs | cut -d " " -f 1)
      popd
      substituteInPlace gui/src-tauri/src/tray.rs \
        --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

  # solarxr needs to be installed after compiling its Typescript files. This isn't
  # done the first time, because `pnpm_9.configHook` ignores `package.json` scripts.
  preBuild = ''
    pnpm --filter solarxr-protocol install
  '';

  doCheck = false; # No tests

  # Get rid of placeholder slimevr.jar
  postInstall = ''
    rm $out/share/slimevr/slimevr.jar
    rm -d $out/share/slimevr
  '';

  # `JAVA_HOME`, `JAVA_TOOL_OPTIONS`, and `--launch-from-path` are so the GUI can
  # launch the server.
  postFixup = ''
    wrapProgram "$out/bin/slimevr" \
      --set JAVA_HOME "${slimevr-server.passthru.java.home}" \
      --set JAVA_TOOL_OPTIONS "${slimevr-server.passthru.javaOptions}" \
      --add-flags "--launch-from-path ${slimevr-server}/share/slimevr"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://docs.slimevr.dev/";
    description = "App for facilitating full-body tracking in virtual reality";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      gale-username
      imurx
    ];
    platforms = with lib.platforms; darwin ++ linux;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "slimevr";
  };
}
