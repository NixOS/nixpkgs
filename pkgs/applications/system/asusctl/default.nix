{ lib
, rustPlatform
, fetchFromGitLab
, systemd
, coreutils
, pkg-config
, cmake
, fontconfig
, gtk3
, libappindicator
, libGL
}:

rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "5.0.2";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    rev = version;
    hash = "sha256-0+HCqp/mn+O6Cnbmma7iw5EFBbLozvnkqGA378oj0G8=";
  };

  cargoHash = "";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecolor-0.21.0" = "sha256-m7eHX6flwO21umtx3dnIuVUnNsEs3ZCyOk5Vvp/lVfI=";
      "notify-rust-4.6.0" = "sha256-jhCgisA9f6AI9e9JQUYRtEt47gQnDv5WsdRKFoKvHJs=";
      "supergfxctl-5.1.2" = "sha256-HJGyjFeN3bq+ArCGfFHAMnjW76wSnNyxPWR0ELcyjLg=";
    };
  };

  postPatch = ''
    files="
      asusd-user/src/config.rs
      asusd-user/src/daemon.rs
      asusd/src/ctrl_anime/config.rs
      rog-aura/src/aura_detection.rs
      rog-control-center/src/main.rs
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
  '';

  nativeBuildInputs = [ pkg-config cmake rustPlatform.bindgenHook ];

  buildInputs = [ systemd fontconfig gtk3 ];

  # upstream has minimal tests, so don't rebuild twice
  doCheck = false;

  postInstall = ''
    make prefix=$out install-data
  '';

  postFixup = ''
    patchelf --add-rpath "${libappindicator}/lib:${libGL}/lib" "$out/bin/rog-control-center"
  '';

  meta = with lib; {
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops";
    homepage = "https://gitlab.com/asus-linux/asusctl";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ k900 aacebedo ];
  };
}
