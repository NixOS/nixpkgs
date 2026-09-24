{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxtst,
  libxi,
}:

stdenv.mkDerivation {
  pname = "keym";
  version = "unstable-2022-07-10";

  src = fetchFromGitHub {
    owner = "cwkx";
    repo = "keym";
    rev = "67a6d39d45e17221353e06c39283b5636b46d25c";
    hash = "sha256-v2eS7un2ABnpWBwuKq+0CeLX8ivtlNUjM2jRboKumOE=";
  };

  buildInputs = [
    libx11
    libxtst
    libxi
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = "https://github.com/cwkx/keym";
    description = "C tool to control mouse with keyboard for X11";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "keym";
    maintainers = with lib.maintainers; [ CompileTime ];
  };
}
