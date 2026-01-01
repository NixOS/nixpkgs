{
  lib,
  stdenv,
  fetchFromGitHub,
  capnproto,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "capnproto-java";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto-java";
    rev = "v${version}";
    hash = "sha256-7uYtRHKsJvbE1b0HbNXGbRXpkUHHLjMDIWLlOUcQWDk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ capnproto ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Cap'n Proto codegen plugin for Java";
    mainProgram = "capnpc-java";
    longDescription = "Only includes compiler plugin, the Java runtime/library that the generated code will link to must be built separately with Maven.";
    homepage = "https://dwrensha.github.io/capnproto-java/index.html";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
    license = licenses.mit;
    maintainers = with maintainers; [
      bhipple
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      solson
    ];
  };
}
