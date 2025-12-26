{
  lib,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,

  stdenv,
  clangStdenv,
  llvmPackages,
  nixosTests,

  # https://goupile.org/en/build recommends a Paranoid build
  # which is not bit by bit reproducible, whereas others are
  profile ? "Paranoid", # Debug/Fast
}:
let
  stdenv' = if (profile == "Paranoid") then clangStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "goupile";
  version = "3.11.1";

  # https://github.com/Koromix/rygel/tags
  src = fetchFromGitHub {
    owner = "Koromix";
    repo = "rygel";
    tag = "goupile/${finalAttrs.version}";
    hash = "sha256-fvWWjNxiXhGqbJhdH6GeXr7jKHnxjr36g6kkHhLm6Z0=";
  };

  patches = [
    ./0001-try-debug-prune-bug.patch
    ./0002-goupile-wild-logs-patch.patch
    ./0003-sandbox-vm-bug-debug.patch
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals (profile == "Paranoid") [
    llvmPackages.bintools
  ];

  # pipe2() is only exposed with _GNU_SOURCE
  NIX_CFLAGS_COMPILE = [ "-D_GNU_SOURCE" ];

  # NOTE: in the next release >3.11.1
  # --version_file can be removed, and FelixVersions.ini will be used by default
  buildPhase = ''
    runHook preBuild
    ./bootstrap.sh
    echo "goupile = ${finalAttrs.version}" >FelixVersions.ini
    ./felix -s -p${profile} goupile --version_file FelixVersions.ini
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

  passthru.tests = { inherit (nixosTests) goupile; };

  meta = {
    changelog = "https://github.com/Koromix/rygel/blob/${finalAttrs.src.rev}/src/goupile/CHANGELOG.md";
    description = "Free design tool for secure forms including Clinical Report Forms (eCRF)";
    homepage = "https://goupile.org/en";
    license = lib.licenses.gpl3Plus; # sdpx headers
    platforms = lib.platforms.linux; # https://goupile.org/en/build
    mainProgram = "goupile";
    maintainers = with lib.maintainers; [ phanirithvij ];
    teams = with lib.teams; [ ngi ];
  };
})
