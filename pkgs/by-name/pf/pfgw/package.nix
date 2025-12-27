{
  stdenv,
  lib,
  fetchsvn,
  fetchurl,
  gmp,
  gwnum,
}:

let
  gwnum-pinned = gwnum.override {
    version = "31.01b02";
    hash = "sha256-TttiqcMY/8+Vf4SF31B2/sMrRmUzfLR6Xu26Y5McEfM=";
  };
in
stdenv.mkDerivation {
  pname = "pfgw";
  version = "4.1.5-unstable-2025-11-17";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/openpfgw/code/";
    rev = "709";
    hash = "sha256-FPZ2kz1Pc3tTeRxHj6ETHfHsjmEehVM/lYzqXd+UKF8=";
  };

  buildInputs = [
    gmp
    gwnum-pinned
  ];

  postPatch = ''
    substituteInPlace makefile \
      --replace-fail "packages/gmp/64bit/libgmp.a" "-lgmp" \
      --replace-fail "packages/gwnum/64bit/gwnum.a" "-lgwnum"

    substituteInPlace make.inc \
      --replace-fail "CXXFLAGS += -g" ""
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 pfgw64 $out/bin/pfgw

    runHook postInstall
  '';

  passthru = {
    inherit gwnum-pinned;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "PrimeForm GW(NUM) - probable/deterministic primality testing";
    homepage = "https://sourceforge.net/projects/openpfgw/";
    license = licenses.publicDomain;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ brubsby ];
  };
}
