{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "miniupnpc";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "miniupnp";
    repo = "miniupnp";
    tag = "miniupnpc_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-Fjd4JPk6Uc7cPPQu9NiBv82XArd11TW+7sTL3wC9/+s=";
  };

  sourceRoot = "${src.name}/miniupnpc";

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "UPNPC_BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "UPNPC_BUILD_STATIC" stdenv.hostPlatform.isStatic)
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/upnpc";
  doInstallCheck = true;

  doCheck = !stdenv.hostPlatform.isFreeBSD;

  postInstall = ''
    mv $out/bin/upnpc-* $out/bin/upnpc
    mv $out/bin/upnp-listdevices-* $out/bin/upnp-listdevices
    mv $out/bin/external-ip.sh $out/bin/external-ip
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit (nixosTests) upnp;
  };

  meta = {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "Client that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = with lib.platforms; linux ++ freebsd ++ darwin;
    license = lib.licenses.bsd3;
    mainProgram = "upnpc";
  };
}
