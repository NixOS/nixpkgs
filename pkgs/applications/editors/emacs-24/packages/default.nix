{ pkgs, stdenv, fetchurl, fetchFromGitHub, fetchgit
, emacs, texinfo

# non-emacs packages
, external
}:

# package.el-based emacs packages

## init.el
# (require 'package)
# (setq package-archives nil
#       package-user-dir "~/.nix-profile/share/emacs/site-lisp/elpa")
# (package-initialize)


let
  melpa = import ./melpa.nix { 
    inherit stdenv fetchurl emacs texinfo;
  };
in

rec {
  ace-jump-mode = melpa.mkDerivation (self: {
    pname   = "ace-jump-mode";
    version = "20140616";
    src = fetchFromGitHub {
      owner  = "winterTTr";
      repo   = self.pname;
      rev    = "8351e2df4fbbeb2a4003f2fb39f46d33803f3dac";
      sha256 = "17axrgd99glnl6ma4ls3k01ysdqmiqr581wnrbsn3s4gp53mm2x6";
    };
  });

  ag = melpa.mkDerivation (self: {
    pname   = "ag";
    version = "0.44";
    src = fetchFromGitHub {
      owner  = "Wilfred";
      repo   = "${self.pname}.el";
      rev    = self.version;
      sha256 = "19y5w9m2flp4as54q8yfngrkri3kd7fdha9pf2xjgx6ryflqx61k";
    };
    packageRequires = [ dash s ];
  });
  
  async = melpa.mkDerivation (self: {
    pname   = "async";
    version = "1.2";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = "emacs-async";
      rev    = "v${self.version}";
      sha256 = "1j6mbvvbnm2m1gpsy9ipxiv76b684nn57yssbqdyiwyy499cma6q";
    };
  });

  auctex = melpa.mkDerivation (self: {
    pname   = "auctex";
    version = "11.87.7";
    src = fetchurl {
      url    = "http://elpa.gnu.org/packages/${self.fname}.tar";
      sha256 = "07bhw8zc3d1f2basjy80njmxpsp4f70kg3ynkch9ghlai3mm2b7n";
    };
    buildPhase = ''
      cp $src ${self.fname}.tar
    '';
  });
  
  auto-complete = melpa.mkDerivation (self: {
    pname = "auto-complete";
    version = "1.3.1";
    src = fetchurl {
      url = "http://cx4a.org/pub/auto-complete/${self.fname}.tar.bz2";
      sha256 = "124qxfp0pcphwlmrasbfrci48brxnrzc38h4wcf2sn20x1mvcrlj";
    };
    meta = {
      description = "Auto-complete extension for Emacs";
      homepage = http://cx4a.org/software/auto-complete/;
      license = stdenv.lib.licenses.gpl3Plus;
      platforms = stdenv.lib.platforms.all;
    };
  });

  bind-key = melpa.mkDerivation (self: {
    pname   = "bind-key";
    version = "20141013";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = "use-package";
      rev    = "d43af5e0769a92f77e01dea229e376d9006722ef";
      sha256 = "1m4v5h52brg2g9rpbqfq9m3m8fv520vg5mjwppnbw6099d17msqd";
    };
    files = [ "bind-key.el" ];
  });

  change-inner = melpa.mkDerivation (self: {
    pname   = "change-inner";
    version = "20130208";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${self.pname}.el";
      rev    = "6374b745ee1fd0302ad8596cdb7aca1bef33a730";
      sha256 = "1fv8630bqbmfr56zai08f1q4dywksmghhm70084bz4vbs6rzdsbq";
    };
    packageRequires = [ expand-region ];
  });

  circe = melpa.mkDerivation (self: {
    pname   = "circe";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${self.version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    packageRequires = [ lcs lui ];
    fileSpecs = [ "lisp/circe*.el" ];
  });

  company-mode = melpa.mkDerivation (self: {
    pname   = "company-mode";
    version = "0.8.6";
    src = fetchFromGitHub {
      owner  = "company-mode";
      repo   = "company-mode";
      rev    = self.version;
      sha256 = "1xwxyqg5dan8m1qkdxyzm066ryf24h07karpdlm3s09izfdny33f";
    };
  });

  dash = melpa.mkDerivation (self: {
    pname   = "dash";
    version = "2.9.0";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${self.pname}.el";
      rev    = self.version;
      sha256 = "1lg31s8y6ljsz6ps765ia5px39wim626xy8fbc4jpk8fym1jh7ay";
    };
  });

  diminish = melpa.mkDerivation (self: {
    pname   = "diminish";
    version = "0.44";
    src = fetchFromGitHub {
      owner  = "emacsmirror";
      repo   = self.pname;
      rev    = self.version;
      sha256 = "0hshw7z5f8pqxvgxw74kbj6nvprsgfvy45fl854xarnkvqcara09";
    };
  });

  epl = melpa.mkDerivation (self: {
    pname   = "epl";
    version = "20140823";
    src = fetchFromGitHub {
      owner  = "cask";
      repo   = self.pname;
      rev    = "63c78c08e345455f3d4daa844fdc551a2c18024e";
      sha256 = "04a2aq8dj2cmy77vw142wcmnjvqdbdsp6z0psrzz2qw0b0am03li";
    };
  });

  evil-god-state = melpa.mkDerivation (self: {
    pname   = "evil-god-state";
    version = "20140830";
    src = fetchFromGitHub {
      owner  = "gridaphobe";
      repo   = self.pname;
      rev    = "234a9b6f500ece89c3dfb5c1df5baef6963e4566";
      sha256 = "16v6dpw1hibrkf9hga88gv5axvp1pajd67brnh5h4wpdy9qvwgyy";
    };
    packageRequires = [ evil god-mode ];
  });

  evil-surround = melpa.mkDerivation (self: {
    pname   = "evil-surround";
    version = "20140616";
    src = fetchFromGitHub {
      owner  = "timcharper";
      repo   = self.pname;
      rev    = "71f380b6b6ed38f739c0a4740b3d6de0c52f915a";
      sha256 = "0wrmlmgr4mwxlmmh8blplddri2lpk4g8k3l1vpb5c6a975420qvn";
    };
    packageRequires = [ evil ];
  });

  evil = melpa.mkDerivation (self: {
    pname   = "evil";
    version = "20141020";
    src = fetchgit {
      url = "git://gitorious.org/evil/evil";
      rev = "999ec15587f85100311c031aa8efb5d50c35afe4";
      sha256 = "0yiqpzsm5sr7xdkixdvfg312dk9vsdcmj69gizk744d334yn8rsz";
    };
    packageRequires = [ goto-chg undo-tree ];
  });

  exec-path-from-shell = melpa.mkDerivation (self: {
    pname   = "exec-path-from-shell";
    version = "20141022";
    src = fetchFromGitHub {
      owner  = "purcell";
      repo   = self.pname;
      rev    = "e4af0e9b44738e7474c89ed895200b42e6541515";
      sha256 = "0lxikiqf1jik88lf889q4f4f8kdgg3npciz298x605nhbfd5snbd";
    };
  });

  expand-region = melpa.mkDerivation (self: {
    pname   = "expand-region";
    version = "20141012";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${self.pname}.el";
      rev    = "fa413e07c97997d950c92d6012f5442b5c3cee78";
      sha256 = "04k0518wfy72wpzsswmncnhd372fxa0r8nbfhmbyfmns8n7sr045";
    };
  });

  flycheck-pos-tip = melpa.mkDerivation (self: {
    pname   = "flycheck-pos-tip";
    version = "20140813";
    src = fetchFromGitHub {
      owner  = "flycheck";
      repo   = self.pname;
      rev    = "5b3a203bbdb03e4f48d1654efecd71f44376e199";
      sha256 = "0b4x24aq0jh4j4bjv0fqyaz6hzh3gqf57k9763jj9rl32cc3dpnp";
    };
    packageRequires = [ flycheck popup ];
  });

  flycheck = melpa.mkDerivation (self: {
    pname   = "flycheck";
    version = "0.20";
    src = fetchFromGitHub {
      owner  = self.pname;
      repo   = self.pname;
      rev    = self.version;
      sha256 = "0cq7y7ssm6phvx5pfv2yqq4j0yqmm0lhjav7v4a8ql7094cd790a";
    };
    packageRequires = [ dash pkg-info ];
  });

  ghc-mod = melpa.mkDerivation (self: {
    pname = "ghc";
    version = external.ghc-mod.version;
    src = external.ghc-mod.src;
    fileSpecs = [ "elisp/*.el" ];
  });

  git-commit-mode = melpa.mkDerivation (self: {
    pname = "git-commit-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = self.version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "git-commit-mode.el" ];
  });

  git-rebase-mode = melpa.mkDerivation (self: {
    pname = "git-rebase-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = self.version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "git-rebase-mode.el" ];
  });

  gitattributes-mode = melpa.mkDerivation (self: {
    pname = "gitattributes-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = self.version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "gitattributes-mode.el" ];
  });

  gitconfig-mode = melpa.mkDerivation (self: {
    pname = "gitconfig-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = self.version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "gitconfig-mode.el" ];
  });

  gitignore-mode = melpa.mkDerivation (self: {
    pname = "gitignore-mode";
    version = "0.15.0";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "git-modes";
      rev    = self.version;
      sha256 = "1x03276yq63cddc89n8i47k1f6p26b7a5la4hz66fdf15gmr8496";
    };
    files = [ "gitignore-mode.el" ];
  });

  gnus = melpa.mkDerivation (self: {
    pname   = "gnus";
    version = "20140501";
    src = fetchgit {
      url = "http://git.gnus.org/gnus.git";
      rev = "4228cffcb7afb77cf39678e4a8988a57753502a5";
      sha256 = "0qd0wpxkz47irxghmdpa524c9626164p8vgqs26wlpbdwyvm64a0";
    };
    fileSpecs = [ "lisp/*.el" "texi/*.texi" ];
    preBuild = ''
      (cd lisp && make gnus-load.el)
    '';
  });

  god-mode = melpa.mkDerivation (self: {
    pname   = "god-mode";
    version = "20140811";
    src = fetchFromGitHub {
      owner  = "chrisdone";
      repo   = self.pname;
      rev    = "6b7ae259a58ca1d7776aa4eca9f1092e4c0033e6";
      sha256 = "1amr98nq82g2d3f3f5wlqm9g38j64avygnsi9rrlbfqz4f71vq7x";
    };
  });

  goto-chg = melpa.mkDerivation (self: {
    pname   = "goto-chg";
    version = "1.6";
    src = fetchgit {
      url = "git://gitorious.org/evil/evil";
      rev = "999ec15587f85100311c031aa8efb5d50c35afe4";
      sha256 = "0yiqpzsm5sr7xdkixdvfg312dk9vsdcmj69gizk744d334yn8rsz";
    };
    files = [ "lib/goto-chg.el" ];
  });

  haskell-mode = melpa.mkDerivation (self: {
    pname   = "haskell-mode";
    version = "20150101";
    src = fetchFromGitHub {
      owner  = "haskell";
      repo   = self.pname;
      rev    = "0db5efaaeb3b22e5a3fdafa600729e14c1716ee2";
      sha256 = "0d63cgzj579cr8zbrnl0inyy35b26sxinqxr7bgrjsngpmhm52an";
    };
  });

  helm-swoop = melpa.mkDerivation (self: {
    pname   = "helm-swoop";
    version = "20141224";
    src = fetchFromGitHub {
      owner  = "ShingoFukuyama";
      repo   = self.pname;
      rev    = "06a251f7d7fce2a5719e0862e5855972cd8ab1ae";
      sha256 = "0nq33ldhbvfbm6jnsxqdf3vwaqrsr2gprkzll081gcyl2s1x0l2m";
    };
    packageRequires = [ helm ];
  });

  helm = melpa.mkDerivation (self: {
    pname   = "helm";
    version = "20150105";
    src = fetchFromGitHub {
      owner  = "emacs-helm";
      repo   = self.pname;
      rev    = "e5608ad86e7ca72446a4b1aa0faf604200ffe895";
      sha256 = "0n2kr6pyzcsi8pq6faxz2y8kicz1gmvj98fzzlq3a107dqqp25ay";
    };
    packageRequires = [ async ];
  });

  idris-mode = melpa.mkDerivation (self: {
    pname   = "idris-mode";
    version = "0.9.15";
    src = fetchFromGitHub {
      owner  = "idris-hackers";
      repo   = "idris-mode";
      rev    = self.version;
      sha256 = "00pkgk1zxan89i8alsa2dpa9ls7imqk5zb1kbjwzrlbr0gk4smdb";
    };
    packageRequires = [ flycheck ];
  });

  lcs = melpa.mkDerivation (self: {
    pname   = "lcs";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${self.version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    fileSpecs = [ "lisp/lcs*.el" ];
  });

  lui = melpa.mkDerivation (self: {
    pname   = "lui";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${self.version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    packageRequires = [ tracking ];
    fileSpecs = [ "lisp/lui*.el" ];
  });

  magit = melpa.mkDerivation (self: {
    pname   = "magit";
    version = "20141025";
    src = fetchFromGitHub {
      owner  = "magit";
      repo   = "magit";
      rev    = "50c08522c8a3c67e0f3b821fe4df61e8bd456ff9";
      sha256 = "0mzyx72pidzvla1x2qszn3c60n2j0n8i5k875c4difvd1n4p0vsk";
    };
    packageRequires = [ git-commit-mode git-rebase-mode ];
  });

  markdown-mode = melpa.mkDerivation (self: {
    pname   = "markdown-mode";
    version = "2.0";
    src = fetchFromGitHub {
      owner  = "defunkt";
      repo   = self.pname;
      rev    = "v${self.version}";
      sha256 = "1l2w0j9xl8pipz61426s79jq2yns42vjvysc6yjc29kbsnhalj29";
    };
  });

  org-plus-contrib = melpa.mkDerivation (self: {
    pname   = "org-plus-contrib";
    version = "20141020";
    src = fetchurl {
      url    = "http://orgmode.org/elpa/${self.fname}.tar";
      sha256 = "02njxmdbmias2f5psvwqc115dyakcwm2g381gfdv8qz4sqav0r77";
    };
    buildPhase = ''
      cp $src ${self.fname}.tar
    '';
  });

  pkg-info = melpa.mkDerivation (self: {
    pname   = "pkg-info";
    version = "20140610";
    src = fetchFromGitHub {
      owner  = "lunaryorn";
      repo   = "${self.pname}.el";
      rev    = "475cdeb0b8d44f9854e506c429eeb445787014ec";
      sha256 = "0x4nz54f2shgcw3gx66d265vxwdpdirn64gzii8dpxhsi7v86n0p";
    };
    packageRequires = [ epl ];
  });

  popup = melpa.mkDerivation (self: {
    pname   = "popup";
    version = "0.5.0";
    src = fetchFromGitHub {
      owner  = "auto-complete";
      repo   = "${self.pname}-el";
      rev    = "v${self.version}";
      sha256 = "0836ayyz1syvd9ry97ya06l8mpr88c6xbgb4d98szj6iwbypcj7b";
    };
  });

  projectile = melpa.mkDerivation (self: {
    pname   = "projectile";
    version = "20141020";
    src = fetchFromGitHub {
      owner  = "bbatsov";
      repo   = self.pname;
      rev    = "13580d83374e0c17c55b3a680b816dfae407657e";
      sha256 = "10c28h2g53sg68lwamhak0shdhh26h5xaipipz3n4281sr1fwg58";
    };
    packageRequires = [ dash helm s pkg-info epl ];
  });

  rich-minority = melpa.mkDerivation (self: {
    pname   = "rich-minority";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner  = "Bruce-Connor";
      repo   = self.pname;
      rev    = self.version;
      sha256 = "0kvhy4mgs9llihwsb1a9n5a85xzjiyiyawxnz0axy2bvwcxnp20k";
    };
    packageRequires = [ dash ];
  });

  s = melpa.mkDerivation (self: {
    pname   = "s";
    version = "20140910";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${self.pname}.el";
      rev    = "1f85b5112f3f68169ddaa2911fcfa030f979eb4d";
      sha256 = "9d871ea84f98c51099528a03eddf47218cf70f1431d4c35c19c977d9e73d421f";
    };
  });

  shorten = melpa.mkDerivation (self: {
    pname   = "shorten";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${self.version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    fileSpecs = [ "lisp/shorten*.el" ];
  });

  smart-mode-line = melpa.mkDerivation (self: {
    pname   = "smart-mode-line";
    version = "2.6";
    src = fetchFromGitHub {
      owner  = "Bruce-Connor";
      repo   = self.pname;
      rev    = self.version;
      sha256 = "17nav2jbvbd13xzgp29x396mc617n2dh6whjk4wnyvsyv7r0s9f6";
    };
    packageRequires = [ dash rich-minority ];
  });

  smartparens = melpa.mkDerivation (self: {
    pname   = "smartparens";
    version = "1.6.2";
    src = fetchFromGitHub {
      owner  = "Fuco1";
      repo   = self.pname;
      rev    = self.version;
      sha256 = "16pzd740vd1r3qfmxia2ibiarinm6xpja0mjv3nni5dis5s4r9gc";
    };
    packageRequires = [ dash ];
  });

  structured-haskell-mode = melpa.mkDerivation (self: {
    pname = "shm";
    version = external.structured-haskell-mode.version;
    src = external.structured-haskell-mode.src;
    packageRequires = [ haskell-mode ];
    fileSpecs = [ "elisp/*.el" ];
    meta = {
      homepage = "https://github.com/chrisdone/structured-haskell-mode";
      description = "Structured editing Emacs mode for Haskell";
      license = self.stdenv.lib.licenses.bsd3;
      platforms = self.ghc.meta.platforms;
    };
  });

  switch-window = melpa.mkDerivation (self: {
    pname   = "switch-window";
    version = "20140919";
    src = fetchFromGitHub {
      owner  = "dimitri";
      repo   = self.pname;
      rev    = "3ffbe68e584f811e891f96afa1de15e0d9c1ebb5";
      sha256 = "09221128a0f55a575ed9addb3a435cfe01ab6bdd0cca5d589ccd37de61ceccbd";
    };
  });

  tracking = melpa.mkDerivation (self: {
    pname   = "tracking";
    version = "1.5";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = "circe";
      rev    = "v${self.version}";
      sha256 = "08dsv1dzgb9jx076ia7xbpyjpaxn1w87h6rzlb349spaydq7ih24";
    };
    packageRequires = [ shorten ];
    fileSpecs = [ "lisp/tracking*.el" ];
  });

  undo-tree = melpa.mkDerivation (self: {
    pname   = "undo-tree";
    version = "0.6.4";
    src = fetchgit {
      url    = "http://www.dr-qubit.org/git/${self.pname}.git";
      rev    = "a3e81b682053a81e082139300ef0a913a7a610a2";
      sha256 = "1qla7njkb7gx5aj87i8x6ni8jfk1k78ivwfiiws3gpbnyiydpx8y";
    };
  });

  use-package = melpa.mkDerivation (self: {
    pname   = "use-package";
    version = "20141013";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = self.pname;
      rev    = "d43af5e0769a92f77e01dea229e376d9006722ef";
      sha256 = "1m4v5h52brg2g9rpbqfq9m3m8fv520vg5mjwppnbw6099d17msqd";
    };
    packageRequires = [ bind-key diminish ];
    files = [ "use-package.el" ];
  });

  volatile-highlights = melpa.mkDerivation (self: {
    pname   = "volatile-highlights";
    version = "1.11";
    src = fetchFromGitHub {
      owner  = "k-talo";
      repo   = "${self.pname}.el";
      rev    = "fb2abc2d4d4051a9a6b7c8de2fe7564161f01f24";
      sha256 = "1v0chqj5jir4685jd8ahw86g9zdmi6xd05wmzhyw20rbk924fcqf";
    };
  });

  weechat = melpa.mkDerivation (self: {
    pname   = "weechat.el";
    version = "20141016";
    src = fetchFromGitHub {
      owner  = "the-kenny";
      repo   = self.pname;
      rev    = "4cb2ced1eda5167ce774e04657d2cd077b63c706";
      sha256 = "003sihp7irm0qqba778dx0gf8xhkxd1xk7ig5kgkryvl2jyirk28";
    };
    postPatch = stdenv.lib.optionalString (!stdenv.isLinux) ''
      rm weechat-sauron.el weechat-secrets.el
    '';
    packageRequires = [ s ];
  });

  wgrep = melpa.mkDerivation (self: {
    pname   = "wgrep";
    version = "20141017";
    src = fetchFromGitHub {
      owner  = "mhayashi1120";
      repo   = "Emacs-wgrep";
      rev    = "7ef26c51feaef8a5ec0929737130ab8ba326983c";
      sha256 = "075z0glain0dp56d0cp468y5y88wn82ab26aapsrdzq8hmlshwn4";
    };
  });
}
