{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "nezha-theme-user";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "hamster1963";
    repo = "nezha-dash-v1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3zaA3T4zW18caOQe5DBF8Zsms3cjks3Ywyfkyk6N2N0=";
  };

  # TODO: Switch to the bun build function once available in nixpkgs
  postPatch = ''
    cp ${./package-lock.json} package-lock.json

    # We cannot directly get the git commit hash from the tarball
    substituteInPlace vite.config.ts \
      --replace-fail 'git rev-parse --short HEAD' 'echo refs/tags/v${finalAttrs.version}'
    substituteInPlace src/components/Footer.tsx \
      --replace-fail '/commit/' '/tree/'
  '';

  npmDepsHash = "sha256-hjVvp2dWBHqXrq/7+kLDmcUUrV15ln/8tNNqDmJ/Sh4=";

  npmPackFlags = [ "--ignore-scripts" ];

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "Nezha monitoring user frontend based on next.js";
    changelog = "https://github.com/hamster1963/nezha-dash-v1/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/hamster1963/nezha-dash-v1";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
