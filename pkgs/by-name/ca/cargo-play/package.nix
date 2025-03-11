{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-play";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "fanzeyi";
    repo = pname;
    rev = version;
    sha256 = "sha256-Z5zcLQYfQeGybsnt2U+4Z+peRHxNPbDriPMKWhJ+PeA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kgdg2GZmFGMua3eYo30tpDTFBKncbaiONJf+ocfMaBk=";

  # these tests require internet access
  checkFlags = [
    "--skip=dtoa_test"
    "--skip=infer_override"
  ];

  meta = with lib; {
    description = "Run your rust code without setting up cargo";
    mainProgram = "cargo-play";
    homepage = "https://github.com/fanzeyi/cargo-play";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
