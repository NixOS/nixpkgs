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
  aesniSupport ? stdenv.hostPlatform.aesSupport,
}:

stdenv.mkDerivation rec {
  pname = "i2pd";
  version = "2.54.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "sha256-neoIDZNBBDq3tqz1ET3/CS/zb0Lret9niyuU7iWoNIE=";
  };

  buildInputs = [
    boost
    zlib
    openssl
  ] ++ lib.optional upnpSupport miniupnpc;

  nativeBuildInputs = [
    installShellFiles
  ];

  makeFlags =
    let
      ynf = a: b: a + "=" + (if b then "yes" else "no");
    in
    [
      (ynf "USE_AESNI" aesniSupport)
      (ynf "USE_UPNP" upnpSupport)
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
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.unix;
    mainProgram = "i2pd";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
