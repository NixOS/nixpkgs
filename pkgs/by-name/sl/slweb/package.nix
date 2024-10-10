{
  lib,
  stdenv,
  fetchFromSourcehut,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slweb";
  version = "0.10.1";

  src = fetchFromSourcehut {
    owner = "~strahinja";
    repo = "slweb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AJg8qgbNUKizU0uyTnq9EviIXOUuaGvQowLAyTWhGTY=";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace-fail "/usr/local" "$out"
  '';

  env = {
    FALLBACKVER = finalAttrs.version;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Static website generator which aims at being simplistic";
    homepage = "https://strahinja.srht.site/slweb/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "slweb";
  };
})
