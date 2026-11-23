{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
  gnupg,
  less,
  openssh,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gittuf";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = "gittuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a7vcC6oNcdowM+9J4I66qkFjPktzbwCv3IbsO1Me/dM=";
  };

  vendorHash = "sha256-wydhdcmdrmo9Gezopt+gN1nPRGm/T2yPxjfLwcMGW14=";

  ldflags = [ "-X github.com/gittuf/gittuf/internal/version.gitVersion=${finalAttrs.version}" ];

  __structuredAttrs = true;

  nativeCheckInputs = [
    git
    gnupg
    less
    openssh
  ];
  checkFlags = [ "-skip=TestLoadRepository|TestSSH" ];

  postInstall = "rm $out/bin/cli"; # remove gendoc helper binaries

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/gittuf/gittuf/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Security layer for Git repositories";
    homepage = "https://gittuf.dev";
    license = lib.licenses.asl20;
    mainProgram = "gittuf";
    maintainers = with lib.maintainers; [
      flandweber
      anish
    ];
  };
})
