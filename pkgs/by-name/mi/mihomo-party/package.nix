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
  webkitgtk_4_1,
  udev,
  libayatana-appindicator,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mihomo-party";
  version = "1.7.7";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
    in
    fetchurl {
      url = "https://github.com/mihomo-party-org/mihomo-party/releases/download/v${finalAttrs.version}/mihomo-party-linux-${finalAttrs.version}-${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-u6h85NW7c57MDW0Vyg7lMbpYc0Ea2bDF6OKO9RJCGEU=";
        aarch64-linux = "sha256-KemT52mV7BVaanDCOUqPD5YSfx7q6j8Q5B/KyYX9CK8=";
      };
    };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    nss
    nspr
    alsa-lib
    openssl
    webkitgtk_4_1
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/mihomo-party.desktop \
      --replace-fail "/opt/mihomo-party/mihomo-party" "mihomo-party"
    ln -s $out/opt/mihomo-party/mihomo-party $out/bin/mihomo-party

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          udev
          libayatana-appindicator
        ]
      } $out/opt/mihomo-party/mihomo-party
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
})
