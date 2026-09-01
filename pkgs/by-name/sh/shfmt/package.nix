{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  replaceVars,
  scdoc,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "shfmt";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W0/40VfqHxKsdIZQzjv3T4Vc/BVgLl9aMuwSUycvclE=";
  };

  vendorHash = "sha256-OfdXhgPyRRifRK4CylmOqWh0qmZ80mNAhBZtqJlwPPY=";

  patches = [
    (replaceVars ./version.patch {
      inherit (finalAttrs) version;
    })
  ];

  subPackages = [ "cmd/shfmt" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postBuild = ''
    scdoc < cmd/shfmt/shfmt.1.scd > shfmt.1
    installManPage shfmt.1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/mvdan/sh";
    changelog = "https://github.com/mvdan/sh/releases/tag/v${finalAttrs.version}";
    description = "Shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      zowoq
      SuperSandro2000
    ];
    mainProgram = "shfmt";
  };
})
