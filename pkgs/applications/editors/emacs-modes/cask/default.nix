{ stdenv, fetchgit, emacs, python }:

stdenv.mkDerivation rec {
  name = "cask-0.7.3";

  src = fetchgit {
    url = "https://github.com/cask/cask.git";
    rev = "717b64a9ba7640ec366e8573da0c01f9c4d57b0c";
    sha256 = "0j18rzgpibisfcci6kcgjs8nlkfi1dw33dxp6ab6zaiarydwgcs5";
  };

  buildInputs = [ emacs python ];

  # byte-compiling emacs files automatically triggers cask's bootstrap
  # mechanism, what we don't want.
  dontBuild = true;

  installPhase = ''
    install -d "$out/share/emacs/site-lisp"
    install cask*.el* "$out/share/emacs/site-lisp"

    install -d "$out/bin"
    install bin/cask "$out/bin"

    # We also need to install cask's templates in order for 'cask
    # init' to work properly.
    install -d "$out/templates"
    install templates/* "$out/templates"

    # In order to work with cask's hard coded file paths (during bootstrap),
    # we have to create these links.
    ln -s "$out/share/emacs/site-lisp/"* "$out"

    # This file disables cask's self-updating function.
    touch "$out/.no-upgrade"
  '';

  meta = with stdenv.lib; {
    description = "Project management tool for Emacs";
    longDescription =
      ''
        Cask is a project management tool for Emacs that helps automate the
        package development cycle; development, dependencies, testing,
        building, packaging and more. Cask can also be used to manage
        dependencies for your local Emacs configuration.
      '';
    homepage = "https://github.com/cask/cask";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.jgeerds ];
  };
}
