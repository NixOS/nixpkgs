{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript }:

buildKodiAddon rec {
  pname = "catchuptvandmore-images";
  namespace = "resource.images.catchuptvandmore";
  version = "1.0.22";

  src = fetchFromGitHub {
    owner = "Catch-up-TV-and-More";
    repo = "resource.images.catchuptvandmore";
    rev = "3a042bf42309dc5371de989584a63a58385cfc6e";
    hash = "sha256-7bPuzRW7exvUvxxoDCLnBw9wrUUfDqKgRQy3Z5rrtwQ=";
  };

  meta = with lib; {
    homepage =
      "https://github.com/Catch-up-TV-and-More/resource.images.catchuptvandmore";
    description = "Catch-up TV & More channel logos and artwork";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
