{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  mpg123,
  zlib,
  xxd,
}:
stdenv.mkDerivation (finalAttrs: {
  # Upstream's latest release is v0.2.0 from 2023-10-30.
  # (And it doesn't #include <cstdint> => doesn't build.)
  # However, master has quite recent commits.
  pname = "projectorrays";
  version = "0.2.0-unstable-2025-11-13";

  src = fetchFromGitHub {
    owner = "ProjectorRays";
    repo = "ProjectorRays";
    # https://github.com/ProjectorRays/ProjectorRays/issues/62
    rev = "6f9bcebf626b43719abe2affcbbcb041d154d666";
    hash = "sha256-n28F2YVo2LfmBGWwVIfPIYYGZNI3cVkwJ3jO02e5t78=";
  };
  patches = [
    # Update this patch anytime you update rev!
    ./0001-hardcode-commit-hash-in-makefile.patch
  ];

  buildInputs = [
    boost
    mpg123
    zlib
  ];
  nativeBuildInputs = [
    xxd
  ];

  installPhase = ''
    runHook preInstall
    install -D --mode=755 "projectorrays" --target-directory $out/bin
    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Decompiler for Macromedia Shockwave/Macromedia Director/Adobe Shockwave/Adobe Director";
    homepage = "https://github.com/ProjectorRays/ProjectorRays";
    mainProgram = "projectorrays";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.libewa ];
  };
})
