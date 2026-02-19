{
  lib,
  stdenv,
  fetchFromGitHub,
  libck,
  cctools,
}:

let
  version = "0.36.0";
  bootstrap = stdenv.mkDerivation {
    pname = "cyclone-bootstrap";
    inherit version;

    src = fetchFromGitHub {
      owner = "justinethier";
      repo = "cyclone-bootstrap";
      rev = "v${version}";
      sha256 = "sha256-8WK4rsLK3gi9a6PKFaT3KRK256rEDTTO6QvqYrOtYDs=";
    };

    enableParallelBuilding = true;

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

    buildInputs = [ libck ];

    makeFlags = [ "PREFIX=${placeholder "out"}" ];
  };
in
stdenv.mkDerivation {
  pname = "cyclone";
  inherit version;

  src = fetchFromGitHub {
    owner = "justinethier";
    repo = "cyclone";
    rev = "v${version}";
    sha256 = "sha256-5h8jZ8EBgiLLYH/j3p7CqsQGXHhjGtQfOnxPbFnT5WM=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ bootstrap ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  buildInputs = [ libck ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://justinethier.github.io/cyclone/";
    description = "Brand-new compiler that allows practical application development using R7RS Scheme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
