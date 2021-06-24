{ mkDerivation, fetchFromGitHub, cmake, pkg-config, lib,
  qttools, fribidi, libunibreak }:

mkDerivation rec {
  pname = "coolreader";
  version = "3.2.55";

  src = fetchFromGitHub {
    owner = "buggins";
    repo = pname;
    rev = "cr${version}";
    sha256 = "sha256-gYAaYGEjw7p6y4h5j6j/4Ld+b37Nv+kt04Wp+qb8gzY=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ qttools fribidi libunibreak ];

  meta = with lib; {
    homepage = "https://github.com/buggins/coolreader";
    description = "Cross platform open source e-book reader";
    license = licenses.gpl2Plus; # see https://github.com/buggins/coolreader/issues/80
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
