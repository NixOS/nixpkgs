{
  lib,
  rustPlatform,
  mold,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "microfetch";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "${finalAttrs.version}";
    hash = "sha256-aJ2QuMbUM/beMD8b62AqzTNljQ8RtBNOSvj9nJfRXbA=";
  };

  cargoHash = "sha256-vGvpjRJr4ez322JWUwboVml22vnRVRlwpZ9W4F5wATA=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ mold ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Microscopic fetch script in Rust, for NixOS systems";
    homepage = "https://github.com/NotAShelf/microfetch";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nydragon
      NotAShelf
    ];
    mainProgram = "microfetch";
    platforms = lib.platforms.linux;
  };
})
