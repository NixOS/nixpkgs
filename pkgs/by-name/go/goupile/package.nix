{
  lib,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,

  clangStdenv,
  llvmPackages,
  nixosTests,

  # https://goupile.org/en/build recommends a Paranoid build
  # which is not bit by bit reproducible, whereas others are.
  # In nixpkgs we decide to chose reproducibility.
  profile ? "Fast",

  nix-update-script,
}:

assert lib.assertOneOf "profile" profile [
  "Fast"
  "Debug"
  "Paranoid"
];

clangStdenv.mkDerivation (finalAttrs: {
  pname = "goupile";
  version = "3.12.10";

  # https://github.com/Koromix/rygel/tags
  src = fetchFromGitHub {
    owner = "Koromix";
    repo = "rygel";
    tag = "goupile/${finalAttrs.version}";
    hash = "sha256-rqixX9OrmDM3Kh/Zmr46OruOpB+M2b40CsfE2NaB+W4=";
  };

  nativeBuildInputs = [
    installShellFiles
    llvmPackages.bintools
  ];

  # pipe2() is only exposed with _GNU_SOURCE
  env.NIX_CFLAGS_COMPILE = toString [
    "-D_GNU_SOURCE"
  ];

  buildPhase = ''
    runHook preBuild
    ./bootstrap.sh
    echo "goupile = ${finalAttrs.version}" >FelixVersions.ini
    ./felix -s -p${profile} goupile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    installBin bin/${profile}/goupile
    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    tests = { inherit (nixosTests) goupile; };
    updateScript = nix-update-script { extraArgs = [ "--version-regex=goupile/(.*)" ]; };
  };

  meta = {
    changelog = "https://github.com/Koromix/rygel/blob/${finalAttrs.src.rev}/src/goupile/CHANGELOG.md";
    description = "Free design tool for secure forms including Clinical Report Forms (eCRF)";
    homepage = "https://goupile.org/en";
    license = lib.licenses.gpl3Plus; # sdpx headers
    platforms = lib.platforms.linux; # https://goupile.org/en/build
    mainProgram = "goupile";
    teams = with lib.teams; [ ngi ];
  };
})
