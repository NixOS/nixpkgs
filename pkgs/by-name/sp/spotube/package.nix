{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
  makeWrapper,
  undmg,
  wrapGAppsHook3,

  glib-networking,
  gtk3,
  libappindicator,
  libnotify,
  libsoup_3,
  mpv-unwrapped,
  xdg-user-dirs,
  webkitgtk_4_1,
}:

let
  pname = "spotube";
  version = "3.8.2";

  meta = {
    description = "Open source, cross-platform Spotify client compatible across multiple platforms";
    longDescription = ''
      Spotube is an open source, cross-platform Spotify client compatible across
      multiple platforms utilizing Spotify's data API and YouTube (or Piped.video or JioSaavn)
      as an audio source, eliminating the need for Spotify Premium
    '';
    downloadPage = "https://github.com/KRTirtho/spotube/releases";
    homepage = "https://spotube.krtirtho.dev/";
    license = lib.licenses.bsdOriginal;
    mainProgram = "spotube";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  fetchArtifact =
    { filename, hash }:
    fetchurl {
      url = "https://github.com/KRTirtho/spotube/releases/download/v${version}/${filename}";
      inherit hash;
    };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchArtifact {
      filename = "Spotube-macos-universal.dmg";
      hash = "sha256-2nqWHQDxJ0PcwTiLAa8YZffqwsdnepMpXvpqRPX5JxM=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      undmg
      makeBinaryWrapper
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications $out/bin
      cp -r spotube.app $out/Applications
      makeBinaryWrapper $out/Applications/spotube.app/Contents/MacOS/spotube $out/bin/spotube
      runHook postInstall
    '';
  };

  linux = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchArtifact {
      filename = "Spotube-linux-x86_64.deb";
      hash = "sha256-kDPNWbspmORClVMH91Lt3dLVsRwGxiBtB49CHSHxQxI=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook3
    ];

    buildInputs = [
      glib-networking
      gtk3
      libappindicator
      libnotify
      libsoup_3
      mpv-unwrapped
      webkitgtk_4_1
    ];

    dontWrapGApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r usr/* $out
      runHook postInstall
    '';

    preFixup = ''
      patchelf $out/share/spotube/lib/libmedia_kit_native_event_loop.so \
          --replace-needed libmpv.so.1 libmpv.so
    '';

    postFixup = ''
      makeWrapper $out/share/spotube/spotube $out/bin/spotube \
          "''${gappsWrapperArgs[@]}" \
          --prefix LD_LIBRARY_PATH : $out/share/spotube/lib:${lib.makeLibraryPath [ mpv-unwrapped ]} \
          --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
