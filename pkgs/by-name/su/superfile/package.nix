{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "superfile";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    rev = "v${version}";
    hash = "sha256-z1jcRzID20s7tEDUaEcnOYBfv/BPZtcXz9fy3V5iPPg=";
  };

  vendorHash = "sha256-OzPH7dNu/V4HDGSxrvYxu3s+hw36NiulFZs0BJ44Pjk=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${src.rev}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [momeemt];
    mainProgram = "superfile";
  };
}
