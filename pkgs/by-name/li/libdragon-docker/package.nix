{
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs_22,
  npmHooks,
  stdenv,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdragon-docker";
  version = "12.0.4";

  src = fetchFromGitHub {
    owner = "anacierdem";
    repo = "libdragon-docker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sSibqWh60d0LhuCkAnLwkitFD5XgRejyS3ptbacYjkk=";
  };
  patches = [ ./allow-write.patch ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    inherit (finalAttrs) src;
    hash = "sha256-N/p5uexuGoNryx27+nNyDU4z3VkDT2x1FRis2OdA9Js=";
  };

  nativeBuildInputs = [
    nodejs_22
    npmHooks.npmConfigHook
  ];

  dontFixup = true;

  buildPhase = ''
    runHook preBuild
    npm run pack ${finalAttrs.version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv build/libdragon-linux $out/bin/libdragon
    runHook postInstall
  '';

  meta = {
    description = "Docker container for easy development with DragonMinded libdragon";
    homepage = "https://github.com/anacierdem/libdragon-docker";
    license = lib.licenses.mit;
    mainProgram = "libdragon";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
