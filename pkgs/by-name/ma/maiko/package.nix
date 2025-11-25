{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maiko";
  version = "250616-de1fafba";

  src = fetchFromGitHub {
    owner = "Interlisp";
    repo = "maiko";
    tag = "maiko-${finalAttrs.version}";
    hash = "sha256-RYBV3gqcDPxRteCvUyqm8lKUpW4r0L7kJLlED8M72DI=";
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
    inherit (xorg.libX11.meta) platforms;
  };
})
