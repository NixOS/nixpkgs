{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtprotoproxy";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/T3NtjDHnEOc/90mCp7NF9J+Bvd1YOTknkq73MQ9KxU=";
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
