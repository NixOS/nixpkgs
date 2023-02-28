{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tubekit";
  version = "4";

  src = fetchFromGitHub {
    owner = "reconquest";
    repo = "tubekit";
    rev = "refs/tags/v${version}";
    hash = "sha256-sq91uR8ITMOv8hivwKQR02mMlJpjDHw6RxiwVUrpwnY=";
  };

  vendorHash = "sha256-qrGzmr1dZPn5r2WBJA7FT7RTqP2sxnrXgbrnKlnpF0Y=";

  meta = with lib; {
    description = "Kubectl alternative with quick context switching";
    homepage = "https://github.com/reconquest/tubekit";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ farcaller ];
  };
}
