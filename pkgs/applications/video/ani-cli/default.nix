{ fetchFromGitHub
, makeWrapper
, stdenvNoCC
, lib
, gnugrep
, gnused
, gawk
, ffmpeg
, curl
, openssl
, mpv
, aria2
}:

stdenvNoCC.mkDerivation rec {
  pname = "ani-cli";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ani-cli";
    rev = "v${version}";
    sha256 = "LSyqcJX+bPW/qtO3FaZh9RaXW2xeGc/9tdC2CmhDwUw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./bin/ani-cli $out/bin/ani-cli

    mv ./lib $out/

    wrapProgram $out/bin/ani-cli \
      --prefix PATH : ${lib.makeBinPath [ gnugrep gnused curl openssl mpv aria2 gawk ffmpeg ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pystardust/ani-cli";
    description = "A cli tool to browse and play anime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ skykanin ];
    platforms = platforms.unix;
  };
}
