{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.4.3";
  pname = "laszip";

  src = fetchFromGitHub {
    owner = "LASzip";
    repo = "LASzip";
    rev = finalAttrs.version;
    hash = "sha256-9fzal54YaocONtguOCxnP7h1LejQPQ0dKFiCzfvTjCY=";
  };

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ];

  meta = {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = "https://laszip.org";
    changelog = "https://github.com/LASzip/LASzip/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.michelk ];
    platforms = lib.platforms.unix;
  };
})
