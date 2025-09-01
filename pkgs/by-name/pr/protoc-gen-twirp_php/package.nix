{
  lib,
  buildGoModule,
  fetchgit,
}:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.14.0";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    hash = "sha256-yAq/bgzLJlkdWKdSpsi0QGDNFFvsM8lyjDxU0YvRcaI=";
  };

  vendorHash = "sha256-4/cIu6J0eQd61FWGyRQ5tMM3G9ev7TNIccrZi93ZlJg=";

  subPackages = [ "protoc-gen-twirp_php" ];

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "PHP port of Twitch's Twirp RPC framework";
    mainProgram = "protoc-gen-twirp_php";
    homepage = "https://github.com/twirphp/twirp";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
