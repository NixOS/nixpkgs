{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "github-release";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "github-release";
    repo = "github-release";
    tag = "v${finalAttrs.version}";
    hash = "sha256-foQZsYfYM/Cqtck+xfdup6WUeoBiqBTP7USCyPMv5q0=";
  };

  vendorHash = null;

  ldflags = [ "-s" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Commandline app to create and edit releases on Github (and upload artifacts)";
    mainProgram = "github-release";
    longDescription = ''
      A small commandline app written in Go that allows you to easily create and
      delete releases of your projects on Github.
      In addition it allows you to attach files to those releases.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/github-release/github-release";
    maintainers = with lib.maintainers; [
      ardumont
    ];
  };
})
