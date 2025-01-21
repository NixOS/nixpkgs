{
  fetchFromGitea,
  lcrq,
  lib,
  librecast,
  libsodium,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lcsync";
  version = "0.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecast";
    repo = "lcsync";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x8KjvUtn00g+zxDfSWZq4WgALDKRgbCF9rtipdOMbpc=";
  };
  buildInputs = [
    lcrq
    librecast
    libsodium
  ];
  configureFlags = [ "SETCAP_PROGRAM=true" ];
  installFlags = [ "PREFIX=$(out)" ];
  doCheck = true;

  meta = {
    changelog = "https://codeberg.org/librecast/lcsync/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Librecast File and Syncing Tool";
    mainProgram = "lcsync";
    homepage = "https://librecast.net/lcsync.html";
    license = [
      lib.licenses.gpl2
      lib.licenses.gpl3
    ];
    maintainers = with lib.maintainers; [
      albertchae
      aynish
      DMills27
      jasonodoom
      jleightcap
    ];
    platforms = lib.platforms.gnu;
  };
})
