{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "boringtun";
    rev = "boringtun-cli-${version}";
    sha256 = "sha256-PY7yqBNR4CYh8Y/vk4TYxxJnnv0eig8sjXp4dR4CX04=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9qvX6P/DquQDlt6wOzI5ZQXQzNil1cD7KiuegDXtrQ0=";

  # Testing this project requires sudo, Docker and network access, etc.
  doCheck = false;

  meta = with lib; {
    description = "Userspace WireGuard® implementation in Rust";
    homepage = "https://github.com/cloudflare/boringtun";
    license = licenses.bsd3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "boringtun-cli";
  };
}
