{
  lib,
  buildNpmPackage,
  fetchzip,
  git,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
}:
buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "angular-cli";
  version = "22.2.2";

  src = fetchzip {
    url = "https://registry.npmjs.org/@angular/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-p6MI4kfFNB0ku85PpX2TRkd/s/dt9wXTLAmx+mMyTyo=";
  };

  npmDepsHash = "sha256-qobItnQdwgNqjSXaX2w9sH2iM1/f+HIQ/Mm8hUQI+vM=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = ''
    wrapProgram $out/bin/ng --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "CLI tool for Angular";
    homepage = "https://github.com/angular/angular-cli";
    downloadPage = "https://www.npmjs.com/package/@angular/cli";
    changelog = "https://github.com/angular/angular-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hosea ];
    mainProgram = "ng";
  };
})
