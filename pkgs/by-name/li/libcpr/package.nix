{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
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

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ curl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if staticOnly then "OFF" else "ON"}"
    "-DCPR_USE_SYSTEM_CURL=ON"
  ];

  postPatch = ''
    # Linking with stdc++fs is no longer necessary.
    sed -i '/stdc++fs/d' include/CMakeLists.txt
  '';

  postInstall = ''
    substituteInPlace "$out/lib/cmake/cpr/cprTargets.cmake" \
      --replace "_IMPORT_PREFIX \"$out\"" \
                "_IMPORT_PREFIX \"$dev\""
  '';

  meta = with lib; {
    description = "C++ wrapper around libcurl";
    homepage = "https://docs.libcpr.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
