{ stdenv, fetchgit, emacs, python }:

stdenv.mkDerivation rec {
  name = "cask-0.7.2";

  src = fetchgit {
    url = "https://github.com/cask/cask.git";
    rev = "8d667e1ce3f3aa817a7b996f02058b2441f83958";
    sha256 = "08brrdyz7zsw134zwf4dyj6bj2glflszssfq8vya3mh01s38mfri";
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
