{
  lib,
  fetchFromGitHub,
  fetchurl,
  flutter341,
  replaceVars,
  rustPlatform,
  stdenvNoCC,

  # nativeBuildInputs
  copyDesktopItems,
  makeBinaryWrapper,
  makeDesktopItem,
  undmg,

  # buildInputs
  libayatana-appindicator,

  # passthru
  nixosTests,
}:
let
  pname = "localsend";
  version = "1.18.0";

  meta = {
    description = "Open source cross-platform alternative to AirDrop";
    homepage = "https://localsend.org/";
    donationPage = "https://localsend.org/donate";
    downloadPage = "https://github.com/localsend/localsend/releases";
    changelog = "https://github.com/localsend/localsend/blob/HEAD/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sikmir
      linsui
      pandapip1
      prince213
    ];
  };
in
if stdenvNoCC.hostPlatform.isDarwin then
  import ./darwin.nix {
    inherit
      pname
      version
      meta

      lib
      fetchurl
      stdenvNoCC

      makeBinaryWrapper
      undmg
      ;
  }
else
  import ./linux.nix {
    inherit
      pname
      version
      meta

      lib
      fetchFromGitHub
      flutter341
      replaceVars
      rustPlatform
      stdenvNoCC

      copyDesktopItems
      makeDesktopItem

      libayatana-appindicator

      nixosTests
      ;
  }
