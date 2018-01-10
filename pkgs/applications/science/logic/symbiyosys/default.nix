{ stdenv, fetchFromGitHub, yosys, python3 }:

stdenv.mkDerivation rec {
  name = "symbiyosys-${version}";
  version = "2017.12.06";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "symbiyosys";
    rev    = "82f394260a74b07892d7f5bdec10ae0a8cad6caa";
    sha256 = "0cniqxaf2m5xh7hqwcpdvwcxg7vqargzahbkzdfwafkdsqpb0ly3";
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
    description = "Yosys verification tools for Hardware Definition Languages";
    homepage    = https://symbiyosys.readthedocs.io/;
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
