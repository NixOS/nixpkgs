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
    version = "31.04b02";
    hash = "sha256-9raQlbY7CRybXQA/GBUK4Pat6mlzUV8+o9m7ErP/Tr0=";
  };
in
stdenv.mkDerivation {
  pname = "pfgw";
  version = "4.1.7-unstable-2026-01-05";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/openpfgw/code/";
    rev = "711";
    hash = "sha256-0AQuBT1Vll3TOrTWCTCHqt15lynXLtUcpnZA7aAT4jA=";
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
