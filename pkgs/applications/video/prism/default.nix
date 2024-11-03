{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prism";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IRR7Gu+wGUUYyFfhc003QVlEaWCJPmi6XYVUN6Q6+GA=";
  };

  vendorHash = "sha256-uKtVifw4dxJdVvHxytL+9qjXHEdTyiz8U8n/95MObdY=";

  meta = with lib; {
    description = "RTMP stream recaster/splitter";
    homepage = "https://github.com/muesli/prism";
    license = licenses.mit;
    maintainers = with maintainers; [ paperdigits ];
    mainProgram = "prism";
  };
}
