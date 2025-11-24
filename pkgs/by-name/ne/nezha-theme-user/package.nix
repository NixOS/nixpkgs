{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "nezha-theme-user";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "hamster1963";
    repo = "nezha-dash-v1";
    tag = "v${version}";
    hash = "sha256-W3UnDDvzj5AWT8EQyNL7TtDxQlgQpfYeLZsvSCF/dGw=";
  };

  # TODO: Switch to the bun build function once available in nixpkgs
  postPatch = ''
    cp ${./package-lock.json} package-lock.json

    # We cannot directly get the git commit hash from the tarball
    substituteInPlace vite.config.ts \
      --replace-fail 'git rev-parse --short HEAD' 'echo refs/tags/v${version}'
    substituteInPlace src/components/Footer.tsx \
      --replace-fail '/commit/' '/tree/'
  '';

  npmDepsHash = "sha256-nILKXXFOp+Ix6gYpCgcKpAPiLAV9sgMqZ+oTfWZhSIs=";

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
    changelog = "https://github.com/hamster1963/nezha-dash-v1/releases/tag/v${version}";
    homepage = "https://github.com/hamster1963/nezha-dash-v1";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
