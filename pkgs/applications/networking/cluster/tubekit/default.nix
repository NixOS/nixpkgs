{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tubekit";
  version = "5";

  src = fetchFromGitHub {
    owner = "reconquest";
    repo = "tubekit";
    rev = "refs/tags/v${version}";
    hash = "sha256-fUe5bMFF569A9Xdx3bfQH2DzbQDRfZ+ewlDL+gK2gWw=";
  };

  vendorHash = "sha256-qAmkUV5l5g8/w8ZTYFGYvd9I8NUk8rMYjutenHvTRnw=";

  meta = with lib; {
    description = "Kubectl alternative with quick context switching";
    homepage = "https://github.com/reconquest/tubekit";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ farcaller ];
  };
}
