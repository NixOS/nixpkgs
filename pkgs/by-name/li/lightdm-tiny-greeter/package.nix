{
  lib,
  stdenv,
  linkFarm,
  lightdm-tiny-greeter,
  fetchFromGitHub,
  pkg-config,
  lightdm,
  gtk3,
  glib,
  wrapGAppsHook3,
  config,
  conf ? config.lightdm-tiny-greeter.conf or "",
}:

stdenv.mkDerivation rec {
  pname = "lightdm-tiny-greeter";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "tobiohlala";
    repo = "lightdm-tiny-greeter";
    rev = version;
    hash = "sha256-5mXol3KhjfweIBuoq+JZVnTjsWm7h/hWYurhso68XyE=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    lightdm
    gtk3
    glib
  ];

  postUnpack = lib.optionalString (conf != "") ''
    cp ${builtins.toFile "config.h" conf} source/config.h
  '';

  buildPhase = ''
    mkdir -p $out/bin $out/share/xgreeters
    make ${pname}
    mv ${pname} $out/bin/.
    mv lightdm-tiny-greeter.desktop $out/share/xgreeters
  '';

  installPhase = ''
    substituteInPlace "$out/share/xgreeters/lightdm-tiny-greeter.desktop" \
      --replace "Exec=lightdm-tiny-greeter" "Exec=$out/bin/lightdm-tiny-greeter"
  '';

  passthru.xgreeters = linkFarm "lightdm-tiny-greeter-xgreeters" [
    {
      path = "${lightdm-tiny-greeter}/share/xgreeters/lightdm-tiny-greeter.desktop";
      name = "lightdm-tiny-greeter.desktop";
    }
  ];

  meta = {
    description = "Tiny multi user lightdm greeter";
    mainProgram = "lightdm-tiny-greeter";
    homepage = "https://github.com/tobiohlala/lightdm-tiny-greeter";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
