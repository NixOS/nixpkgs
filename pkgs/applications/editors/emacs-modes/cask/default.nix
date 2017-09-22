{ stdenv, fetchFromGitHub, emacs, python }:

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "cask-${version}";

  src = fetchFromGitHub {
    owner = "cask";
    repo = "cask";
    rev = "v${version}";
    sha256 = "1sl094adnchjvf189c3l1njawrj5ww1sv5vvjr9hb1ng2rw20z7b";
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
    homepage = https://github.com/cask/cask;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.jgeerds ];
  };
}
