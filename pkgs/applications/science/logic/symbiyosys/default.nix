{ stdenv, fetchFromGitHub
, bash, python3, yosys
, yices, boolector, aiger
}:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2020.05.18";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "SymbiYosys";
    rev    = "13fef4a710d0e2cf0f109ca75a94fb7253ba6838";
    sha256 = "152nyxddiqbxvbd06cmwavvgi931v6i35zj9sh3z04m737grvb3d";
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
