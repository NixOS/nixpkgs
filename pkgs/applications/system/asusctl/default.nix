{ lib
, rustPlatform
, fetchFromGitLab
, e2fsprogs
, systemd
, coreutils
, pkg-config
, cmake
, fontconfig
, gtk3
, libappindicator
}:

rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "4.6.0";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    rev = version;
    hash = "sha256-QXRUi/CiJTG04Kv/p3PWVloPIguLyfFQoiY6tCQIF/M=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecolor-0.20.0" = "sha256-tnjFkaCWmCPGw3huQN9VOAeiH+zk3Zk9xYoRKmg2WQg=";
      "notify-rust-4.6.0" = "sha256-jhCgisA9f6AI9e9JQUYRtEt47gQnDv5WsdRKFoKvHJs=";
      "supergfxctl-5.0.2" = "sha256-oyOi6DLMtShY0V81l96zii1ibYCueNgHle+FGHmNv+M=";
    };
  };

  patches = [
    # drop after release > 4.6.0, it was merged
    ./2bd751f841-Makefile-split-install.patch
  ];

  postPatch = ''
    files="
      rog-aura/src/aura_detection.rs
      rog-control-center/src/main.rs
      daemon/src/ctrl_anime/config.rs
      daemon-user/src/daemon.rs
      daemon-user/src/config.rs
    "
    for file in $files; do
      substituteInPlace $file --replace /usr/share $out/share
    done

    substituteInPlace daemon/src/ctrl_platform.rs --replace /usr/bin/chattr ${e2fsprogs}/bin/chattr

    substituteInPlace data/asusd.rules --replace systemctl ${systemd}/bin/systemctl
    substituteInPlace data/asusd.service \
      --replace /usr/bin/asusd $out/bin/asusd \
      --replace /bin/sleep ${coreutils}/bin/sleep
    substituteInPlace data/asusd-user.service \
      --replace /usr/bin/asusd-user $out/bin/asusd-user \
      --replace /usr/bin/sleep ${coreutils}/bin/sleep
  '';

  nativeBuildInputs = [ pkg-config cmake rustPlatform.bindgenHook ];

  buildInputs = [ systemd fontconfig gtk3 ];

  # upstream has minimal tests, so don't rebuild twice
  doCheck = false;

  postInstall = ''
    make prefix=$out install-data
  '';

  postFixup = ''
    patchelf --add-rpath "${libappindicator}/lib" "$out/bin/rog-control-center"
  '';

  meta = with lib; {
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops";
    homepage = "https://gitlab.com/asus-linux/asusctl";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ k900 aacebedo ];
  };
}
