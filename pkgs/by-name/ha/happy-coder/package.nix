{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "happy-coder";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "slopus";
    repo = "happy-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q4o8FHBhZsNL+D8rREjPzI1ky5+p3YNSxKc1OlA2pcs=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-DlUUAj5b47KFhUBsftLjxYJJxyCxW9/xfp3WUCCClDY=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    makeWrapper
  ];

  # Currently `happy` requires `node` to start its daemon
  postInstall = ''
    wrapProgram $out/bin/happy \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
        ]
      }
    wrapProgram $out/bin/happy-mcp \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
        ]
      }
  '';

  meta = {
    description = "Mobile and web client wrapper for Claude Code and Codex with end-to-end encryption";
    homepage = "https://github.com/slopus/happy-cli";
    changelog = "https://github.com/slopus/happy-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onsails ];
    mainProgram = "happy";
  };
})
