{ lib, stdenv
, fetchFromGitHub
, bison
, flex
, verilog
, which
}:

stdenv.mkDerivation rec {
  pname = "vhd2vl";
  version = "unstable-2018-09-01";

  src = fetchFromGitHub {
    owner = "ldoolitt";
    repo = pname;
    rev = "37e3143395ce4e7d2f2e301e12a538caf52b983c";
    sha256 = "17va2pil4938j8c93anhy45zzgnvq3k71a7glj02synfrsv6fs8n";
  };

  patches = lib.optionals (!stdenv.isAarch64) [
    # fix build with verilog 11.0
    ./test.patch
  ];

  nativeBuildInputs = [
    bison
    flex
    which
  ];

  buildInputs = [
    verilog
  ];

  # the "translate" target both (a) builds the software and (b) runs
  # the tests (without validating the results)
  buildTargets = [ "translate" ];

  # the "diff" target examines the test results
  checkTarget = "diff";

  installPhase = ''
    runHook preInstall
    install -D -m755 src/vhd2vl $out/bin/vdh2vl
    runHook postInstall
  '';

  meta = with lib; {
    description = "VHDL to Verilog converter";
    homepage = "https://github.com/ldoolitt/vhd2vl";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
