{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dms";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "anacrolix";
    repo = "dms";
    tag = "v${version}";
    hash = "sha256-dObY2MNrrQqn5i/y2LDlKvd9S04EArmsalIsfXsrth0=";
  };

  vendorHash = "sha256-f6Jl78ZPLD7Oq4Bq8MBQpHEKnBvpyTWZ9qHa1fGOlgA=";

  meta = with lib; {
    homepage = "https://github.com/anacrolix/dms";
    description = "UPnP DLNA Digital Media Server with basic video transcoding";
    license = licenses.bsd3;
    maintainers = [ maintainers.claes ];
    platforms = platforms.linux;
    mainProgram = "dms";
  };
}
