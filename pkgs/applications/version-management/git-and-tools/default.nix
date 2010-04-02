/* moving all git tools into one attribute set because git is unlikely to be
 * referenced by other packages and you can get a fast overview.
*/
args: with args; with pkgs;
let
  inherit (pkgs) stdenv fetchurl subversion;
  config = getPkgConfig "git";
in
rec {

  git = import ./git {
    inherit fetchurl stdenv curl openssl zlib expat perl python gettext
      asciidoc texinfo xmlto docbook2x
      docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion;
    svnSupport = config "svnSupport" false; # for git-svn support
    guiSupport = config "guiSupport" false;
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey];
  };

  # The full-featured Git.
  gitFull = import ./git rec {
    inherit fetchurl stdenv curl openssl zlib expat perl python gettext
      asciidoc texinfo xmlto docbook2x
      docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion;
    svnSupport = true;
    guiSupport = true;
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey];
  };

  gitGit = import ./git/git-git.nix {
    inherit fetchurl sourceFromHead stdenv curl openssl zlib expat perl gettext
      asciidoc texinfo xmlto docbook2x
      docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion autoconf;
    svnSupport = config "svnSupport" false; # for git-svn support
    guiSupport = config "guiSupport" false;
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

  topGit = stdenv.mkDerivation rec {
    name = "topgit-0.8";

    src = fetchgit {
      url = "http://repo.or.cz/r/topgit.git";
      rev = name;
      sha256 = "14g233hk70xs51h4jqyivjfqnwmjjpc95fjb7wdny64i9ddz03aj";
    };

    configurePhase = "export prefix=$out";

    postInstall = ''
      mkdir -p "$out/share/doc/${name}"
      cp -v README "$out/share/doc/${name}"

      mkdir -p $out/etc/bash_completion.d
      make prefix=$out \
        install
      mv contrib/tg-completion.bash $out/etc/bash_completion.d
    '';

    meta = {
      description = "TopGit aims to make handling of large amount of interdependent topic branches easier";
      maintainers = [ lib.maintainers.marcweber lib.maintainers.ludo ];
      homepage = http://repo.or.cz/w/topgit.git; # maybe there is also another one, I haven't checked
      license = "GPLv2";
      platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
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
