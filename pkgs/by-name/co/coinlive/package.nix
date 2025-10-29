{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "coinlive";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mayeranalytics";
    repo = "coinlive";
    tag = "v${version}";
    hash = "sha256-llw97jjfPsDd4nYi6lb9ug6sApPoD54WlzpJswvdbRs=";
  };

  cargoHash = "sha256-OswilwabVfoKIeHxo7sxCvgGH5dRfyTmnKED+TcxSV8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # Test requires network access
    "--skip=utils::test_get_infos"
  ];

  doInstallCheck = true;

  meta = {
    description = "Live cryptocurrency prices CLI";
    homepage = "https://github.com/mayeranalytics/coinlive";
    changelog = "https://github.com/mayeranalytics/coinlive/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "coinlive";
  };
}
