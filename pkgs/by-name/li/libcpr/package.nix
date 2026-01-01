{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
<<<<<<< HEAD
  pkg-config,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  staticOnly ? stdenv.hostPlatform.isStatic,
}:

let
<<<<<<< HEAD
  version = "1.14.1";
=======
  version = "1.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenv.mkDerivation {
  pname = "libcpr";
  inherit version;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libcpr";
    repo = "cpr";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-kwbkdAeTpkEJbzvqpUQx007ZIBtwqOPG8n41TvFxeiM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
=======
    hash = "sha256-OkOyh2ibt/jX/Dc+TB1uSlWtzEhdSQwHVN96oCOh2yM=";
  };

  nativeBuildInputs = [ cmake ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  propagatedBuildInputs = [ curl ];

  cmakeFlags = [
<<<<<<< HEAD
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!staticOnly))
    (lib.cmakeBool "CPR_USE_SYSTEM_CURL" true)
=======
    "-DBUILD_SHARED_LIBS=${if staticOnly then "OFF" else "ON"}"
    "-DCPR_USE_SYSTEM_CURL=ON"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postPatch = ''
    # Linking with stdc++fs is no longer necessary.
    sed -i '/stdc++fs/d' include/CMakeLists.txt
  '';

  postInstall = ''
    substituteInPlace "$out/lib/cmake/cpr/cprTargets.cmake" \
<<<<<<< HEAD
      --replace-fail "_IMPORT_PREFIX \"$out\"" \
                     "_IMPORT_PREFIX \"$dev\""
  '';

  meta = {
    description = "C++ wrapper around libcurl";
    homepage = "https://docs.libcpr.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      phodina
      rycee
    ];
    platforms = lib.platforms.all;
=======
      --replace "_IMPORT_PREFIX \"$out\"" \
                "_IMPORT_PREFIX \"$dev\""
  '';

  meta = with lib; {
    description = "C++ wrapper around libcurl";
    homepage = "https://docs.libcpr.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
