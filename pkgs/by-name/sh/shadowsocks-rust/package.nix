{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shadowsocks-rust";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "shadowsocks-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BS6tc/ac7zewfzYvGWf+OkYjNjBwOWYTumVtQpjWHdg=";
  };

  cargoPatches = [
    # TODO: remove once this is merged upstream and released
    # https://github.com/shadowsocks/shadowsocks-rust/pull/2203
    ./update-webpki-roots.patch
  ];

  cargoHash = "sha256-Lwc/TYs4cfN3W/Wc74lL0nqD6LCbwDWfMnPyhiXoR+k=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  buildFeatures = [
    "trust-dns"
    "local-tunnel"
    "local-socks4"
    "local-redir"
    "local-dns"
    "local-tun"
    "aead-cipher-extra"
    "aead-cipher-2022"
    "aead-cipher-2022-extra"
  ];

  # all of these rely on connecting to www.example.com:80
  checkFlags = [
    "--skip=http_proxy"
    "--skip=tcp_tunnel"
    "--skip=tcprelay"
    "--skip=udp_tunnel"
    "--skip=udp_relay"
    "--skip=socks4_relay_connect"
    "--skip=socks5_relay_aead"
    "--skip=socks5_relay_stream"
    "--skip=trust_dns_resolver"
  ];

  # timeouts in sandbox
  doCheck = false;

  meta = {
    description = "Rust port of Shadowsocks";
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    changelog = "https://github.com/shadowsocks/shadowsocks-rust/raw/v${finalAttrs.version}/debian/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ enovamaker ];
  };
})
