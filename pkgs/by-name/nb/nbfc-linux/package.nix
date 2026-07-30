{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  lua5_4,
  curl,
  libxml2,
  openssl,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbfc-linux";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "nbfc-linux";
    repo = "nbfc-linux";
    tag = finalAttrs.version;
    hash = "sha256-468/dFRjEgyJ0AW98wKq04WKZ4sZyzswBASSF6hyjVY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    lua5_4
    curl
    libxml2
    openssl
  ];

  configureFlags = [
    "--bindir=${placeholder "out"}/bin"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "C port of Stefan Hirschmann's NoteBook FanControl";
    longDescription = ''
      nbfc-linux provides fan control service for notebooks
    '';
    homepage = "https://github.com/nbfc-linux/nbfc-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Celibistrial
      bohanubis
    ];
    mainProgram = "nbfc";
    platforms = lib.platforms.linux;
  };
})
