{
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch2,
  lib,
  makeDesktopItem,
  nix-update-script,
  nwjs,
}:

buildNpmPackage (finalAttrs: {
  pname = "onlykey";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "trustcrypto";
    repo = "OnlyKey-App";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8MSdr+ghCBPeGp63Yi1T+gyEwXOEUW3vqi9CrCmozrw=";
  };

  patches = [
    # Provides package-lock.json
    (fetchpatch2 {
      url = "https://github.com/trustcrypto/OnlyKey-App/commit/b8918cec80f5feda50c24a0aec3d6fb914ea8481.patch";
      hash = "sha256-ULMZI7fo5SJGrfCRqZzZVoGOTDQ8q/NG/uXMjNkQ+qk=";
    })
  ];

  desktopItem = makeDesktopItem {
    name = "onlykey";
    exec = "onlykey";
    icon = "onlykey";
    desktopName = "OnlyKey";
    comment = finalAttrs.meta.description;
    categories = [
      "Utility"
    ];
    terminal = false;
  };

  npmDepsHash = "sha256-DpjB95KEHfAc4GBxY40uUjlN7ifBMUncufVTmTXqDo8=";

  # when installing packages, nw tries to download nwjs in its postInstall
  # script. There are currently no other postInstall scripts, so this
  # should not break other things.
  npmFlags = [ "--ignore-scripts" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share"
    cp -r build "$out/share/onlykey"

    ln -s "${finalAttrs.desktopItem}/share/applications" "$out/share/applications"

    mkdir -p "$out/share/icons/hicolor/128x128/apps"
    install -D resources/onlykey_logo_128.png "$out/share/icons/hicolor/128x128/apps/onlykey.png"

    makeWrapper ${nwjs}/bin/nw "$out/bin/onlykey" \
      --add-flags "$out/share/onlykey"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Setup and configure OnlyKey";
    homepage = "https://github.com/trustcrypto/OnlyKey-App";
    changelog = "https://github.com/trustcrypto/OnlyKey-App/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "onlykey";
  };
})
