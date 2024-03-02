{ lib, buildNimPackage, fetchFromSourcehut }:

buildNimPackage (finalAttrs: {
  pname = "base45";
  version = "20230124";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-9he+14yYVGt2s1IuRLPRsv23xnJzERkWRvIHr3PxFYk=";
  };
  meta = finalAttrs.src.meta // {
    description = "Base45 library for Nim";
    license = lib.licenses.unlicense;
    mainProgram = finalAttrs.pname;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
