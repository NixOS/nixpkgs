{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poop";
  version = "0.5.0-unstable-2026-05-04";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "poop";
    rev = "e1a802d19a4b8267e2fa79c3ede15c09357b31c9";
    hash = "sha256-cT9ueK4VrPR9qv4qS9suvm8P2bAywDYlxnDU183aBrA=";
  };

  nativeBuildInputs = [
    zig_0_16
  ];

  meta = {
    description = "Compare the performance of multiple commands with a colorful terminal user interface";
    homepage = "https://github.com/andrewrk/poop";
    changelog = "https://github.com/andrewrk/poop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    platforms = lib.platforms.linux;
    mainProgram = "poop";
  };
})
