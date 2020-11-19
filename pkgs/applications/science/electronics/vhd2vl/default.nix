{ stdenv
, fetchFromGitHub
, fetchpatch
, bison
, flex
, verilog
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

  patches = stdenv.lib.optionals (!stdenv.isAarch64) [
    # fix build with verilog 11.0 - https://github.com/ldoolitt/vhd2vl/pull/15
    # for some strange reason, this is not needed for aarch64
    (fetchpatch {
      url = "https://github.com/ldoolitt/vhd2vl/commit/ce9b8343ffd004dfe8779a309f4b5a594dbec45e.patch";
      sha256 = "1qaqhm2mk66spb2dir9n91b385rarglc067js1g6pcg8mg5v3hhf";
    })
  ];

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    verilog
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/vhd2vl $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "VHDL to Verilog converter";
    homepage = "https://github.com/ldoolitt/vhd2vl";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
