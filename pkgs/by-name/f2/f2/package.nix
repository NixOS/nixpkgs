{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "f2";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    rev = "v${version}";
    sha256 = "sha256-z2w+1dAwd3108J+ApHn2rj9duW9qObd3AZJXyt0811c=";
  };

  vendorHash = "sha256-xKw9shfAtRjD0f4BGALM5VPjGOaYz1IqXWcctHcV/p8=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  # has no tests
  doCheck = false;

  meta = {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "f2";
  };
}
