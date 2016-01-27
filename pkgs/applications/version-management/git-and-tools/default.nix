/* All git-relates tools live here, in a separate attribute set so that users
 * can get a fast overview over what's available.
 */
args @ {pkgs}: with args; with pkgs;
let
  inherit (pkgs) stdenv fetchgit fetchurl subversion;

  gitBase = lib.makeOverridable (import ./git) {
    inherit fetchurl stdenv curl openssl zlib expat perl python gettext gnugrep
      asciidoc xmlto docbook2x docbook_xsl docbook_xml_dtd_45 libxslt cpio tcl
      tk makeWrapper subversionClient gzip libiconv;
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

in
rec {

  # support for bugzilla
  git-bz = callPackage ./git-bz { };

  git = appendToName "minimal" gitBase;

  # Git with SVN support, but without GUI.
  gitSVN = lowPrio (appendToName "with-svn" (gitBase.override {
    svnSupport = true;
  }));

  # The full-featured Git.
  gitFull = gitBase.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = !stdenv.isDarwin;
  };

  git-annex = pkgs.haskellPackages.git-annex-with-assistant;
  gitAnnex = git-annex;

  git-annex-remote-b2 = pkgs.goPackages.git-annex-remote-b2;

  qgit = import ./qgit {
    inherit fetchurl stdenv;
    inherit (xorg) libXext libX11;
    qt = qt4;
  };

  qgitGit = import ./qgit/qgit-git.nix {
    inherit fetchurl sourceFromHead stdenv;
    inherit (xorg) libXext libX11;
    qt = qt4;
  };

  stgit = import ./stgit {
    inherit fetchurl stdenv python git;
  };

  topGit = lib.makeOverridable (import ./topgit) {
    inherit stdenv fetchurl;
  };

  tig = callPackage ./tig { };

  transcrypt = callPackage ./transcrypt { };

  hub = import ./hub {
    inherit go;
    inherit stdenv fetchgit;
    inherit (darwin) Security;
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

  subgit = callPackage ./subgit { };

  darcsToGit = callPackage ./darcs-to-git { };

  gitflow = callPackage ./gitflow { };

  git-radar = callPackage ./git-radar { };

  git-remote-hg = callPackage ./git-remote-hg { };

  gitRemoteGcrypt = callPackage ./git-remote-gcrypt { };

  git-extras = callPackage ./git-extras { };

  git-cola = callPackage ./git-cola { };

  git-imerge = callPackage ./git-imerge { };

  git-crypt = callPackage ./git-crypt { };
}
