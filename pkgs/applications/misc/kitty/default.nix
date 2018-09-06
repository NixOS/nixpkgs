{ stdenv, fetchFromGitHub, python3Packages, glfw, libunistring, harfbuzz,
  fontconfig, pkgconfig, ncurses, imagemagick, xsel,
  libstartup_notification, libX11, libXrandr, libXinerama, libXcursor,
  libxkbcommon, libXi, libXext, wayland-protocols, wayland,
  which, dbus
}:

with python3Packages;
buildPythonApplication rec {
  version = "0.12.0";
  name = "kitty-${version}";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "1n2pi9pc903inls1fvz257q7wpif76rj394qkgq7pixpisijdyjm";
  };

  buildInputs = [
    fontconfig glfw ncurses libunistring harfbuzz libX11
    libXrandr libXinerama libXcursor libxkbcommon libXi libXext
    wayland-protocols wayland dbus
  ];

  nativeBuildInputs = [ pkgconfig which sphinx ];

  outputs = [ "out" "terminfo" ];

  postPatch = ''
    substituteInPlace kitty/utils.py \
      --replace "find_library('startup-notification-1')" "'${libstartup_notification}/lib/libstartup-notification-1.so'"

    substituteInPlace docs/Makefile \
      --replace 'python3 .. +launch $(shell which sphinx-build)' \
                'PYTHONPATH=$PYTHONPATH:.. HOME=$TMPDIR/nowhere $(shell which sphinx-build)'
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

  postInstall = ''
    mkdir -p $terminfo/share
    mv $out/share/terminfo $terminfo/share/terminfo

    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kovidgoyal/kitty;
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tex rvolosatovs ];
  };
}
