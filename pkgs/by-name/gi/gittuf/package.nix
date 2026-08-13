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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = "gittuf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VWbM7y9XCs/pANJtPa3MDbDhuEtVQ97X5Cyo6yY0Rd8=";
  };

  vendorHash = "sha256-VTfS0bLq7B037qmFABO5JDrV98zik5ycR4s6NZr3H4s=";

  ldflags = [ "-X github.com/gittuf/gittuf/internal/version.gitVersion=${finalAttrs.version}" ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeCheckInputs = [
    git
    gnupg
    less
    openssh
  ];
  checkFlags = [ "-skip=TestLoadRepository|TestSSH" ];

  postInstall = "rm $out/bin/cli $out/bin/sandbox"; # remove gendoc helper binaries

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
