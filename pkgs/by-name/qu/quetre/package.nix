{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
  sass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quetre";
  version = "8.0.0-unstable-2025-11-06";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zyachel";
    repo = "quetre";
    rev = "33f952c4b7318b6425e958e79375f61de6289035";
    hash = "sha256-/biKk0Vb0PeO0sHOoW2s3WnDjdAnLN0UYh5AwHJZQmw=";
  };

  patches = [ ./pnpm-lock.patch ];

  pnpmDeps = fetchPnpmDeps {
    pname = "quetre";
    inherit (finalAttrs) version;

    src = stdenv.mkDerivation {
      inherit (finalAttrs) src patches;

      name = "quetre-patched-src";
      installPhase = "cp -r . $out";
    };

    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-nVzzCVKiUuDJQY/cAJmW8i5ZyYIC1pqUcC9ZzyImPro=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    makeWrapper
    sass
  ];

  postBuild = ''
    pnpm run sass:build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/quetre
    cp -r . $out/share/quetre/

    makeWrapper ${nodejs}/bin/node $out/bin/quetre \
      --add-flags "$out/share/quetre/server.js" \
      --chdir "$out/share/quetre"

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
