{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "v2ray-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "wi1dcard";
    repo = "v2ray-exporter";
    rev = "v${version}";
    hash = "sha256-0YMsoM+0bMsY6+uP9+kqcxQEnxHRyY+g944Izsazv4o=";
  };

  vendorHash = "sha256-+jrD+QatTrMaAdbxy5mpCm8lF37XDIy1GFyEiUibA2k=";

  meta = {
    description = "Prometheus exporter for V2Ray daemon";
    mainProgram = "v2ray-exporter";
    homepage = "https://github.com/wi1dcard/v2ray-exporter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
