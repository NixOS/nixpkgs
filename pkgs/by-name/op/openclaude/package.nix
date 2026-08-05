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
    rev = "63fda83d5578ddcc251eefa0c6800a85913895b5";
    hash = "sha256-k5XkNzAYFzMD8TcX2n1VOSOWn6rzLetvmj4XOFm/XYc=";
  };
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  nativeBuildInputs = [bun];
  npmDepsHash = "sha256-s7qKSPlDtsPHQ8+SWR8YtyvDudqQWyLHW/mPaOaMip0=";
  #openclaude requires ripgrep in the PATH
  postInstall = ''
    wrapProgram $out/bin/openclaude \
      --prefix PATH : ${lib.makeBinPath [ripgrep]}
  '';
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Open-source coding-agent CLI for cloud and local model providers";
    homepage = "https://github.com/Gitlawb/openclaude";
    changelog = "https://github.com/Gitlawb/openclaude/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [kmdtaufik];
    mainProgram = "openclaude";
  };
})
