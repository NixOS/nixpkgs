{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libxslt,
  html-tidy,
}:

stdenv.mkDerivation rec {
  pname = "html-tidy";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "htacg";
    repo = "tidy-html5";
    rev = version;
    hash = "sha256-vzVWQodwzi3GvC9IcSQniYBsbkJV20iZanF33A0Gpe0=";
  };

  # https://github.com/htacg/tidy-html5/pull/1036
  patches = (
    fetchpatch {
      url = "https://github.com/htacg/tidy-html5/commit/e9aa038bd06bd8197a0dc049380bc2945ff55b29.diff";
      sha256 = "sha256-Q2GjinNBWLL+HXUtslzDJ7CJSTflckbjweiSMCnIVwg=";
    }
  );
  # https://github.com/htacg/tidy-html5/issues/1139
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required (VERSION 2.8.12)' 'cmake_minimum_required(VERSION 3.5)'
  '';

  nativeBuildInputs = [
    cmake
    libxslt # manpage
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) html-tidy;

  cmakeFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DHOST_TIDY=tidy"
  ];

  # ATM bin/tidy is statically linked, as upstream provides no other option yet.
  # https://github.com/htacg/tidy-html5/issues/326#issuecomment-160322107

  meta = with lib; {
    description = "HTML validator and `tidier'";
    longDescription = ''
      HTML Tidy is a command-line tool and C library that can be
      used to validate and fix HTML data.
    '';
    license = licenses.libpng; # very close to it - the 3 clauses are identical
    homepage = "http://html-tidy.org";
    platforms = platforms.all;
    maintainers = with maintainers; [ edwtjo ];
    mainProgram = "tidy";
  };
}
