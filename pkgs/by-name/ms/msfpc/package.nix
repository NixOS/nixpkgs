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

stdenv.mkDerivation (finalAttrs: {
  pname = "msfpc";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "g0tmi1k";
    repo = "msfpc";
    rev = "v${finalAttrs.version}";
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

  meta = {
    description = "MSFvenom Payload Creator";
    mainProgram = "msfpc";
    homepage = "https://github.com/g0tmi1k/msfpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
  };
})
