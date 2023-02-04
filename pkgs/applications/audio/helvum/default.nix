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
  version = "0.3.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = pname;
    rev = version;
    sha256 = "0nhv6zw2zzxz2bg2zj32w1brywnm5lv6j3cvmmvwshc389z2k5x1";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-EIHO9qVPIXgezfFOaarlTU0an762nFmX1ELbQuAZ7rY";
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

  # FIXME: workaround for Pipewire 0.3.64 deprecated API change, remove when fixed upstream
  NIX_CFLAGS_COMPILE = [ "-DPW_ENABLE_DEPRECATED" ];

  meta = with lib; {
    description = "A GTK patchbay for pipewire";
    homepage = "https://gitlab.freedesktop.org/pipewire/helvum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
}
