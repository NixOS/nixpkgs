{
  stdenv,
  lib,
  fetchFromGitHub,
  pkgs,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bleur";
  version = "0.0.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bleur-org";
    repo = "bleur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wf8qkKfKl1zCkkwPvIMRI7YI/YrMnukwuGu+W6P82v8=";
  };

  cargoHash = "sha256-3REb0uFZWF3RBvKXe5Icmp96P9GvrGRuYQyVjexolBU=";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];
  strictDeps = true;

  meta = {
    description = "That buddy that will get everything ready for you";
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "bleur";
    homepage = "https://bleur.uz/";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      orzklv
      bahrom04
      wolfram444
    ];
  };
})
