{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
let
  pname = "mdsf";
  version = "0.5.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "mdsf";
    tag = "v${version}";
    hash = "sha256-KHTWE3ENRc/VHrgwAag6DsnEU3c8Nqw15jR5jWlNrk4=";
  };

  cargoHash = "sha256-kgqRwYjDc/eV9wv1G6aAhfrGpoYDPCFfqaTm+T2p7uw=";

  checkFlags = [
    "--skip=tests::it_should_add_go_package_if_missing"
    "--skip=tests::it_should_format_the_code"
    "--skip=tests::it_should_format_the_codeblocks_that_start_with_whitespace"
    "--skip=tests::it_should_not_care_if_go_package_is_set"
    "--skip=tests::it_should_not_modify_outside_blocks"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for formatting a linting markdown code snippets using language specific tools";
    homepage = "https://github.com/hougesen/mdsf";
    changelog = "https://github.com/hougesen/mdsf/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mdsf";
  };
}
