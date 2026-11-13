{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  expect,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fcp";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "svetlitski";
    repo = "fcp";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-YupsJRtju9JyGGzSTk+tyEGh4ifpJllXVifsFoZ4Rwc=";
  };

  cargoHash = "sha256-PsYmzHwFpgAJ3AClt5buSuAtlXxvKQyz3XeZBtTXsLs=";

  nativeBuildInputs = [ expect ];

  # character_device fails with "File name too long" on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    patchShebangs tests/*.exp
  '';

  meta = {
    description = "Significantly faster alternative to the classic Unix cp(1) command";
    homepage = "https://github.com/svetlitski/fcp";
    changelog = "https://github.com/svetlitski/fcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.georgyo
      lib.maintainers.flokli
    ];
    mainProgram = "fcp";
  };
})
