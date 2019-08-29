{ stdenv, fetchFromGitHub, yosys, bash, python3 }:

stdenv.mkDerivation rec {
  pname = "symbiyosys";
  version = "2019.08.13";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "symbiyosys";
    rev    = "9cb542ac7a310b3dfa626349db53bed6236b670c";
    sha256 = "0c7nz740738ybk33zzlfl00cq86n31wvra8pqqkpl4ygxnwca1d6";
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
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
