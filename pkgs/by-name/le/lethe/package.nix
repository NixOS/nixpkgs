{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lethe";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = "lethe";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-y2D/80pnpYpTl+q9COTQkvtj9lzBlOWuMcnn5WFnX8E=";
  };

  cargoHash = "sha256-Ky39RpLoYks4xDiheSsrUj3l/ZrGcY+y5IuDZ28pH/c=";

  meta = {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lethe";
  };
})
