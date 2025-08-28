{
  lib,
  stdenv,
  fetchFromGitHub,
  libck,
  cctools,
}:

let
  version = "0.34.0";
  bootstrap = stdenv.mkDerivation {
    pname = "cyclone-bootstrap";
    inherit version;

    src = fetchFromGitHub {
      owner = "justinethier";
      repo = "cyclone-bootstrap";
      rev = "v${version}";
      sha256 = "sha256-kJBPb0Ej32HveY/vdGpH2gyxSwq8Xq7muneFIw3Y7hM=";
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
    sha256 = "sha256-4U/uOTbFpPTC9BmO6Wkhy4PY8UCFVt5eHSGqrOlKT/U=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ bootstrap ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  buildInputs = [ libck ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://justinethier.github.io/cyclone/";
    description = "Brand-new compiler that allows practical application development using R7RS Scheme";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
