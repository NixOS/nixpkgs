{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "openrsync";
  version = "unstable-2022-05-08";

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = "openrsync";
    rev = "f50d0f8204ea18306a0c29c6ae850292ea826995";
    hash = "sha256-4tygoCQGIM0wqLfdWp55/oOPhD3lPUuTd9/LXQAASXU=";
  };

  # Uses oconfigure
  prefixKey = "PREFIX=";

  meta = with lib; {
    homepage = "https://www.openrsync.org/";
    description = "BSD-licensed implementation of rsync";
    license = licenses.isc;
    maintainers = with maintainers; [ fgaz ];
    # https://github.com/kristapsdz/openrsync#portability
    # https://github.com/kristapsdz/oconfigure#readme
    platforms = platforms.unix;
  };
}
