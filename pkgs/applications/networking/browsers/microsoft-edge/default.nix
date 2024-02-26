{
  beta = import ./browser.nix {
    channel = "beta";
    version = "122.0.2365.52";
    revision = "1";
    hash = "sha256-H8VTDyDY2Rm5z4cJruzMa1YorBAUL0pJuwhQ6cy4WfY=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "123.0.2400.1";
    revision = "1";
    hash = "sha256-I9PT320DJgqJYNwB0pvngyLlV+N2jaS5tOwVwwNHex0=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "122.0.2365.52";
    revision = "1";
    hash = "sha256-hULyUUFhMjiareXr1zTynyknVyert45N0H4iR8woGRw=";
  };
}
