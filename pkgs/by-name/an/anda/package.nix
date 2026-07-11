{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anda";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "FyraLabs";
    repo = "anda";
    tag = finalAttrs.version;
    hash = "sha256-4KiqIBWQfI8IagSoa39+bh0bVdhbuwTmxPdNkRlNEdA=";
  };

  cargoHash = "sha256-EWPahdExDi0TFVVMPljTb+j8iUtoqYOqU8LI621gj30=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A modern Build/CI System";
    homepage = "https://github.com/FyraLabs/anda";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "anda";
  };
})
