{
  lib,
  stdenv,
  fetchFromGitHub,
  isStatic ? false,
}:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "sha256-l7GUA+vlSECi/72eU3Y9COpGtLTRh3vYcHUi+uRkCn8=";
  };

  patches = lib.optional stdenv.hostPlatform.isMinGW ./0001-fix-building-for-mingw-w64.patch;

  # remove the -arch flags which are set by default in the build
  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-archflags=\"-mmacosx-version-min=10.14\""
  ] ++ lib.optional isStatic "--enable-static";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Small XML library";
    homepage = "https://www.msweet.org/mxml/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
