{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-variables";
  version = "0.2.4";

  src = fetchFromGitLab {
    owner = "tglman";
    repo = "mdbook-variables";
    rev = version;
    hash = "sha256-whvRCV1g2avKegfQpMgYi+E6ETxT2tQqVS2SWRpAqF8=";
  };

  cargoHash = "sha256-WLHXeYNfALa7GfFAHEO9PAlFKB2lbDefgAYCn6G0U6Y=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "mdBook preprocessor to replace values with env variables";
    mainProgram = "mdbook-variables";
    homepage = "https://gitlab.com/tglman/mdbook-variables";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kraftnix ];
  };
}
