{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  importNpmLock,
  env ? { },
}:
let
  commitHash = "e6a2887";
  # Update this with: `git log -1 --format="%cI" <release tag>`
  commitTime = "2026-08-08T11:57:34+08:00";
  versionDate = lib.strings.replaceString "-" "." (lib.lists.head (lib.strings.split "T" commitTime));
in
buildNpmPackage (finalAttrs: {
  pname = "phanpy";
  version = "${versionDate}.${commitHash}";

  src = fetchFromGitHub {
    owner = "cheeaun";
    repo = "phanpy";
    rev = finalAttrs.version;
    hash = "sha256-DB/TQAIEgXJajdTrXclbhGP4Ku8BZPpIoUNK8wT48WQ=";
  };

  npmDepsHash = "sha256-SsH0w4ySRobIwB63jrdg5u4d+5gOcwBYrMr1V2tcUxI=";
  npmRebuildFlagsArray = [ "--ignore-scripts" ];

  env = {
    # This makes Vite behave in a sealed environment.
    CI = true;
    # The following environment variables are injected because Phanpy's build
    # step tries to get them with `git`. As the ".git" directory is removed
    # from the source, this doesn't work.
    PHANPY_COMMIT_HASH = commitHash;
    PHANPY_COMMIT_TIME = commitTime;
    # Set the build time to the same as the commit time, as it will show up in
    # the settings.
    PHANPY_BUILD_TIME = commitTime;
  }
  // env; # The user-supplied environment variables take precedence.

  buildPhase = ''
    runHook preBuild

    # Run this part of the post-install script.
    # We avoid `npm run postinstall` because it tries to download extra dependencies.
    npm run generate-icons

    # Build with Vite.
    # We set `NODE_ENV` here, not globally, because we want dev dependencies to be installed.
    NODE_ENV='production' npm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv ./dist $out

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "A minimalistic opinionated Mastodon web client";
    homepage = "https://phanpy.social";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      SamirTalwar
    ];
  };
})
