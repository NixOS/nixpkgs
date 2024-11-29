{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "versatiles";
  version = "0.13.0"; # When updating: Replace with current version

  src = fetchFromGitHub {
    owner = "versatiles-org";
    repo = "versatiles-rs";
    rev = "refs/tags/v${version}"; # When updating: Replace with long commit hash of new version
    hash = "sha256-6HuBKRvt6P4GpFaIiYsGO/8wcjML2UDdUFoYvIM/Z0k="; # When updating: Use `lib.fakeHash` for recomputing the hash once. Run: 'nix-build -A versatiles'. Swap with new hash and proceed.
  };

  cargoHash = "sha256-7kJf6BHNRfLDFRZp8Q2M2ZGXH0NzG/QBqw5/s20AIm4="; # When updating: Same as above

  # Testing only necessary for the `bins` and `lib` features
  cargoTestFlags = [
    "--bins"
    "--lib"
  ];

  # Skip tests that require network access
  checkFlags = [
    "--skip tools::convert::tests::test_remote1"
    "--skip tools::convert::tests::test_remote2"
    "--skip tools::probe::tests::test_remote"
    "--skip tools::serve::tests::test_remote"
    "--skip utils::io::data_reader_http"
    "--skip utils::io::data_reader_http::tests::read_range_git"
    "--skip utils::io::data_reader_http::tests::read_range_googleapis"
  ];

  meta = {
    description = "Toolbox for converting, checking and serving map tiles in various formats";
    longDescription = ''
      VersaTiles is a Rust-based project designed for processing and serving tile data efficiently.
      It supports multiple tile formats and offers various functionalities for handling tile data.
    '';
    homepage = "https://versatiles.org/";
    downloadPage = "https://github.com/versatiles-org/versatiles-rs";
    changelog = "https://github.com/versatiles-org/versatiles-rs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wilhelmines ];
    mainProgram = "versatiles";
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
}
