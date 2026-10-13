{
  fetchFromGitHub,
  installShellFiles,
  lib,
  makeBinaryWrapper,
  nix,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ncr";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "greyxp1";
    repo = "ncr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7AVCNFeBSGTm+hpZXGsgnOEVrIcVl5gUGqBqcimk28c=";
  };

  cargoHash = "sha256-jPyPN1s5D1hORi/7dW8uWk3yDCBP/nHnMwnA8auj8vI=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  doCheck = false;

  postInstall = ''
    for assets in target/*/release/build/ncr-*/out; do
      installManPage "$assets/ncr.1"
      installShellCompletion "$assets"/ncr.{bash,fish,nu} --zsh "$assets/_ncr"
      install -Dm644 "$assets/ncr.elv" "$out/share/elvish/lib/ncr.elv"
      install -Dm644 "$assets/_ncr.ps1" "$out/share/powershell/ncr.Completion.ps1"
    done
    install -Dm644 LICENSE "$out/share/doc/ncr/LICENSE"

    # Prefer the user's Nix or Lix installation.
    wrapProgram "$out/bin/ncr" --suffix PATH : ${lib.makeBinPath [ nix ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Evaluation time and closure reports for Nix configurations";
    homepage = "https://github.com/greyxp1/ncr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.greyxp1 ];
    mainProgram = "ncr";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
