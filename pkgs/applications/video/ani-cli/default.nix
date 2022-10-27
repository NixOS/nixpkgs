{ fetchFromGitHub
, makeWrapper
, stdenvNoCC
, lib
, gnugrep
, gnused
, curl
, openssl
, mpv
, aria2
}:

stdenvNoCC.mkDerivation rec {
  pname = "ani-cli";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ani-cli";
    rev = "v${version}";
    sha256 = "sha256-Xb7MNL7YKbvyRR5ZppUfCYeYpjNAiJWNOjIFk5fUvpY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ani-cli $out/bin/ani-cli

    wrapProgram $out/bin/ani-cli \
      --prefix PATH : ${lib.makeBinPath [ gnugrep gnused curl openssl mpv aria2 ]}

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
