{ lib
, fetchFromGitLab
, makeDesktopItem
, copyDesktopItems
, rustPlatform
, pkg-config
, clang
, libclang
, glib
, gtk4
, pipewire
}:

rustPlatform.buildRustPackage rec {
  pname = "helvum";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "ryuukyu";
    repo = pname;
    rev = version;
    sha256 = "sha256-f6+6Qicg5J6oWcafG4DF0HovTmF4r6yfw6p/3dJHmB4=";
  };

  cargoSha256 = "sha256-zGa6nAmOOrpiMr865J06Ez3L6lPL0j18/lW8lw1jPyU=";

  nativeBuildInputs = [ clang copyDesktopItems pkg-config ];
  buildInputs = [ glib gtk4 pipewire ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  desktopItems = makeDesktopItem {
    name = "Helvum";
    exec = pname;
    desktopName = "Helvum";
    genericName = "Helvum";
    categories = "AudioVideo;";
  };

  meta = with lib; {
    description = "A GTK patchbay for pipewire";
    homepage = "https://gitlab.freedesktop.org/ryuukyu/helvum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fufexan ];
  };
}
