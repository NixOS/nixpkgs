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

  delta = callPackage ./delta {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  diff-so-fancy = callPackage ./diff-so-fancy { };

  gh = callPackage ./gh { };

  ghorg = callPackage ./ghorg { };

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

  git-brunch = pkgs.haskellPackages.git-brunch;

  git-appraise = callPackage ./git-appraise {};

  git-bug = callPackage ./git-bug { };

  # support for bugzilla
  git-bz = callPackage ./git-bz { };

  git-chglog = callPackage ./git-chglog { };

  git-cinnabar = callPackage ./git-cinnabar { };

  git-codeowners = callPackage ./git-codeowners { };

  git-codereview = callPackage ./git-codereview { };

  git-cola = callPackage ./git-cola { };

  git-crypt = callPackage ./git-crypt { };

  git-delete-merged-branches = callPackage ./git-delete-merged-branches { };

  git-dit = callPackage ./git-dit {
    inherit (darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  git-doc = lib.addMetaAttrs {
    description = "Additional documentation for Git";
    longDescription = ''
      This package contains additional documentation (HTML and text files) that
      is referenced in the man pages of Git.
    '';
  } gitFull.doc;

  git-extras = callPackage ./git-extras { };

  git-fame = callPackage ./git-fame {};

  git-fast-export = callPackage ./fast-export { mercurial = mercurial_4; };

  git-filter-repo = callPackage ./git-filter-repo {
    pythonPackages = python3Packages;
  };

  git-gone = callPackage ./git-gone {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-hub = callPackage ./git-hub { };

  git-ignore = callPackage ./git-ignore { };

  git-imerge = python3Packages.callPackage ./git-imerge { };

  git-interactive-rebase-tool = callPackage ./git-interactive-rebase-tool {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  git-machete = python3Packages.callPackage ./git-machete { };

  git-my = callPackage ./git-my { };

  git-octopus = callPackage ./git-octopus { };

  git-open = callPackage ./git-open { };

  git-radar = callPackage ./git-radar { };

  git-recent = callPackage ./git-recent {
    util-linux = if stdenv.isLinux then util-linuxMinimal else util-linux;
  };

  git-remote-codecommit = python3Packages.callPackage ./git-remote-codecommit { };

  git-remote-gcrypt = callPackage ./git-remote-gcrypt { };

  git-remote-hg = callPackage ./git-remote-hg { };

  git-reparent = callPackage ./git-reparent { };

  git-secret = callPackage ./git-secret { };

  git-secrets = callPackage ./git-secrets { };

  git-standup = callPackage ./git-standup { };

  git-stree = callPackage ./git-stree { };

  git-subrepo = callPackage ./git-subrepo { };

  git-subset = callPackage ./git-subset {
    inherit (darwin.apple_sdk.frameworks) Security;
  };

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

  gitbatch = callPackage ./gitbatch { };

  gitflow = callPackage ./gitflow { };

  gitin = callPackage ./gitin { };

  gitstatus = callPackage ./gitstatus { };

  gitui = callPackage ./gitui {
    inherit (darwin.apple_sdk.frameworks) Security AppKit;
    inherit (pkgs) openssl perl;
  };

  glab = callPackage ./glab { };

  grv = callPackage ./grv { };

  hub = callPackage ./hub { };

  lab = callPackage ./lab { };

  lefthook = callPackage ./lefthook {
    # Please use empty attrset once upstream bugs have been fixed
    # https://github.com/Arkweid/lefthook/issues/151
    buildGoModule = buildGo114Module;
  };

  legit = callPackage ./legit { };

  pass-git-helper = python3Packages.callPackage ./pass-git-helper { };

  pre-commit = pkgs.python3Packages.toPythonApplication pkgs.python3Packages.pre-commit;

  qgit = qt5.callPackage ./qgit { };

  rs-git-fsmonitor = callPackage ./rs-git-fsmonitor { };

  scmpuff = callPackage ./scmpuff { };

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

  git-vanity-hash = callPackage ./git-vanity-hash { };

  ydiff = pkgs.python3.pkgs.toPythonApplication pkgs.python3.pkgs.ydiff;

} // lib.optionalAttrs (config.allowAliases or true) (with self; {
  # aliases
  darcsToGit = darcs-to-git;
  gitAnnex = git-annex;
  gitBrunch = git-brunch;
  gitFastExport = git-fast-export;
  gitRemoteGcrypt = git-remote-gcrypt;
  svn_all_fast_export = svn-all-fast-export;
  topGit = top-git;
});
in
  self
