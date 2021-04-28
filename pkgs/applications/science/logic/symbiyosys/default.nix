{ lib, stdenv, fetchFromGitHub
, bash, python3, yosys
, yices, boolector, z3, aiger
}:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2020.08.22";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "SymbiYosys";
    rev    = "33b0bb7d836fe2a73dc7b10587222f2a718beef4";
    sha256 = "03rbrbwsji1sqcp2yhgbc0fca04zsryv2g4izjhdzv64nqjzjyhn";
  };

  buildInputs = [ ];
  patchPhase = ''
    patchShebangs .

    # Fix up Yosys imports
    substituteInPlace sbysrc/sby.py \
      --replace "##yosys-sys-path##" \
                "sys.path += [p + \"/share/yosys/python3/\" for p in [\"$out\", \"${yosys}\"]]"

    # Fix various executable references
    substituteInPlace sbysrc/sby_core.py \
      --replace '"/usr/bin/env", "bash"' '"${bash}/bin/bash"' \
      --replace ', "btormc"'             ', "${boolector}/bin/btormc"' \
      --replace ', "aigbmc"'             ', "${aiger}/bin/aigbmc"'

    substituteInPlace sbysrc/sby_core.py \
      --replace '##yosys-program-prefix##' '"${yosys}/bin/"'

    substituteInPlace sbysrc/sby.py \
      --replace '/usr/bin/env python3' '${python3}/bin/python'
  '';

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/bin $out/share/yosys/python3

    cp sbysrc/sby_*.py $out/share/yosys/python3/
    cp sbysrc/sby.py $out/bin/sby

    chmod +x $out/bin/sby
  '';

  doCheck = false; # not all provers are yet packaged...
  checkInputs = [ python3 yosys boolector yices z3 aiger ];
  checkPhase = "make test";

  meta = {
    description = "Tooling for Yosys-based verification flows";
    homepage    = "https://symbiyosys.readthedocs.io/";
    license     = lib.licenses.isc;
    maintainers = with lib.maintainers; [ thoughtpolice emily ];
    platforms   = lib.platforms.all;
  };
}
