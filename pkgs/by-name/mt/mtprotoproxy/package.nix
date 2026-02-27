{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtprotoproxy";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tQ6e1Y25V4qAqBvhhKdirSCYzeALfH+PhNtcHTuBurs=";
  };

  nativeBuildInputs = with python3Packages; [ wrapPython ];
  pythonPath = with python3Packages; [
    pyaes
    pycrypto
    uvloop
  ];

  installPhase = ''
    install -Dm755 mtprotoproxy.py $out/bin/mtprotoproxy
    wrapPythonPrograms
  '';

  meta = {
    description = "Async MTProto proxy for Telegram";
    license = lib.licenses.mit;
    homepage = "https://github.com/alexbers/mtprotoproxy";
    platforms = python3.meta.platforms;
    maintainers = [ ];
    mainProgram = "mtprotoproxy";
  };
})
