{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gtk3
, alsaLib
}:

stdenv.mkDerivation rec {
  pname = "free42";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "thomasokken";
    repo = pname;
    rev = "v${version}";
    sha256 = "jzNopLndYH9dIdm30pyDaZNksHwS4i5LTZUXRmcrTp8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 alsaLib ];

  postPatch = ''
    sed -i -e "s|/bin/ls|ls|" gtk/Makefile
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    make -C gtk cleaner
    make --jobs=$NIX_BUILD_CORES -C gtk
    make -C gtk clean
    make --jobs=$NIX_BUILD_CORES -C gtk BCD_MATH=1
    runHook postBuild
  '';

  preInstall = ''
    install --directory $out/bin \
                        $out/share/doc/${pname} \
                        $out/share/${pname}/skins \
                        $out/share/icons/hicolor/48x48/apps \
                        $out/share/icons/hicolor/128x128/apps
  '';

  installPhase = ''
    runHook preInstall
    install -m755 gtk/free42dec gtk/free42bin $out/bin
    install -m644 gtk/README $out/share/doc/${pname}/README-GTK
    install -m644 README $out/share/doc/${pname}/README

    install -m644 gtk/icon-48x48.xpm $out/share/icons/hicolor/48x48/apps
    install -m644 gtk/icon-128x128.xpm $out/share/icons/hicolor/128x128/apps
    install -m644 skins/* $out/share/${pname}/skins
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/thomasokken/free42";
    description = "A software clone of HP-42S Calculator";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
