{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefox-gnome-theme";
  version = "143";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
  };

  dontConfigure = true;
  dontBuild = true;

  # patching the install script for nix:
  # - point to the nix store
  # - don't preserve mode so successive installations work without elevation
  # - don't try to move files out of the nix store
  postPatch = ''
    patchShebangs ./scripts
    substituteInPlace ./scripts/auto-install.sh \
      --replace-fail \
        'installScript="./scripts/install.sh"' \
        'installScript="${placeholder "out"}/bin/install.sh"' \
      --replace-fail \
        'eval "chmod +x ''${installScript}"' \
        ""
    substituteInPlace ./scripts/install.sh \
      --replace-fail \
        'THEMEDIRECTORY=$(cd "$(dirname $0)" && cd .. && pwd)' \
        'THEMEDIRECTORY="${placeholder "out"}/share/firefox-gnome-theme"' \
      --replace-fail \
        'cp -fR "$THEMEDIRECTORY/."' \
        'cp -fR --no-preserve=mode "$THEMEDIRECTORY/."' \
      --replace-fail \
        'mv chrome/firefox-gnome-theme/configuration/user.js' \
        'cp chrome/firefox-gnome-theme/configuration/user.js'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 ./scripts/{auto-,}install.sh -t $out/bin
    install -Dm644 ./icon.svg ./user{Chrome,Content}.css -t $out/share/firefox-gnome-theme
    install -Dm644 ./configuration/user.js -t $out/share/firefox-gnome-theme/configuration
    cp -r ./theme $out/share/firefox-gnome-theme

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GNOME theme for Firefox";
    longDescription = ''
      A GNOME theme for Firefox.
      This theme follows latest GNOME Adwaita style.
    '';
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    downloadPage = "https://github.com/rafaelmardojai/firefox-gnome-theme/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.nekowinston ];
    platforms = lib.platforms.all;
  };
})
