{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "dpms-off";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "dpms-off";
    rev = "17c5600fdfcf3f5aeb7c85b649dc53e18565b21f";
    hash = "sha256-fADydBO4XISt2n7vrkCuca8db9jtMVsUUvqYAqeVy60=";
  };

  cargoHash = "sha256-wpX14e+J+n1it+1D6OD/AyDn+bOuSoJCEEWlmuZ7c0Y=";

  meta = {
    description = "Turn off monitors to save power (for Wayland)";
    homepage = "https://github.com/lilydjwg/dpms-off";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.philiptaron ];
    mainProgram = "dpms-off";
  };
}
