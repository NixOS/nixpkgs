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
  version = "4.5.6";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    rev = version;
    hash = "sha256-9WEP+/BI5fh3IhVsLSPrnkiZ3DmXwTFaPXyzBNs7cNM=";
  };

  cargoSha256 = "sha256-iXMor2hI8Q/tpdSCaUjiEsvVfmWKXI6Az0J6aqMwE2E=";

  postPatch = ''
    files="
      daemon/src/config.rs
      daemon/src/ctrl_anime/config.rs
      daemon-user/src/daemon.rs
      daemon-user/src/ctrl_anime.rs
      daemon-user/src/user_config.rs
      rog-control-center/src/main.rs
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

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ systemd fontconfig gtk3 ];

  # upstream has minimal tests, so don't rebuild twice
  doCheck = false;

  postInstall = ''
    install -Dm444 -t $out/share/dbus-1/system.d/ data/asusd.conf
    install -Dm444 -t $out/share/rog-gui/layouts/ rog-aura/data/layouts/*

    install -Dm444 -t $out/share/applications/ rog-control-center/data/rog-control-center.desktop
    install -Dm444 -t $out/share/icons/hicolor/512x512/apps/ rog-control-center/data/rog-control-center.png data/icons/asus_notif_*
    install -Dm444 -t $out/share/icons/hicolor/scalable/status/ data/icons/scalable/*

    install -Dm444 -t $out/share/asusd/anime/asus/rog/ rog-anime/data/anime/asus/rog/Sunset.gif
    install -Dm444 -t $out/share/asusd/anime/asus/gaming/ rog-anime/data/anime/asus/gaming/Controller.gif
    install -Dm444 -t $out/share/asusd/anime/custom/ rog-anime/data/anime/custom/*

    install -Dm444 -t $out/share/asusd/data/ data/asusd-ledmodes.toml

    install -Dm444 data/asusd.rules $out/lib/udev/rules.d/99-asusd.rules
    install -Dm444 -t $out/share/dbus-1/system.d/ data/asusd.conf
    install -Dm444 -t $out/lib/systemd/system/ data/asusd.service
    install -Dm444 -t $out/lib/systemd/user/ data/asusd-user.service
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
