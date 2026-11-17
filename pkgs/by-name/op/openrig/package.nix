{
  lib,
  stdenv,
  buildNpmPackage,
  fetchzip,
  nix-update-script,
  nodejs_24,
  openssh,
  rsync,
  tmux,
  git,
  lsof,
  procps,
  coreutils,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "openrig";
  version = "0.7.16";

  nodejs = nodejs_24;

  src = fetchzip {
    url = "https://registry.npmjs.org/@openrig/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-MHMoFjcDg0gXufyIlgm9a5r2wQtU1Y5cKmHfFcLlbU0=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-QG5LrVXiFbEYxaHhUIvFsTh1h6pnGo0nvy4a8kpuQOQ=";
  npmInstallFlags = [ "--omit=dev" ];
  dontNpmBuild = true;
  dontNpmPrune = true;

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath (
      [
        nodejs_24
        tmux
        rsync
        git
        openssh
        lsof
        coreutils
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ procps ]
    ))
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "Coordination layer for coding agents: shared context, messaging, and long-running seats";
    homepage = "https://openrig.dev";
    downloadPage = "https://www.npmjs.com/package/@openrig/cli";
    changelog = "https://github.com/mvschwarz/openrig/releases";
    license = lib.licenses.asl20;
    mainProgram = "rig";
    identifiers = {
      purlParts = {
        type = "npm";
        spec = "%40openrig/cli@${finalAttrs.version}";
      };
    };
  };
})
