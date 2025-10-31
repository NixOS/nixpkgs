{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  installShellFiles,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashmq";
  version = "1.23.2";

  src = fetchFromGitHub {
    owner = "halfgaar";
    repo = "FlashMQ";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v/gc9YVIBTQP8/wnYKucBQci/8oz+Xo9BTorAV6Jxqs=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
  ];

  buildInputs = [ openssl ];

  installPhase = ''
    runHook preInstall

    install -Dm755 flashmq -t $out/bin
    installManPage $src/man/*.{1,5}

    runHook postInstall
  '';

  meta = {
    description = "Fast light-weight MQTT broker/server";
    mainProgram = "flashmq";
    homepage = "https://www.flashmq.org/";
    license = lib.licenses.osl3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
  };
})
