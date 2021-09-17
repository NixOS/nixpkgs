{ lib, stdenv, fetchFromGitHub, nim, termbox, pcre }:

let
  noise = fetchFromGitHub {
    owner = "jangko";
    repo = "nim-noise";
    rev = "v0.1.14";
    sha256 = "0wndiphznfyb1pac6zysi3bqljwlfwj6ziarcwnpf00sw2zni449";
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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nimmm";
    rev = "v${version}";
    sha256 = "168n61avphbxsxfq8qzcnlqx6wgvz5yrjvs14g25cg3k46hj4xqg";
  };

  nativeBuildInputs = [ nim ];
  buildInputs = [ termbox pcre ];

  buildPhase = ''
    export HOME=$TMPDIR;
    nim -p:${noise} -p:${nimbox} -p:${lscolors}/src c -d:release src/nimmm.nim
  '';

  installPhase = ''
    install -Dt $out/bin src/nimmm
  '';

  meta = with lib; {
    description = "Terminal file manager written in nim";
    homepage = "https://github.com/joachimschmidt557/nimmm";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.joachimschmidt557 ];
  };
}
