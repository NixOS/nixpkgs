{
  lib,
  stdenv,
  fetchFromGitHub,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chsrc";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "RubyMetric";
    repo = "chsrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AgyaaKPCyqivCMd6VrV1Fiu6D/bvgW/faztVByjghiQ=";
  };

  nativeBuildInputs = [ texinfo ];

  installPhase = ''
    runHook preInstall

    install -Dm755 chsrc $out/bin/chsrc
    install -Dm644 doc/chsrc.1 -t $out/share/man/man1/
    makeinfo doc/chsrc.texi --output=chsrc.info
    install -Dm644 chsrc.info -t $out/share/info/

    runHook postInstall
  '';

  meta = {
    description = "Change Source everywhere for every software";
    homepage = "https://chsrc.run/";
    changelog = "https://github.com/RubyMetric/chsrc/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "chsrc";
  };
})
