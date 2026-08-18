{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "confy-tui";
  version = "3.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "phluxjr";
    repo = "confy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SFcRMJn8AfNdLnBHEDQ9MVUiTo/8wmtEWwCKMgLTo74=";
  };

  cargoHash = "sha256-E4AK2WLwr7GEexM8JncfHoSBQxQ1OuCkro9jEq+9I4s=";

  postInstall = ''
    install -Dm644 confy.1 $out/share/man/man1/confy.1
  '';

  meta = {
    description = "config manager tui for linux/unix systems";
    homepage = "https://github.com/phluxjr/confy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ phluxjr ];
    mainProgram = "confy";
    platforms = lib.platforms.unix;
  };
})
