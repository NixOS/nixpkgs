{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config, libqalculate, gtk3, curl, wrapGAppsHook, desktopToDarwinBundle }:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-gtk";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bG0hui5GjHWHny/8Rq5sZGz3s5rYnYlpc+K8I/LwDto=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook wrapGAppsHook ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [ libqalculate gtk3 curl ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner doronbehar alyaeanyx ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
})
