{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  qt6,
  pkg-config,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "skwd-paper-plasma";
  version = "1.0.0-beta.26";

  src = fetchFromGitHub {
    owner = "liixini";
    repo = "skwd-paper-plasma";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S/REAkeG7XEsXMARkou6Fnhjyn31sbyUFzuuCjz5qW8=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  postInstall = ''
    mkdir -p $out/share/licenses/skwd-paper-plasma

    cp -r $src/LICENSE $out/share/licenses/skwd-paper-plasma/
  '';

  meta = {
    description = "KDE Plasma wallpaper integration for Skwd Paper";
    homepage = "https://github.com/liixini/skwd-wall";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      futurekismo
      HomieDerPrakti
    ];
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };
})
