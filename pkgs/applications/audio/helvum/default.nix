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
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = pname;
    rev = version;
    hash = "sha256-TvjO7fGobGmAltVHeXWyMtMLANdVWVGvBYq20JD3mMI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-W5Imlut30cjV4A6TCjBFLbViB0CDUucNsvIUiCXqu7I=";
  };

  nativeBuildInputs = [
    clang
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    desktop-file-utils
    glib
    gtk4
    pipewire
  ];

  meta = with lib; {
    description = "A GTK patchbay for pipewire";
    homepage = "https://gitlab.freedesktop.org/pipewire/helvum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
}
