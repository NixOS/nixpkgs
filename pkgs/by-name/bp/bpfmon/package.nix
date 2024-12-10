{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  yascreen,
}:

stdenv.mkDerivation rec {
  pname = "bpfmon";
  version = "2.53";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "bpfmon";
    rev = "refs/tags/v${version}";
    hash = "sha256-+W+3RLvgXXtUImzLkJr9mSWExvAUgjMp+lR9sg14VaY=";
  };

  buildInputs = [
    libpcap
    yascreen
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "BPF based visual packet rate monitor";
    mainProgram = "bpfmon";
    homepage = "https://github.com/bbonev/bpfmon";
    changelog = "https://github.com/bbonev/bpfmon/releases/tag/v${version}";
    maintainers = with maintainers; [ arezvov ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
