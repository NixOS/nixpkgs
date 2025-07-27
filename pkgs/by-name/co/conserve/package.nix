{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "conserve";
  version = "24.8.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "conserve";
    rev = "v${version}";
    hash = "sha256-rdZTx0wFFtWt3EcpvWHY6m+8TEHEj53vhVpdRp5wbos=";
  };

  cargoHash = "sha256-r14ApN9kGWIyeNlbqrb+vOvvmH2n+O5ovvtSVNTMASo=";

  checkFlags = [
    # expected to panic if unix user has no secondary group,
    # which is the case in the nix sandbox
    "--skip=test_fixtures::test::arbitrary_secondary_group_is_found"
    "--skip=chgrp_reported_as_changed"
  ];

  meta = with lib; {
    description = "Robust portable backup tool in Rust";
    homepage = "https://github.com/sourcefrog/conserve";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "conserve";
  };
}
