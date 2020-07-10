{ stdenv, fetchFromGitHub
, bash, python3, yosys
, yices, boolector, aiger
}:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2020.07.03";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "SymbiYosys";
    rev    = "06e80194c77f5cc38c6999b1d3047a2d6ca82e15";
    sha256 = "1hl03qy98pgq24ijyimf9pf7qxp42l7cki66wx48jys4m1s6n8v9";
  };

  buildInputs = [ python3 ];
  patchPhase = ''
    patchShebangs .

    # Fix up Yosys imports
    substituteInPlace sbysrc/sby.py \
      --replace "##yosys-sys-path##" \
                "sys.path += [p + \"/share/yosys/python3/\" for p in [\"$out\", \"${yosys}\"]]"

    # Fix various executable references
    substituteInPlace sbysrc/sby_core.py \
      --replace '"/usr/bin/env", "bash"' '"${bash}/bin/bash"' \
      --replace ': "btormc"'       ': "${boolector}/bin/btormc"' \
      --replace ': "yosys"'        ': "${yosys}/bin/yosys"' \
      --replace ': "yosys-smtbmc"' ': "${yosys}/bin/yosys-smtbmc"' \
      --replace ': "yosys-abc"'    ': "${yosys}/bin/yosys-abc"' \
      --replace ': "aigbmc"'       ': "${aiger}/bin/aigbmc"' \
  '';

  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin $out/share/yosys/python3

    cp sbysrc/sby_*.py $out/share/yosys/python3/
    cp sbysrc/sby.py $out/bin/sby

    chmod +x $out/bin/sby
  '';

  meta = {
    description = "Tooling for Yosys-based verification flows";
    homepage    = "https://symbiyosys.readthedocs.io/";
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
