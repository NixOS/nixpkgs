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
    gitwebPerlLibs = with perlPackages; [ CGI HTMLParser ];
  };

in
rec {
  # Try to keep this generally alphabetized

  bitbucket-server-cli = callPackage ./bitbucket-server-cli { };

  darcsToGit = callPackage ./darcs-to-git { };

  diff-so-fancy = callPackage ./diff-so-fancy { };

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

  git-annex = pkgs.haskellPackages.git-annex;
  gitAnnex = git-annex;

  git-annex-remote-b2 = callPackage ./git-annex-remote-b2 { };

  git-annex-remote-rclone = callPackage ./git-annex-remote-rclone { };

  # support for bugzilla
  git-bz = callPackage ./git-bz { };

  git-cola = callPackage ./git-cola { };

  git-crypt = callPackage ./git-crypt { };

  git-extras = callPackage ./git-extras { };

  git-hub = callPackage ./git-hub { };

  git-imerge = callPackage ./git-imerge { };

  git-radar = callPackage ./git-radar { };

  git-remote-hg = callPackage ./git-remote-hg { };

  git-stree = callPackage ./git-stree { };

  git2cl = callPackage ./git2cl { };

  gitFastExport = callPackage ./fast-export { };

  gitRemoteGcrypt = callPackage ./git-remote-gcrypt { };

  gitflow = callPackage ./gitflow { };

  hub = callPackage ./hub {
    inherit (darwin) Security;
  };

  qgit = callPackage ./qgit { };

  stgit = callPackage ./stgit {
  };

  subgit = callPackage ./subgit { };

  svn2git = callPackage ./svn2git {
    git = gitSVN;
  };

  svn2git_kde = callPackage ./svn2git-kde { };

  tig = callPackage ./tig { };

  topGit = callPackage ./topgit { };

  transcrypt = callPackage ./transcrypt { };
}
