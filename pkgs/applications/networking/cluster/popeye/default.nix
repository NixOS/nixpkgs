{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "popeye";
  version = "0.8.10";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "1cx39xipvvhb12nhvg7kfssnqafajni662b070ynlw8p870bj0sn";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/popeye/cmd.version=${version}
      -X github.com/derailed/popeye/cmd.commit=b7a876eafd4f7ec5683808d8d6880c41c805056a
      -X github.com/derailed/popeye/cmd.date=2020-08-25T23:02:30Z
  '';

  vendorSha256 = "0b2bawc9wnqwgvrv614rq5y4ns9di65zqcbb199y2ijpsaw5d9a7";

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
