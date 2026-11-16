{
  stdenv,
  fetchFromCodeberg,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lcrq";
  version = "0.4.1";

  src = fetchFromCodeberg {
    owner = "librecast";
    repo = "lcrq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1rkrwgIJWCZ281IZ04Gktq3mYJK4xXN7qI16IOI7Bco=";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    changelog = "https://codeberg.org/librecast/lcrq/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "Librecast RaptorQ library";
    homepage = "https://librecast.net/lcrq.html";
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
    platforms = lib.platforms.unix;
  };
})
