{
  lib,
  buildGoModule,
  fetchgit,
}:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
  version = "0.13.0";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
    hash = "sha256-Yn1oR69cHu/Q2HDRGzDNZ7RrTkNcwu4eFIrJFbmdhG0=";
  };

  vendorHash = "sha256-OjOHHXGWFX1K7berkc8vPXegdlr1QFFMPhRd0D5bK00=";

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
