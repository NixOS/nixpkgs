{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  ripgrep,
}:
buildNpmPackage (finalAttrs: {
  pname = "openclaude";
  version = "0.27.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gitlawb";
    repo = "openclaude";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j5FYko4qriB5HmRF0ZMlH396WGjaekVp0X0WhPLzt24=";
  };
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  nativeBuildInputs = [ bun ];
  npmDepsHash = "sha256-rvNKMAU1pJjUuNSGxTEj30pFHhLfwwMEKN229WCqG+8=";
  #openclaude requires ripgrep in the PATH
  postInstall = ''
    wrapProgram $out/bin/openclaude \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}
  '';
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Open-source coding-agent CLI for cloud and local model providers";
    homepage = "https://github.com/Gitlawb/openclaude";
    changelog = "https://github.com/Gitlawb/openclaude/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmdtaufik ];
    mainProgram = "openclaude";
  };
})
