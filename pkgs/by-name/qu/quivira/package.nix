{ lib, fetchurl }:
let
  pname = "quivira";
  version = "4.1";
in
fetchurl {
  name = "${pname}-${version}";
  url = "http://www.quivira-font.com/files/Quivira.otf";

  # Download the source file to a temporary directory so that $out can be a
  # directory with the expected structure.
  downloadToTemp = true;
  # recursiveHash needs to be true because $out is going to be a directory.
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/opentype/Quivira.otf
  '';

  sha256 = "Hhl+0Oc5DDohOpBbEARMunMYCpr6nn4X6RgpQeEksNo=";
  meta = {
    description = "Free Unicode font in the OpenType format which is supported by every usual office program or printer";
    homepage = "http://www.quivira-font.com/";
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.nosewings ];
    # From the homepage: "If you try to install Quivira on a Mac,
    # you will get an error message about the 'post table
    # usability'."
    platforms = lib.filter (platform: !lib.hasInfix "darwin" platform) lib.platforms.all;
  };
}
