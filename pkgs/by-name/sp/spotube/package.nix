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

stdenv.mkDerivation (finalAttrs: {
  pname = "spotube";
  version = "3.9.0";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  sourceRoot = lib.optionalString stdenv.hostPlatform.isDarwin ".";

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      undmg
      makeBinaryWrapper
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
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

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out
      cp -r usr/* $out
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r Spotube.app $out/Applications
      makeBinaryWrapper $out/Applications/Spotube.app/Contents/MacOS/Spotube $out/bin/spotube
    ''}

    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/share/spotube/lib/libmedia_kit_native_event_loop.so \
        --replace-needed libmpv.so.1 libmpv.so
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapper $out/share/spotube/spotube $out/bin/spotube \
        "''${gappsWrapperArgs[@]}" \
        --prefix LD_LIBRARY_PATH : $out/share/spotube/lib:${lib.makeLibraryPath [ mpv-unwrapped ]} \
        --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
  '';

  passthru.sources =
    let
      fetchArtifact =
        { filename, hash }:
        fetchurl {
          url = "https://github.com/KRTirtho/spotube/releases/download/v${finalAttrs.version}/${filename}";
          inherit hash;
        };
    in
    {
      "aarch64-linux" = fetchArtifact {
        filename = "Spotube-linux-aarch64.deb";
        hash = "sha256-KBuUAgUU6c/rBkkbpYjSarzckIoi+gRtCkumvtaoras=";
      };
      "x86_64-linux" = fetchArtifact {
        filename = "Spotube-linux-x86_64.deb";
        hash = "sha256-vzzK3csyKYP6fKKIoysziBsc2tqrg5LXS/6KoXBtNVI=";
      };
      "x86_64-darwin" = fetchArtifact {
        filename = "Spotube-macos-universal.dmg";
        hash = "sha256-wwIIKY+bmMJZigc2AK/QMg142uvZ+D6LOddzedJM5f8=";
      };
      "aarch64-darwin" = fetchArtifact {
        filename = "Spotube-macos-universal.dmg";
        hash = "sha256-wwIIKY+bmMJZigc2AK/QMg142uvZ+D6LOddzedJM5f8=";
      };
    };

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
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
