{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bashNonInteractive,
  openssl,
  windows,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srt";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "Haivision";
    repo = "srt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fdgj6URuMaem+ZVy7D8Hnf2Ev1HindevdvX0xyxCL4M=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    bashNonInteractive
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    windows.pthreads
  ];

  strictDeps = true;

  patches = [
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    ./no-msvc-compat-headers.patch
  ];

  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DENABLE_SHARED=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
    # TODO Remove this when https://github.com/Haivision/srt/issues/538 is fixed and available to nixpkgs
    # Workaround for the fact that srt incorrectly disables GNUInstallDirs when LIBDIR is specified,
    # see https://github.com/NixOS/nixpkgs/pull/54463#discussion_r249878330
    "-UCMAKE_INSTALL_LIBDIR"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Secure, Reliable, Transport";
    homepage = "https://github.com/Haivision/srt";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ nh2 ];
    platforms = lib.platforms.all;
  };
})
