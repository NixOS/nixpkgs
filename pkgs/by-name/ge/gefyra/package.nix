{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  docker,
  kubectl,
}:

stdenv.mkDerivation rec {
  pname = "gefyra";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "gefyrahq";
    repo = "gefyra";
    rev = version;
    sha256 = "sha256-piF/h2g9NeLbSVC5YjfcN1Hq+LWXe+Ib3LolA/vOZdw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 gefyra "$out/bin/gefyra"
    wrapProgram $out/bin/gefyra \
      --prefix PATH : ${
        lib.makeBinPath [
          docker
          kubectl
        ]
      }
    runHook postInstall
  '';

  meta = {
    description = "Tool to connect local containers to kubernetes clusters";
    homepage = "https://gefyra.dev";
    downloadPage = "https://github.com/gefyrahq/gefyra";
    mainProgram = "gefyra";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tobifroe ];
    platforms = lib.platforms.linux;
  };
}
