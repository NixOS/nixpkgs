{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piped";
  version = "0-unstable-2024-06-05";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "Piped";
    rev = "a0cdc6f0c47e7f21acb0afc9c28426b740e0294d";
    hash = "sha256-KFf+kqRzL3PABxroUzejaQVweHrUtnqHFwMG0vjuW8g=";
  };

  nativeBuildInputs = [nodejs pnpm.configHook];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-zMrftk8gd0t+2bQMEgEHucXkROUfUpKb8Nssj5/C56s=";
  };

  buildPhase = ''
    pnpm build
  '';

  installPhase = ''
    cp -r dist/ $out
  '';

  passthru.tests = {
    piped = nixosTests.piped;
  };

  meta = {
    description = "An alternative privacy-friendly YouTube frontend which is efficient by design";
    homepage = "https://github.com/TeamPiped/Piped";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [defelo];
  };
})
