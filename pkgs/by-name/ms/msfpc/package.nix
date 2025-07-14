{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  metasploit,
  curl,
  inetutils,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "msfpc";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "g0tmi1k";
    repo = "msfpc";
    rev = "v${version}";
    sha256 = "UIdE0oSaNu16pf+M96x8AnNju88hdzokv86wm8uBYDQ=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 msfpc.sh $out/bin/msfpc

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/msfpc \
      --prefix PATH : "${
        lib.makeBinPath [
          metasploit
          curl
          inetutils
          openssl
        ]
      }"
  '';

  meta = with lib; {
    description = "MSFvenom Payload Creator";
    mainProgram = "msfpc";
    homepage = "https://github.com/g0tmi1k/msfpc";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
