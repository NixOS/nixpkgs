{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "alioth";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    rev = "refs/tags/v${version}";
    hash = "sha256-K0Hx6EJYyPJZA+FLIj44BtUuZZOqWW2DUJt1QbeZyu0=";
  };

  cargoHash = "sha256-J+1SXHQJJxT0qN/ELAvwQFnKCo13ZrQClpbfleM4PkA=";

  separateDebugInfo = true;

  checkFlags = [
    # "test did not panic as expected"
    "--skip" "test_align_up_panic"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/alioth";
    description = "Experimental Type-2 Hypervisor in Rust implemented from scratch";
    license = licenses.asl20;
    mainProgram = "alioth";
    maintainers = with maintainers; [ astro ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
