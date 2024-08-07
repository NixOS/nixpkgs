{
  stdenv,
  lib,
  makeDesktopItem,
  makeWrapper,
  copyDesktopItems,
  bash,
  coreutils,
  findutils,
  gnome,
  zenity ? gnome.zenity,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "lug-helper";
  version = "2.17";
  src = fetchFromGitHub {
    owner = "starcitizen-lug";
    repo = "lug-helper";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-iJMyhjCzHsS8Kgukt+j8avF+WIzh4am7rtJmy0j4Tjk=";
  };

  buildInputs = [
    bash
    coreutils
    findutils
    zenity
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "lug-helper";
      exec = "lug-helper";
      icon = "${finalAttrs.src}/lug-logo.png";
      comment = "Star Citizen LUG Helper";
      desktopName = "LUG Helper";
      categories = [ "Utility" ];
      mimeTypes = [ "application/x-lug-helper" ];
    })
  ];

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/lug-helper
    mkdir -p $out/share/pixmaps

    cp lug-helper.sh $out/bin/lug-helper
    cp -r lib/* $out/share/lug-helper/
    cp lug-logo.png $out/share/pixmaps/lug-helper.png
    wrapProgram $out/bin/lug-helper \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          findutils
          zenity
        ]
      }

  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "script to manage and optimize star citizen on linux";
    longDescription = ''
      lug-helper is a script designed to help you manage and optimize star citizen on linux.
    '';
    homepage = "https://github.com/starcitizen-lug/lug-helper";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ fuzen ];
    platforms = lib.platforms.linux;
  };
})
