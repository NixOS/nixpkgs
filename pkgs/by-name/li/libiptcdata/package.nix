{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libiconv,
  libintl,
}:

stdenv.mkDerivation rec {
  pname = "libiptcdata";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ianw";
    repo = "libiptcdata";
    rev = "release_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-ZjokepDAHiSEwXrkvM9qUAPcpIiRQoOsv7REle7roPU=";
  };

  postPatch = ''
    # gtk-doc doesn't build without network access
    sed -i '/GTK_DOC_CHECK/d;/docs/d' configure.ac
    sed -i 's/docs//' Makefile.am
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    libintl
  ];

  meta = with lib; {
    description = "Library for reading and writing the IPTC metadata in images and other files";
    mainProgram = "iptc";
    homepage = "https://github.com/ianw/libiptcdata";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wegank ];
  };
}
