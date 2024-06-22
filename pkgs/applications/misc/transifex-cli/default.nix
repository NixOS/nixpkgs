{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "transifex-cli";
  version = "1.6.14";

  src = fetchFromGitHub {
    owner = "transifex";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-yKkRoeq0hPYMjZcoL9h3l8FimnCjjVSlk9whliEnkzE=";
  };

  vendorHash = "sha256-rcimaHr3fFeHSjZXw1w23cKISCT+9t8SgtPnY/uYGAU=";

  ldflags = [
    "-s" "-w" "-X 'github.com/transifex/cli/internal/txlib.Version=${version}'"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/tx
  '';

  # Tests contain network calls
  doCheck = false;

  meta = with lib; {
    description = "Transifex command-line client";
    homepage = "https://github.com/transifex/transifex-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ thornycrackers ];
    mainProgram = "tx";
  };
}
