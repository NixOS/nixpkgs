{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sub-batch";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "kl";
    repo = "sub-batch";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-L8Nw2HavLxwbJZ8WzrtJKZxfP77HCsVef9WrdhbdpqQ=";
  };

  cargoHash = "sha256-sqXVlihZWEIP/Ea0kEtoyaLct9v0pWRq0imf+6cH8TM=";

  checkFlags = [
    # requires alass-cli / alass which is not packaged in nixpkgs
    "--skip=can_run_alass_on_sub_file"
    "--skip=can_show_confirm_without_panicking"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Match and rename subtitle files to video files and perform other batch operations on subtitle files";
    changelog = "https://github.com/kl/sub-batch/blob/v${finalAttrs.version}/CHANGELOG";
    homepage = "https://github.com/kl/sub-batch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      erictapen
      kangazero
    ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "sub-batch";
  };
})
