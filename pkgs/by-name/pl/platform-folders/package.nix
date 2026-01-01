{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "platform-folders";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "sago007";
    repo = "PlatformFolders";
    rev = version;
    hash = "sha256-8dKW9nmxiqt47Z9RBNuHjFRyOhwmi+9mR7prUOxXIRE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  passthru.updateScript = gitUpdater { };

<<<<<<< HEAD
  meta = {
    description = "C++ library to look for standard platform directories so that you do not need to write platform-specific code";
    homepage = "https://github.com/sago007/PlatformFolders";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "C++ library to look for standard platform directories so that you do not need to write platform-specific code";
    homepage = "https://github.com/sago007/PlatformFolders";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
