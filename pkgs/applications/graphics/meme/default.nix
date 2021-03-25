{ lib
, unstableGitUpdater
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "meme";
  version = "unstable-2020-05-28";

  src = fetchFromGitHub {
    owner = "nomad-software";
    repo = "meme";
    rev = "33a8b7d0de6996294a0464a605dacc17b26a6b02";
    sha256 = "05h8d6pjszhr49xqg02nw94hm95kb7w1i7nw8jxi582fxxm2qbnm";
  };

  vendorSha256 = null;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A command line utility for creating image macro style memes";
    homepage = "https://github.com/nomad-software/meme";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    platforms = with platforms; linux ++ darwin;
  };
}
