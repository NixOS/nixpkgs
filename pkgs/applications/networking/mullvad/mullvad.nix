{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
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
  version = "2024.1";

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "mullvadvpn-app";
    rev = version;
    hash = "sha256-syIBYZe+e6i5A6Te51eNKcwwycnRhO1o2tP+z81NYXQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nix-0.26.1" = "sha256-b5bLeZVNbJE7aBnyzl0qvo0mXFeXa4hAZiuT1VJiFLk=";
      "udp-over-tcp-0.3.0" = "sha256-5PeaM7/zhux1UdlaKpnQ2yIdmFy1n2weV/ux9lSRha4=";
      "hickory-proto-0.24.0" = "sha256-IqGVoQ1vRruCcaDr82ARkvSo42Pe9Q6iJIWnSd6GqEg=";
    };
  };

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
    dest=build/lib/${stdenv.hostPlatform.config}
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
