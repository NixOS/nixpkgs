{ stdenv, fetchFromGitHub
, bash, python3, yosys
, yices, boolector, aiger
}:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2020.03.24";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "SymbiYosys";
    rev    = "8a62780b9df4d2584e41cdd42cab92fddcd75b31";
    sha256 = "0ss5mrzwff2dny8kfciqbrz67m6k52yvc1shd7gk3qb99x7g7fp8";
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
