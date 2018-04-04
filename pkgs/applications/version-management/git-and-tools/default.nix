/* All git-relates tools live here, in a separate attribute set so that users
 * can get a fast overview over what's available.
 */
args @ {pkgs}: with args; with pkgs;
let
  gitBase = callPackage ./git {
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
    gitwebPerlLibs = with perlPackages; [ CGI HTMLParser CGIFast FCGI FCGIProcManager HTMLTagCloud ];
  };

in
rec {
  # Try to keep this generally alphabetized

  bfg-repo-cleaner = callPackage ./bfg-repo-cleaner { };

  bitbucket-server-cli = callPackage ./bitbucket-server-cli { };

  darcsToGit = callPackage ./darcs-to-git { };

  diff-so-fancy = callPackage ./diff-so-fancy { };

  ghq = callPackage ./ghq { };

  git = appendToName "minimal" gitBase;

  git-fame = callPackage ./git-fame {};

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

  git-annex = pkgs.haskellPackages.git-annex;
  gitAnnex = git-annex;

  git-annex-metadata-gui = libsForQt5.callPackage ./git-annex-metadata-gui {
    inherit (python3Packages) buildPythonApplication pyqt5 git-annex-adapter;
  };

  git-annex-remote-b2 = callPackage ./git-annex-remote-b2 { };

  git-annex-remote-rclone = callPackage ./git-annex-remote-rclone { };

  # support for bugzilla
  git-bz = callPackage ./git-bz { };

  git-codeowners = callPackage ./git-codeowners { };

  git-cola = callPackage ./git-cola { };

  git-crypt = callPackage ./git-crypt { };

  git-dit = callPackage ./git-dit { };

  git-extras = callPackage ./git-extras { };

  git-hub = callPackage ./git-hub { };

  git-imerge = callPackage ./git-imerge { };

  git-octopus = callPackage ./git-octopus { };

  git-open = callPackage ./git-open { };

  git-radar = callPackage ./git-radar { };

  git-recent = callPackage ./git-recent {
    utillinux = if stdenv.isLinux then utillinuxMinimal else null;
  };

  git-remote-hg = callPackage ./git-remote-hg { };

  git-secret = callPackage ./git-secret { };

  git-stree = callPackage ./git-stree { };

  git2cl = callPackage ./git2cl { };

  gitFastExport = callPackage ./fast-export { };

  gitRemoteGcrypt = callPackage ./git-remote-gcrypt { };

  gitflow = callPackage ./gitflow { };

  grv = callPackage ./grv { };

  hub = callPackage ./hub {
    inherit (darwin) Security;
  };

  qgit = qt5.callPackage ./qgit { };

  stgit = callPackage ./stgit {
  };

  subgit = callPackage ./subgit { };

  svn2git = callPackage ./svn2git {
    git = gitSVN;
  };

  svn-all-fast-export = libsForQt5.callPackage ./svn-all-fast-export { };

  tig = callPackage ./tig { };

  topGit = callPackage ./topgit { };

  transcrypt = callPackage ./transcrypt { };

  # aliases
  svn_all_fast_export = svn-all-fast-export;
}
