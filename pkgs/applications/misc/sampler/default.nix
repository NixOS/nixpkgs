{ lib, buildGoModule, fetchFromGitHub, alsaLib }:

buildGoModule rec {
  pname = "sampler";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "sqshq";
    repo = pname;
    rev = "v${version}";
    sha256 = "129vifb1y57vyqj9p23gq778jschndh2y2ingwvjz0a6lrm45vpf";
  };

  modSha256 = "0wgwnn50lrg6ix5ll2jdwi421wgqgsv4y9xd5hfj81kya3dxcbw0";

  subPackages = [ "." ];

  buildInputs = [ alsaLib ];

  meta = with lib; {
    description = "Tool for shell commands execution, visualization and alerting";
    homepage = "https://sampler.dev";
    license = licenses.gpl3;
    maintainers = with maintainers; [ uvnikita ];
    platforms = platforms.unix;
  };
}
