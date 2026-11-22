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
  version = "1.27.3";

  src = fetchFromGitHub {
    owner = "halfgaar";
    repo = "FlashMQ";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C2q29lGLuBvmYhOFciO16bf9SCnIQhDArw/w6BfP/t8=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
  ];

  buildInputs = [ openssl ];

  installPhase = ''
    runHook preInstall

    installBin flashmq
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
