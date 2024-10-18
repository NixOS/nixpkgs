{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spacectl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "spacelift-io";
    repo = "spacectl";
    rev = "v${version}";
    hash = "sha256-wEu7AmFn1782XTKKb7JxQWn/ZSHrQbuZ/SDldn6pUNo=";
  };

  vendorHash = "sha256-SYfXG6YM0Q2rCnoTM2tYvE17uBCD8yQiW/5DTCxMPWo=";

  meta = {
    homepage = "https://github.com/spacelift-io/spacectl";
    description = "Spacelift client and CLI";
    changelog = "https://github.com/spacelift-io/spacectl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "spacectl";
  };
}
