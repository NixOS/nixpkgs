{ callPackage, glib, libao, intltool, libmirage, coreutils }:
let pkg = import ./base.nix {
  version = "3.2.5";
  pname = "cdemu-daemon";
  pkgSha256 = "16g6fv1lxkdmbsy6zh5sj54dvgwvm900fd18aq609yg8jnqm644d";
};
in callPackage pkg {
  nativeBuildInputs = [ intltool ];
  buildInputs = [ glib libao libmirage ];
  drvParams.postInstall = ''
    mkdir -p $out/share/dbus-1/services
    cp -R ../$pname-$version/service-example $out/share/cdemu
    substitute \
      $out/share/cdemu/net.sf.cdemu.CDEmuDaemon.service \
      $out/share/dbus-1/services/net.sf.cdemu.CDEmuDaemon.service \
      --replace /bin/true ${coreutils}/bin/true
  '';
}
