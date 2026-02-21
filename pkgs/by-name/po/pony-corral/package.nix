{
  lib,
  stdenv,
  fetchFromGitHub,
  ponyc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corral";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "corral";
    rev = finalAttrs.version;
    hash = "sha256-pJ6/+PYxMpJcj1e9v2Al8vIWFizJnLMIw7LlVU9ogS0=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ponyc ];

  installFlags = [
    "prefix=${placeholder "out"}"
    "install"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    changelog = "https://github.com/ponylang/corral/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      redvers
      numinit
    ];
    inherit (ponyc.meta) platforms;
  };
})
