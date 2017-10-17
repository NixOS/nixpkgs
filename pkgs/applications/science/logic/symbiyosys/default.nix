{ stdenv, fetchFromGitHub, yosys, python3 }:

stdenv.mkDerivation rec {
  name = "symbiyosys-${version}";
  version = "2017.10.16";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "symbiyosys";
    rev    = "f403b99fae053baab651e3ec8345a68cb3ba6a96";
    sha256 = "0jzzlybxaqmhrasfjv3q3skshalr7lvv4p142qgdqz1ig36znbi8";
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
