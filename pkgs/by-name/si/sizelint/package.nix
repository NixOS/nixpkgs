{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sizelint";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "sizelint";
    tag = "v${version}";
    hash = "sha256-06RJrE0w1Xhj364dUUuYadxleX12mkB8yO+h1QLZhH0=";
  };

  cargoHash = "sha256-1kg1xfgzqrbZvazRavM4aW7oyRei9jKW0a+a6z2HLnc=";

  meta = {
    description = "Lint your file tree based on file sizes";
    homepage = "https://github.com/a-kenji/sizelint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "sizelint";
  };
}
