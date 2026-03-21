{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  boost,
  zlib,
  openssl,
  upnpSupport ? true,
  miniupnpc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i2pd";
  version = "2.59.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = "i2pd";
    tag = finalAttrs.version;
    hash = "sha256-PBwjP54gVtMduN//OXxd35KnRJv7sbA1MIUU+1KNUac=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace Makefile.osx \
      --replace-fail "-msse" ""
  '';

  buildInputs = [
    boost
    zlib
    openssl
  ]
  ++ lib.optional upnpSupport miniupnpc;

  nativeBuildInputs = [
    installShellFiles
  ];

  makeFlags = [
    "USE_UPNP=${lib.boolToYesNo upnpSupport}"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D i2pd $out/bin/i2pd
    install --mode=444 -D 'contrib/i2pd.service' "$out/etc/systemd/system/i2pd.service"
    installManPage 'debian/i2pd.1'
  '';

  meta = {
    homepage = "https://i2pd.website";
    description = "Minimal I2P router written in C++";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ edwtjo ];
    platforms = lib.platforms.unix;
    mainProgram = "i2pd";
  };
})
