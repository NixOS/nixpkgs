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

stdenv.mkDerivation (finalAttrs: {
  pname = "sparkle";
  version = "1.6.7";

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
      url = "https://github.com/xishang0128/sparkle/releases/download/${finalAttrs.version}/sparkle-linux-${finalAttrs.version}-${arch}.deb";
      hash = selectSystem {
        x86_64-linux = "sha256-WpyHZzQ3LkBToiBXLUoUx5H4ZhK3J5JVqXYDl+9MtHo=";
        aarch64-linux = "sha256-7u5CUB8i5b2PXhHw0x8rjCH8jcC2Ncrz00Nty7rqKng=";
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
    substituteInPlace $out/share/applications/sparkle.desktop \
      --replace-fail "/opt/sparkle/sparkle" "sparkle"
    ln -s $out/opt/sparkle/sparkle $out/bin/sparkle

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
      } $out/opt/sparkle/sparkle
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/xishang0128/sparkle";
    mainProgram = "sparkle";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
