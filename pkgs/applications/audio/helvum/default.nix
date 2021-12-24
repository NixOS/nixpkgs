{ lib
, clang
, desktop-file-utils
, fetchFromGitLab
, fetchpatch
, glib
, gtk4
, libclang
, meson
, ninja
, pipewire
, pkg-config
, rustPlatform
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "helvum";
  version = "0.3.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "ryuukyu";
    repo = pname;
    rev = version;
    sha256 = "sha256-Kt6gnMRTOVXqjAjEZKlylcGhzl52ZzPNVbJhwzLhzkM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kxJRY9GSPwnb431iYCfJdGcl5HjpFr2KkWrFDpGajp8=";
  };

  nativeBuildInputs = [
    clang
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ];

  buildInputs = [
    desktop-file-utils
    glib
    gtk4
    pipewire
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  patches = [
    # enables us to use gtk4-update-icon-cache instead of gtk3 one
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/ryuukyu/helvum/-/merge_requests/24.patch";
      sha256 = "sha256-WmI6taBL/6t587j06n0mwByQ8x0eUA5ECvGNjg2/vtk=";
    })
  ];

  postPatch = ''
    patchShebangs build-aux/cargo.sh
  '';

  meta = with lib; {
    description = "A GTK patchbay for pipewire";
    homepage = "https://gitlab.freedesktop.org/ryuukyu/helvum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
}
