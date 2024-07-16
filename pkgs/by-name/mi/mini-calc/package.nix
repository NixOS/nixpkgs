{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gnuplot,
  makeWrapper,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "mini-calc";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "coco33920";
    repo = "calc";
    rev = version;
    hash = "sha256-f2xmc6wzZ5MwwBDYQNoxbFmIclZWd/xOOI4/MCmrnEI=";
  };

  cargoHash = "sha256-OiAU94URgOHZ/iNbCF5rE55zfZNkW3bdjPZo05kpIRo=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/mini-calc \
      --prefix PATH : "${lib.makeBinPath [ gnuplot ]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  versionCheckProgram = "echo -v | mini-calc";
  versionCheckProgramArg = "";

  meta = {
    description = "Fully-featured minimalistic configurable calculator written in Rust";
    changelog = "https://github.com/coco33920/calc/blob/${version}/CHANGELOG.md";
    homepage = "https://calc.nwa2coco.fr";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "mini-calc";
    platforms = lib.platforms.unix;
  };
}
