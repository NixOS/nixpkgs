{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  versionCheckHook,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miniupnpc";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "miniupnp";
    repo = "miniupnp";
    tag = "miniupnpc_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-8EWchUppW4H2kEUCGBXIk1meARJj2usKKO5gFYPoW3s=";
  };

  sourceRoot = "${finalAttrs.src.name}/miniupnpc";

  patches = [
    # fix missing include
    # remove on next release
    (fetchpatch {
      url = "https://github.com/miniupnp/miniupnp/commit/e263ab6f56c382e10fed31347ec68095d691a0e8.patch";
      hash = "sha256-PHqjruFOcsGT3rdFS/GD3wEvalCmoRY4BtIKFxCjKDw=";
      stripLen = 1;
    })
  ];

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
    chmod +x $out/bin/external-ip
    patchShebangs $out/bin/external-ip
    substituteInPlace $out/bin/external-ip \
      --replace-fail "upnpc" $out/bin/upnpc
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
})
