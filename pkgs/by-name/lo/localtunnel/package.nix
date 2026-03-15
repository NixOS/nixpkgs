{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "localtunnel";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "localtunnel";
    repo = "localtunnel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6gEK1VjF25Kbe2drxbxUKDNJGqZ+OXgkulPkAkMR2+k=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-zq9ygsKDU4lIsNxc6ovW+IXVztQoEaJAekzBrwCK7ik=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/localtunnel/localtunnel/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "CLI for localtunnel";
    homepage = "https://localtunnel.me";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "lt";
  };
})
