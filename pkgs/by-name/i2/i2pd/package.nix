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

stdenv.mkDerivation rec {
  pname = "i2pd";
  version = "2.58.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = "i2pd";
    tag = version;
    hash = "sha256-moUcivW3YIE2SvjS7rCXTjeCKUW/u/NXWH3VmJ9x6jg=";
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

  meta = with lib; {
    homepage = "https://i2pd.website";
    description = "Minimal I2P router written in C++";
    license = licenses.bsd3;
    platforms = platforms.unix;
    mainProgram = "i2pd";
  };
}
