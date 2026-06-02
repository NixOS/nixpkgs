{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mxml";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-l7GUA+vlSECi/72eU3Y9COpGtLTRh3vYcHUi+uRkCn8=";
  };

  # remove the -arch flags which are set by default in the build
  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-archflags=\"-mmacosx-version-min=10.14\""
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Small XML library";
    homepage = "https://www.msweet.org/mxml/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
