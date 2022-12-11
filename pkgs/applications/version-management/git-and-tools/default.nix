{ lib, pkgs }:

lib.makeScope pkgs.newScope (self:
  let
    inherit (self) stdenv callPackage lowPrio
      darwin libsForQt5 haskellPackages perlPackages python3Packages;
  in {

    git = callPackage ./git {
      inherit (darwin.apple_sdk.frameworks) CoreServices Security;
      perlLibs = [perlPackages.LWP perlPackages.URI perlPackages.TermReadKey];
      smtpPerlLibs = [
        perlPackages.libnet perlPackages.NetSMTPSSL
        perlPackages.IOSocketSSL perlPackages.NetSSLeay
        perlPackages.AuthenSASL perlPackages.DigestHMAC
      ];
    };

    # The full-featured Git.
    gitFull = self.git.override {
      svnSupport = true;
      guiSupport = true;
      sendEmailSupport = true;
      withSsh = true;
      withLibsecret = !stdenv.isDarwin;
    };

    # Git with SVN support, but without GUI.
    gitSVN = lowPrio (self.git.override { svnSupport = true; });

    git-doc = lib.addMetaAttrs {
      description = "Additional documentation for Git";
      longDescription = ''
        This package contains additional documentation (HTML and text files)
        that is referenced in the man pages of Git.
      '';
    } self.gitFull.doc;

    gitMinimal = self.git.override {
      withManual = false;
      pythonSupport = false;
      perlSupport = false;
      withpcre2 = false;
    };

    bfg-repo-cleaner = callPackage ./bfg-repo-cleaner { };

    bit = callPackage ./bit { };

    bitbucket-server-cli = callPackage ./bitbucket-server-cli { };

    bump2version = python3Packages.callPackage ./bump2version { };

    cgit = callPackage ./cgit { };

    cgit-pink = callPackage ./cgit/pink.nix { };

    conform = callPackage ./conform { };

    darcs-to-git = callPackage ./darcs-to-git { };

    delta = callPackage ./delta {
      inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation Security;
    };

    diff-so-fancy = callPackage ./diff-so-fancy { };

    gex = callPackage ./gex { };

    gfold = callPackage ./gfold {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    gita = python3Packages.callPackage ./gita { };

    gitoxide = callPackage ./gitoxide {
      inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
    };

    gg-scm = callPackage ./gg { };

    github-cli = self.gh;
    gh = callPackage ./gh { };

    ghorg = callPackage ./ghorg { };

    ghq = callPackage ./ghq { };

    ghr = callPackage ./ghr { };

    git-absorb = callPackage ./git-absorb {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git-aggregator = callPackage ./git-aggregator { };

    git-annex-metadata-gui = libsForQt5.callPackage ./git-annex-metadata-gui {
      inherit (python3Packages) buildPythonApplication pyqt5 git-annex-adapter;
    };

    git-annex-remote-dbx = callPackage ./git-annex-remote-dbx {
      inherit (python3Packages)
        buildPythonApplication
        fetchPypi
        dropbox
        annexremote
        humanfriendly;
    };

    git-annex-remote-googledrive = callPackage ./git-annex-remote-googledrive {
      inherit (python3Packages)
        buildPythonApplication
        fetchPypi
        annexremote
        drivelib
        gitpython
        tenacity
        humanfriendly;
    };

    git-annex-remote-rclone = callPackage ./git-annex-remote-rclone { };

    git-annex-utils = callPackage ./git-annex-utils { };

    git-appraise = callPackage ./git-appraise { };

    git-backup = callPackage ./git-backup {
      openssl = self.openssl_1_1;
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git-big-picture = callPackage ./git-big-picture { };

    git-branchless = callPackage ./git-branchless {
      inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
    };

    git-bug = callPackage ./git-bug { };

    git-chglog = callPackage ./git-chglog { };

    git-cinnabar = callPackage ./git-cinnabar {
      inherit (darwin.apple_sdk.frameworks) CoreServices;
    };

    git-cliff = callPackage ./git-cliff {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git-codeowners = callPackage ./git-codeowners { };

    git-codereview = callPackage ./git-codereview { };

    git-cola = callPackage ./git-cola { };

    git-crecord = callPackage ./git-crecord { };

    git-credential-1password = callPackage ./git-credential-1password { };

    git-credential-keepassxc = callPackage ./git-credential-keepassxc {
      inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation;
    };

    git-crypt = callPackage ./git-crypt { };

    git-delete-merged-branches = callPackage ./git-delete-merged-branches { };

    git-extras = callPackage ./git-extras { };

    git-fame = callPackage ./git-fame { };

    git-fast-export = callPackage ./fast-export { };

    git-fire = callPackage ./git-fire { };

    git-ftp = callPackage ./git-ftp { };

    git-gone = callPackage ./git-gone {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git-hound = callPackage ./git-hound { };

    git-hub = callPackage ./git-hub { };

    git-ignore = callPackage ./git-ignore { };

    git-imerge = python3Packages.callPackage ./git-imerge { };

    git-interactive-rebase-tool = callPackage ./git-interactive-rebase-tool {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git-lfs = lowPrio (callPackage ./git-lfs { });

    git-my = callPackage ./git-my { };

    git-machete = python3Packages.callPackage ./git-machete { };

    git-nomad = callPackage ./git-nomad {
      inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
    };

    git-octopus = callPackage ./git-octopus { };

    git-open = callPackage ./git-open { };

    git-privacy = callPackage ./git-privacy { };

    git-publish = python3Packages.callPackage ./git-publish { };

    git-quick-stats = callPackage ./git-quick-stats { };

    git-quickfix = callPackage ./git-quickfix {
      inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
    };

    git-radar = callPackage ./git-radar { };

    git-recent = callPackage ./git-recent {
      util-linux =
        if stdenv.isLinux
        then self.util-linuxMinimal
        else self.util-linux;
    };

    git-remote-codecommit = python3Packages.callPackage ./git-remote-codecommit { };

    gitRepo = self.git-repo;
    git-repo = callPackage ./git-repo { };

    git-repo-updater = python3Packages.callPackage ./git-repo-updater { };

    git-review = python3Packages.callPackage ./git-review { };

    git-remote-gcrypt = callPackage ./git-remote-gcrypt { };

    git-remote-hg = callPackage ./git-remote-hg { };

    git-reparent = callPackage ./git-reparent { };

    git-secret = callPackage ./git-secret { };

    git-secrets = callPackage ./git-secrets { };

    git-series = callPackage ./git-series {
      openssl = self.openssl_1_1;
    };

    git-sizer = callPackage ./git-sizer { };

    git-standup = callPackage ./git-standup { };

    git-stree = callPackage ./git-stree { };

    git-subrepo = callPackage ./git-subrepo { };

    git-subset = callPackage ./git-subset {
      openssl = self.openssl_1_1;
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git-subtrac = callPackage ./git-subtrac { };

    git-sync = callPackage ./git-sync { };

    git-team = callPackage ./git-team { };

    git-test = callPackage ./git-test { };

    git-town = callPackage ./git-town { };

    git-trim = callPackage ./git-trim {
      openssl = self.openssl_1_1;
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git-up = callPackage ./git-up {
      pythonPackages = python3Packages;
    };

    git-vanity-hash = callPackage ./git-vanity-hash { };

    git-vendor = callPackage ./git-vendor { };

    git-when-merged = callPackage ./git-when-merged { };

    git-workspace = callPackage ./git-workspace {
      inherit (darwin.apple_sdk.frameworks) Security;
    };

    git2cl = callPackage ./git2cl { };

    gitbatch = callPackage ./gitbatch { };

    gitflow = callPackage ./gitflow { };

    gitfs = callPackage ../tools/filesystems/gitfs { };

    gitless = callPackage ./gitless { };

    gitlint = python3Packages.callPackage ./gitlint { };

    gitls = callPackage ./gitls { };

    gitmux = callPackage ./gitmux { };

    gitnuro = callPackage ./gitnuro { };

    gitsign = callPackage ./gitsign { };

    gitstats = callPackage ./gitstats { };

    gitstatus = callPackage ./gitstatus { };

    gitty = callPackage ./gitty { };

    gitui = callPackage ./gitui {
      inherit (darwin.apple_sdk.frameworks) Security AppKit;
    };

    gitweb = callPackage ./gitweb { };

    glab = callPackage ./glab { };

    glitter = callPackage ./glitter { };

    gst = callPackage ./gst { };

    hub = callPackage ./hub { };

    hut = callPackage ./hut { };

    josh = callPackage ./josh { };

    lab = callPackage ./lab { };

    lefthook = callPackage ./lefthook { };

    legit = callPackage ./legit { };

    lucky-commit = callPackage ./lucky-commit {
      inherit (darwin.apple_sdk.frameworks) OpenCL;
    };

    pass-git-helper = python3Packages.callPackage ./pass-git-helper { };

    qgit = qt5.callPackage ./qgit { };

    radicle-cli = callPackage ./radicle-cli {
      inherit (darwin) DarwinTools;
      inherit (darwin.apple_sdk.frameworks) AppKit;
    };

    radicle-upstream = callPackage ./radicle-upstream { };

    rs-git-fsmonitor = callPackage ./rs-git-fsmonitor { };

    scmpuff = callPackage ./scmpuff { };

    stgit = callPackage ./stgit { };

    subgit = callPackage ./subgit { };

    svn-all-fast-export = libsForQt5.callPackage ./svn-all-fast-export { };

    svn2git = callPackage ./svn2git {
      git = self.gitSVN;
    };

    thicket = callPackage ./thicket { };

    tig = callPackage ./tig {
      readline = self.readline81;
    };

    top-git = callPackage ./topgit { };

    transcrypt = callPackage ./transcrypt { };

    inherit (haskellPackages) git-annex;

    inherit (haskellPackages) git-brunch;

    git-autofixup = perlPackages.GitAutofixup;

    ghrepo-stats = with python3Packages; toPythonApplication ghrepo-stats;

    git-filter-repo = with python3Packages; toPythonApplication git-filter-repo;

    git-revise = with python3Packages; toPythonApplication git-revise;
  }
)
