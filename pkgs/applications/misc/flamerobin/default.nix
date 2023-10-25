{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, wxGTK32
, boost
, firebird
}:

stdenv.mkDerivation rec {
  version = "0.9.3.12";
  pname = "flamerobin";

  src = fetchFromGitHub {
    owner = "mariuz";
    repo = "flamerobin";
    rev = version;
    sha256 = "sha256-uWx3riRc79VKh7qniWFjxxc7v6l6cW0i31HxoN1BSdA=";
  };

  patches = [
    # rely on compiler command line for __int128 and std::decimal::decimal128
    (fetchpatch {
      url = "https://github.com/mariuz/flamerobin/commit/8e0ea6d42aa28a4baeaa8c8b8b57c56eb9ae3540.patch";
      sha256 = "sha256-l6LWXA/sRQGQKi798bzl0iIJ2vdvXHOjG7wdFSXv+NM=";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    wxGTK32
    boost
    firebird
  ];

  meta = with lib; {
    description = "Database administration tool for Firebird RDBMS";
    homepage = "https://github.com/mariuz/flamerobin";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ uralbash ];
    platforms = platforms.unix;
  };
}
