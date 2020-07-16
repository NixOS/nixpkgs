{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amfora";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    sha256 = "0bnjwsyi6l9p27rajwh0nq53zi4km7qpgyb08q17j0vd87gpdhka";
  };

  vendorSha256 = "1rj2m3rg8ixclj5jr0nmp266vwj1mg5ampxn04i3wgaayy49dbdi";

  meta = with lib; {
    description = "A fancy terminal browser for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/amfora";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ deifactor ];
  };
}
