{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  i3-back,
}:
rustPlatform.buildRustPackage rec {
  pname = "i3-back";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "i3-back";
    rev = "refs/tags/v${version}";
    hash = "sha256-xGfX7ttWrcIVhy+MkR5RZr2DCAwIKwGu7zkafHcrjaE=";
  };

  # The tool needs a nightly compiler.
  RUSTC_BOOTSTRAP = 1;

  cargoHash = "sha256-Ot8f/58bAlpDSB11l14paCx2yjVoAYaHVIXaOzT1z/c=";

  passthru.tests.version = testers.testVersion { package = i3-back; };

  meta = {
    description = "i3/Sway utility to switch focus to your last focused window";
    homepage = "https://github.com/Cretezy/i3-back";
    changelog = "https://github.com/Cretezy/i3-back/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gabyx ];
    platforms = lib.platforms.linux;
    mainProgram = "i3-back";
  };
}
