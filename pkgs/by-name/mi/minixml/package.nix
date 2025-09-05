{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "sha256-2iDA7EwjG7FINW+F5+0dT/1pmZDmqRvCMmCdk6OSwNQ=";
  };

  # remove the -arch flags which are set by default in the build
  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--with-archflags=\"-mmacosx-version-min=10.14\""
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Small XML library";
    homepage = "https://www.msweet.org/mxml/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
