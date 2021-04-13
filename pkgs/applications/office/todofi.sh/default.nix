{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, gawk
, gnugrep
, gnused
, rofi
, todo-txt-cli
}:

stdenv.mkDerivation rec {
  pname = "todofi.sh";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hugokernel";
    repo = "todofi.sh";
    rev = "v${version}";
    sha256 = "1gmy5inlghycsxiwnyyjyv81jn2fmfk3s9x78kcgyf7khzb5kwvj";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm 755 todofi.sh -t $out/bin
  '';

  wrapperPath = with lib; makeBinPath [
    coreutils
    gawk
    gnugrep
    gnused
    rofi
    todo-txt-cli
  ];

  fixupPhase = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/todofi.sh --prefix PATH : "${wrapperPath}"
  '';

  meta = with lib; {
    description = "Todo-txt + Rofi = Todofi.sh";
    homepage = "https://github.com/hugokernel/todofi.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ ewok ];
    platforms = platforms.linux;
  };
}
