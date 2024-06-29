{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayws";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f0kXy7/31imgHHqKPmW9K+QrLqroaPaXwlJkzOoezRU=";
  };

  cargoSha256 = "sha256-VYT6wV59fraAoJgR/i6GlO8s7LUoehGtxPAggEL1eLo=";
  # Required patch until upstream fixes https://gitlab.com/w0lff/swayws/-/issues/1
  cargoPatches = [
    ./ws-update-Cargo-lock.patch
  ];

  # swayws does not have any tests
  doCheck = false;

  meta = with lib; {
    description = "Sway workspace tool which allows easy moving of workspaces to and from outputs";
    mainProgram = "swayws";
    homepage = "https://gitlab.com/w0lff/swayws";
    license = licenses.mit;
    maintainers = [ maintainers.atila ];
  };
}
