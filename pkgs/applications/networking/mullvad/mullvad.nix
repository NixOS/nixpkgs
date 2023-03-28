{ lib
, stdenv
, writeText
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, protobuf
, makeWrapper
, git
, dbus
, libnftnl
, libmnl
, libwg
, enableOpenvpn ? true
, openvpn-mullvad
, shadowsocks-rust
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "mullvad";
  version = "2023.2";

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "mullvadvpn-app";
    rev = version;
    hash = "sha256-UozgUsew6MRplahTW/y688R2VetO50UGQevmVo8/QNs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "udp-over-tcp-0.2.0" = "sha256-h44xrmRAlfy1Br0PAtZAzOwSMptaUatjXysA/l2Kff8=";
    };
  };

  patches = [
    # https://github.com/mullvad/mullvadvpn-app/pull/4389
    # can be removed after next release
    (fetchpatch {
      name = "mullvad-version-dont-check-git.patch";
      url = "https://github.com/mullvad/mullvadvpn-app/commit/8062cc74fc94bbe073189e78328901606c859d41.patch";
      hash = "sha256-1BhCId0J1dxhPM3oOmhZB+07N+k1GlvAT1h6ayfx174=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    makeWrapper
    git
    installShellFiles
  ];

  buildInputs = [
    dbus.dev
    libnftnl
    libmnl
  ];

  # talpid-core wants libwg.a in build/lib/{triple}
  preBuild = ''
    dest=build/lib/${stdenv.targetPlatform.config}
    mkdir -p $dest
    ln -s ${libwg}/lib/libwg.a $dest
  '';

  postInstall = ''
    compdir=$(mktemp -d)
    for shell in bash zsh fish; do
      $out/bin/mullvad shell-completions $shell $compdir
    done
    installShellCompletion --cmd mullvad \
      --bash $compdir/mullvad.bash \
      --zsh $compdir/_mullvad \
      --fish $compdir/mullvad.fish
  '';

  postFixup =
    # Place all binaries in the 'mullvad-' namespace, even though these
    # specific binaries aren't used in the lifetime of the program.
    ''
      for bin in relay_list translations-converter tunnel-obfuscation; do
        mv "$out/bin/$bin" "$out/bin/mullvad-$bin"
      done
    '' +
    # Files necessary for OpenVPN tunnels to work.
    lib.optionalString enableOpenvpn ''
      mkdir -p $out/share/mullvad
      cp dist-assets/ca.crt $out/share/mullvad
      ln -s ${openvpn-mullvad}/bin/openvpn $out/share/mullvad
      ln -s ${shadowsocks-rust}/bin/sslocal $out/share/mullvad
      ln -s $out/lib/libtalpid_openvpn_plugin.so $out/share/mullvad
    '' +
    # Set the directory where Mullvad will look for its resources by default to
    # `$out/share`, so that we can avoid putting the files in `$out/bin` --
    # Mullvad defaults to looking inside the directory its binary is located in
    # for its resources.
    ''
      wrapProgram $out/bin/mullvad-daemon \
        --set-default MULLVAD_RESOURCE_DIR "$out/share/mullvad"
    '';

  passthru = {
    inherit libwg;
    inherit openvpn-mullvad;
  };

  meta = with lib; {
    description = "Mullvad VPN command-line client tools";
    homepage = "https://github.com/mullvad/mullvadvpn-app";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cole-h ];
  };
}
