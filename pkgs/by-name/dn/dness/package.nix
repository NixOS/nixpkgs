{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dness";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "nickbabcock";
    repo = "dness";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X1aV23EJRkms3Hfk/UAwnnnDSVwZucxp0KYXCTaF8ko=";
  };

  cargoHash = "sha256-WN5sgeBIlF8YIE7xvHI/V14ewyroQZP+v4oFALnu9xo=";

  doCheck = false; # Many tests require network access

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic DNS updating tool supporting a variety of providers";
    homepage = "https://github.com/nickbabcock/dness";
    maintainers = with lib.maintainers; [ logan-barnett ];
    mainProgram = "dness";
    license = lib.licenses.mit;
  };
})
