{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  inherit (python3Packages) buildPythonApplication hatchling rich-click;
in
buildPythonApplication {
  pname = "android-unpinner";
  version = "0-unstable-2025-10-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "android-unpinner";
    rev = "60cbfee4d43cedaff622d72c27d87e418a111413";
    sha256 = "sha256-nEkGn7RCraZuRSKp9hsVcRgE1EW6nRqEzxsGXprEd9Q=";
  };

  build-system = [ hatchling ];

  dependencies = [ rich-click ];

  # https://github.com/NixOS/nixpkgs/pull/442819
  pythonRelaxDeps = [ "rich-click" ];

  pythonImportsCheck = [ "android_unpinner" ];

  meta = {
    description = "Remove Certificate Pinning from APKs";
    homepage = "https://github.com/mitmproxy/android-unpinner";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
