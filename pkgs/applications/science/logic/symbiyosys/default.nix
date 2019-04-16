{ stdenv, fetchFromGitHub, yosys, python3 }:

stdenv.mkDerivation rec {
  name = "symbiyosys-${version}";
  version = "2019.03.28";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "symbiyosys";
    rev    = "44869656b86993e7ebdc59e7b27191f3ecf119dc";
    sha256 = "1p18yzcadn91xzmqrg5xkwfl3p9mnlps57simz7dkkxzcqzjybvn";
  };

  buildInputs = [ python3 yosys ];

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
  '';
  meta = {
    description = "Tooling for Yosys-based verification flows";
    homepage    = https://symbiyosys.readthedocs.io/;
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
