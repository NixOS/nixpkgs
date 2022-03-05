{ callPackage, glib, libao, intltool, libmirage }:
let pkg = import ./base.nix {
  version = "3.2.5";
  pname = "cdemu-daemon";
  pkgSha256 = "16g6fv1lxkdmbsy6zh5sj54dvgwvm900fd18aq609yg8jnqm644d";
};
in callPackage pkg {
  buildInputs = [ glib libao libmirage intltool ];
}
