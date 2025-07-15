{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "musl-obstack";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "musl-obstack";
    rev = "v${version}";
    sha256 = "sha256-oydS7FubUniMHAUWfg84OH9+CZ0JCrTXy7jzwOyJzC8=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./0001-ignore-obstack_free-alias-on-darwin.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/void-linux/musl-obstack";
    description = "Extraction of the obstack functions and macros from GNU libiberty for use with musl-libc";
    platforms = platforms.unix;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.pjjw ];
  };
}
