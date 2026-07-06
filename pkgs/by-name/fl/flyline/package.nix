{
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "flyline";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2apK1e/Hqb8bUj9Ng7cB+pz27Hv14MXMy2JYYI7nxKE=";
  };

  cargoHash = "sha256-Ci1PVqGZ4ttrkUAtePHKKsqI/SVoedlH4Mua7MzFDvo=";

  checkFlags = [
    # docker_integration_tests fails
    "--skip=test_bash_3_2_57"
    "--skip=test_bash_4_4_18"
    "--skip=test_bash_4_4_rc1"
    "--skip=test_bash_5_0"
    "--skip=test_bash_5_3"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bash plugin to replace readline for a modern line editing experience";
    homepage = "https://github.com/HalFrgrd/flyline";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lwb-2021 ];
  };
})
