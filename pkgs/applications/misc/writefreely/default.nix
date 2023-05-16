{ lib, buildGoModule, fetchFromGitHub, go-bindata }:

buildGoModule rec {
  pname = "writefreely";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "writeas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GnuqYgiwXdKM+os5RzuUYe9ADOhZaxou5dD7GCEE1Ns=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-IBer+8FP+IWWJPnaugr8zzQA9mSVFzP0Nofgl/PhtzQ=";
=======
  vendorSha256 = "sha256-IBer+8FP+IWWJPnaugr8zzQA9mSVFzP0Nofgl/PhtzQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ go-bindata ];

  preBuild = ''
    make assets
  '';

  ldflags = [ "-s" "-w" "-X github.com/writeas/writefreely.softwareVer=${version}" ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  meta = with lib; {
    description = "Build a digital writing community";
    homepage = "https://github.com/writeas/writefreely";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
  };
}
