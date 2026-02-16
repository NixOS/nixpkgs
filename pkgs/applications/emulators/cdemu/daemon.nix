{
  stdenv,
  callPackage,
  cmake,
  pkg-config,
  glib,
  libao,
  intltool,
  libmirage,
  coreutils,
}:

let
  inherit
    (callPackage ./common-drv-attrs.nix {
      version = "3.3.0";
      pname = "cdemu-daemon";
      hash = "sha256-AYHjiOAQdu685gc6p0j2QNtCmTYTWix1kzWQZYvGPWU=";
    })
    pname
    version
    src
    meta
    ;
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    cmake
    pkg-config
    intltool
  ];
  buildInputs = [
    glib
    libao
    libmirage
  ];
  postInstall = ''
    mkdir -p $out/share/dbus-1/services
    cp -R ../service-example $out/share/cdemu
    substitute \
      $out/share/cdemu/net.sf.cdemu.CDEmuDaemon.service \
      $out/share/dbus-1/services/net.sf.cdemu.CDEmuDaemon.service \
      --replace /bin/true ${coreutils}/bin/true
  '';

  meta = {
    inherit (meta)
      description
      license
      longDescription
      maintainers
      platforms
      ;
    homepage = "https://cdemu.sourceforge.io/about/daemon/";
    mainProgram = "cdemu-daemon";
  };
}
