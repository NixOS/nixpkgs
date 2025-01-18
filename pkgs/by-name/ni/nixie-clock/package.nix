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
    rev = "v1.0.0";
    sha256 = lib.fakeHash;
  };
  cargoHash = lib.fakeHash;
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
