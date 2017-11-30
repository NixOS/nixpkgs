{ stdenv, fetchFromGitHub, pkgs, python3Packages, glfw, libunistring, harfbuzz, fontconfig, zlib, pkgconfig, ncurses, imagemagick, makeWrapper, xsel, libstartup_notification }:

with python3Packages;
buildPythonApplication rec {
  version = "0.5.0";
  name = "kitty-${version}";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "1w202rsgswagb3kiqbwg4xixcglip2hhz6wj1qx9x2whi4zl1l68";
  };

  buildInputs = [ fontconfig glfw ncurses libunistring harfbuzz ];

  nativeBuildInputs = [ pkgconfig ];

  postPatch = ''
    substituteInPlace kitty/utils.py \
      --replace "find_library('startup-notification-1')" "'${libstartup_notification}/lib/libstartup-notification-1.so'"
    '';

  buildPhase = ''
    python3 setup.py linux-package
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r linux-package/{bin,share,lib} $out
    wrapProgram "$out/bin/kitty" --prefix PATH : "$out/bin:${stdenv.lib.makeBinPath [ imagemagick xsel ]}"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kovidgoyal/kitty;
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tex ];
  };
}
