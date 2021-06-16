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
  version = "0.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "ryuukyu";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZnpdGXK8N8c/s4qC2NXcn0Pdqrqr47iOWvVwXD9pn1A=";
  };

  cargoSha256 = "sha256-2v2L20rUWftXdhhuE3wiRrDIuSg6VFxfpWYMRaMUyTU=";

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
