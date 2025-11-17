{
  faketty,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nodejs,
  openssl,
  pnpm,
  prisma-engines,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reactive-resume";
  version = "4.4.4";

  src = fetchFromGitHub {
    owner = "AmruthPillai";
    repo = "Reactive-Resume";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A+pa+9kj0G/RpvKoiwS3X8NPDNzvsfAaWMrZEy7RZ40=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-l5cUyAH/Fg/8T3JrneoIrfqkMWBrhIuf1PCIBkb9X4A=";
  };

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    faketty
    nodejs
    pnpm.configHook
    prisma-engines
  ];

  # `faketty` workaround for https://github.com/nrwl/nx/issues/22445
  buildPhase = ''
    runHook preBuild

    faketty pnpm run build --disableRemoteCache=true --nxBail=true --outputStyle=static --tui=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive dist "$out"
    cp --recursive node_modules "$out/apps/server"
    chmod a-x "$out"/apps/client/templates/jpg/*.jpg # https://github.com/AmruthPillai/Reactive-Resume/pull/2346

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Resume builder";
    homepage = "https://rxresu.me/";
    changelog = "https://github.com/AmruthPillai/Reactive-Resume/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      l0b0
    ];
    platforms = lib.platforms.all;
  };
})
