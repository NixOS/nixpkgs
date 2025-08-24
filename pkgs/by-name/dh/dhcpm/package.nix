{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dhcpm";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "leshow";
    repo = "dhcpm";
    tag = "v${version}";
    hash = "sha256-vjKN9arR6Os3pgG89qmHt/0Ds5ToO38tLsQBay6VEIk=";
  };

  cargoHash = "sha256-L6+/buzhYoLdFh7x8EmT37JyY5Pr7oFzyOGbhvgNvlw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for constructing & sending DHCP messages";
    homepage = "https://github.com/leshow/dhcpm";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "dhcpm";
  };
}
