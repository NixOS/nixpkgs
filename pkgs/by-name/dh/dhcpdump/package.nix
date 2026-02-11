{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  installShellFiles,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dhcpdump";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "dhcpdump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ck6DLsLQ00unNqPLBKkxaJLDCaPFjTFJcQjTbKSq0U8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    perl # pod2man
    installShellFiles
  ];

  buildInputs = [
    libpcap
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 dhcpdump "$out/bin/dhcpdump"
    installManPage dhcpdump.8

    runHook postInstall
  '';

  meta = {
    description = "Tool for visualization of DHCP packets as recorded and output by tcpdump to analyze DHCP server responses";
    homepage = "https://github.com/bbonev/dhcpdump";
    changelog = "https://github.com/bbonev/dhcpdump/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nickcao ];
    license = lib.licenses.bsd2;
    mainProgram = "dhcpdump";
  };
})
