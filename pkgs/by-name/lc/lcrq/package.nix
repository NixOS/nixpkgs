{
  stdenv,
  fetchFromCodeberg,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lcrq";
  version = "0.4.0";

  src = fetchFromCodeberg {
    owner = "librecast";
    repo = "lcrq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1kKWg+GN+WrYx7RTjTLqfGt9qcqeh9vc/TyfZMKsH7A=";
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
