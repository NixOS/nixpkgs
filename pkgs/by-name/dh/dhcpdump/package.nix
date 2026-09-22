{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  pkg-config,
  installShellFiles,
  libpcap,
  yascreen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dhcpdump";
  version = "2.00";

  src = fetchFromGitHub {
    owner = "dhcpdump-org";
    repo = "dhcpdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yIrB8ALkaewRpZduKCnnrpnr+H7mHSv9wrFAQaeQ8HU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    perl # pod2man
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libpcap
    yascreen
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 dhcpdump "$out/bin/dhcpdump"
    installManPage dhcpdump.8

    runHook postInstall
  '';

  meta = {
    description = "Tool for visualization of DHCP packets as recorded and output by tcpdump to analyze DHCP server responses";
    homepage = "https://github.com/dhcpdump-org/dhcpdump";
    changelog = "https://github.com/dhcpdump-org/dhcpdump/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
    license = lib.licenses.bsd2;
    mainProgram = "dhcpdump";
  };
})
