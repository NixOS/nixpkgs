{ stdenv, fetchFromGitHub, yosys, python3 }:

stdenv.mkDerivation rec {
  name = "symbiyosys-${version}";
  version = "2018.03.21";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "symbiyosys";
    rev    = "76a624a363bc44df102359595d34f29370c6668b";
    sha256 = "1ikax1yiqgj5442wcgp1iigw8wiyw7k848z4ykn7k068kbc320bm";
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
    platforms   = stdenv.lib.platforms.linux;
  };
}
