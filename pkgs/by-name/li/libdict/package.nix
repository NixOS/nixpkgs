{ stdenv
, lib
, fetchFromGitHub
, cmake
, cunit
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdict";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "rtbrick";
    repo = "libdict";
    rev = finalAttrs.version;
    hash = "sha256-GFK2yjtxAwwstoJQGCXxwNKxn3LL74FBxad7JdOn0pU=";
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

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/rtbrick/libdict/";
    changelog = "https://github.com/rtbrick/libdict/releases/tag/${finalAttrs.version}";
    description = "C library of key-value data structures";
    license = licenses.bsd2;
    maintainers = teams.wdz.members;
  };
})
