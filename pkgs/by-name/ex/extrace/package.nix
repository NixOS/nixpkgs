{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "extrace";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "extrace";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jy/Ac3NcqBkW0kHyypMAVUGAQ41qWM96BbLAym06ogM=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -dm755 "$out/share/licenses/extrace/"
    install -m644 LICENSE "$out/share/licenses/extrace/LICENSE"
  '';

  meta = {
    homepage = "https://github.com/leahneukirchen/extrace";
    description = "Trace exec() calls system-wide";
    license = with lib.licenses; [
      gpl2Plus
      bsd2
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.leahneukirchen ];
  };
})
