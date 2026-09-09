{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeWrapper,
  bashInteractive,
  gh,
  jq,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gh-gonest";
  version = "0-unstable-2025-12-17";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emmanuel-ferdman";
    repo = "gh-gonest";
    rev = "4be041b29e6e102b04b00f98619c818780060a60";
    hash = "sha256-NTqq7y/6Gw1CXgmEpj7an2bT7d5ZFjjlV4zyBthC5yw=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bashInteractive ];

  # runtimeInputs is not used by mkDerivation directly, but defining it means
  # the packages on the path at runtime can be more easily inspected and
  # overridden.
  runtimeInputs = [
    gh
    jq
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m755 gh-gonest "$out"/bin/gh-gonest

    runHook postInstall
  '';

  # Use --suffix to ensure that, if the user has a `gh` executable (e.g.
  # because they've set `programs.gh.package` in Home Manager), then that gets
  # picked up first.
  postFixup = ''
    wrapProgram "$out"/bin/gh-gonest \
      --suffix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    homepage = "https://github.com/emmanuel-ferdman/gh-gonest";
    description = "GitHub CLI extension for cleaning up ghost notifications";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.me-and ];
    mainProgram = "gh-gonest";
  };
})
