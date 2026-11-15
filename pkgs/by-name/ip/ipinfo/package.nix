{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ipinfo";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "ipinfo";
    repo = "cli";
    tag = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-tE174q8eV37N5+Vh/dNb82iM5X1HEk06ObmzuJw+dQs=";
  };

  vendorHash = null;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  # Tests require network access
  doCheck = false;

  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    changelog = "https://github.com/ipinfo/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
