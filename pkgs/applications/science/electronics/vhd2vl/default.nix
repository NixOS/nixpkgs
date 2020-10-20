{ stdenv
, fetchFromGitHub
, bison
, flex
, verilog
}:

stdenv.mkDerivation rec {
  pname = "vhd2vl-unstable";
  version = "2018-09-01";

  src = fetchFromGitHub {
    owner = "ldoolitt";
    repo = "vhd2vl";
    rev = "37e3143395ce4e7d2f2e301e12a538caf52b983c";
    sha256 = "17va2pil4938j8c93anhy45zzgnvq3k71a7glj02synfrsv6fs8n";
  };

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
