{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  pkg-config,
  staticOnly ? stdenv.hostPlatform.isStatic,
}:

let
  version = "1.12.0";
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
    hash = "sha256-OkOyh2ibt/jX/Dc+TB1uSlWtzEhdSQwHVN96oCOh2yM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [ curl ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!staticOnly))
    (lib.cmakeBool "CPR_USE_SYSTEM_CURL" true)
  ];

  postPatch = ''
    # Linking with stdc++fs is no longer necessary.
    sed -i '/stdc++fs/d' include/CMakeLists.txt
  '';

  postInstall = ''
    substituteInPlace "$out/lib/cmake/cpr/cprTargets.cmake" \
      --replace-fail "_IMPORT_PREFIX \"$out\"" \
                     "_IMPORT_PREFIX \"$dev\""
  '';

  meta = with lib; {
    description = "C++ wrapper around libcurl";
    homepage = "https://docs.libcpr.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      phodina
      rycee
    ];
    platforms = platforms.all;
  };
}
