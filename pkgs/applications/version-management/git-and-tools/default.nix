/* moving all git tools into one attribute set because git is unlikely to be
 * referenced by other packages and you can get a fast overview.
*/
args: with args; with pkgs;
let
  inherit (pkgs) stdenv fetchurl getConfig subversion;
in
rec {

  git = import ./git {
    inherit fetchurl stdenv curl openssl zlib expat perl gettext
      asciidoc texinfo xmlto docbook2x
      docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion;
    svnSupport = getConfig ["git" "svnSupport"] false; # for git-svn support
    guiSupport = getConfig ["git" "guiSupport"] false;
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey subversion];
  };

  gitGit = import ./git/git-git.nix {
    inherit fetchurl sourceFromHead stdenv curl openssl zlib expat perl gettext
      asciidoc texinfo xmlto docbook2x
      docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion autoconf;
    svnSupport = getConfig ["git" "svnSupport"] false; # for git-svn support
    guiSupport = getConfig ["git" "guiSupport"] false;
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey subversion];
  };

  qgit = import ./qgit {
    inherit fetchurl stdenv;
    inherit (xlibs) libXext libX11;
    qt = qt4;
  };

  qgitGit = import ./qgit/qgit-git.nix {
    inherit fetchurl sourceFromHead stdenv;
    inherit (xlibs) libXext libX11;
    qt = qt4;
  };


  stgit = import ./stgit {
        inherit fetchurl stdenv python git;
  };

  topGit = stdenv.mkDerivation {
    name = "TopGit-git"; # official release 0.8
    # REGION AUTO UPDATE:    { name = "topGit"; type="git"; url="http://repo.or.cz/w/topgit.git"; }
    src = sourceFromHead "topGit-f59e4f9e87e5f485fdaee0af002edd2105fa298a.tar.gz"
                 (fetchurl { url = "http://mawercer.de/~nix/repos/topGit-f59e4f9e87e5f485fdaee0af002edd2105fa298a.tar.gz"; sha256 = "12aa6d34c82d505066b851e24069fe9d6930d70913b7d94a0cc6e8f06f127170"; });
    # END
    phases="unpackPhase patchPhase installPhase";
    installPhase = ''
      mkdir -p $out/etc/bash_completion.d
      make prefix=$out \
        install
      mv contrib/tg-completion.bash $out/etc/bash_completion.d
    '';
    meta = {
      description = "TopGit aims to make handling of large amount of interdependent topic branches easier";
      maintainers = [lib.maintainers.marcweber];
      homepage = http://repo.or.cz/w/topgit.git; # maybe there is also another one, I haven't checked
      license = "GPLv2";
    };
  };

  tig = stdenv.mkDerivation {
    name = "tig-0.14.1";
    src = fetchurl {
      url = "http://jonas.nitro.dk/tig/releases/tig-0.14.1.tar.gz";
      sha256 = "1a8mi1pv36v67n31vs95gcibkifnqq5s1x69lz1cz0218yv9s73r";
    };
    buildInputs = [ncurses asciidoc xmlto docbook_xsl];
    installPhase = ''
      make install
      make install-doc
    '';
    meta = {
      description = "console git repository browser that additionally can act as a pager for output from various git commands";
      homepage = http://jonas.nitro.dk/tig/;
      license = "GPLv2";
    };
  };

  gitFastExport = import ./fast-export {
    inherit fetchurl sourceFromHead stdenv mercurial coreutils git makeWrapper
      subversion;
  };

}
