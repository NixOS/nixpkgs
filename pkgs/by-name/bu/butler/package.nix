{
  lib,
  stdenv,
  fetchFromGitHub,
  _7zz,
  brotli,
  buildGoModule,
  libc7zip,
  nix-update-script,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "butler";
  version = "15.32.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "butler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RNjOph2sxqu49cyfXwX0VFgiAxtAivulSnKoax1BRKQ=";
    leaveDotGit = true;

    postFetch = ''
      cd "$out"
      git rev-parse HEAD > COMMIT
      git log --max-count=1 --pretty=%ct > SOURCE_DATE_EPOCH
      rm -rf .git
    '';
  };

  postPatch = ''
    substituteInPlace endpoints/launch/helpers_test.go \
      --replace-fail '"/bin/sh"' '"${stdenv.shell}"'
  '';

  buildInputs = [ brotli ];

  vendorHash = "sha256-IJ/ODqn7dMwW/PZ7dmad/BdlhsR0FslSuGr6qJLQCSA=";

  # Don't download prebuilt libc7zip
  # Load libc7zip from the store
  postConfigure = ''
    substituteInPlace vendor/github.com/itchio/boar/szextractor/szextractor.go \
      --replace-fail 'os.Getenv("BUTLER_NO_DEPS") == "1"' 'true'
  ''
  + lib.optionalString (lib.meta.availableOn stdenv.hostPlatform libc7zip) ''
    substituteInPlace vendor/github.com/itchio/sevenzip-go/sz/glue.go \
      --replace-fail 'execPath, err := os.Executable()' '_, err := os.Executable()' \
      --replace-fail 'filepath.Dir(execPath)' '"${lib.getLib libc7zip}/lib"'
  '';

  preBuild = ''
    ldflags+=("-X=github.com/itchio/butler/buildinfo.Commit=$(cat COMMIT)")
    ldflags+=("-X=github.com/itchio/butler/buildinfo.BuiltAt=$(cat SOURCE_DATE_EPOCH)")
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  # Test_DownloadsDrive needs network
  checkFlags = [ "-skip=^Test_DownloadsDrive$" ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  # Docs and code generator for butlerd, not a user tool
  excludedPackages = [ "butlerd/generous" ];

  # Otherwise version is 'head'
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/itchio/butler/buildinfo.Version=${finalAttrs.src.tag}"
  ];

  passthru = {
    tests = lib.optionalAttrs (lib.meta.availableOn stdenv.hostPlatform libc7zip) {
      extract-7z =
        runCommand "butler-extract-7z"
          {
            nativeBuildInputs = [
              _7zz
              finalAttrs.finalPackage
              writableTmpDirAsHomeHook
            ];
          }
          ''
            echo nixpkgs > a.txt
            7zz a test.7z a.txt
            butler extract -d out test.7z
            grep -qx nixpkgs out/a.txt
            touch $out
          '';
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line itch.io helper";
    homepage = "https://itch.io/docs/butler";
    changelog = "https://github.com/itchio/butler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naelstrof ];
    mainProgram = "butler";
  };
})
