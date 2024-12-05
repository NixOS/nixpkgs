{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chemacs2";
  version = "0-unstable-2023-01-20";

  src = fetchFromGitHub {
    owner = "plexus";
    repo = "chemacs2";
    rev = "c2d700b784c793cc82131ef86323801b8d6e67bb";
    hash = "sha256-/WtacZPr45lurS0hv+W8UGzsXY3RujkU5oGGGqjqG0Q=";
  };

  outputs = [ "out" "doc" ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -t $out/share/site-lisp/chemacs2/ -Dm644 init.el early-init.el chemacs.el
    install -t $doc/share/doc/chemacs2/ -Dm644 README.org CHANGELOG.md

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/plexus/chemacs2";
    description = "Emacs version switcher, improved";
    longDescription = ''
      Chemacs 2 is an Emacs profile switcher, it makes it easy to run multiple
      Emacs configurations side by side.

      Think of it as a bootloader for Emacs.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
