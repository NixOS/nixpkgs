{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "miniupnpc";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "miniupnp";
    repo = "miniupnp";
    rev = "miniupnpc_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-kGbw1/2mskFTbPuDTEoGYtOl+H+XyLESF7zaZPD81k8=";
  };

  sourceRoot = "${src.name}/miniupnpc";

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "UPNPC_BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "UPNPC_BUILD_STATIC" stdenv.hostPlatform.isStatic)
  ];

  doCheck = !stdenv.hostPlatform.isFreeBSD;

  postInstall = ''
    mv $out/bin/upnpc-* $out/bin/upnpc
    mv $out/bin/upnp-listdevices-* $out/bin/upnp-listdevices
    mv $out/bin/external-ip.sh $out/bin/external-ip
  '';

  passthru.tests = {
    inherit (nixosTests) upnp;
  };

  meta = with lib; {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "Client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = with platforms; linux ++ freebsd ++ darwin;
    license = licenses.bsd3;
    mainProgram = "upnpc";
  };
}
