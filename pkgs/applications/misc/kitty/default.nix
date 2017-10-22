{ stdenv, fetchFromGitHub, pkgs, python3Packages, glfw, libunistring, glew, fontconfig, zlib, pkgconfig, ncurses, imagemagick, makeWrapper }:

with python3Packages;
buildPythonApplication rec {
  version = "0.4.0";
  name = "kitty-${version}";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "1gvr9l3bgbf87b2ih36zfi5qcga925vjjr8snbak7sgxqzifimij";
  };

  buildInputs = [ pkgconfig glew fontconfig glfw ncurses libunistring ];

  buildPhase = ''
    python3 setup.py linux-package
  '';

  installPhase = ''
    cd linux-package
    mkdir -p $out/bin/
    mkdir -p $out/lib/
    mkdir -p $out/share
    cp -r bin/* $out/bin
    cp -r share/* $out/share/
    cp -r lib/* $out/lib/

    wrapProgram "$out/bin/kitty" --set PATH "$out/bin:/run/wrappers/bin:/run/current-system/sw/bin:${stdenv.lib.makeBinPath [ imagemagick ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kovidgoyal/kitty;
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3;
  };
}
