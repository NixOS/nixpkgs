{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "harsh";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NgYmzRoJCoFpfo4NXnQKCp/gvN9g076Y9Pq8CnMrC/s=";
  };

  vendorHash = "sha256-Xzyu6jy4sbZPZv0EIksA2snlsivc0jp02QoOYpmFtQw=";

  meta = with lib; {
    description = "CLI habit tracking for geeks";
    homepage = "https://github.com/wakatara/harsh";
    changelog = "https://github.com/wakatara/harsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ laurailway ];
    mainProgram = "harsh";
  };
}
