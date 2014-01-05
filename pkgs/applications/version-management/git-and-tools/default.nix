/* moving all git tools into one attribute set because git is unlikely to be
 * referenced by other packages and you can get a fast overview.
*/
args: with args; with pkgs;
let
  inherit (pkgs) stdenv fetchgit fetchurl subversion;
in
rec {

  git = lib.makeOverridable (import ./git) {
    inherit fetchurl stdenv curl openssl zlib expat perl python gettext gnugrep
      asciidoc xmlto docbook2x docbook_xsl docbook_xml_dtd_45 libxslt cpio tcl
      tk makeWrapper subversionClient gzip;
    texinfo = texinfo5;
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

  # support for bugzilla
  gitBz = import ./git-bz {
    inherit fetchgit stdenv makeWrapper python asciidoc xmlto # docbook2x docbook_xsl docbook_xml_dtd_45 libxslt
      ;
    inherit (pythonPackages) pysqlite;
  };

  # Git with SVN support, but without GUI.
  gitSVN = lowPrio (appendToName "with-svn" (git.override {
    svnSupport = true;
  }));

  # The full-featured Git.
  gitFull = appendToName "full" (git.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = !stdenv.isDarwin;
  });

  gitAnnex = pkgs.haskellPackages.gitAnnex;

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
    inherit stdenv fetchurl;
  };

  tig = import ./tig {
    inherit stdenv fetchurl ncurses asciidoc xmlto docbook_xsl docbook_xml_dtd_45;
  };

  hub = import ./hub {
    inherit (rubyLibs) rake;
    inherit stdenv fetchurl groff makeWrapper;
  };

  gitFastExport = import ./fast-export {
    inherit fetchgit stdenv mercurial coreutils git makeWrapper subversion;
  };

  git2cl = import ./git2cl {
    inherit fetchgit stdenv perl;
  };

  svn2git = import ./svn2git {
    inherit stdenv fetchurl ruby makeWrapper;
    git = gitSVN;
  };

  svn2git_kde = callPackage ./svn2git-kde { };

  darcsToGit = callPackage ./darcs-to-git { };

  gitflow = callPackage ./gitflow { };
}
