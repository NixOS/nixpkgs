{
  lib,
  stdenv,
  boost,
  fetchFromGitHub,
  openssl,
  zlib,
}:

stdenv.mkDerivation {
  pname = "i2pd-tools";
  version = "2.58.0-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = "i2pd-tools";
    rev = "34944bbd5d0bab34694b1f57edba4b5a783f8b7b";
    hash = "sha256-W0khA1uVHmMBQdUwPMo/q64P9I6t6Eatf/KPaamJg7I=";
    fetchSubmodules = true;
  };

  buildInputs = [
    zlib
    openssl
    boost
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for bin in \
        routerinfo keygen vain keyinfo regaddr \
        regaddr_3ld regaddralias x25519 famtool autoconf_i2pd \
        verifyhost offlinekeys b33address i2pbase64;
    do
      install -Dm755 $bin -t $out/bin
    done

    runHook postInstall
  '';

  meta = {
    description = "Toolsuite to work with keys and eepsites";
    homepage = "https://github.com/PurpleI2P/i2pd-tools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      MulliganSecurity
      ryand56
    ];
    platforms = lib.platforms.linux;
  };
}
