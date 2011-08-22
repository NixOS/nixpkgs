/* moving all git tools into one attribute set because git is unlikely to be
 * referenced by other packages and you can get a fast overview.
*/
args: with args; with pkgs;
let
  inherit (pkgs) stdenv fetchurl subversion;
in
rec {

  git = lib.makeOverridable (import ./git) {
    inherit fetchurl stdenv curl openssl zlib expat perl python gettext gnugrep
      asciidoc texinfo xmlto docbook2x docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion;
    svnSupport = false;		# for git-svn support
    guiSupport = false;		# requires tcl/tk
    sendEmailSupport = false;	# requires plenty of perl libraries
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey];
    smtpPerlLibs = [
      perlPackages.NetSMTP perlPackages.NetSMTPSSL
      perlPackages.IOSocketSSL perlPackages.NetSSLeay
      perlPackages.MIMEBase64 perlPackages.AuthenSASL
      perlPackages.DigestHMAC
    ];
  };

  # Git with SVN support, but without GUI.
  gitSVN = lowPrio (appendToName "with-svn" (git.override {
    svnSupport = true;
  }));

  # The full-featured Git.
  gitFull = appendToName "full" (git.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = stdenv.isDarwin == false;
  });

  gitGit = import ./git/git-git.nix {
    inherit fetchurl sourceFromHead stdenv curl openssl zlib expat perl gettext
      asciidoc texinfo xmlto docbook2x
      docbook_xsl docbook_xml_dtd_45 libxslt
      cpio tcl tk makeWrapper subversion autoconf;
    svnSupport = false;
    guiSupport = false;
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey subversion];
  };

  gitAnnex = lib.makeOverridable (import ./git-annex) {
    inherit stdenv fetchurl libuuid rsync findutils curl perl git ikiwiki which;
    inherit (haskellPackages) ghc MissingH utf8String QuickCheck2 pcreLight SHA dataenc
      HTTP testpack monadControl;
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

  topGit = lib.makeOverridable (import ./topgit) {
    inherit stdenv fetchurl unzip;
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

  svn2git = import ./svn2git {
    inherit stdenv fetchgit qt47 subversion apr;
  };

  gitSubtree = stdenv.mkDerivation {
    name = "git-subtree-0.4";
    src = fetchurl {
      url = "http://github.com/apenwarr/git-subtree/tarball/v0.4";
#      sha256 = "0y57lpbcc2142jgrr4lflyb9xgzs9x33r7g4b919ncn3alb95vdr";
      sha256 = "19s8352igwh7x1nqgdfs7rgxahw9cnfv7zmpzpd63m1r3l2945d4";
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
