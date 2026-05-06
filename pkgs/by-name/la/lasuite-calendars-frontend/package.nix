{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  npmHooks,
  fetchNpmDeps,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lasuite-calendars";
  version = "unstable-2026-04-20";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "calendars";
    rev = "f70d7164f827bbb050b8b810eac055b9e538645a";
    hash = "sha256-fY6OGFq91FzVp2W4iiE1QLgguusBJExNpRGorUsSLLc=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version src sourceRoot;
    hash = "sha256-r1NsETPteYcY0xG0Yo6zOcq3q0yMxXTZl0iNaYpq8Gg=";
  };

  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    cp -r apps/calendars/out/ $out

    runHook postInstall
  '';

  meta = {
    description = "A modern, open-source calendar application for managing events and schedules";
    homepage = "https://github.com/suitenumerique/calendars";
    changelog = "https://github.com/suitenumerique/calendars/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      soyouzpanda
    ];
    platforms = lib.platforms.all;
  };
})
