{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "lethe";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = "lethe";
    rev = "v${version}";
    sha256 = "sha256-y2D/80pnpYpTl+q9COTQkvtj9lzBlOWuMcnn5WFnX8E=";
  };

  cargoHash = "sha256-Ky39RpLoYks4xDiheSsrUj3l/ZrGcY+y5IuDZ28pH/c=";

  meta = with lib; {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "lethe";
  };
}
