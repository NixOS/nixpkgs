{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "shadowsocks-rust";
    tag = "v${version}";
    hash = "sha256-lCm/Y0R4/Ti4Eq06/za4D2YanwQ79IkhCBK2TO9/Yfs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-//cEAeYSpsB429YaWBu+6T4dorV5OZFZuNxLgvqXxR8=";

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
    changelog = "https://github.com/shadowsocks/shadowsocks-rust/raw/v${version}/debian/changelog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
