{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gtk4
, protobuf
, libsecret
, libadwaita
, rustPlatform
, desktop-file-utils
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "flare";
  version = "0.5.3";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "Schmiddiii";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-gco8cqlO5t5ugbIaPWBbDpbp0E9j6rvTDRp4NQkUIl0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-y1CHCSGHJlqMwogqWmpYAVkgUP2xGDS4xs99I1X81s4=";
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk4
    libadwaita
    libsecret
    protobuf
  ];

  meta = with lib; {
    description = "A unofficial Signal GTK client.";
    homepage = "https://gitlab.com/Schmiddiii/flare";
    license = licenses.agpl3;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
