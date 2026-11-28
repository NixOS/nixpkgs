{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "afx";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "babarot";
    repo = "afx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a3HGMszC4Ls4w8bEtbtfYWSv/n+q39o0Vnj/XDeJ5Pg=";
  };

  vendorHash = "sha256-tlZK539TvwZ3w28tcBd0YW8cAnxBd0FaYvaoM7JXzUo=";

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/babarot/afx/cmd.Version=v${finalAttrs.version}"
    "-X github.com/babarot/afx/cmd.BuildTag=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  preInstallCheck = ''
    export HOME=$(mktemp -d)
  '';
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package manager for command-line tools and shell plugins";
    homepage = "https://github.com/babarot/afx";
    changelog = "https://github.com/babarot/afx/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "afx";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
