{ lib, stdenv
, autoPatchelfHook
, buildFHSUserEnv
, dpkg
, fetchurl
, gcc-unwrapped
, ocl-icd
, zlib
, extraPkgs ? []
}:
let
  majMin = lib.versions.majorMinor version;
  version = "7.6.13";

  fahclient = stdenv.mkDerivation rec {
    inherit version;
    pname = "fahclient";

    src = fetchurl {
      url = "https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${majMin}/fahclient_${version}_amd64.deb";
      sha256 = "1j2cnsyassvifp6ymwd9kxwqw09hks24834gf7nljfncyy9g4g0i";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
    ];

    buildInputs = [
      gcc-unwrapped.lib
      zlib
    ];

    unpackPhase = "dpkg-deb -x ${src} ./";
    installPhase = "cp -ar usr $out";
  };
in
buildFHSUserEnv {
  name = fahclient.name;

  targetPkgs = pkgs': [
    fahclient
    ocl-icd
  ] ++ extraPkgs;

  runScript = "/bin/FAHClient";

  extraInstallCommands = ''
    mv $out/bin/$name $out/bin/FAHClient
  '';

  meta = {
    description = "Folding@home client";
    homepage = "https://foldingathome.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}
