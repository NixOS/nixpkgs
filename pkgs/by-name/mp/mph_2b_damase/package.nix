{ stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "mph-2b-damase";
  version = "2";

  src = fetchzip {
    url = "https://web.archive.org/web/20160322114946/http://www.wazu.jp/downloads/damase_v.2.zip";
    hash = "sha256-4x78D+c3ZBxfhTQQ4+gyxvrsuztHF2ItXLh4uA0PxvU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = { };
}
