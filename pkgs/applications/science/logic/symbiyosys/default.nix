{ stdenv, fetchFromGitHub
, bash, python3, yosys
, yices, boolector, aiger
}:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2020.02.11";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "SymbiYosys";
    rev    = "0a7013017f9d583ef6cc8d10712f4bf11cf6e024";
    sha256 = "08xz8sgvs1qy7jxp8ma5yl49i6nl7k6bkhry4afdvwg3fvwis39c";
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
