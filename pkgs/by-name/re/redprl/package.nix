{ lib, stdenv, fetchFromGitHub, mlton }:

stdenv.mkDerivation {
  pname = "redprl";
  version = "unstable-2019-11-04";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "sml-redprl";
    rev = "c72190de76f7ed1cfbe1d2046c96e99ac5022b0c";
    fetchSubmodules = true;
    hash = "sha256-xrQT5o0bsIN+mCYUOz9iY4+j3HGROb1I6R2ADcLy8n4=";
  };

  buildInputs = [ mlton ];

  postPatch = ''
    patchShebangs ./script/
  '';

  buildPhase = ''
    ./script/mlton.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ./bin/redprl $out/bin
  '';

  meta = with lib; {
    description = "Proof assistant for Nominal Computational Type Theory";
    mainProgram = "redprl";
    homepage = "http://www.redprl.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.unix;
  };
}
