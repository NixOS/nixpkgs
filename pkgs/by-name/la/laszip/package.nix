{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.5.0";
  pname = "laszip";

  src = fetchFromGitHub {
    owner = "LASzip";
    repo = "LASzip";
    tag = finalAttrs.version;
    hash = "sha256-xZ8IFnqrGt47lN+C6/ibgbIWqpObDf4RHPaGMXw0WZ4=";
  };

  patches = [
    # Fix aarch64-darwin build.
    (fetchpatch {
      url = "https://github.com/LASzip/LASzip/commit/2274e52076c5f4cbe2d826d690c21713ddd842b4.patch";
      hash = "sha256-C6AOJSY8JJCNNA5Fuz3OiQpzSFO/PwI6Wj+WBUW948k=";
    })
  ];

  hardeningDisable = [ "format" ]; # -Werror=format-security

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  meta = {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = "https://laszip.org";
    changelog = "https://github.com/LASzip/LASzip/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.unix;
  };
})
