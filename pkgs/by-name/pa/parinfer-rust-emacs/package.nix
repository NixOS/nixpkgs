{
  fetchFromGitHub,
  lib,
  llvmPackages,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parinfer-rust-emacs";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "justinbarclay";
    repo = "parinfer-rust-emacs";
    rev = "v${version}";
    hash = "sha256-SNs/75beomxvexfE4+3v/l9Xl5w5SY0EWcORHvRitOw=";
  };

  cargoHash = "sha256-LmfcY9iR7BGh3dF/raSZTIwburtaQRI3I3XvOZG343M=";

  meta = with lib; {
    description = "An emacs centric fork of parinfer-rust";
    mainProgram = "parinfer-rust";
    homepage = "https://github.com/justinbarclay/parinfer-rust-emacs";
    license = licenses.isc;
    maintainers = with maintainers; [ brsvh ];
  };
}
