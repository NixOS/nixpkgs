{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "corkscrew";
  version = "2.0";
  src = fetchFromGitHub {
    owner = "bryanpkc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JiddvTbuOysenrVWGUEyKSzpCF1PJaYWQUdz3FuLCdw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/bryanpkc/corkscrew";
    description = "Tool for tunneling SSH through HTTP proxies";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "corkscrew";
  };
}
