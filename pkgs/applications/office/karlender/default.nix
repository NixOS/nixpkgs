{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, gtk4
, libadwaita
, wrapGAppsHook4
, glib
, tzdata
}:

rustPlatform.buildRustPackage rec {
  pname = "karlender";
  version = "0.9.2";

  src = fetchFromGitLab {
    owner = "floers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-txPMOWwxgs9PH1Scnwr/X4cuMIUa+eoLW3K2aqmqRMQ=";
  };

  cargoHash = "sha256-OyyzzkoYBed2XFCesj3QBodT9e/BaapGl/z0f6+cDZA=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  postPatch = ''
    substituteInPlace src/domain/time.rs --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace build.rs --replace "// gra::build" "gra::build"
  '';

  postInstall = ''
    substituteInPlace target/gra-gen/data/codes.loers.Karlender.desktop \
      --replace "Exec=codes.loers.Karlender" "Exec=karlender"
    substituteInPlace target/gra-gen/data/codes.loers.Karlender.appdata.xml \
      --replace "<binary>codes.loers.Karlender</binary>" "<binary>karlender</binary>"
    install -Dm444 target/gra-gen/codes.loers.Karlender.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.64.png -T $out/share/icons/hicolor/64x64/apps/codes.loers.Karlender.png
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.128.png -T $out/share/icons/hicolor/128x128/apps/codes.loers.Karlender.png
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.desktop -t $out/share/applications/
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.appdata.xml -t $out/share/metainfo/
  '';

  meta = with lib; {
    description = "Mobile-friendly GTK calendar application";
    mainProgram = "karlender";
    homepage = "https://gitlab.com/floers/karlender";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
