{
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "action-validator";
  version = "0.6.0-unstable-2025-02-16";

  src = fetchFromGitHub {
    owner = "mpalmer";
    repo = "action-validator";
    rev = "2f8be1d2066eb3687496a156d00b4f1b3ea7b028";
    hash = "sha256-QDnikgAfkrvn7/vnmgTQ5J8Ro2HZ6SVkp9cPUYgejqM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-FuJ5NzeZhfN312wK5Q1DgIXUAN6hqxu/1BhGqasbdS8=";

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    branch = "main";
  };

  meta = {
    description = "Tool to validate GitHub Action and Workflow YAML files";
    homepage = "https://github.com/mpalmer/action-validator";
    license = lib.licenses.gpl3Plus;
    mainProgram = "action-validator";
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
}
