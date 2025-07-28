{
  lib,
  stdenv,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
  cmake,
  zlib,
  pandoc,
  doxygen,
  graphviz,
  openssl,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "globalplatform";
  version = "2.4.0-unstable-2025-03-23";

  src = fetchFromGitHub {
    owner = "kaoh";
    repo = "globalplatform";
    rev = "0f970751c5d9e8a7030f897ca2d1b86d0eeba4c2";
    sha256 = "sha256-H/muc/gY5glXPWKj75fHi6+1DAP91YGAUefdQkX9nfk=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    pandoc
    doxygen
    graphviz
  ];

  buildInputs = [
    zlib
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pcsclite
  ];

  cmakeFlags = [
    "-DTESTING=ON"
  ];

  doCheck = true;

  nativeCheckInputs = [
    cmocka
  ];

  preCheck = ''
    cp "$src/gpshell/helloworld.cap" globalplatform/src
    cp "$src/globalplatform/src/rsa_pub_key_test.pem" globalplatform/src
  '';

  # libglobalplatform.so uses dlopen() to load specified connection plugins at runtime.
  # Currently, libgppcscconnectionplugin.so is the only plugin included.
  # The user has to specify custom plugin locations by setting LD_LIBRARY_PATH.

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf $out/lib/libglobalplatform.so --add-rpath "$out/lib"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -add_rpath "$out/lib" "$out/lib/libglobalplatform.dylib"
    '';

  meta = {
    description = "C library + command-line for Open- / GlobalPlatform smart cards";
    mainProgram = "gpshell";
    homepage = "https://github.com/kaoh/globalplatform";
    # Clarify license for GPShell
    # https://github.com/kaoh/globalplatform/issues/81
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ stargate01 ];
  };
})
