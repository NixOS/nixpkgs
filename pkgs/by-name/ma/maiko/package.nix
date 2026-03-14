{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maiko";
  version = "260301-f4021ef2";

  src = fetchFromGitHub {
    owner = "Interlisp";
    repo = "maiko";
    tag = "maiko-${finalAttrs.version}";
    hash = "sha256-HfmhKb9cP8d/V9ETes90ktwRdGkHzWYsI+RCv64+6LY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libx11 ];

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
    inherit (libx11.meta) platforms;
  };
})
