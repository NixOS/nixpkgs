{ stdenv, callPackage, cmake, pkg-config, glib, libao, intltool, libmirage, coreutils }:
stdenv.mkDerivation {

  inherit (callPackage ./common-drv-attrs.nix {
    version = "3.2.6";
    pname = "cdemu-daemon";
    hash = "sha256-puQE4+91xhRuNjVPZYgN/WO0uO8fVAOdxQWOGQ+FfY8=";
  }) pname version src meta;

  nativeBuildInputs = [ cmake pkg-config intltool ];
  buildInputs = [ glib libao libmirage ];
  postInstall = ''
    mkdir -p $out/share/dbus-1/services
    cp -R ../service-example $out/share/cdemu
    substitute \
      $out/share/cdemu/net.sf.cdemu.CDEmuDaemon.service \
      $out/share/dbus-1/services/net.sf.cdemu.CDEmuDaemon.service \
      --replace /bin/true ${coreutils}/bin/true
  '';
}
