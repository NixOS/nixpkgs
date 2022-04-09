{ lib, stdenv, fetchFromGitHub, pkg-config, linkFarm, lightdm-enso-os-greeter
, dbus, pcre, libepoxy, libXdmcp, at-spi2-core, libxklavier, libxkbcommon, libpthreadstubs
, gtk3, vala, cmake, libgee, libX11, lightdm, gdk-pixbuf, clutter-gtk, wrapGAppsHook, librsvg }:

stdenv.mkDerivation {
  pname = "lightdm-enso-os-greeter";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nick92";
    repo = "Enso-OS";
    rev = "ed48330bfd986072bd82ac542ed8f8a7365c6427";
    sha256 = "sha256-v79J5KyjeJ99ifN7nK/B+J7f292qDAEHsmsHLAMKVYY=";
  };

  patches = [
    ./fix-paths.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    gtk3
    pcre
    libepoxy
    libgee
    libX11
    lightdm
    libXdmcp
    gdk-pixbuf
    clutter-gtk
    libxklavier
    at-spi2-core
    libxkbcommon
    libpthreadstubs
    librsvg
  ];

  preConfigure = ''
    cd greeter
  '';

  passthru.xgreeters = linkFarm "enso-os-greeter-xgreeters" [{
    path = "${lightdm-enso-os-greeter}/share/xgreeters/pantheon-greeter.desktop";
    name = "pantheon-greeter.desktop";
  }];

  postFixup = ''
    substituteInPlace $out/share/xgreeters/pantheon-greeter.desktop \
      --replace "pantheon-greeter" "$out/bin/pantheon-greeter"
  '';

  meta = with lib; {
    description = ''
      A fork of pantheon greeter that positions elements in a central and
      vertigal manner and adds a blur effect to the background
    '';
    homepage = "https://github.com/nick92/Enso-OS";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
