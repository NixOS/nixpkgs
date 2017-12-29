{ stdenv, fetchFromGitHub, pkgs, python3Packages, glfw, libunistring, glew, fontconfig, zlib, pkgconfig, ncurses, imagemagick, makeWrapper }:

with python3Packages;
buildPythonApplication rec {
  version = "0.4.2";
  name = "kitty-${version}";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "058676r2b83mjggbfc701v3vlviaslf7qciz8sm8lcda82k01wfp";
  };

  buildInputs = [ glew fontconfig glfw ncurses libunistring ];

  nativeBuildInputs = [ pkgconfig ];

  buildPhase = ''
    python3 setup.py linux-package
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r linux-package/{bin,share,lib} $out
    wrapProgram "$out/bin/kitty" --prefix PATH : "$out/bin:${stdenv.lib.makeBinPath [ imagemagick ]}"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kovidgoyal/kitty;
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tex ];
  };
}
