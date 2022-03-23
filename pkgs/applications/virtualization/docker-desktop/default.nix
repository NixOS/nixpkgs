{ fetchurl, lib, stdenvNoCC, undmg }:

let
  # https://desktop.docker.com/mac/main/amd64/appcast.xml
  # https://desktop.docker.com/mac/main/arm64/appcast.xml
  version = "4.6.1";
  buildNumber = "76265";
  sources = {
    x86_64-darwin = {
      url = "https://desktop.docker.com/mac/main/amd64/${buildNumber}/Docker.dmg";
      sha256 = "sha256-KMs3uFfDt1Guj695aBGmi2fmKfm+Scwszja8FRQsYvA=";
    };
    aarch64-darwin = {
      url = "https://desktop.docker.com/mac/main/arm64/${buildNumber}/Docker.dmg";
      sha256 = "sha256-q/gauZMB4a8OaqlmveLLMPK7arU30VpCy9SrbmpaPZ0=";
    };
  };
in stdenvNoCC.mkDerivation {
  inherit version;

  pname = "docker-desktop";

  src = fetchurl sources.${stdenvNoCC.hostPlatform.system};

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -r 'Docker.app' "$out/Applications"
    runHook postInstall
  '';

  meta = {
    description = "Docker Desktop – the fastest way to containerize applications.";
    homepage = "https://www.docker.com/products/docker-desktop/";
    license = {
      fullName = "Docker Subscription Service Agreement";
      url = "https://www.docker.com/legal/docker-software-end-user-license-agreement/";
      free = false;
    };
    maintainers = with lib.maintainers; [ steinybot ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
