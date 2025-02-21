{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libpcap,
  gitUpdater,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "softflowd";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "irino";
    repo = "softflowd";
    tag = "softflowd-v${finalAttrs.version}";
    hash = "sha256-yeLVRkdNNvq072b7lMX3sE72uAxEvErM1VnuPqvwEdU=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libpcap
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "softflowd-v"; };

  meta = {
    description = "Flow-based network traffic analyser capable of Cisco NetFlow";
    homepage = "https://github.com/irino/softflowd";
    changelog = "https://github.com/irino/softflowd/releases/tag/spftflowd-v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fooker ];
    platforms = lib.platforms.unix;
  };
})
