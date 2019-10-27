{ stdenv, fetchFromGitHub, yosys, bash, python3 }:

stdenv.mkDerivation {
  pname = "symbiyosys";
  version = "2019.10.11";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "symbiyosys";
    rev    = "23f89011b678daa9da406d4f45f790e45f8f68ca";
    sha256 = "01596yvfj79iywwczjwlb2l9qnh7bsj7jff66jdk1ybjnxf841f0";
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
