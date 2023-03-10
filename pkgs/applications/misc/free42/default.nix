{ lib
, stdenv
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, pkg-config
, gtk3
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "free42";
  version = "3.0.17";

  src = fetchFromGitHub {
    owner = "thomasokken";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3G2vRPupZtZKF1VazNQGa1AplqFzhI5M+olyeJ26kXo=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    gtk3
  ];

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

  installPhase = ''
    runHook preInstall

    install --directory $out/bin \
                        $out/share/doc/${pname} \
                        $out/share/${pname}/skins \
                        $out/share/icons/hicolor/48x48/apps \
                        $out/share/icons/hicolor/128x128/apps

    install -m755 gtk/free42dec gtk/free42bin $out/bin
    install -m644 gtk/README $out/share/doc/${pname}/README-GTK
    install -m644 README $out/share/doc/${pname}/README

    install -m644 gtk/icon-48x48.xpm $out/share/icons/hicolor/48x48/apps
    install -m644 gtk/icon-128x128.xpm $out/share/icons/hicolor/128x128/apps
    install -m644 skins/* $out/share/${pname}/skins

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.thomasokken.free42bin";
      desktopName = "Free42Bin";
      genericName = "Calculator";
      exec = "free42bin";
      type = "Application";
      comment = meta.description;
      categories = [ "Utility" "Calculator" ];
    })
    (makeDesktopItem {
      name = "com.thomasokken.free42dec";
      desktopName = "Free42Dec";
      genericName = "Calculator";
      exec = "free42dec";
      type = "Application";
      comment = meta.description;
      categories = [ "Utility" "Calculator" ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/thomasokken/free42";
    description = "A software clone of HP-42S Calculator";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ AndersonTorres plabadens ];
    platforms = with platforms; unix;
  };
}
