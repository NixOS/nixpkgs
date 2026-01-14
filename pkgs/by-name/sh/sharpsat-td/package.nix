{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  gmp,
  mpfr,
}:

let
  satlib-bmc = fetchzip {
    url = "https://www.cs.ubc.ca/~hoos/SATLIB/Benchmarks/SAT/BMC/bmc.tar.gz";
    stripRoot = false;
    sha256 = "sha256-F1Jfrj4iMMf/3LFCShIDMs4JfLkJ51Z4wkL1FDT9b/A=";
  };

  # needed for mpfr 4.2.0+ support
  mpreal = fetchFromGitHub {
    owner = "advanpix";
    repo = "mpreal";
    rev = "mpfrc++-3.6.9";
    sha256 = "sha256-l61SKEx4pBocADrEGPVacQ6F2ep9IuvNZ8W08dKeZKg=";
  };

in
stdenv.mkDerivation {
  pname = "sharpsat-td";
  version = "0-unstable-2021-09-05";

  src = fetchFromGitHub {
    owner = "Laakeri";
    repo = "sharpsat-td";
    rev = "b9bb015305ea5d4e1ac7141691d0fe55ca983d31";
    sha256 = "sha256-FE+DUd58eRr5w9RFw0fMHfjIiNDWIcG7XbyWJ/pI28U=";
  };

  postPatch = ''
    # just say no to bundled binaries
    rm bin/*

    # ensure resultant build calls its own binaries
    substituteInPlace src/decomposition.cpp \
      --replace '"../../../flow-cutter-pace17/flow_cutter_pace17"' '"'"$out"'/bin/flow_cutter_pace17"'
    substituteInPlace src/preprocessor/treewidth.cpp \
      --replace '"./flow_cutter_pace17"' '"'"$out"'/bin/flow_cutter_pace17"'

    # replace bundled version of mpreal/mpfrc++
    rm -r src/mpfr
    cp -r ${mpreal} src/mpfr

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gmp
    mpfr
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 sharpSAT $out/bin/sharpSAT-td
    install -Dm755 flow_cutter_pace17 $out/bin/flow_cutter_pace17

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # "correct" answer from https://sites.google.com/site/marcthurley/sharpsat/benchmarks/collected-model-counts
    $out/bin/sharpSAT-td -decot 1 -decow 100 -cs 3500 -tmpdir "$TMPDIR" \
      ${satlib-bmc}/bmc-ibm-1.cnf | grep -F 'c s exact arb int 7333984412904350856728851870196181665291102236046537207120878033973328441091390427157620940515935993557837912658856672133150412904529478729364681871717139154252602322050981277183916105207406949425074710972297902317183503443350157267211568852295978718386711142950559533715161449971311118966214098944000'

    runHook postInstallCheck
  '';

  meta = {
    description = "Fast solver for the #SAT model counting problem";
    homepage = "https://github.com/Laakeri/sharpsat-td";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ ris ];
    # uses clhash, which is non-portable
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
