{ lib
, rustPlatform
, fetchFromGitLab
, systemd
, coreutils
, gnugrep
, pkg-config
, fontconfig
, libGL
, libinput
, libxkbcommon
, mesa
, seatd
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "6.0.6";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    rev = version;
    hash = "sha256-to2HJAqU3+xl6Wt90GH7RA7079v1QyP+AE0pL/9rd/M=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "const-field-offset-0.1.5" = "sha256-53pT9ERsmF4lM9tVG09hgbM0zfbTp1qSM+NDyFQxe3c=";
      "notify-rust-4.7.0" = "sha256-A7edUorty5GpGXCUQPszZuXtLdEmbmrDSU9JcoDaiaI=";
      "supergfxctl-5.2.2" = "sha256-hg1QJ7DLtn5oH6IqQu7BcWIsZKAsFy6jjsjF/2o1Cos=";
    };
  };

  postPatch = ''
    files="
      asusd-user/src/config.rs
      asusd-user/src/daemon.rs
      asusd/src/ctrl_anime/config.rs
      rog-aura/src/aura_detection.rs
      rog-control-center/src/lib.rs
      rog-control-center/src/main.rs
      rog-control-center/src/tray.rs
    "
    for file in $files; do
      substituteInPlace $file --replace /usr/share $out/share
    done

    substituteInPlace data/asusd.rules --replace systemctl ${systemd}/bin/systemctl
    substituteInPlace data/asusd.service \
      --replace /usr/bin/asusd $out/bin/asusd \
      --replace /bin/sleep ${coreutils}/bin/sleep
    substituteInPlace data/asusd-user.service \
      --replace /usr/bin/asusd-user $out/bin/asusd-user \
      --replace /usr/bin/sleep ${coreutils}/bin/sleep

    substituteInPlace Makefile \
      --replace /usr/bin/grep ${lib.getExe gnugrep}
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    libGL
    libinput
    libxkbcommon
    mesa
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
  '';

  meta = with lib; {
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops";
    homepage = "https://gitlab.com/asus-linux/asusctl";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ k900 aacebedo ];
  };
}
