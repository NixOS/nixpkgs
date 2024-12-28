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
, darwin
, enableOpenvpn ? true
, openvpn-mullvad
, shadowsocks-rust
, installShellFiles
, writeShellScriptBin
}:
let
  # NOTE(cole-h): This is necessary because wireguard-go-rs executes go in its build.rs (whose goal
  # is to  produce $OUT_DIR/libwg.a), and a mixed Rust-Go build is non-trivial (read: I didn't want
  # to attempt it). So, we just fake the "go" binary and do what it would have done: put libwg.a
  # under $OUT_DIR so that it can be linked against.
  fakeGoCopyLibwg = writeShellScriptBin "go" ''
    [ ! -e "$OUT_DIR"/libwg.a ] && cp ${libwg}/lib/libwg.a "$OUT_DIR"/libwg.a
  '';
in
rustPlatform.buildRustPackage rec {
  pname = "mullvad";
  version = "2024.8";

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "mullvadvpn-app";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-mDQRIlu1wslgLhYlH87i9yntfPwTd7UQK2c6IoHuIqU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HCW2brAQK20oJIFKrdqHqRmihnKnxGZfyt5T8Yrt1z8=";

  checkFlags = "--skip=version_check";

  nativeBuildInputs = [
    pkg-config
    protobuf
    makeWrapper
    git
    installShellFiles
    fakeGoCopyLibwg
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      dbus.dev
      libnftnl
      libmnl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.libpcap
    ];

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
