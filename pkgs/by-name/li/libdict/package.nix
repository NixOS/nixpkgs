{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  cunit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdict";
<<<<<<< HEAD
  version = "1.0.5";
=======
  version = "1.0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rtbrick";
    repo = "libdict";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-604escyV5MVuYggs1awIrorCrdXSUj3IhjwXV2QdDMU=";
=======
    hash = "sha256-GFK2yjtxAwwstoJQGCXxwNKxn3LL74FBxad7JdOn0pU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    cunit
  ];

  cmakeFlags = [
    "-DLIBDICT_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DLIBDICT_SHARED=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=strict-prototypes"
      "-Wno-error=newline-eof"
    ]
  );

  doCheck = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/rtbrick/libdict/";
    changelog = "https://github.com/rtbrick/libdict/releases/tag/${finalAttrs.version}";
    description = "C library of key-value data structures";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.wdz ];
=======
  meta = with lib; {
    homepage = "https://github.com/rtbrick/libdict/";
    changelog = "https://github.com/rtbrick/libdict/releases/tag/${finalAttrs.version}";
    description = "C library of key-value data structures";
    license = licenses.bsd2;
    teams = [ teams.wdz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
