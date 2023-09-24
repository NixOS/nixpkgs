{
  stable = import ./browser.nix {
    channel = "stable";
    version = "117.0.2045.35";
    revision = "1";
    sha256 = "sha256-2am+TLZC024mpxOk6GLB0TZY+Kfnm/CyH8sMBLod1Js=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "117.0.2045.31";
    revision = "1";
    sha256 = "sha256-Nee99jE6kswYfmZlMjv4EV4HDz1l+9YhhWHonhe2uUM=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "118.0.2088.9";
    revision = "1";
    sha256 = "sha256-JNIccQrdLpiEItgt4Lh0eZQgnXE+5Lx3vGDjzm5sKWM=";
  };
}
