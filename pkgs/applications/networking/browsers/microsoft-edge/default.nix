{
  beta = import ./browser.nix {
    channel = "beta";
    version = "106.0.1370.17";
    revision = "1";
    sha256 = "sha256:0g9w3a7znc3iq0y27drjv5l45zk8lm0c1djd1r30iijln8a1diak";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "107.0.1375.0";
    revision = "1";
    sha256 = "sha256:1a014jyrk5f11dr2s2mf1m8kfq39rbc5rh0bkmclbwsl83rdfdi4";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "105.0.1343.42";
    revision = "1";
    sha256 = "sha256:18jnq1q65989xl98j2n3wlim0j00krkjxxnkfx2h7kymqjgysm6d";
  };
}
