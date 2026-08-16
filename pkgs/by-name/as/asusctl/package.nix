{
  lib,
  rustPlatform,
  fetchFromGitHub,
  systemd,
  coreutils,
  gnugrep,
  pkg-config,
  fontconfig,
  libGL,
  libinput,
  libxkbcommon,
  libgbm,
  seatd,
  wayland,
  glibc,
  udevCheckHook,
  gettext,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asusctl";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "OpenGamingCollective";
    repo = "asusctl";
    tag = finalAttrs.version;
    hash = "sha256-qLdOdZaQm3t7LhvoCCo/FwZo4O7Z9aP1KPPlERgZX00=";
  };

  cargoHash = "sha256-sAJ4el6URZXHD2NWiWpJSBf8Qeq2v/y+F9KpMCc8BbE=";

  postPatch = ''
    files="
      asusd-user/src/config.rs
      asusd-user/src/daemon.rs
      asusd/src/aura_anime/config.rs
      rog-aura/src/aura_detection.rs
      rog-control-center/src/lib.rs
      rog-control-center/src/main.rs
      rog-control-center/src/tray.rs
    "
    for file in $files; do
      substituteInPlace $file --replace-fail /usr/share $out/share
    done

    substituteInPlace rog-control-center/src/main.rs \
      --replace-fail 'std::env::var("RUST_TRANSLATIONS").is_ok()' 'true'

    substituteInPlace data/asusd.service \
      --replace-fail /usr/bin/asusd $out/bin/asusd \
      --replace-fail /bin/sleep ${lib.getExe' coreutils "sleep"}

    substituteInPlace data/asus-shutdown.service \
      --replace-fail /usr/bin/asus-shutdown $out/bin/asus-shutdown

    substituteInPlace Makefile \
      --replace-fail /usr/bin/grep ${lib.getExe gnugrep}
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    udevCheckHook
    gettext
  ];

  buildInputs = [
    fontconfig
    libGL
    libinput
    libxkbcommon
    libgbm
    seatd
    systemd
    wayland
  ];

  env = {
    # force linking to all the dlopen()ed dependencies
    RUSTFLAGS = toString (
      map (a: "-C link-arg=${a}") [
        "-Wl,--push-state,--no-as-needed"
        "-lEGL"
        "-lfontconfig"
        "-lwayland-client"
        "-Wl,--pop-state"
      ]
    );
  };

  # upstream has minimal tests, so don't rebuild twice
  doCheck = false;
  doInstallCheck = true;

  postInstall = ''
    make prefix=$out install-data

    patchelf $out/bin/rog-control-center \
      --add-needed ${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0
  '';

  meta = {
    description = "Control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops";
    homepage = "https://github.com/OpenGamingCollective/asusctl";
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      k900
      aacebedo
      yuannan
      luytan
    ];
  };
})
