{
  fetchFromGitHub,
  lib,
  libnl,
  libpcap,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nmrpflash";
  version = "0.9.26";

  src = fetchFromGitHub {
    owner = "jclehner";
    repo = "nmrpflash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I+6bZtiwR1DbZ8ykIBVBqo1LdQftUaU301aMh01StqU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libnl
    libpcap
  ];

  PREFIX = "${placeholder "out"}";
  STANDALONE_VERSION = finalAttrs.version;

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Netgear Unbrick Utility";
    homepage = "https://github.com/jclehner/nmrpflash";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ dadada ];
    mainProgram = "nmrpflash";
    platforms = lib.platforms.unix;
  };
})
