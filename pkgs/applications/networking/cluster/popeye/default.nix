{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "popeye";
  version = "0.9.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "1rslmcdjs53zvv0xaf00vxqsfc3jh2p584j3q6nfgrghc978xmpf";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/popeye/cmd.version=${version}
      -X github.com/derailed/popeye/cmd.commit=022c3104b642aab6bdb287468fb79068a33e1b0d
      -X github.com/derailed/popeye/cmd.date=2020-10-31T16:44:45Z
  '';

  vendorSha256 = "08195dnka7rs38py3kjii9zh9nifg2fnbi1wzjl0pc38i2bbrz0k";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Kubernetes cluster resource sanitizer";
    homepage = "https://github.com/derailed/popeye";
    changelog = "https://github.com/derailed/popeye/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
    platforms = platforms.linux;
  };
}
