{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  tzdata,
  fetchpatch,
  replaceVars,
}:

stdenv.mkDerivation rec {
  pname = "howard-hinnant-date";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "v${version}";
    hash = "sha256-qfrmH3NRyrDVmHRmmWzM5Zz37E7RFXJqaV1Rq2E59qs=";
  };

  patches = [
    # Add pkg-config file
    # https://github.com/HowardHinnant/date/pull/538
    (fetchpatch {
      name = "output-date-pc-for-pkg-config.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/date/538-output-date-pc-for-pkg-config.patch?id=11f6b4d4206b0648182e7b41cd57dcc9ccea0728";
      sha256 = "1ma0586jsd89jgwbmd2qlvlc8pshs1pc4zk5drgxi3qvp8ai1154";
    })
    # Without this patch, this library will drop a `tzdata` directory into
    # `~/Downloads` if it cannot find `/usr/share/zoneinfo`. Make the path it
    # searches for `zoneinfo` be the one from the `tzdata` package.
    (replaceVars ./make-zoneinfo-available.diff {
      inherit tzdata;
    })
  ];

  # Tweaks to fix undefined variable substitutions
  # https://github.com/HowardHinnant/date/pull/538#pullrequestreview-1373268697
  postPatch = ''
    substituteInPlace date.pc.in \
      --replace '@CMAKE_INSTALL_LIB@' '@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace '@CMAKE_INSTALL_INCLUDE@' '@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      --replace '@PACKAGE_VERSION@' '${version}'
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_TZ_LIB=true"
    "-DBUILD_SHARED_LIBS=true"
    "-DUSE_SYSTEM_TZ_DB=true"
  ];

  outputs = [
    "out"
    "dev"
  ];

  # fixes "cycle detected in build"
  postInstall = lib.optionalString stdenv.hostPlatform.isWindows ''
    mkdir $dev/lib
    mv $out/CMake $dev/lib/cmake
  '';

  meta = with lib; {
    license = licenses.mit;
    description = "Date and time library based on the C++11/14/17 <chrono> header";
    homepage = "https://github.com/HowardHinnant/date";
    platforms = with platforms; unix ++ windows;
    maintainers = with maintainers; [ r-burns ];
  };
}
