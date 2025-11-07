{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dwarf2json";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = "dwarf2json";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-M5KKtn5kly23TwbjD5MVLzIum58exXqCFs6jxsg6oGM=";
  };

  vendorHash = "sha256-3PnXB8AfZtgmYEPJuh0fwvG38dtngoS/lxyx3H+rvFs=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = with lib; {
    homepage = "https://github.com/volatilityfoundation/dwarf2json";
    description = "Convert ELF/DWARF symbol and type information into vol3's intermediate JSON";
    license = licenses.vol-sl;
    maintainers = with maintainers; [
      arkivm
      asauzeau
    ];
    mainProgram = "dwarf2json";
  };
})
