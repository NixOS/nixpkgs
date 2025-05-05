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
  version = "0.2.11";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "rist";
    repo = "librist";
    rev = "v${version}";
    hash = "sha256-xWqyQl3peB/ENReMcDHzIdKXXCYOJYbhhG8tcSh36dY=";
  };

  # avoid rebuild on Linux for now
  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    # https://code.videolan.org/rist/librist/-/issues/192
    ./no-brew-darwin.diff
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
