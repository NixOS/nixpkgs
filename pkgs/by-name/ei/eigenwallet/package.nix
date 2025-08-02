{
  lib,
  fetchurl,
  stdenv,
  dpkg,
  autoPatchelfHook,
  cairo,
  gdk-pixbuf,
  webkitgtk_4_1,
  gtk3,
  buildFHSEnv,
}:

let
  version = "2.0.3";

  deps = [
    cairo
    gdk-pixbuf
    webkitgtk_4_1
    gtk3
  ];

  thisPackage = stdenv.mkDerivation (finalAttrs: {
    pname = "eigenwallet";
    inherit version;

    src = fetchurl {
      url = "https://github.com/eigenwallet/core/releases/download/${finalAttrs.version}/UnstoppableSwap_${finalAttrs.version}_amd64.deb";
      hash = "sha256-2uOsZ6IvaQes+FYGQ0cNYlySzjyNwf/3fqk3DJzN+WI=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    buildInputs = [
      cairo
      gdk-pixbuf
      webkitgtk_4_1
      gtk3
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      mv {usr/bin,usr/share} $out

      runHook postInstall
    '';

    meta = {
      description = "Protocol and desktop application for swapping Monero and Bitcoin";
      homepage = "https://unstoppableswap.net";
      maintainers = with lib.maintainers; [ JacoMalan1 ];
      license = lib.licenses.gpl3Only;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "unstoppableswap-gui-rs";
    };
  });
in

buildFHSEnv {
  name = "unstoppableswap-gui-rs";
  targetPkgs = _: deps ++ [ thisPackage ];
  runScript = "unstoppableswap-gui-rs";

  inherit (thisPackage) meta;
}
