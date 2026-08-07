{
  stdenv,
  moonfire-nvr,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moonfire-nvr-ui";
  inherit (moonfire-nvr) version src;

  sourceRoot = "${finalAttrs.src.name}/ui";

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    sourceRoot = "${finalAttrs.src.name}/ui";
    fetcherVersion = 4;
    hash = "sha256-U/SHOVlx0kj1hfl09KcPg3CQZX9HZE5SghVEThWL1RA=";
  };

  installPhase = ''
    runHook preInstall

    cp -r public $out

    runHook postInstall
  '';

  meta = moonfire-nvr.meta // {
    description = "Moonfire UI";
  };
})
