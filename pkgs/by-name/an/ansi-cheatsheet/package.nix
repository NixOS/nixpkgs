{
  fetchFromGitHub,
  lib,
  stdenv,
  zig,
}:
stdenv.mkDerivation {
  pname = "ansi";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "ansi";
    rev = "6b6d3b991706247af90f3f72c67238144f77a928";
    hash = "sha256-/JRG5qZlEOUJ/R37bl8x8okwlVLjlXUcSg7VMkulY0M=";
  };
  buildInputs = [ zig ];
  buildPhase = ''
    export LIBRARY_PATH=/usr/lib
    export DYLD_LIBRARY_PATH=/usr/lib
    cacheDir=$(mktemp -d)
    zig build --global-cache-dir $cacheDir
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp zig-out/bin/ansi $out/bin
  '';
  meta = with lib; {
    description = "A cheatsheet for ansi escape codes";
    homepage = "https://github.com/NewDawn0/ansi";
    license = licenses.mit;
    maintainers = [ NewDawn0 ];
    platforms = platforms.all;
  };
}
