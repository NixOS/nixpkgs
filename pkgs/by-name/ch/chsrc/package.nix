{
  lib,
  fetchFromGitHub,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chsrc";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "RubyMetric";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-MwT6SuDisJ2ynxlOqAUA8WjhrTeUcyoAMArehnby8Yw=";
  };

  nativeBuildInputs = [ texinfo ];

  patches = [
    ./disable-static-compiling.patch
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 chsrc $out/bin/chsrc
    install -Dm644 doc/chsrc.1 -t $out/share/man/man1/
    makeinfo doc/chsrc.texi --output=chsrc.info
    install -Dm 644 chsrc.info -t $out/share/info/
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
    maintainers = with lib.maintainers; [ cryo ];
    platforms = lib.platforms.all;
    mainProgram = "chsrc";
  };
})
