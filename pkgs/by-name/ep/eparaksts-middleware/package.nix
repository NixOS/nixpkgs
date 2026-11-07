{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  pcsclite,
  zlib,
  glib,
  gtk2,
  libsm,
  libxxf86vm,
  libGLU,
  buildFHSEnv,
  lib,
}:
let
  unwrapped = stdenv.mkDerivation (finalAttrs: {
    name = "latvia-eid-middleware-unwrapped";
    version = "2.2.16";

    src = fetchurl {
      url = "https://www.eparaksts.lv/files/ep3updates/debian/pool/eparaksts/l/latvia-eid-middleware/latvia-eid-middleware_${finalAttrs.version}-1_amd64.deb";
      hash = "sha256-WbGrxEkWcheCdvqipu/dePO3xcy841UjCkDgHttQk2g=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    buildInputs = [
      glib
      gtk2
      libGLU
      pcsclite
      libsm
      libxxf86vm
      zlib
    ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt
      cp -r opt/* $out/opt
      cp -r opt/latvia-eid/* $out/

      runHook postInstall
    '';
  });
  eidlv-pintool = buildFHSEnv {
    name = "eidlv-pintool";
    inherit (unwrapped) version;
    targetPkgs = pkgs: [
      unwrapped
    ];
    runScript = "${unwrapped}/bin/eidlv-pintool";
  };
in
# Combine unwrapped middleware package with fhs-wrapped eidlv-pintool.
stdenv.mkDerivation {
  name = "eparaksts-middleware";
  version = unwrapped.version;
  dontUnpack = true;
  dontBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    cp -r ${unwrapped} $out
    chmod -R +w $out
    ln -sf ${eidlv-pintool}/bin/eidlv-pintool $out/bin/eidlv-pintool
  '';

  meta = {
    description = "Latvia eID signing middleware.";
    homepage = "https://www.eparaksts.lv";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ dshatz ];
    platforms = [ "x86_64-linux" ];
  };
}
