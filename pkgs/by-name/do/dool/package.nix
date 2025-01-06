{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "dool";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "scottchiefbaker";
    repo = "dool";
    rev = "v${version}";
    hash = "sha256-VII8Om43YILP3w0CsiKKdJDuK2Lc1rit2EY+eAArvng=";
  };

  buildInputs = [
    python3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  # fix the plugins directory
  postPatch = ''
    substituteInPlace dool \
      --replace-fail \
        "os.path.dirname(os.path.abspath(__file__)) + '/plugins/'" \
        "'$out/share/dool/'"
  '';

  meta = with lib; {
    description = "Python3 compatible clone of dstat";
    homepage = "https://github.com/scottchiefbaker/dool";
    changelog = "https://github.com/scottchiefbaker/dool/blob/${src.rev}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
    mainProgram = "dool";
  };
}
