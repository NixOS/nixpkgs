{
  lib,
  stdenv,
  fetchurl,
  gmp,
  m4,
}:

let
  pname = "ecm";
  version = "7.0.6";
  name = "${pname}-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://gitlab.inria.fr/zimmerma/ecm/uploads/ad3e5019fef98819ceae58b78f4cce93/ecm-${version}.tar.gz";
    hash = "sha256-fSDs5hq2ogrYXywYBkyr133Eapb/iUtSINuxbkZm6KU=";
  };

  postPatch = ''
    patchShebangs test.ecmfactor
    patchShebangs test.ecm
    substituteInPlace test.ecm --replace /bin/rm rm
  '';

  # See https://trac.sagemath.org/ticket/19233
  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "--disable-asm-redc";

  buildInputs = [
    m4
    gmp
  ];

  doCheck = true;

  meta = {
    description = "Elliptic Curve Method for Integer Factorization";
    mainProgram = "ecm";
    license = lib.licenses.gpl3Only;
    homepage = "https://gitlab.inria.fr/zimmerma/ecm";
    maintainers = [ lib.maintainers.roconnor ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
