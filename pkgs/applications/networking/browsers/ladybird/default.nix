{ lib
, gcc11Stdenv
, fetchFromGitHub
, cmake
, ninja
, unzip
, wrapQtAppsHook
, libxcrypt
, qtbase
, qttools
, nixosTests
}:

let serenity = fetchFromGitHub {
  owner = "SerenityOS";
  repo = "serenity";
  rev = "a0f3e2c9a2b82117aa7c1a3444ad0d31baa070d5";
  hash = "sha256-8Xde59ZfdkTD39mYSv0lfFjBHFDWTUwfozE+Q9Yq6C8=";
};

in gcc11Stdenv.mkDerivation {
  pname = "ladybird";
  version = "unstable-2022-09-29";

  # Remember to update `serenity` too!
  src = fetchFromGitHub {
    owner = "SerenityOS";
    repo = "ladybird";
    rev = "d69ad7332477de33bfd1963026e057d55c6f222d";
    hash = "sha256-XQj2Bohk8F6dGCAManOmmDP5b/SqEeZXZbLDYPfvi2E=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    unzip
    wrapQtAppsHook
  ];

  buildInputs = [
    libxcrypt
    qtbase
  ];

  cmakeFlags = [
    "-DSERENITY_SOURCE_DIR=${serenity}"
    # Disable network operations
    "-DENABLE_TIME_ZONE_DATABASE_DOWNLOAD=false"
    "-DENABLE_UNICODE_DATABASE_DOWNLOAD=false"
  ];

  passthru.tests = {
    nixosTest = nixosTests.ladybird;
  };

  meta = with lib; {
    description = "A browser using the SerenityOS LibWeb engine with a Qt GUI";
    homepage = "https://github.com/awesomekling/ladybird";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    # SerenityOS only works on x86, and can only be built on unix systems.
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
