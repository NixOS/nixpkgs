{ lib
, stdenv
, fetchFromGitHub
, autoconf-archive
, autoreconfHook
, pkg-config
, curlWithGnuTls
, libev
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "clboss";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "ZmnSCPxj";
    repo = "clboss";
    rev = "v${version}";
    hash = "sha256-T61rkTEGLCZrEBp1WFhHnQ7DQyhctMf5lgbOs6u9E0o=";
  };

  nativeBuildInputs = [ autoconf-archive autoreconfHook pkg-config libev curlWithGnuTls sqlite ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Automated C-Lightning Node Manager";
    homepage = "https://github.com/ZmnSCPxj/clboss";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "clboss";
  };
}
