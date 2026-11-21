{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  opentalk-controller,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opentalk-web-frontend";
  version = "2.4.4";

  src = fetchFromGitLab {
    domain = "gitlab.opencode.de";
    owner = "opentalk";
    repo = "web-frontend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DU0qgDvagkrijq7zwkS7btsB06pGy3uNBhwt/SJPCx0=";
  };

  postPatch = ''
    # Tries to invoke git to get the commit hash.
    # We replace it with the version tag as we only fetch a snapshot.
    substituteInPlace app/vite.config.js \
      --replace-fail 'getAppVersion()' '"${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-4cKhi73+Wm+IPHahvBVllBWRpW1dUjij2uJWw3GDUQQ=";
  };

  buildPhase = ''
    runHook preBuild

    # pnpmConfigHook only patches scripts in the root dir's node_modules
    patchShebangs packages/rtk-rest-api/node_modules/{*,.*}

    pnpm build

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    pnpm test:unit:ci

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mv dist $out

    runHook postInstall
  '';

  passthru = {
    inherit (opentalk-controller.passthru) updateScript;
  };

  meta = {
    description = "Secure video conferencing solution that was designed with productivity, digital sovereignty and privacy in mind";
    homepage = "https://gitlab.opencode.de/opentalk/web-frontend";
    changelog = "https://gitlab.opencode.de/opentalk/web-frontend/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    platforms = lib.platforms.all;
  };
})
