{
  lib,
  rustPlatform,
  fetchFromGitLab,
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
}:
rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "6.1.12";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    tag = version;
    hash = "sha256-E/tDd7wQKDgC91x1rGa8Ltn4GMPk3DJDvmMQNafVLyM=";
  };

  cargoHash = "sha256-lvm3xvI01RyaSS39nm3l7Zpn3x23DDBQr+0Gggl4p9U=";

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

    substituteInPlace data/asusd.rules --replace-fail systemctl ${lib.getExe' systemd "systemctl"}
    substituteInPlace data/asusd.service \
      --replace-fail /usr/bin/asusd $out/bin/asusd \
      --replace-fail /bin/sleep ${lib.getExe' coreutils "sleep"}
    substituteInPlace data/asusd-user.service \
      --replace-fail /usr/bin/asusd-user $out/bin/asusd-user \
      --replace-fail /usr/bin/sleep ${lib.getExe' coreutils "sleep"}

    substituteInPlace Makefile \
      --replace-fail /usr/bin/grep ${lib.getExe gnugrep}

    substituteInPlace /build/asusctl-${version}-vendor/sg-0.4.0/build.rs \
      --replace-fail /usr/include ${lib.getDev glibc}/include
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    udevCheckHook
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

  # force linking to all the dlopen()ed dependencies
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lfontconfig"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  # upstream has minimal tests, so don't rebuild twice
  doCheck = false;
  doInstallCheck = true;

  postInstall = ''
    make prefix=$out install-data

    patchelf $out/bin/rog-control-center \
      --add-needed ${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0
  '';

  meta = with lib; {
    description = "Control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops";
    homepage = "https://gitlab.com/asus-linux/asusctl";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      k900
      aacebedo
    ];
  };
}
