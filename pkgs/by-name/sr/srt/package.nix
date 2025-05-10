{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  windows,
}:

stdenv.mkDerivation rec {
  pname = "srt";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "Haivision";
    repo = "srt";
    rev = "v${version}";
    sha256 = "sha256-NLy9GuP4OT/kKAIIDXSHtsmaBzXRuFohFM/aM+46cao=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      windows.mingw_w64_pthreads
    ];

  patches = lib.optionals stdenv.hostPlatform.isMinGW [
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

  meta = with lib; {
    description = "Secure, Reliable, Transport";
    homepage = "https://github.com/Haivision/srt";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nh2 ];
    platforms = platforms.all;
  };
}
