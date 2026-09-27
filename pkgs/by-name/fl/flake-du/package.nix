{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flake-du";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kmein";
    repo = "flake-du";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mwSZvAEs4RKzIKErnxPhK7J7yhqo1ibDRy0FXoKlsHY=";
  };

  cargoHash = "sha256-DYVT9jM9WcgoVSOnoUIWWR9EmNywR1f4xZOAzkbNkCk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Tool for managing flake inputs with disk usage insights";
    license = lib.licenses.mit;
    homepage = "https://github.com/kmein/flake-du";
    maintainers = [ lib.maintainers.kmein ];
  };
})
