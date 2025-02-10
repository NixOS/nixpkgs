{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "josephburnett";
    repo = "jd";
    rev = "v${version}";
    sha256 = "sha256-lajmATDx5FV4B8PJmhDFDRgDcv8yicJezm6Z5lKd0VU=";
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
      blaggacao
    ];
    mainProgram = "jd";
  };
}
