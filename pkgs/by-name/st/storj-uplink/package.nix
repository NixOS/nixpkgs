{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
<<<<<<< HEAD
  version = "1.142.7";
=======
  version = "1.142.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Y0pnketYzKC7xzndIceFk7dwyUwSjMzvvJF1EqSSD7s=";
=======
    hash = "sha256-TMHIbzcUNwzKIz9wN27sbf/XFvL+VYF9dLEpRc0cZYA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-sdLobkctLiehei9J2vxc/IH3whGeqxq6T+AadrIuPRs=";

  ldflags = [ "-s" ];

  # Tests fail with 'listen tcp 127.0.0.1:0: bind: operation not permitted'.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = lib.licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with lib.maintainers; [ felipeqq2 ];
  };
})
