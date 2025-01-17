{
  lib,
  buildGoModule,
  fetchgit,
}:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.12.0";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    hash = "sha256-GDDycFWGrNXWdWNjGhb+W6kImF1nqVVH+dJ8VjYQ2MQ=";
  };

  vendorHash = "sha256-ErTXIbPKAFm8jBYRPuWSaCFbTS+5MPyto9edixbTR7E=";

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
