{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${version}";
    sha256 = "sha256-chCxbbRZEE29KVnTQWID889kJ2H4qJGVL+vsxzr6VtA=";
  };

  # not including web ui
  excludedPackages = [
    "gae"
    "pack"
  ];

  vendorHash = null;

  meta = with lib; {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = licenses.mit;
    maintainers = with maintainers; [
      bryanasdev000
    ];
    mainProgram = "jd";
  };
}
