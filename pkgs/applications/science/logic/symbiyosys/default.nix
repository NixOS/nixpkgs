{ stdenv, fetchFromGitHub
, bash, python3, yosys
, yices, boolector, aiger, abc-verifier
}:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2020.02.08";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "SymbiYosys";
    rev    = "500b526131f434b9679732fc89515dbed67c8d7d";
    sha256 = "1pwbirszc80r288x81nx032snniqgmc80i09bbha2i3zd0c3pj5h";
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
      --replace ': "yosys-abc"' ': "${abc-verifier}/bin/abc"' \
      --replace ': "aigbmc"' ': "${aiger}/bin/aigbmc"' \
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
