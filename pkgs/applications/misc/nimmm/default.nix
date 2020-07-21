{ stdenv, fetchFromGitHub, nim, termbox, pcre }:

let
  noise = fetchFromGitHub {
    owner = "jangko";
    repo = "nim-noise";
    rev = "db1e86e312413e4348fa82c02340784316a89cc1";
    sha256 = "0n9l2dww5smrsl1xfqxjnxz3f1srb72lc1wl3pdvs6xfyf44qzlh";
  };

  nimbox = fetchFromGitHub {
    owner = "dom96";
    repo = "nimbox";
    rev = "6a56e76c01481176f16ae29b7d7c526bd83f229b";
    sha256 = "15x1sdfxa1xcqnr68705jfnlv83lm0xnp2z9iz3pgc4bz5vwn4x1";
  };

  lscolors = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nim-lscolors";
    rev = "v0.3.3";
    sha256 = "0526hqh46lcfsvymb67ldsc8xbfn24vicn3b8wrqnh6mag8wynf4";
  };

in stdenv.mkDerivation rec {
  pname = "nimmm";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nimmm";
    rev = "v${version}";
    sha256 = "1zpq181iz6g7yfi298gjwv33b89l4fpnkjprimykah7py5cpw67w";
  };

  nativeBuildInputs = [ nim ];
  buildInputs = [ termbox pcre ];

  NIX_LDFLAGS = "-lpcre";

  buildPhase = ''
    export HOME=$TMPDIR;
    nim -p:${noise} -p:${nimbox} -p:${lscolors}/src c -d:release src/nimmm.nim
  '';

  installPhase = ''
    install -Dt $out/bin src/nimmm
  '';

  meta = with stdenv.lib; {
    description = "Terminal file manager written in nim";
    homepage = "https://github.com/joachimschmidt557/nimmm";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.joachimschmidt557 ];
  };
}
