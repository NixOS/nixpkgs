{
  callPackage,
}:

# to update: try to find the latest 3.x.x or 4.x.x .tar.gz on https://www.xp-pen.com/download
{
  xppen_3 = callPackage ./generic.nix {
    pname = "xppen_3";
    version = "3.4.9-240131";
    url = "https://www.xp-pen.com/download/file.html?id=2829&pid=1016&ext=gz";
    hash = "sha256-udUjkOW6nGo8zvMhVl6Iepa6OzCVz/M9m+DMqNKrfFg=";
  };
  xppen_4 = callPackage ./generic.nix {
    pname = "xppen_4";
    version = "4.0.4-240815";
    url = "https://www.xp-pen.com/download/file.html?id=3325&pid=1016&ext=gz";
    hash = "sha256-NVO9VaUmcQDI4rL76BBQDmII8vpmmo9qgcGetv6CIFE=";
  };
}
