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
}:

stdenv.mkDerivation rec {
  pname = "mihomo-party";
  version = "1.7.2";

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
      url = "https://github.com/mihomo-party-org/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-hJnb0K3ytw0ITwL6dY1klSG260WrZQiHhz4FRZ0idI4=";
        aarch64-linux = "sha256-6hAB1QezewgKI2We0zDTK+vNgxcMP2AEmGZqdSbMcWQ=";
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
    webkitgtk_4_0
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
}
