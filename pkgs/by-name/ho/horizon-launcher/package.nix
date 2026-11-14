{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  buildFHSEnv,
  jdk25,
  openssl,
  alsa-lib,
  udev,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

let
  unwrapped = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "horizon-launcher-unwrapped";
    version = "0.2.63";

    __structuredAttrs = true;

    env = {
      # launcher/Cargo.toml is not bumped every release; CI sets these at compile time (launcher.yml).
      HORIZON_LAUNCHER_VERSION = finalAttrs.version;
      HORIZON_LAUNCHER_TAG = "launcher@${finalAttrs.version}";
      # Public Azure app id (docs/microsoft-account.md); empty build cannot sign in to Microsoft.
      HORIZON_MSA_CLIENT_ID = "331e08f8-172d-43b9-835a-3108c2fcdbf3";
    };

    src = fetchFromGitHub {
      owner = "horizon-rust";
      repo = "horizon";
      tag = "launcher@${finalAttrs.version}";
      hash = "sha256-tLWWxyxGzz6jET8hzgqeA4Umpyuuy46a3IZdvGe52ZE=";
    };

    cargoRoot = "launcher";
    buildAndTestSubdir = "launcher";

    cargoHash = "sha256-bm//pWLdyvr2qDTtzAes5/gFRpU1Mzdypp5xlGo68BY=";

    postPatch = ''
      substituteInPlace launcher/src/main.rs \
        --replace-fail "let _ = horizon_launcher::desktop::repair(backend::exe_path());" ""
    '';

    nativeBuildInputs = [
      pkg-config
      makeWrapper
    ];

    buildInputs = [
      alsa-lib
      udev
      fontconfig
      freetype
      libGL
      libxcb
      libxkbcommon
      openssl
      vulkan-loader
      wayland
    ];

    doCheck = false;

    installPhase = ''
      runHook preInstall

      install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/horizon-launcher $out/bin/horizon-launcher

      mkdir -p $out/share/icons
      cp -r packaging/icons/hicolor $out/share/icons/
      install -Dm644 -t $out/share/applications packaging/linux/horizon-launcher.desktop packaging/linux/horizon.desktop

      wrapProgram $out/bin/horizon-launcher \
        --set-default HORIZON_TELEMETRY_URL off \
        --set-default HORIZON_LAUNCHER_NO_SELF_UPDATE 1 \
        --prefix PATH : ${lib.makeBinPath [ jdk25 ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

      runHook postInstall
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      $out/bin/horizon-launcher --version
      runHook postInstallCheck
    '';

    passthru.upstreamTag = finalAttrs.src.tag;

    meta = {
      description = "Launcher for Horizon, an unofficial native Minecraft: Java Edition 26.3 client";
      longDescription = ''
        Horizon is Minecraft: Java Edition 26.3 rewritten in Rust. This launcher
        downloads Horizon nightlies, prepares game resources from your own legally
        obtained copy of Minecraft, and starts the client.

        Not an official Minecraft product. Not approved by or associated with
        Mojang or Microsoft. Horizon contains no Minecraft code, assets or data.
      '';
      homepage = "https://playhorizon.dev";
      changelog = "https://github.com/horizon-rust/horizon/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ cleboost ];
      mainProgram = "horizon-launcher";
      platforms = lib.platforms.linux;
    };
  });
in
buildFHSEnv {
  pname = "horizon-launcher";
  inherit (unwrapped) version meta;

  targetPkgs =
    pkgs:
    [
      unwrapped
      jdk25
    ]
    ++ (with pkgs; [
      alsa-lib
      alsa-plugins
      pipewire
      libpulseaudio
      udev
      libGL
      vulkan-loader
      wayland
      libxkbcommon
      libx11
      libxcb
      libxcursor
      libxi
      libxrandr
      fontconfig
      freetype
      openssl
      zlib
      xdg-utils
      stdenv.cc.cc.lib
      # native mod toolchain
      stdenv.cc
      pkg-config
      alsa-lib.dev
      udev.dev
      openssl.dev
      gnumake
      git
    ]);

  extraOutputsToInstall = [ "dev" ];

  profile = ''
    export HORIZON_LAUNCHER_NO_SELF_UPDATE=1
    export HORIZON_LAUNCHER_DESKTOP_EXEC=''${HORIZON_LAUNCHER_DESKTOP_EXEC:-horizon-launcher}
    export JAVA_HOME=${jdk25.home}
    export ALSA_PLUGIN_DIR=/usr/lib/alsa-lib
    export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig
  '';

  runScript = "horizon-launcher";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${unwrapped}/share/applications $out/share/applications
    ln -s ${unwrapped}/share/icons $out/share/icons
  '';

  passthru = unwrapped.passthru // {
    inherit unwrapped;
  };
}
