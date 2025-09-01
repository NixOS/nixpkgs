{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "golines";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "golines";
    rev = "v${version}";
    sha256 = "sha256-Y4q3xpGw8bAi87zJ48+LVbdgOc7HB1lRdYhlsF1YcVA=";
  };

  vendorHash = "sha256-94IXh9iBAE0jJXovaElY8oFdXE6hxYg0Ww0ZEHLnEwc=";

  meta = with lib; {
    description = "Golang formatter that fixes long lines";
    homepage = "https://github.com/segmentio/golines";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
    mainProgram = "golines";
  };
}
