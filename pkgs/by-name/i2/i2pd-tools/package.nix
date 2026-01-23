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
  version = "2.56.0";

  #tries to access the network during the tests, which fails

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = "i2pd-tools";
    rev = "33fce4b087d92ee90653460bbe7a07cdc0c7b121";
    hash = "sha256-mmCs8AHHKhx1/rDp/Vc1p2W3pufoTa4FcJyJwD919zw=";
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
        regaddr_3ld regaddralias x25519 famtool autoconf;
    do
      install -Dm755 $bin -t $out/bin
    done

    runHook postInstall
  '';

  meta = {
    description = "Toolsuite to work with keys and eepsites";
    homepage = "https://github.com/PurpleI2P/i2pd-tools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ MulliganSecurity ];
    mainProgram = "i2pd-tools";
  };
}
