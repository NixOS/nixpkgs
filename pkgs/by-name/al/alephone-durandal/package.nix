{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "durandal";
  desktopName = "Marathon-Durandal";
  version = "20240510";
  icon = alephone.icons + "/marathon2.png";

  # nixpkgs-update: no auto update
  zip = fetchurl {
    url = "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${version}/Marathon2-${version}-Data.zip";
    hash = "sha256-uoBl1/7XlXmMLqpk3tvme9w18q4Yh0WCrmqSzjGxNz0=";
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
