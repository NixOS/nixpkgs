{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  git,
  python3,
  makeWrapper,
  writeScriptBin,
  darwin,
  which,
  nix-update-script,
  testers,
  pylyzer,
}:

rustPlatform.buildRustPackage rec {
  pname = "pylyzer";
  version = "0.0.61";

  src = fetchFromGitHub {
    owner = "mtshiba";
    repo = "pylyzer";
    rev = "refs/tags/v${version}";
    hash = "sha256-t0BzNNofjeBlNqf6iqaWrTzVpzEACyyrZ3YKDYz713U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustpython-ast-0.4.0" = "sha256-kMUuqOVFSvvSHOeiYMjWdsLnDu12RyQld3qtTyd5tAM=";
    };
  };

  nativeBuildInputs = [
    git
    python3
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [ (writeScriptBin "diskutil" "") ];

  buildInputs = [ python3 ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mkdir -p $out/lib
    cp -r $HOME/.erg/ $out/lib/erg
  '';

  nativeCheckInputs = [ which ];

  checkFlags = [
    # this test causes stack overflow
    # > thread 'exec_import' has overflowed its stack
    "--skip=exec_import"
  ];

  postFixup = ''
    wrapProgram $out/bin/pylyzer --set ERG_PATH $out/lib/erg
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = pylyzer; };
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
