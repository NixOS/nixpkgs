{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "obsidian-headless";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "obsidianmd";
    repo = "obsidian-headless";
    rev = "5f51535b744625ee2cf47d61f704d4d9276590b7";
    hash = "sha256-RnLiCbAgetMO8pXYNjNW7fPeR8O7/Zz2i/x5OXOL+8U=";
  };

  npmDepsHash = "sha256-9XV5AHdolm2gsFX0vUJpNI73ogKdTQdyekseutw7N+Q";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  meta = {
    description = "Headless client for Obsidian Sync and Obsidian Publish. Sync and publish your vaults from the command line without the desktop app";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      halfwhey
    ];
    mainProgram = "ob";
  };
})
