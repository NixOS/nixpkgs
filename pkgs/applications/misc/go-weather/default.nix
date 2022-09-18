{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "go-weather";
  version = "0.15.7";

  src = fetchFromGitHub {
    owner = "genuinetools";
    repo = "weather";
    rev = "v${version}";
    sha256 = "sha256-FbXrCcJYXhq7A9XFIGWXxWA+wmH72mIGZGrAMnKr8/c=";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/genuinetools/weather";
    description = "Weather via the command line";
    longDescription = ''
      Weather via the command line. Uses the darksky.net API so it's
      super accurate. Also includes any current weather alerts in the output.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
  };
}
