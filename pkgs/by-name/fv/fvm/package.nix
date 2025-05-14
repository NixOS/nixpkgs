{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  nix-update-script,
}:

buildDartApplication rec {
  pname = "fvm";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "leoafarias";
    repo = "fvm";
    tag = version;
    hash = "sha256-i7sJRBrS5qyW8uGlx+zg+wDxsxgmolTMcikHyOzv3Bs=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple CLI to manage Flutter SDK versions";
    homepage = "https://github.com/leoafarias/fvm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
