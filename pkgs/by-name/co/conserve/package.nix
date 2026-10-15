{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "conserve";
  version = "24.8.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "conserve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rdZTx0wFFtWt3EcpvWHY6m+8TEHEj53vhVpdRp5wbos=";
  };

  cargoHash = "sha256-r14ApN9kGWIyeNlbqrb+vOvvmH2n+O5ovvtSVNTMASo=";

  checkFlags = [
    # expected to panic if unix user has no secondary group,
    # which is the case in the nix sandbox
    "--skip=test_fixtures::test::arbitrary_secondary_group_is_found"
    "--skip=chgrp_reported_as_changed"
  ];

  meta = {
    description = "Robust portable backup tool in Rust";
    homepage = "https://github.com/sourcefrog/conserve";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "conserve";
  };
})
