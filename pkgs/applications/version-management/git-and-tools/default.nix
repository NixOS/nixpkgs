/* moving all git tools into one attribute set because git is unlikely to be
 * referenced by other packages and you can get a fast overview.
*/
args: with args; with pkgs;
let
  inherit (pkgs) stdenv fetchurl subversion;
  config = getPkgConfig "git";
in
rec {

  git = lib.makeOverridable (import ./git) {
    inherit fetchurl stdenv curl openssl zlib expat perl python gettext
      asciidoc texinfo xmlto docbook2x
      docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion;
    svnSupport = config "svnSupport" false; # for git-svn support
    guiSupport = config "guiSupport" false;
    sendEmailSupport = config "sendEmailSupport" false;
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey];
    smtpPerlLibs = [
      perlPackages.NetSMTP perlPackages.NetSMTPSSL
      perlPackages.IOSocketSSL perlPackages.NetSSLeay
      perlPackages.MIMEBase64 perlPackages.AuthenSASL
      perlPackages.DigestHMAC
    ];
  };

  # The full-featured Git.
  gitFull = git.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = stdenv.isDarwin == false;
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
    name = "tig-0.16";
    src = fetchurl {
      url = "http://jonas.nitro.dk/tig/releases/tig-0.16.tar.gz";
      sha256 = "167kak44n66wqjj6jrv8q4ijjac07cw22rlpqjqz3brlhx4cb3ix";
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

  git2cl = import ./git2cl {
    inherit fetchgit stdenv perl;
  };

  gitSubtree = stdenv.mkDerivation {
    name = "git-subtree-0.3";
    src = fetchurl {
      url = "http://github.com/apenwarr/git-subtree/tarball/v0.3";
#      sha256 = "0y57lpbcc2142jgrr4lflyb9xgzs9x33r7g4b919ncn3alb95vdr";
      sha256 = "f2ccac1e9cff4c35d989dc2a5581133c96b72d96c6a5ed89e51b6446dadac03f";
    };
    unpackCmd = "gzip -d < $curSrc | tar xvf -";
    buildInputs = [ git asciidoc xmlto docbook_xsl docbook_xml_dtd_45 libxslt ];
    configurePhase = "export prefix=$out";
    buildPhase = "true";
    installPhase = ''
      make install prefix=$out gitdir=$out/bin #work around to deal with a wrong makefile
    '';
    meta= {
      description = "An experimental alternative to the git-submodule command";
      homepage = http://github.com/apenwarr/git-subtree;
      license = "GPLv2";
    };
  };
}
