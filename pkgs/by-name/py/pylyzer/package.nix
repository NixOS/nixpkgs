{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  python3,
  makeWrapper,
  writeScriptBin,
  which,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "pylyzer";
  version = "0.0.70";

  src = fetchFromGitHub {
    owner = "mtshiba";
    repo = "pylyzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-jj9r5npClLY9mhDHFI92825RYvwn6m9KlngfFL0bqCw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustpython-ast-0.4.0" = "sha256-RChZlXzdzyLp0Lb/LTLbWfbUzPDhmWkf0uVobflCKRk=";
    };
  };

  nativeBuildInputs = [
    git
    python3
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ (writeScriptBin "diskutil" "") ];

  buildInputs = [
    python3
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    mkdir -p $out/lib
    cp -r $HOME/.erg/ $out/lib/erg
  '';

  nativeCheckInputs = [ which ];

  checkFlags =
    [
      # this test causes stack overflow
      # > thread 'exec_import' has overflowed its stack
      "--skip=exec_import"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # Dict({Str..Obj: Int}) does not implement Iterable(Str..Obj..Obj) and Indexable({"a"}..Obj, Int)
      # https://github.com/mtshiba/pylyzer/issues/114
      "--skip=exec_casting"
    ];

  postFixup = ''
    wrapProgram $out/bin/pylyzer --set ERG_PATH $out/lib/erg
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast static code analyzer & language server for Python";
    homepage = "https://github.com/mtshiba/pylyzer";
    changelog = "https://github.com/mtshiba/pylyzer/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "pylyzer";
  };
}
