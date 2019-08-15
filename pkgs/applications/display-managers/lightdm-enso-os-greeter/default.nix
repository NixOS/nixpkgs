{ stdenv, fetchgit, pkgconfig
, dbus, pcre, epoxy, libXdmcp, at-spi2-core, libxklavier, libxkbcommon, libpthreadstubs
, gtk3, vala, cmake, libgee, libX11, lightdm, gdk-pixbuf, clutter-gtk }:

stdenv.mkDerivation rec {
  version = "0.2.1";
  pname = "lightdm-enso-os-greeter";

  src = fetchgit {
    url = https://github.com/nick92/Enso-OS;
    rev = "ed48330bfd986072bd82ac542ed8f8a7365c6427";
    sha256 = "11jm181jq1vbn83h235avpdxz7pqq6prqyzki5yryy53mkj4kgxz";
  };

  buildInputs = [
    dbus
    gtk3
    pcre
    vala
    cmake
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
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  postPatch = ''
    sed -i "s@\''${CMAKE_INSTALL_PREFIX}/@@" greeter/CMakeLists.txt
  '';

  preConfigure = ''
    cd greeter
  '';

  installFlags = [
    "DESTDIR=$(out)"
  ];

  preFixup = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';

  postFixup = ''
    rm -r $out/sbin
  '';

  meta = with stdenv.lib; {
    description = ''
      A fork of pantheon greeter that positions elements in a central and
      vertigal manner and adds a blur effect to the background
    '';
    homepage = https://github.com/nick92/Enso-OS;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
