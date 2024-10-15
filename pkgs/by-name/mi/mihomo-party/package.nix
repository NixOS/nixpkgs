{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  nss,
  nspr,
  alsa-lib,
  openssl,
  webkitgtk_4_0,
  udev,
  libayatana-appindicator,
  libGL,
}:
let
  version = "1.4.8";
  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-nPnPvF3rCJWk2gI4gy2pZfWI+QrwaE55HKpvOhV/5T0=";
        aarch64-linux = "sha256-zaUtbJ+uc+xNCb2pxxkg2kLQctTvXSAYRyTKAJ9+a5s=";
      };
    in
    fetchurl {
      url = "https://github.com/mihomo-party-org/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-${suffix}.deb";
      inherit hash;
    };
in
stdenv.mkDerivation {
  inherit version src;

  pname = "mihomo-party";

  passthru.updateScript = ./update.sh;

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    nss
    nspr
    alsa-lib
    openssl
    webkitgtk_4_0
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = map lib.getLib [
    udev
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r opt/mihomo-party usr/share $out
    substituteInPlace $out/share/applications/mihomo-party.desktop \
      --replace-fail "/opt/mihomo-party/mihomo-party" "mihomo-party"

    runHook postInstall
  '';

  preFixup = ''
    mkdir $out/bin
    makeWrapper $out/mihomo-party/mihomo-party $out/bin/mihomo-party \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
        ]
      }"
  '';

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/mihomo-party-org/mihomo-party";
    mainProgram = "mihomo-party";
    platforms = with lib.platforms; linux ++ darwin;
    broken = stdenv.hostPlatform.isDarwin;
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ aucub ];
  };
}
