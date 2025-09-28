{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "mtprotoproxy";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${version}";
    sha256 = "sha256-tQ6e1Y25V4qAqBvhhKdirSCYzeALfH+PhNtcHTuBurs=";
  };

  nativeBuildInputs = with python3.pkgs; [ wrapPython ];
  pythonPath = with python3.pkgs; [
    pyaes
    pycrypto
    uvloop
  ];

  installPhase = ''
    install -Dm755 mtprotoproxy.py $out/bin/mtprotoproxy
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Async MTProto proxy for Telegram";
    license = licenses.mit;
    homepage = "https://github.com/alexbers/mtprotoproxy";
    platforms = python3.meta.platforms;
    maintainers = [ ];
    mainProgram = "mtprotoproxy";
  };
}
