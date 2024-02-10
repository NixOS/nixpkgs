{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config, libqalculate, gtk3, curl, wrapGAppsHook, desktopToDarwinBundle }:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-gtk";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rQxOOxM4TazkDs/H3KEPbdo6WBl0ptyAlZwv8nnGMss=";
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
    mainProgram = "qalculate-gtk";
    platforms = platforms.all;
  };
})
