{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "prettypst";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "antonWetzel";
    repo = "prettypst";
    rev = "2.0.0";
    hash = "sha256-fGm3HDMJ12HlVOjLtaS2hcAzVl/jl4nqMYly0aBVRxw=";
  };

  cargoHash = "sha256-zfx6SDtvn5waKWZB1gVxcvCzP+Rp7+J+txaRHoRfaBM=";

  meta = {
    changelog = "https://github.com/antonWetzel/prettypst/blob/${src.rev}/changelog.md";
    description = "Formatter for Typst";
    homepage = "https://github.com/antonWetzel/prettypst";
    license = lib.licenses.mit;
    mainProgram = "prettypst";
    maintainers = with lib.maintainers; [ ];
  };
}
