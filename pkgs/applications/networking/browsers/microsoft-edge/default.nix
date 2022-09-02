{
  beta = import ./browser.nix {
    channel = "beta";
    version = "104.0.1293.44";
    revision = "1";
    sha256 = "sha256:01accsknks9ss2v9sn5lx5w1nrmn90rindi9jkfn5i387ssf8p4v";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "105.0.1343.4";
    revision = "1";
    sha256 = "sha256:0bz2zx11v52izv2sf6q40jnpajmzw3r67h4ggmg0pw6g0d4ridva";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "104.0.1293.54";
    revision = "1";
    sha256 = "sha256:1i5h0y9dx3dlks6qnz466axbhyvrc0wfxncfz0n62a32fdj0aswi";
  };
}
