{ callPackage, glib, libao, intltool, libmirage, coreutils }:
callPackage ./base.nix {
  version = "3.2.6";
  pname = "cdemu-daemon";
  hash = "sha256-puQE4+91xhRuNjVPZYgN/WO0uO8fVAOdxQWOGQ+FfY8=";
  nativeBuildInputs = [ intltool ];
  buildInputs = [ glib libao libmirage ];
  extraDrvParams.postInstall = ''
    mkdir -p $out/share/dbus-1/services
    cp -R ../service-example $out/share/cdemu
    substitute \
      $out/share/cdemu/net.sf.cdemu.CDEmuDaemon.service \
      $out/share/dbus-1/services/net.sf.cdemu.CDEmuDaemon.service \
      --replace /bin/true ${coreutils}/bin/true
  '';
}
