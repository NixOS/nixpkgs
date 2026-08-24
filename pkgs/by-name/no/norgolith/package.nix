{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "norgolith";
    repo = "core";
    tag = "norgolith-v${finalAttrs.version}";
    hash = "sha256-R74IUEQ7XkeC/YeEhKTOTPwnhRwDh+nAbAOstc9PzFk=";
  };

  cargoHash = "sha256-Zy8IhQq5Fdnv7CkkEFHV/wxedEAmd6OfKw7BWbRoA7w=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  useNextest = true;
  buildAndTestSubdir = "core";

  env = {
    LIBGIT2_NO_VENDOR = true;
    OPENSSL_NO_VENDOR = true;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The monolithic Norg static site generator built with Rust";
    homepage = "https://norgolith.dev";
    changelog = "https://github.com/norgolith/core/releases/tag/norgolith-v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.Ladas552 ];
    mainProgram = "lith";
  };
})
