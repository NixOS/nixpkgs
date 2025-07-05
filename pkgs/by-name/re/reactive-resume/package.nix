{
  fetchFromGitHub,
  lib,
  nodejs,
  openssl,
  pnpm,
  prisma-engines,
  stdenv,
  util-linux,
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
    hash = "sha256-l5cUyAH/Fg/8T3JrneoIrfqkMWBrhIuf1PCIBkb9X4A=";
  };

  buildInputs = [ openssl.dev ];
  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    prisma-engines
  ];
  buildPhase = ''
    runHook preBuild

    ${util-linux}/bin/script -c "pnpm build" /dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive dist "$out"
    chmod a-x "$out"/apps/client/templates/jpg/*.jpg

    runHook postInstall
  '';

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
