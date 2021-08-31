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
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "ryuukyu";
    repo = pname;
    rev = version;
    sha256 = "sha256-AlHCK4pWaoNjR0eflxHBsuVaaily/RvCbgJv/ByQZK4=";
  };

  cargoSha256 = "sha256-mAhh12rGvQjs2xtm+OrtVv0fgG6qni/QM/oRYoFR7U8=";

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
