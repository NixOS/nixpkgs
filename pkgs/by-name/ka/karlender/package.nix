{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  glib,
  tzdata,
  nix-update-script,
  dbus,
  cargo-gra,
}:

rustPlatform.buildRustPackage rec {
  pname = "karlender";
  version = "0.10.11";

  src = fetchFromGitLab {
    owner = "floers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PwXSJq4uBtgIA2aQ5AZawEMmHoVS2Z9haVHyJ2oyXUs=";
  };

  cargoHash = "sha256-R/oQvyZCcTImOA8FB5bECTj5VGFElImoQwIRX75PtOs=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib
    cargo-gra
  ];

  buildInputs = [
    gtk4
    libadwaita
    dbus
  ];

  checkFlags = [
    "--skip domain::time::tests::test_get_correct_offset_for_dst" # Need time
  ];

  preBuild = ''
    cargo-gra gen
  '';

  postPatch = ''
    substituteInPlace src/domain/time.rs --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  postInstall = ''
    substituteInPlace target/gra-gen/data/codes.loers.Karlender.desktop \
      --replace-fail "Exec=codes.loers.Karlender" "Exec=karlender"
    substituteInPlace target/gra-gen/data/codes.loers.Karlender.appdata.xml \
      --replace-fail "<binary>codes.loers.Karlender</binary>" "<binary>karlender</binary>"
    install -Dm444 target/gra-gen/codes.loers.Karlender.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.64.png -T $out/share/icons/hicolor/64x64/apps/codes.loers.Karlender.png
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.128.png -T $out/share/icons/hicolor/128x128/apps/codes.loers.Karlender.png
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.desktop -t $out/share/applications/
    install -Dm444 target/gra-gen/data/codes.loers.Karlender.appdata.xml -t $out/share/metainfo/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mobile-friendly GTK calendar application";
    homepage = "https://gitlab.com/floers/karlender";
    license = lib.licenses.gpl3Plus;
    mainProgram = "karlender";
    maintainers = with lib.maintainers; [
      chuangzhu
      bot-wxt1221
    ];
    platforms = lib.platforms.linux;
  };
}
