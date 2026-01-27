{
  lib,
  stdenv,
  nodejs,
  fetchFromGitHub,
  pnpm_9,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atomic-browser";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "atomicdata-dev";
    repo = "atomic-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iZRKgRQL/+6RavFMWEugpd8+sWgXgE+itqak5BZe51s=";
  };

  sourceRoot = "source/browser";

  pnpmDeps = pnpm_9.fetchDeps {
    pname = finalAttrs.pname;
    version = finalAttrs.version;
    hash = "sha256-EurqNHOkUuu3bJ028Dz7y4ZWqKR46Vj798jbvDGA3g4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  passthru.updateScript = nix-update-script { };

  buildPhase = ''
    pnpm run build
  '';

  installPhase = ''
    runHook preInstall
    cp -R ./data-browser/dist/ $out/
    runHook postInstall
  '';

  meta = {
    description = "GUI for viewing, editing and browsing Atomic Data";
    homepage = "https://github.com/atomicdata-dev/atomic-server/tree/develop/browser";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.oluchitheanalyst ];
  };
})
