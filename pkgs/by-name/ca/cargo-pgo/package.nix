{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-pgo";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yt9QAgpu667JkdNS7OiB/wB9BLXXpis0ZhWjYuETteU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IZcZqonOtpONjVt8NkwdEfSqPVjtjEV52cqclCnogN0=";

  # Integration tests do not run in Nix build environment due to needing to
  # create and build Cargo workspaces.
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand for optimizing Rust binaries/libraries with PGO and BOLT";
    homepage = "https://github.com/kobzol/cargo-pgo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dannixon ];
  };
}
