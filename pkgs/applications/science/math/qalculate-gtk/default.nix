{ lib, stdenv, fetchFromGitHub, intltool, autoreconfHook, pkg-config, libqalculate, gtk3, curl, wrapGAppsHook3, desktopToDarwinBundle }:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-gtk";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vH4GZaeQ6Ji9aWh8R5B6PE2fBBW7KTyCsFkpgHu6yg8=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkg-config autoreconfHook wrapGAppsHook3 ]
    ++ lib.optionals stdenv.isDarwin [ desktopToDarwinBundle ];
  buildInputs = [ libqalculate gtk3 curl ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ gebner doronbehar alyaeanyx ];
    license = licenses.gpl2Plus;
    mainProgram = "qalculate-gtk";
    platforms = platforms.all;
  };
})
