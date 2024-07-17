{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "replxx";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "AmokHuginnsson";
    repo = "replxx";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-WGiczMJ64YPq0DHKZRBDa7EGlRx7hPlpnk6zPdIVFh4=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if enableStatic then "OFF" else "ON"}" ];

  meta = with lib; {
    homepage = "https://github.com/AmokHuginnsson/replxx";
    description = "A readline and libedit replacement that supports UTF-8, syntax highlighting, hints and Windows and is BSD licensed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
})
