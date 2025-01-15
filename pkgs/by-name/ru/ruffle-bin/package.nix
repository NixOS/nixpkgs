{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  wrapGAppsHook3,
  autoPatchelfHook,
  alsa-lib,
  wayland,
  libxkbcommon,
  vulkan-loader,
  xorg,
  openh264,
  withXorg ? stdenvNoCC.hostPlatform.isLinux,
}:
let
  pname = "ruffle-bin";
  version = "nightly-2025-01-13";

  openh264-2-4-1 = openh264.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "cisco";
      repo = "openh264";
      rev = "v2.4.1";
      hash = "sha256-ai7lcGcQQqpsLGSwHkSs7YAoEfGCIbxdClO6JpGA+MI=";
    };
    postPatch = "";
  });
  urlPrefix =
    version:
    "https://github.com/ruffle-rs/ruffle/releases/download/${version}/ruffle-nightly-${
      builtins.replaceStrings [ "-" ] [ "_" ] (lib.strings.removePrefix "nightly-" version)
    }";
  x86_64-linux = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      meta
      ;

    src = fetchurl {
      url = "${urlPrefix finalAttrs.version}-linux-x86_64.tar.gz";
      hash = "sha256-pn+3cWgMnH06VCBgRxVGB9Dx9Kxq5IAm6ytLa744OOY=";
    };

    nativeBuildInputs = [
      wrapGAppsHook3
      autoPatchelfHook
    ];

    buildInputs = [
      alsa-lib # libasound.so.2
    ];

    runtimeDependencies =
      [
        wayland
        libxkbcommon
        vulkan-loader
        openh264-2-4-1
      ]
      ++ lib.optionals withXorg [
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libxcb
        xorg.libXrender
      ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      install -Dm755 -t $out/bin/ ruffle
      install -Dm644 -t $out/share/icons/hicolor/scalable/apps/ extras/rs.ruffle.Ruffle.svg
      install -Dm644 -t $out/share/applications/ extras/rs.ruffle.Ruffle.desktop
      install -Dm644 -t $out/share/metainfo/ extras/rs.ruffle.Ruffle.metainfo.xml
      install -Dm644 -t $out/share/doc/ruffle LICENSE.md
      install -Dm644 -t $out/share/doc/ruffle README.md

      runHook postInstall
    '';
  });

  # TODO: Add Darwin support.
  darwin = null;

  meta = {
    description = "Nightly pre-built binary release of ruffle, the Adobe Flash Player emulator";
    homepage = "https://ruffle.rs/";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    downloadPage = "https://ruffle.rs/downloads";
    changelog = "https://github.com/ruffle-rs/ruffle/releases/tag/nightly-${version}";
    maintainers = [ ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "ruffle";
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else x86_64-linux
