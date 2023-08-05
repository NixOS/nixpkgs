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
  version = "4.6.2";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    rev = version;
    hash = "sha256-qfl8MUSHjqlSnsaudoRD9fY5TM9zgy7L7DA+pctn/nc=";
  };

  cargoHash = "";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecolor-0.21.0" = "sha256-m7eHX6flwO21umtx3dnIuVUnNsEs3ZCyOk5Vvp/lVfI=";
      "notify-rust-4.6.0" = "sha256-jhCgisA9f6AI9e9JQUYRtEt47gQnDv5WsdRKFoKvHJs=";
      "supergfxctl-5.1.1" = "sha256-AThaZ9dp5T/DtLPE6gZ9qgkw0xksiq+VCL9Y4G41voE=";
    };
  };

  postPatch = ''
    files="
      daemon-user/src/daemon.rs
      daemon-user/src/config.rs
      rog-control-center/src/main.rs
      rog-aura/src/aura_detection.rs
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
