{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "dq";
  version = "20241027";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "dq";
    rev = "refs/tags/${version}";
    hash = "sha256-aXNj2JsSCxp3+zTF2/7SAffrzwQH+3NCppxpnPCLT4o=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 dq dqcache dqcache-makekey dqcache-start -t $out/bin
    installManPage man/*

    runHook postInstall
  '';

  meta = with lib; {
    description = "Recursive DNS/DNSCurve server and comandline tool";
    homepage = "https://github.com/janmojzis/dq";
    changelog = "https://github.com/janmojzis/dq/releases/tag/${version}";
    license = licenses.cc0;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
