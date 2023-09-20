{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, imagemagick
}:

stdenv.mkDerivation rec {
  pname = "tiv";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "stefanhaustein";
    repo = "TerminalImageViewer";
    rev = "v${version}";
    sha256 = "sha256-mCgybL4af19zqECN1pBV+WnxMq2ZtlK5GDTQO3u9CK0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ imagemagick ];

  makeFlags = [ "prefix=$(out)" ];

  preConfigure = "cd src/main/cpp";

  postFixup = ''
    wrapProgram $out/bin/tiv \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/stefanhaustein/TerminalImageViewer";
    description = "Small C++ program to display images in a (modern) terminal using RGB ANSI codes and unicode block graphics characters";
    license = licenses.asl20;
    maintainers = with maintainers; [ magnetophon ];
    platforms = [ "x86_64-linux" ];
  };
}
