{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "containers-shortnames";
  version = "2025.03.19";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "shortnames";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rq1mMZFo8Eyqxcp+SBa/zrE7OZfbjblfAGPBumjuikk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 shortnames.conf $out/share/containers/registries.conf.d/000-shortnames.conf

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    shortnames = "${finalAttrs.finalPackage}/share/containers/registries.conf.d/000-shortnames.conf";
  };

  meta = {
    description = "Registry alias names for shortnames to fully specified container image names";
    homepage = "https://github.com/containers/shortnames";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    maintainers = [ lib.maintainers.marie ];
  };
})
