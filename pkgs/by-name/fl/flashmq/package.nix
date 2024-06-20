{ lib, stdenv, fetchFromGitHub, cmake, installShellFiles, openssl }:

stdenv.mkDerivation rec {
  pname = "flashmq";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "halfgaar";
    repo = "FlashMQ";
    rev = "v${version}";
    hash = "sha256-6ShMYTynqIVm7EH3b9Jzy5UKE7SH/Lq5uWV3VaDVREQ=";
  };

  nativeBuildInputs = [ cmake installShellFiles ];

  buildInputs = [ openssl ];

  installPhase = ''
    runHook preInstall

    install -Dm755 flashmq -t $out/bin
    installManPage $src/man/*.{1,5}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast light-weight MQTT broker/server";
    mainProgram = "flashmq";
    homepage = "https://www.flashmq.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
