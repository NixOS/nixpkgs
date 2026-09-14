{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  makeWrapper,
  sass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quetre";
  version = "8.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zyachel";
    repo = finalAttrs.pname;
    rev = "33f952c4b7318b6425e958e79375f61de6289035";
    hash = "sha256-/biKk0Vb0PeO0sHOoW2s3WnDjdAnLN0UYh5AwHJZQmw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version;

    src = stdenv.mkDerivation {
      inherit (finalAttrs) src;

      name = "${finalAttrs.pname}-patched-src";
      installPhase = "cp -r . $out";
    };

    pnpm = pnpm_9;
    fetcherVersion = 2;
    hash = "sha256-uqe2VieRRWh+CtwdzB+dBvhPo7l1D0j8yPamzExj3jw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9
    pnpmConfigHook
    makeWrapper
    sass
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run sass:build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${finalAttrs.pname}
    cp -r . $out/share/${finalAttrs.pname}/

    makeWrapper ${nodejs}/bin/node $out/bin/${finalAttrs.pname} \
      --add-flags "$out/share/${finalAttrs.pname}/server.js" \
      --chdir "$out/share/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = {
    description = "Libre frontend for Quora";
    longDescription = ''
      Efficient and privacy-focused alternative web frontend for Quora,
      providing a clean interface for reading questions and answers.
    '';
    homepage = "https://quetre.iket.me";
    changelog = "https://github.com/zyachel/quetre/blob/main/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "quetre";
    platforms = lib.platforms.all;
  };
})
