{
  lib,
  melpaBuild,
  fetchFromGitHub,
  nethack,
  gzip,
}:
melpaBuild (
  finalAttrs:
  let
    nethack-emacs = nethack.overrideAttrs (prev: {
      patches = [ "${finalAttrs.src}/enh-${builtins.replaceStrings [ "." ] [ "" ] prev.version}.patch" ];
      postPatch = (prev.postPatch or "") + ''
        sed \
          -e 's,^CFLAGS=-g,CFLAGS=,' \
          -e '/^CFLAGS+=-g/d' \
          -e 's,/bin/gzip,${gzip}/bin/gzip,g' \
          -e 's,^WINTTYLIB=.*,WINTTYLIB=-lncurses,' \
          -e 's,^GAMEPERM = 04755,GAMEPERM = 0755,' \
          -i sys/unix/hints/lisp
      '';
      configurePhase = ''
        pushd sys/unix
        sh setup.sh hints/lisp
        popd
      '';
    });
  in
  rec {
    pname = "nethack";
    version = "0.14.1";

    src = fetchFromGitHub {
      owner = "Feyorsh";
      repo = "nethack-el";
      rev = "v${builtins.replaceStrings [ "." ] [ "-" ] version}";
      hash = "sha256-vy9FrIKnPBFKjpqxxOpfOZVE62juq08CWvchm17ksw0=";
    };

    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp/elpa/${pname}-${version}/build
      cp ${nethack-emacs}/bin/nethack $out/share/emacs/site-lisp/elpa/${pname}-${version}/build/
    '';

    passthru.nethack = nethack-emacs;

    meta = {
      homepage = "https://github.com/Feyorsh/nethack-el";
      description = "Emacs interface to the roguelike NetHack";
      license = with lib.licenses; [
        gpl2
        bsd3
        nethack-emacs.meta.license
      ];
      maintainers = with lib.maintainers; [ feyorsh ];
    };
  }
)
