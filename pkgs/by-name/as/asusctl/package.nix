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
}:
rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "6.1.4";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    rev = version;
    hash = "sha256-t5wjfazKadpYEc29LJmnh3Zdc53wQQY2DYpj3ijZ534=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1IwGjdx2BM6kA17mgYg5+pAr6UOiIuP6//05tcjmJBM=";

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
