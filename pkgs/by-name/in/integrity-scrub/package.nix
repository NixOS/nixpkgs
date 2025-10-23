{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "integrity-scrub";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "illdefined";
    repo = "integrity-scrub";
    tag = version;
    hash = "sha256-oWS6HxdZ8tGeIRGpfHHkNhNdepBjhhdgTjKmxElNPbk=";
  };

  cargoHash = "sha256-3LC3eZNmHG6OFIvQzmvs4BCSX0CVpwaYhZM2H2YoY4M=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  # Requires unstable features
  env.RUSTC_BOOTSTRAP = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/illdefined/integrity-scrub";
    description = "Scrub dm-integrity devices";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = lib.platforms.linux;
  };
}
