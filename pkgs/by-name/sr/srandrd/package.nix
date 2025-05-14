{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXrandr,
  libXinerama,
}:

stdenv.mkDerivation rec {
  pname = "srandrd";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = "srandrd";
    rev = "v${version}";
    sha256 = "sha256-Wf+tVqDaNAiH6UHN8fFv2wM+LEch6wKlZOkqWEqLLkw=";
  };

  buildInputs = [
    libX11
    libXrandr
    libXinerama
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/jceb/srandrd";
    description = "Simple randr daemon";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.utdemir ];
    mainProgram = "srandrd";
  };

}
