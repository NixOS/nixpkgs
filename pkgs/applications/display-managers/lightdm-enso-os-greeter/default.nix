{ lib, stdenv, fetchgit, pkg-config, linkFarm, lightdm-enso-os-greeter
, dbus, pcre, epoxy, libXdmcp, at-spi2-core, libxklavier, libxkbcommon, libpthreadstubs
, gtk3, vala, cmake, libgee, libX11, lightdm, gdk-pixbuf, clutter-gtk, wrapGAppsHook, librsvg }:

stdenv.mkDerivation {
  version = "0.2.1";
  pname = "lightdm-enso-os-greeter";

  src = fetchgit {
    url = "https://github.com/nick92/Enso-OS";
    rev = "ed48330bfd986072bd82ac542ed8f8a7365c6427";
    sha256 = "11jm181jq1vbn83h235avpdxz7pqq6prqyzki5yryy53mkj4kgxz";
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
    epoxy
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
