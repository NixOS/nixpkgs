{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  python3,
  makeWrapper,
  writeScriptBin,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "pylyzer";
  version = "0.0.79";

  src = fetchFromGitHub {
    owner = "mtshiba";
    repo = "pylyzer";
    tag = "v${version}";
    hash = "sha256-CCQluzwB2NAOKE11kQ60FMgIqfGsjgxeHwgJO9WF4Kw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6QqQpABNuy+Dd5EL/E6BXG7+TWXnZ9Tjzu57iSfXvSA=";

  nativeBuildInputs = [
    gitMinimal
    python3
    makeWrapper
    writableTmpDirAsHomeHook
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ (writeScriptBin "diskutil" "") ];

  buildInputs = [
    python3
  ];

  postInstall = ''
    mkdir -p $out/lib
    cp -r $HOME/.erg/ $out/lib/erg
  '';

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
