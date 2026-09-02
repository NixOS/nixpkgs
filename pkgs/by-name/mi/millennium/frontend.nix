{
  nodejs_20,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,

  lib,
  stdenv,

  millennium-src,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "millennium-frontend";
  version = "2.35.0";

  src = millennium-src;

  nativeBuildInputs = [
    nodejs_20
    pnpm_9
    pnpmConfigHook
  ];

  pnpmRoot = "src/frontend";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) version pname;
    pnpm = pnpm_9;
    src = "${finalAttrs.src}/src/frontend";
    fetcherVersion = 3;
    hash = "sha256-i53ZZ8ehOi3ybuckUo1Js5tC4LB0QCe4IQCwDwoegXg=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm --dir src/frontend run prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/frontend/
    cp -r build/frontend.bin $out/share/frontend/

    runHook postInstall
  '';

  meta = {
    homepage = "https://steambrew.app/";
    license = lib.licenses.mit;
    description = "Frontend for Millennium";

    maintainers = [
      lib.maintainers.trivaris
    ];

    platforms = [
      "x86_64-linux"
    ];
  };
})
