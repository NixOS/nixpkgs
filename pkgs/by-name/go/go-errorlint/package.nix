{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-errorlint";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${version}";
    hash = "sha256-BU+3sLUGBCFA1JYFxTEyIan+iWB7Y7SaMFVomfNObMg=";
  };

  vendorHash = "sha256-xn7Ou4l8vbPD44rsN0mdFjTzOvkfv6QN6i5XR1XPxTE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://github.com/polyfloyd/go-errorlint";
    changelog = "https://github.com/polyfloyd/go-errorlint/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
    mainProgram = "go-errorlint";
  };
}
