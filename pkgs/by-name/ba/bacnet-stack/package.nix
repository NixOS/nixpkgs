{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bacnet-stack";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bacnet-stack";
    repo = "bacnet-stack";
    rev = "bacnet-stack-${finalAttrs.version}";
    hash = "sha256-CJmEEIGT6u2nsnl3btWL/JJPxQM53JF6l+mLBSF+Q8Q=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BACDL_BIP" true)
    (lib.cmakeBool "BACNET_STACK_BUILD_APPS" true)
  ];

  # bacnet-stack's CMakeLists builds the apps via add_executable() but never
  # adds install(TARGETS ...) rules for them, so `make install` skips them.
  # Copy them out of the CMake build tree manually.
  postInstall = ''
    mkdir -p $out/bin
    find . -maxdepth 2 -type f -executable -not -name '*.so*' -not -name '*.a' \
      -exec cp -t $out/bin {} +
  '';

  meta = {
    description = "BACnet open source protocol stack for embedded systems, Linux, and Windows";
    homepage = "https://bacnet.sourceforge.net/";
    changelog = "https://github.com/bacnet-stack/bacnet-stack/releases/tag/bacnet-stack-${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ WhittlesJr ];
    platforms = lib.platforms.linux;
  };
})
