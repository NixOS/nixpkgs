{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diswall";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "dis-works";
    repo = "diswall-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5kKVEdzN38gyovGAg3/FE5sbSwCBEiQH1GPsDeQ+rCg=";
  };

  cargoHash = "sha256-WXaNLlTbZc2On19azFUbcsx0fA2LpsNNWxO6BzJ469M=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  doCheck = false;

  meta = {
    description = "Distributed firewall";
    longDescription = ''
      Diswall (distributed firewall) - a client of distributed firewall
      working on many servers and using NATS for the transport level.
      Its purpose - blocking IPs with a blink of the eye on all servers
      in any infrastructure when some IP checks any of the closed ports
      of anyone of these servers. Therefore, diswall provides good
      protection of whole infrastructure (as anti-shodan) preventing
      intruder to get any system information.
    '';
    homepage = "https://www.diswall.stream";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ izorkin ];
    mainProgram = "diswall";
  };
})
