{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  cjson,
  cmocka,
  mbedtls,
}:

stdenv.mkDerivation rec {
  pname = "librist";
  version = "0.2.10";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "rist";
    repo = "librist";
    rev = "v${version}";
    hash = "sha256-8N4wQXxjNZuNGx/c7WVAV5QS48Bff5G3t11UkihT+K0=";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/pull/257020
    ./darwin.patch
    # https://code.videolan.org/rist/librist/-/merge_requests/257
    ./musl.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cjson
    cmocka
    mbedtls
  ];

  meta = with lib; {
    description = "Library that can be used to easily add the RIST protocol to your application";
    homepage = "https://code.videolan.org/rist/librist";
    license = with licenses; [
      bsd2
      mit
      isc
    ];
    maintainers = with maintainers; [ raphaelr ];
    platforms = platforms.all;
  };
}
