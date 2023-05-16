<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, qtbase
, qttools
, libuuid
, seafile-shared
, jansson
, libsearpc
, withShibboleth ? true
, qtwebengine
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "seafile-client";
  version = "9.0.3";
=======
{ mkDerivation, lib, fetchFromGitHub, pkg-config, cmake, qtbase, qttools
, seafile-shared, jansson, libsearpc
, withShibboleth ? true, qtwebengine }:

mkDerivation rec {
  pname = "seafile-client";
  version = "8.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
<<<<<<< HEAD
    rev = "v${version}";
    sha256 = "sha256-zoo34mhNZTEwxjSy8XgmZfEjkujmWj34OtDJQSCb/zk=";
  };

  nativeBuildInputs = [
    libuuid
    pkg-config
    cmake
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    seafile-shared
    jansson
    libsearpc
  ] ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";
=======
    # Tag v8.0.7 used to point to this commit, but was re-tagged later to a state
    # that fails to link properly
    rev = "8b96abf64e6aa19e3beeff6b322bcd6d28120bdd";
    sha256 = "00wfr7dvbyl7pg1xgssgz8a94c7c4n5r9266lhy9qcbz456hdcgj";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ qtbase qttools seafile-shared jansson libsearpc ]
    ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ schmittlauch greizgh ];
  };
}
