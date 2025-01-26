{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  nss,
  nspr,
  alsa-lib,
  openssl,
  webkitgtk_4_0,
  udev,
  libayatana-appindicator,
  libGL,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "mihomo-party";
  version = "1.6.0";

  src =
    let
      selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://github.com/mihomo-party-org/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-dcjw4qGs6Q04LzY2cQLB8DrLybXFH8qFGZfLGz2aBM0=";
        aarch64-linux = "sha256-brDWmEwRaRCzmVVqKrX4NWhIICEZulnepWpGMxk2gPE=";
      };
    };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    nss
    nspr
    alsa-lib
    openssl
    webkitgtk_4_0
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = map lib.getLib [
    udev
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/app
    cp -r opt/mihomo-party $out/app/mihomo-party
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/mihomo-party.desktop \
      --replace-fail "/opt/mihomo-party/mihomo-party" "mihomo-party"

    runHook postInstall
  '';

  preFixup = ''
    mkdir $out/bin
    makeWrapper $out/app/mihomo-party/mihomo-party $out/bin/mihomo-party \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/mihomo-party-org/mihomo-party";
    mainProgram = "mihomo-party";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
  };
}
