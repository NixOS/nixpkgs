{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfreeaptx";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "iamthehorker";
    repo = "libfreeaptx";
    rev = finalAttrs.version;
    sha256 = "sha256-ntbF0jz/ilOk45xMQxx00WJtJq4Wb7VyKE0eKvghYnY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace '-soname' '-install_name' \
      --replace 'lib$(NAME).so' 'lib$(NAME).dylib'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    # disable static builds
    "ANAME="
    "AOBJECTS="
    "STATIC_UTILITIES="
  ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change libfreeaptx.dylib.0 $out/lib/libfreeaptx.dylib.0 $out/bin/freeaptxdec
    install_name_tool -change libfreeaptx.dylib.0 $out/lib/libfreeaptx.dylib.0 $out/bin/freeaptxenc
    install_name_tool -id $out/lib/libfreeaptx.dylib $out/lib/libfreeaptx.dylib
    install_name_tool -id $out/lib/libfreeaptx.dylib.0 $out/lib/libfreeaptx.dylib.0
  '';

  meta = {
    description = "Free Implementation of Audio Processing Technology codec (aptX)";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://github.com/iamthehorker/libfreeaptx";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
