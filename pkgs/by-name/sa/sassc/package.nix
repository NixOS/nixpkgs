{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libsass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sassc";
  version = "3.6.2"; # also check libsass for updates

  src = fetchFromGitHub {
    owner = "sass";
    repo = "sassc";
    rev = finalAttrs.version;
    sha256 = "sha256-jcs3+orRqKt9C3c2FTdeaj4H2rBP74lW3HF8CHSm7lQ=";
  };

  postPatch = ''
    export SASSC_VERSION=${finalAttrs.version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libsass ];

  enableParallelBuilding = true;

  meta = {
    description = "Front-end for libsass";
    homepage = "https://github.com/sass/sassc/";
    license = lib.licenses.mit;
    mainProgram = "sassc";
    maintainers = with lib.maintainers; [
      codyopel
      pjones
    ];
    platforms = lib.platforms.unix;
  };
})
