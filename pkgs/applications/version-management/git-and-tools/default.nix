/* All git-relates tools live here, in a separate attribute set so that users
 * can get a fast overview over what's available.
 */
args @ {config, lib, pkgs}: with args; with pkgs;
let
  gitBase = callPackage ./git {
    svnSupport = false;         # for git-svn support
    guiSupport = false;         # requires tcl/tk
    sendEmailSupport = false;   # requires plenty of perl libraries
    perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey];
    smtpPerlLibs = [
      perlPackages.libnet perlPackages.NetSMTPSSL
      perlPackages.IOSocketSSL perlPackages.NetSSLeay
      perlPackages.AuthenSASL perlPackages.DigestHMAC
    ];
  };

  self = rec {
  # Try to keep this generally alphabetized

  bfg-repo-cleaner = callPackage ./bfg-repo-cleaner { };

  bitbucket-server-cli = callPackage ./bitbucket-server-cli { };

  bump2version = pkgs.python37Packages.callPackage ./bump2version { };

  darcs-to-git = callPackage ./darcs-to-git { };

  delta = callPackage ./delta { };

  diff-so-fancy = callPackage ./diff-so-fancy { };

  gh = callPackage ./gh {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  ghq = callPackage ./ghq { };

  git = appendToName "minimal" gitBase;

  git-absorb = callPackage ./git-absorb {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-annex = pkgs.haskellPackages.git-annex;

  git-annex-metadata-gui = libsForQt5.callPackage ./git-annex-metadata-gui {
    inherit (python3Packages) buildPythonApplication pyqt5 git-annex-adapter;
  };

  git-annex-remote-b2 = callPackage ./git-annex-remote-b2 { };

  git-annex-remote-dbx = callPackage ./git-annex-remote-dbx {
    inherit (python3Packages)
    buildPythonApplication
    fetchPypi
    dropbox
    annexremote
    humanfriendly;
  };

  git-annex-remote-rclone = callPackage ./git-annex-remote-rclone { };

  git-annex-utils = callPackage ./git-annex-utils { };

  git-appraise = callPackage ./git-appraise {};

  git-bug = callPackage ./git-bug { };

  # support for bugzilla
  git-bz = callPackage ./git-bz { };

  git-codeowners = callPackage ./git-codeowners { };

  git-codereview = callPackage ./git-codereview { };

  git-cola = callPackage ./git-cola { };

  git-crypt = callPackage ./git-crypt { };

  git-dit = callPackage ./git-dit {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  git-extras = callPackage ./git-extras { };

  git-fame = callPackage ./git-fame {};

  git-fast-export = callPackage ./fast-export { };

  git-filter-repo = callPackage ./git-filter-repo {
    pythonPackages = python3Packages;
  };

  git-gone = callPackage ./git-gone {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-hub = callPackage ./git-hub { };

  git-ignore = callPackage ./git-ignore { };

  git-imerge = callPackage ./git-imerge { };

  git-interactive-rebase-tool = callPackage ./git-interactive-rebase-tool {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-machete = python3Packages.callPackage ./git-machete { };

  git-my = callPackage ./git-my { };

  git-octopus = callPackage ./git-octopus { };

  git-open = callPackage ./git-open { };

  git-radar = callPackage ./git-radar { };

  git-recent = callPackage ./git-recent {
    utillinux = if stdenv.isLinux then utillinuxMinimal else utillinux;
  };

  git-remote-gcrypt = callPackage ./git-remote-gcrypt { };

  git-remote-hg = callPackage ./git-remote-hg { };

  git-reparent = callPackage ./git-reparent { };

  git-secret = callPackage ./git-secret { };

  git-secrets = callPackage ./git-secrets { };

  git-standup = callPackage ./git-standup { };

  git-stree = callPackage ./git-stree { };

  git-subrepo = callPackage ./git-subrepo { };

  git-subtrac = callPackage ./git-subtrac { };

  git-sync = callPackage ./git-sync { };

  git-test = callPackage ./git-test { };

  git-trim = callPackage ./git-trim {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-workspace = callPackage ./git-workspace {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git2cl = callPackage ./git2cl { };

  # The full-featured Git.
  gitFull = gitBase.override {
    svnSupport = true;
    guiSupport = true;
    sendEmailSupport = true;
    withLibsecret = !stdenv.isDarwin;
  };

  # Git with SVN support, but without GUI.
  gitSVN = lowPrio (appendToName "with-svn" (gitBase.override {
    svnSupport = true;
  }));

  gita = python3Packages.callPackage ./gita {};

  gitflow = callPackage ./gitflow { };

  gitstatus = callPackage ./gitstatus { };

  grv = callPackage ./grv { };

  hub = callPackage ./hub {
    inherit (darwin) Security;
  };

  lab = callPackage ./lab { };

  lefthook = callPackage ./lefthook { };

  pass-git-helper = python3Packages.callPackage ./pass-git-helper { };

  pre-commit = pkgs.python3Packages.toPythonApplication pkgs.python3Packages.pre-commit;

  qgit = qt5.callPackage ./qgit { };

  stgit = callPackage ./stgit { };

  subgit = callPackage ./subgit { };

  svn-all-fast-export = libsForQt5.callPackage ./svn-all-fast-export { };

  svn2git = callPackage ./svn2git {
    git = gitSVN;
  };

  thicket = callPackage ./thicket { };

  tig = callPackage ./tig { };

  top-git = callPackage ./topgit { };

  transcrypt = callPackage ./transcrypt { };

  ydiff = pkgs.python3.pkgs.toPythonApplication pkgs.python3.pkgs.ydiff;

} // lib.optionalAttrs (config.allowAliases or true) (with self; {
  # aliases
  darcsToGit = darcs-to-git;
  gitAnnex = git-annex;
  gitFastExport = git-fast-export;
  gitRemoteGcrypt = git-remote-gcrypt;
  svn_all_fast_export = svn-all-fast-export;
  topGit = top-git;
});
in
  self
