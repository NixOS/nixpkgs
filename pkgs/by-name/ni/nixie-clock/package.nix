{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "nixie-clock";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "nixieClock";
    rev = "e6bde15c65b28da6318877bf0899aad915655b15";
    sha256 = "sha256-Lj98eghrucupnzdkMjGCPtGWO8NQ5ipQymsYUAl+XRU=";
  };
  cargoHash = "sha256-oqiXeX7ct2miDNoURF7+9lElebX4coVox+qzPgUBbj0=";
  meta = {
    description = "A CLI clock that displays time in a Nixie tube style";
    longDescription = ''
      A unique command-line clock that displays the current time using Nixie tube-style digits.
      This charming design adds a vintage touch to your terminal while providing an accurate clock.
    '';

    homepage = "https://github.com/NewDawn0/nixie-clock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
