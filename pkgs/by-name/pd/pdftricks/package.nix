{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  vala,
  gtk3,
  wrapGAppsHook3,
  pantheon,
  ninja,
  ghostscript,
  makeWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pdftricks";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "muriloventuroso";
    repo = "pdftricks";
    tag = finalAttrs.version;
    hash = "sha256-l4Xg4Uk520qoaEo8UxdLE8MfpVkRj/bpGBzL5HwdDUo=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    vala
    wrapGAppsHook3
    ninja
    makeWrapper
  ];

  buildInputs = [
    gtk3
    pantheon.granite
    ghostscript
  ];

  preFixup = ''
    wrapProgram $out/bin/com.github.muriloventuroso.pdftricks \
      --prefix PATH : ${lib.makeBinPath [ ghostscript ]} \
      ''${gappsWrapperArgs[@]}
  '';

  dontWrapGApps = true;

  postPatch = ''
    # Remove positional arguments that cause errors
    substituteInPlace data/meson.build \
      --replace-fail "'desktop'," "" \
      --replace-fail "'appdata'," ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple, efficient application for small manipulations in PDF files using Ghostscript";
    homepage = "https://github.com/muriloventuroso/pdftricks";
    changelog = "https://github.com/muriloventuroso/pdftricks/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    platforms = lib.platforms.linux;
    mainProgram = "com.github.muriloventuroso.pdftricks";
  };
})
