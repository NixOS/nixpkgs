{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "filterpath";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Sigmanificient";
    repo = "filterpath";
    tag = finalAttrs.version;
    hash = "sha256-FOewYznmWOWH2TyNySVoa+spvH4QlXnjlko+/zFiNik=";
  };

  makeFlags = [
    "CC=cc"
    "PREFIX=${placeholder "out"}/bin"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/Sigmanificient/filterpath";
    description = "Retrieve a valid path from a messy piped line";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      sigmanificient
      eveeifyeve # Darwin
    ];
    mainProgram = "filterpath";
    platforms = lib.platforms.unix;
  };
})
