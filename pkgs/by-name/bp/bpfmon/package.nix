{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  yascreen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bpfmon";
  version = "2.60";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "bpfmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VJmDFLffD/uPZnXQGNnQg0+NkvqbnVulpg2ve4VVhpc=";
  };

  buildInputs = [
    libpcap
    yascreen
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "BPF based visual packet rate monitor";
    mainProgram = "bpfmon";
    homepage = "https://github.com/bbonev/bpfmon";
    changelog = "https://github.com/bbonev/bpfmon/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ arezvov ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
