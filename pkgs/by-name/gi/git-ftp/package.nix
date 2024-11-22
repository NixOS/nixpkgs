{ lib
, resholve
, fetchFromGitHub
, fetchpatch
, bash
, coreutils
, git
, gnugrep
, gawk
, curl
, hostname
, gnused
, findutils
, lftp
, pandoc
, man
}:

resholve.mkDerivation rec {
  pname = "git-ftp";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "git-ftp";
    repo = "git-ftp";
    rev = version;
    sha256 = "1hxkqf7jbrx24q18yxpnd3dxzh4xk6asymwkylp1x7zg6mcci87d";
  };

  dontBuild = true;

  # fix bug/typo; PRed upstream @
  # https://github.com/git-ftp/git-ftp/pull/628
  patches = [
    (fetchpatch {
      name = "fix-function-invocation-typo.patch";
      url = "https://github.com/git-ftp/git-ftp/commit/cddf7cbba80e710758f6aac0ec0d77552ea8cd75.patch";
      sha256 = "sha256-2B0QaMJi78Bg3bA1jp41aiyql1/LCryoaDs7+xmS1HY=";
    })
  ];

  installPhase = ''
    make install-all prefix=$out
  '';

  nativeBuildInputs = [ pandoc man ];

  solutions = {
    git-ftp = {
      scripts = [ "bin/git-ftp" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        git
        gnugrep
        gawk
        curl
        hostname
        gnused
        findutils
        lftp
      ];
      fake = {
        # don't resolve impure system macOS security
        # caution: will still be fragile if PATH is bad
        # TODO: fixable once we figure out how to handle
        # this entire class of problem...
        "external" = [ "security" ];
      };
      keep = {
        # looks like run-time user/env/git-config controlled
        "$GIT_PAGER" = true;
        "$hook" = true; # presumably git hooks given context
      };
      execer = [
        # TODO: rm when binlore/resholve handle git; manually
        # checked and see no obvious subexec for now
        "cannot:${git}/bin/git"
        /*
        Mild uncertainty here. There *are* commandlikes in
        the arguments (especially wait & cd), but I think they are
        fine as-is, because I'm reading them as:
        1. ftp commands
        2. running on the remote anyways

        See https://github.com/git-ftp/git-ftp/blob/057f7d8e9f00ffc5a8c6ceaa4be30af2939df41a/git-ftp#L1214-L1221
        */
        "cannot:${lftp}/bin/lftp"
      ];
    };
  };

  meta = with lib; {
    description = "Git powered FTP client written as shell script";
    homepage = "https://git-ftp.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tweber ];
    platforms = platforms.unix;
    mainProgram = "git-ftp";
  };
}
