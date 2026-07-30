{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maiko";
  version = "260319-9259716e";

  src = fetchFromGitHub {
    owner = "Interlisp";
    repo = "maiko";
    tag = "maiko-${finalAttrs.version}";
    hash = "sha256-IqXDw5JuABs1IEKpvq3xjjl4NgZVojdxQYRV6TLhqOk=";
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
