{
  lib,
  stdenv,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "snmalloc";
  version = "0.7.4";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "snmalloc";
    tag = finalAttrs.version;
    hash = "sha256-+UCqUrfvhnB4leiYCnGJ8ORfVkTaGimaErP56XCJ5PM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Message passing based memory allocator";
    homepage = "https://github.com/microsoft/snmalloc";
    downloadPage = "https://github.com/microsoft/snmalloc/releases";
    changelog = "https://github.com/microsoft/snmalloc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ VZstless ];
  };
})
