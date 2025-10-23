# Getdns and Stubby are released together, see https://getdnsapi.net/releases/
# ../../ge/getdns/package.nix

{
  lib,
  stdenv,
  cmake,
  getdns,
  libyaml,
  openssl,
  systemd,
  yq,
  stubby,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stubby";
  version = "0.4.3";
  outputs = [
    "out"
    "man"
    "stubbyExampleJson"
  ];

  inherit (getdns) src;
  sourceRoot = "${getdns.pname}-${getdns.version}/stubby";

  nativeBuildInputs = [
    cmake
    yq
  ];

  buildInputs = [
    getdns
    libyaml
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ systemd ];

  postInstall = ''
    rm -r $out/share/doc
    yq \
      < $NIX_BUILD_TOP/$sourceRoot/stubby.yml.example \
      > $stubbyExampleJson
  '';

  passthru.settingsExample = builtins.fromJSON (builtins.readFile stubby.stubbyExampleJson);

  meta = getdns.meta // {
    description = "Local DNS Privacy stub resolver (using DNS-over-TLS)";
    mainProgram = "stubby";
    longDescription = ''
      Stubby is an application that acts as a local DNS Privacy stub
      resolver (using RFC 7858, aka DNS-over-TLS). Stubby encrypts DNS
      queries sent from a client machine (desktop or laptop) to a DNS
      Privacy resolver increasing end user privacy. Stubby is developed by
      the getdns team.
    '';
    homepage = "https://dnsprivacy.org/dns_privacy_daemon_-_stubby/";
  };
})
