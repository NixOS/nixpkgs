{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sigslot";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "palacaze";
    repo = "sigslot";
    rev = "v${version}";
    hash = "sha256-8JBZ6Xid/uAOfiPKgJKetpj/oBb8lRLPgjkMnrfTKaM=";
  };

  nativeBuildInputs = [ cmake ];

  dontBuild = true;

<<<<<<< HEAD
  meta = {
    description = "Header-only, thread safe implementation of signal-slots for C++";
    license = lib.licenses.mit;
    homepage = "https://github.com/palacaze/sigslot";
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Header-only, thread safe implementation of signal-slots for C++";
    license = licenses.mit;
    homepage = "https://github.com/palacaze/sigslot";
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
