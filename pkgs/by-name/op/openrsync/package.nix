{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "openrsync";
  version = "unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = "openrsync";
    rev = "a257c0f495af2b5ee6b41efc6724850a445f87ed";
    hash = "sha256-pc1lo8d5FY8/1K2qUWzSlrSnA7jnRg4FQRyHqC8I38k=";
  };

  # Uses oconfigure
  prefixKey = "PREFIX=";

  meta = with lib; {
    homepage = "https://www.openrsync.org/";
    description = "BSD-licensed implementation of rsync";
    mainProgram = "openrsync";
    license = licenses.isc;
    maintainers = with maintainers; [ fgaz ];
    # https://github.com/kristapsdz/openrsync#portability
    # https://github.com/kristapsdz/oconfigure#readme
    platforms = platforms.unix;
  };
}
