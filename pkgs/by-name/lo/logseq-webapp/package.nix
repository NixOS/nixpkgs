{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "logseq-webapp";
  version = "0.10.9";

  src = fetchzip {
    url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-linux-x64-${version}.zip";
    hash = "sha256-Ebvue4MWMWdFQt4S5dc9U0vTVUKa+0a+4dE1eC2l6nQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r resources/app/. $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };
}
