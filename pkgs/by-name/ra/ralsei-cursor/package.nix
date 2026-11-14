{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "ralsei-cursor";
  version = "0-unstable-2026-10-02";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rmarkus231";
    repo = "ralseiCursor";
    rev = "76e7cf7176a28bb02aa2fc71b98c34d37479f539";
    hash = "sha256-1dk1ALIbuCXRfNOU2ShXEj5lTwgVTTa6uXjczBBXl88=";
  };

  installPhase = ''
    runHook preInstall

    install -D index.theme $out/share/icons/ralseiCursor/index.theme
    cp -r cursors $out/share/icons/ralseiCursor/

    runHook postInstall
  '';

  meta = {
    description = "Ralsei X11 cursor theme";
    homepage = "https://github.com/rmarkus231/ralseiCursor";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lzcunt ];
    platforms = lib.platforms.linux;
  };
}
