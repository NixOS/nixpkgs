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
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VFLnQNhySXB/VE0u9u2X4jAHq+083+QjhWM7vfyxhM8=";
  };

  vendorHash = "sha256-WLGHcmBslXJO4OKdUK7HqimdUCOtdCdK+AOdlo4hgWk=";

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
