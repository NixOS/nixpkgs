{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "shopify-themekit";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "themekit";
    rev = "v${version}";
    sha256 = "sha256-m0TAgnYklj/WqZJIm9mHLE7SZgXP8YDQZndDgpiNqL0=";
  };

  vendorHash = "sha256-o928qjp7+/U1W03esYTwVEfQ4A3TmPnmgmh4oWpqJoo=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    # Keep `theme` only
    rm -f $out/bin/{cmd,tkrelease}
  '';

  meta = with lib; {
    description = "Command line tool for shopify themes";
    mainProgram = "theme";
    homepage = "https://shopify.github.io/themekit/";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
  };
}
