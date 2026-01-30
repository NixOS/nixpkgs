{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXrandr,
  libXinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srandrd";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = "srandrd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Wf+tVqDaNAiH6UHN8fFv2wM+LEch6wKlZOkqWEqLLkw=";
  };

  buildInputs = [
    libX11
    libXrandr
    libXinerama
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/jceb/srandrd";
    description = "Simple randr daemon";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.utdemir ];
    mainProgram = "srandrd";
  };

})
