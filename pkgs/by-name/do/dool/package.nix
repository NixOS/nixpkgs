{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "dool";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "scottchiefbaker";
    repo = "dool";
    rev = "v${version}";
    hash = "sha256-4q57MIQBnXm1zfOXQyIec/T9HWDtX7nZWYMJa4YkSS8=";
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
