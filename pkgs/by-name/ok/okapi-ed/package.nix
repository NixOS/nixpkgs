{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  ripgrep,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "okapi-ed";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nk9";
    repo = "okapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xnckb3CMB8lE1oaEbmy8etRGJB5BuSoHts0phXm48uM=";
  };

  cargoHash = "sha256-g+JbSph5Fplq7SYKnWUpMQdoT989+qOe+kRUK3K+bDk=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postFixup = ''
    wrapProgram "$out/bin/okapi" \
      --prefix PATH : "${lib.makeBinPath [ ripgrep ]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Find lines across files by regex and edit them all at once with your $EDITOR";
    homepage = "https://github.com/nk9/okapi";
    license = lib.licenses.asl20;
    mainProgram = "okapi";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ toelke ];
  };
})
