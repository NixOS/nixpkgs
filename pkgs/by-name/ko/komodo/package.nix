{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "komodo";
  version = "1.19.3";

  src = fetchFromGitHub {
    owner = "moghtech";
    repo = "komodo";
    tag = "v${version}";
    hash = "sha256-D6W9+JDvLpyALOAjFRcWtJcZMav0ypKmhhVhqlh4AgM=";
  };

  cargoHash = "sha256-uZYNdKhZ91JN6NR3gWVP82rhy6db1qI/h+qmiVwxYT8=";

  # disable for check. document generation is fail
  # > error: doctest failed, to rerun pass `-p komodo_client --doc`
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to build and deploy software on many servers";
    longDescription = ''
      Komodo is a web app to provide structure for managing your servers, builds, deployments, and automated procedures.

      With Komodo you can:
      * Connect all of your servers, and alert on CPU usage, memory usage, and disk usage.
      * Create, start, stop, and restart Docker containers on the connected servers, and view their status and logs.
      * Deploy docker compose stacks. The file can be defined in UI, or in a git repo, with auto deploy on git push.
      * Build application source into auto-versioned Docker images, auto built on webhook. Deploy single-use AWS instances for infinite capacity.
      * Manage repositories on connected servers, which can perform automation via scripting / webhooks.
      * Manage all your configuration / environment variables, with shared global variable and secret interpolation.
      * Keep a record of all the actions that are performed and by whom.

      Komodo is composed of a single core and any amount of connected servers running the periphery application.
    '';
    homepage = "https://komo.do";
    changelog = "https://github.com/moghtech/komodo/releases/tag/v${version}";
    mainProgram = "komodo";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.gpl3;
  };
}
