{ stdenv, fetchFromGitHub, yosys, bash, python3, yices }:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2020.02.08";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "SymbiYosys";
    rev    = "500b526131f434b9679732fc89515dbed67c8d7d";
    sha256 = "1pwbirszc80r288x81nx032snniqgmc80i09bbha2i3zd0c3pj5h";
  };

  buildInputs = [ python3 yosys ];

  propagatedBuildInputs = [ yices ];

  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin $out/share/yosys/python3

    cp sbysrc/sby_*.py $out/share/yosys/python3/
    cp sbysrc/sby.py $out/bin/sby
    chmod +x $out/bin/sby

    # Fix up shebang and Yosys imports
    patchShebangs $out/bin/sby
    substituteInPlace $out/bin/sby \
      --replace "##yosys-sys-path##" \
                "sys.path += [p + \"/share/yosys/python3/\" for p in [\"$out\", \"${yosys}\"]]"
    substituteInPlace $out/share/yosys/python3/sby_core.py \
      --replace '"/usr/bin/env", "bash"' '"${bash}/bin/bash"'
  '';
  meta = {
    description = "Tooling for Yosys-based verification flows";
    homepage    = https://symbiyosys.readthedocs.io/;
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
