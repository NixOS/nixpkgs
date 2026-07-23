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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "${finalAttrs.version}";
    hash = "sha256-akJ44+X1POnV1dZnWq66X5vWokp9TGgJ5/Ey6kh/icA=";
  };

  cargoHash = "sha256-mVS1fv/FI3rDoNm2D7ToiqZJZuySggK2zW2KbbxtpuQ=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ mold ];

  passthru.updateScript = nix-update-script { };

  # For whatever reason the cargo test build in the checkphase attempts to use dynamic libraries.
  # Could be wrong, but rectifying this is probably more of an investment than it's worth.
  doCheck = false;

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
