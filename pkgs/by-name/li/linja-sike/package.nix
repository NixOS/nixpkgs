{ lib, fetchurl }:

fetchurl {
  pname = "linja-sike";
  version = "5.0";

  url = "https://wyub.github.io/tokipona/linja-sike-5.otf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/opentype/linja-sike.otf
  '';

  sha256 = "sha256-LkjG1Oao/LqKwI+eRZPzShTh7lz5DkooltXm7vxZC9w=";

  meta = {
    description = "Extensive sitelen pona font by lipamanka";
    homepage = "https://docs.google.com/document/d/1d8kUIAVlB-JNgK3LWr_zVCuUOZTh2hF7CfC6xQgxsBs/edit?usp=sharing";
    downloadPage = "https://wyub.github.io/tokipona/linjasike";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ somasis ];
  };
}
