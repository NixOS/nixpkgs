{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.81.0";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9YroUxcLixu+MNL37JByCulCHv0WxWGwqBQ/+FGtZLw=";
  };

  vendorSha256 = "sha256-5gQyoLirXajkzxKxzcuPnjECL2mJPiHS65lYkyIpKs8=";

  doCheck = false;

  runVend = true;

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "A fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux Br1ght0ne Frostman ];
  };
}
