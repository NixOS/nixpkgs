{ stdenv, fetchFromGitHub, yosys, python3 }:

stdenv.mkDerivation rec {
  name = "symbiyosys-${version}";
  version = "2018.12.09";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "symbiyosys";
    rev    = "0772456a15b5a474c3c90a06b48e46a67d8a6614";
    sha256 = "00p2l1g9z8nnmkc57l1cfn9ignjjmxwnyaxj2xjd1fim4kzd5475";
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
