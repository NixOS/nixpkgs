/* All git-relates tools live here, in a separate attribute set so that users
 * can get a fast overview over what's available.
 */
args @ {pkgs}: with args; with pkgs;
let
  inherit (pkgs) stdenv fetchgit fetchurl subversion;

  gitBase = lib.makeOverridable (import ./git) {
    inherit fetchurl stdenv curl openssl zlib expat perl python gettext gnugrep
      asciidoc xmlto docbook2x docbook_xsl docbook_xml_dtd_45 libxslt cpio tcl
      tk makeWrapper subversionClient gzip openssh libiconv;
    texinfo = texinfo5;
    svnSupport = false;         # for git-svn support
    guiSupport = false;         # requires tcl/tk
    sendEmailSupport = false;   # requires plenty of perl libraries
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
  # Try to keep this generally alphabetized

  darcsToGit = callPackage ./darcs-to-git { };

  git = appendToName "minimal" gitBase;

  # The full-featured Git.
  gitFull = gitBase.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = !stdenv.isDarwin;
  };

  # Git with SVN support, but without GUI.
  gitSVN = lowPrio (appendToName "with-svn" (gitBase.override {
    svnSupport = true;
  }));

  git-annex = pkgs.haskellPackages.git-annex-with-assistant;
  gitAnnex = git-annex;

  git-annex-remote-b2 = pkgs.goPackages.git-annex-remote-b2;

  # support for bugzilla
  git-bz = callPackage ./git-bz { };

  git-cola = callPackage ./git-cola { };

  git-crypt = callPackage ./git-crypt { };

  git-extras = callPackage ./git-extras { };

  git-imerge = callPackage ./git-imerge { };

  git-radar = callPackage ./git-radar { };

  git-remote-hg = callPackage ./git-remote-hg { };

  git-stree = callPackage ./git-stree { };

  git2cl = import ./git2cl {
    inherit fetchgit stdenv perl;
  };

  gitFastExport = import ./fast-export {
    inherit fetchgit stdenv mercurial coreutils git makeWrapper subversion;
  };

  gitRemoteGcrypt = callPackage ./git-remote-gcrypt { };

  gitflow = callPackage ./gitflow { };

  hub = import ./hub {
    inherit go;
    inherit stdenv fetchgit;
    inherit (darwin) Security;
  };

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

  subgit = callPackage ./subgit { };

  svn2git = import ./svn2git {
    inherit stdenv fetchurl ruby makeWrapper;
    git = gitSVN;
  };

  svn2git_kde = callPackage ./svn2git-kde { };

  tig = callPackage ./tig { };

  topGit = lib.makeOverridable (import ./topgit) {
    inherit stdenv fetchurl;
  };

  transcrypt = callPackage ./transcrypt { };
}
