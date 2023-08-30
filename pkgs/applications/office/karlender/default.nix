{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, gtk4
, libadwaita
, wrapGAppsHook4
, glib
, dbus
, tzdata
}:

let
  cargo-gra = rustPlatform.buildRustPackage rec {
    pname = "cargo-gra";
    version = "0.6.0";
    src = fetchFromGitLab {
      owner = "floers";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-PUfNQyK8EaAv2Ql+jWOpwXhds8DVo47GCHMofDMD4Nk=";
    };
    cargoHash = "sha256-xsaavcpDaiDDbL3Dl+7NLcfB5U6vuYsVPoIuA/KXCvI=";
    meta = with lib; {
      description = "Framework for writing flatpak apps with GTK in Rust";
      homepage = "https://crates.io/crates/gtk-rust-app";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ chuangzhu ];
    };
  };
in

rustPlatform.buildRustPackage rec {
  pname = "karlender";
  version = "0.10.3";

  src = fetchFromGitLab {
    owner = "floers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1PnbfyvzR0NSR6knEAGXQu/oSpxNAW1THK23je6pr0Q=";
  };

  cargoHash = "sha256-Xgo90dFkuJgCs9aEE8JnkOlNmh54XSRkhjfzwhTRmQc=";

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

  postPatch = ''
    substituteInPlace src/domain/time.rs --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  preBuild = ''
    cargo gra gen
  '';

  # test domain::time::tests::test_get_correct_offset_for_dst ... FAILED
  doCheck = false;

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
    homepage = "https://gitlab.com/floers/karlender";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
