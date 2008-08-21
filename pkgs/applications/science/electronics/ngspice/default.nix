args:
args.stdenv.mkDerivation {
  name = "ng-spice-rework-15c";

  src = args.fetchurl {
    url = mirror://sourceforge/ngspice/ng-spice-rework-15c.tar.gz;
    sha256 = "0v0pbdc54ra0s98dz6mhj80n333ggbn4xpf53vi66sd02hcjblmg";
  };

  buildInputs =(with args; [readline]);

  meta = {
      description = "The Next Generation Spice (Electronic Circuit Simulator).";
      homepage = http://ngspice.sourceforge.net;
      license = ["BSD" "GPLv2"];
  };
}
