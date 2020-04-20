{ stdenv
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
  majMin = stdenv.lib.versions.majorMinor version;
  version = "7.5.1";

  fahclient = stdenv.mkDerivation rec {
    inherit version;
    pname = "fahclient";

    src = fetchurl {
      url = "https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${majMin}/fahclient_${version}_amd64.deb";
      hash = "sha256-7+RwYdMoZnJZwYFbmLxsN9ozk2P7jpOGZz9qlvTTfSY=";
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
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.zimbatm ];
    platforms = [ "x86_64-linux" ];
  };
}
