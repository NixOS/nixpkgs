{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "storrent";
  version = "unstable-2023-01-14";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "storrent";
    rev = "86270ee777a19a521f8898a179485e0347f90ce0";
    hash = "sha256-JYNtuyk4hhe1jZgY/5Bz91Ropdw/U7n1VKHYkdUjZ0I=";
  };

  vendorHash = "sha256-iPKZPXsa6ya29N/u9QYd5LAm42+FtHZLGStRDxsAxe4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/jech/storrent";
    description = "An implementation of the BitTorrent protocol that is optimised for streaming media";
    mainProgram = "storrent";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
