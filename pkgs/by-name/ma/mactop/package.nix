{
  lib,
  buildGoModule,
  fetchFromGitHub,
  llvmPackages,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "mactop";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "metaspartan";
    repo = "mactop";
    tag = "v${version}";
    hash = "sha256-rWALbjy7s6X3hegcUxoR0XUXKFZGnWRWV5OeXtN3BjU=";
  };

  vendorHash = "sha256-TF66wg8nyAb/kZ80XLaD7H39EehZQ896DS6Ce3+P8Lk=";

  proxyVendor = true;

  nativeBuildInputs = [ llvmPackages.lld ];

  env = {
    # Work around ld64's libc++ hardening issue.
    # TODO: Remove once #536365 reaches this branch.
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  doCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };
  versionCheckProgramArg = "--version";

  meta = {
    description = "Terminal-based monitoring tool 'top' designed to display real-time metrics for Apple Silicon chips";
    homepage = "https://github.com/metaspartan/mactop";
    changelog = "https://github.com/metaspartan/mactop/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "mactop";
    platforms = [ "aarch64-darwin" ];
  };
}
