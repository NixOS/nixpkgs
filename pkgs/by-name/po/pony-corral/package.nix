{
  lib,
  stdenv,
  fetchFromGitHub,
  ponyc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corral";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "corral";
    rev = finalAttrs.version;
    hash = "sha256-zbOlk92oyy17VyUalYnUZPxAO+8wjRMCqcwLx0lLL1g=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ponyc ];

  installFlags = [
    "prefix=${placeholder "out"}"
    "install"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    changelog = "https://github.com/ponylang/corral/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      redvers
      numinit
    ];
    inherit (ponyc.meta) platforms;
  };
})
