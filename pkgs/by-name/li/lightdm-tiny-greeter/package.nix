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
    owner = "off-world";
    repo = "lightdm-tiny-greeter";
    rev = version;
    sha256 = "08azpj7b5qgac9bgi1xvd6qy6x2nb7iapa0v40ggr3d1fabyhrg6";
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

  meta = with lib; {
    description = "Tiny multi user lightdm greeter";
    mainProgram = "lightdm-tiny-greeter";
    homepage = "https://github.com/off-world/lightdm-tiny-greeter";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
