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
  version = "7.6.9";

  fahclient = stdenv.mkDerivation rec {
    inherit version;
    pname = "fahclient";

    src = fetchurl {
      url = "https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${majMin}/fahclient_${version}_amd64.deb";
      sha256 = "1v4yijjjdq9qx1fp60flp9ya6ywl9qdsgkzwmzjzp8sd5gfvhyr6";
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
