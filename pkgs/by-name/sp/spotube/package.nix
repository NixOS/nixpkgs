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
  version = "5.0.0";

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
    webkitgtk_4_1
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out
    cp -r usr/* $out
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r Spotube.app $out/Applications
    makeBinaryWrapper $out/Applications/Spotube.app/Contents/MacOS/Spotube $out/bin/spotube
  ''
  + ''
    runHook postInstall
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
        { suffix, hash }:
        fetchurl {
          name = "Spotube-${finalAttrs.version}-${suffix}";
          url = "https://github.com/KRTirtho/spotube/releases/download/v${finalAttrs.version}/Spotube-${suffix}";
          inherit hash;
        };
    in
    {
      "aarch64-linux" = fetchArtifact {
        suffix = "linux-aarch64.deb";
        hash = "sha256-xMYqhywxJTghJlxqO05i79140R5PBOsMw66BYIWq5Vw=";
      };
      "x86_64-linux" = fetchArtifact {
        suffix = "linux-x86_64.deb";
        hash = "sha256-ZsppON33jnn52eoVtCX7gyWy7lLlRRrhzvOz7reCP4Q=";
      };
      "x86_64-darwin" = fetchArtifact {
        suffix = "macos-universal.dmg";
        hash = "sha256-OMgDMWBsG/Powfti4ObeZfWFir8KzCbzi8ujV6Y967s=";
      };
      "aarch64-darwin" = fetchArtifact {
        suffix = "macos-universal.dmg";
        hash = "sha256-OMgDMWBsG/Powfti4ObeZfWFir8KzCbzi8ujV6Y967s=";
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
