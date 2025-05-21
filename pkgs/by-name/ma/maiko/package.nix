{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maiko";
  version = "250201-55e20ea9";

  src = fetchFromGitHub {
    owner = "Interlisp";
    repo = "maiko";
    tag = "maiko-${finalAttrs.version}";
    hash = "sha256-7TmMvDaSmdbMa2fVbETRcyKndGM3CuaxI2cJj00WlSc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ xorg.libX11 ];

  installPhase = ''
    runHook preInstall
    find . -maxdepth 1 -executable -type f -exec install -Dt $out/bin '{}' \;
    runHook postInstall
  '';

  meta = {
    description = "Medley Interlisp virtual machine";
    homepage = "https://interlisp.org/";
    changelog = "https://github.com/Interlisp/maiko/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehmry ];
    inherit (xorg.libX11.meta) platforms;
  };
})
