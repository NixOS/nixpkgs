{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "superfile";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    rev = "v${version}";
    hash = "sha256-ajLlXySf/YLHrwwacV5yIF8qU5pKvEoOwpDoxh49qaU=";
  };

  vendorHash = "sha256-vybe4KNj6ZhvXRTiN7e5+IhOewfK5L2jKPrcdCYGc4k=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${src.rev}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [momeemt redyf];
    mainProgram = "superfile";
  };
}
