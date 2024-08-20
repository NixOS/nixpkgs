{
  beta = import ./browser.nix {
    channel = "beta";
    version = "128.0.2739.5";
    revision = "1";
    hash = "sha256-y+587iVWgPk2a1P/F2iwSW1NEnAJaigL6rlVmqaIDJk=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "128.0.2739.5";
    revision = "1";
    hash = "sha256-zY3iGbeYlOoArNNdF1qNwdtp25P0uWJmVMEK7kJIiqQ=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "127.0.2651.86";
    revision = "1";
    hash = "sha256-1Dh+OoTrghn9ArvEnBZCkLnUf0m0qnkEtCoWjA8QId4=";
  };
}
