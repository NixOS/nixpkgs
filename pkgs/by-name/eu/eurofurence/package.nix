{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "eurofurence";
  version = "2000-04-21";

  srcs =
    map
      (
        { url, hash }:
        fetchzip {
          name = builtins.baseNameOf url;
          stripRoot = false;
          inherit url hash;
        }
      )
      [
        {
          url = "https://web.archive.org/web/20200131023120/http://eurofurence.net/eurof_tt.zip";
          hash = "sha256-Al4tT2/qV9/K5le/OctybxgPcNMVDJi0OPr2EUBk8cE=";
        }
        {
          url = "https://web.archive.org/web/20200130083325/http://eurofurence.net/eurofctt.zip";
          hash = "sha256-ZF0Neysp0+TQgNAN+2IrfR/7dn043rSq6S3NHJ3gLUI=";
        }
        {
          url = "https://web.archive.org/web/20200206093756/http://eurofurence.net/monof_tt.zip";
          hash = "sha256-Kvcsp/0LzHhwPudP1qWLxhaiJ5/su1k7FBuV9XPKIGs=";
        }
        {
          url = "https://web.archive.org/web/20200206171841/http://eurofurence.net/pagebxtt.zip";
          hash = "sha256-CvKhzvxSQqdEHihQBfCSu1QgjzKn38DWaONdz5BpM4M=";
        }
        {
          url = "https://web.archive.org/web/20190812003003/http://eurofurence.net/unifurtt.zip";
          hash = "sha256-n9xnzJi8wvK6oCVQUQnQ1X9jW6WgyMKKIiDsT4j2Aas=";
        }
      ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    for src in $srcs; do
      install -D $src/*.ttf -t $out/share/fonts/truetype
      install -D $src/*.txt -t $out/share/doc/$name
    done
    runHook postInstall
  '';

  meta = {
    homepage = "https://web.archive.org/web/20200131023120/http://eurofurence.net/eurofurence.html";
    description = "Family of geometric rounded sans serif fonts";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.free;
  };
}
