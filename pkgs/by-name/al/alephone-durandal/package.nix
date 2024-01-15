{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "durandal";
  desktopName = "Marathon-Durandal";
  version = "20230119";
  icon = alephone.icons + "/marathon2.png";

  zip = fetchurl {
    url =
      "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${version}/Marathon2-${version}-Data.zip";
    sha256 = "sha256-Vbfk5wLgvNEZW2BohMY5mPXaRbNlHxJdWLYTsE8CSwI=";
  };

  meta = {
    description = "Second chapter of the Marathon trilogy";
    longDescription = ''
      Fresh from your triumph on the starship Marathon, you are seized by the rogue computer Durandal to do his bidding in a distant part of the galaxy. Within the ruins of an ancient civilization, you must seek the remnants of a lost clan and uncover their long-buried secrets. Battle opponents ancient and terrible, with sophisticated weapons and devious strategies, all the while struggling to escape the alien nightmare…

      This release of Marathon 2: Durandal includes the classic graphics, and revamped high-definition textures and monsters from the Xbox Live Arcade edition.
    '';
    homepage = "https://alephone.lhowon.org/games/marathon2.html";
  };

}
