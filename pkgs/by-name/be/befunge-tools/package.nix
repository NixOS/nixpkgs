{
  lib,
  fetchFromGitHub,
  rustPlatform,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "befunge-tools";
  version = "0-unstable-2025-08-02";

  src = fetchFromGitHub {
    owner = "esoterra";
    repo = "befunge-tools";
    rev = "a345da9a72670154dfc3de105d7a8297665430c7";
    hash = "sha256-zhLcZ3+4XaVbFqouHDUSiZ7CSdM0T/PPfqayl6W1elE=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-aylH69J7ISDzBfp7zyC1SUH205+Du75r1TDGnoU/kww=";

  postInstall = ''
    mkdir -p $out/share
    cp -r programs $out/share/
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "A collection of command line tools for executing, analyzing, and visualizing Befunge code";
    homepage = "https://github.com/esoterra/befunge-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ julm ];
  };
})
