{
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01qml0yilb9basf7is2614skjp8384h2pycfx86cr8023arfj98g";
      type = "gem";
    };
    version = "0.2.0";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  cri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rank6i9p2drwdcmhan6ifkzrz1v3mwpx47fwjl75rskxwjfkgwa";
      type = "gem";
    };
    version = "2.15.12";
  };
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qnd6ff4az22ysnmni3730c41b979xinilahzg86bn7gv93ip9pw";
      type = "gem";
    };
    version = "1.13.0";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "104s7n9505488p923cs0pl3jlgn4naam28clkm2885hrysizpjbb";
      type = "gem";
    };
    version = "2.10.1";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y87p3yk15bjbk0z9mf01r50lzxvp7agr56lbm9gxiz26mb9fbfr";
      type = "gem";
    };
    version = "0.3.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f49frpfdr8czwm2mjkfny4pini6fy49b6hamw4jrppl4vsg14ys";
      type = "gem";
    };
    version = "3.1.1";
  };
  fast_gettext = {
    dependencies = [ "prime" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gsz2ywvnms7b4w7bs4dg7cykhgx7z74fa7xy0sbw45a0v2c89px";
      type = "gem";
    };
    version = "2.4.0";
  };
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b5g1i3xdvmxxpq4qp0z4v78ivqnazz26w110fh4cvzsdayz8zgi";
      type = "gem";
    };
    version = "1.3.3";
  };
  gettext = {
    dependencies = [
      "erubi"
      "locale"
      "prime"
      "racc"
      "text"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16h0kda5z4s4zqygyk0f52xzs9mlz9r4lnhjwk729hhmdbz68a19";
      type = "gem";
    };
    version = "3.4.9";
  };
  gettext-setup = {
    dependencies = [
      "fast_gettext"
      "gettext"
      "locale"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v6liz934gmx1wv1z6bvpim6aanbr66xjhb90lc9z1jxayczmm1a";
      type = "gem";
    };
    version = "1.1.0";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04mw326i9vsdcqwm4bf0zvnqw237f8l7022nhlbmak92bqqpg62s";
      type = "gem";
    };
    version = "2.8.2";
  };
  locale = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "107pm4ccmla23z963kyjldgngfigvchnv85wr6m69viyxxrrjbsj";
      type = "gem";
    };
    version = "2.1.4";
  };
  log4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ri90q0frfmigkirqv5ihyrj59xm8pq5zcmf156cbdv4r4l2jicv";
      type = "gem";
    };
    version = "1.1.10";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gpg8gzi0xwymw4aaq2iafcbx31i3xzkg3fb30mdxn1d4qhc3dqa";
      type = "gem";
    };
    version = "1.6.0";
  };
  minitar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f307mpj4j0gp7iq77xj4p149f4krcvbll9rismng3jcijpbn79s";
      type = "gem";
    };
    version = "0.12.1";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10n2n9aq00ih8v881af88l1zyrqgs5cl3njdw8argjwbl5ggqvm9";
      type = "gem";
    };
    version = "0.4.1";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1973kz8lbck6ga5v42f55jk8b8pnbgwp9p67dl1xw15gvz55dsfl";
      type = "gem";
    };
    version = "0.1.2";
  };
  puppet_forge = {
    dependencies = [
      "faraday"
      "faraday-follow_redirects"
      "minitar"
      "semantic_puppet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d65zri1nmpph8iki5iigdzfqd6rfyc1mlgdfhg69q3566rcff06";
      type = "gem";
    };
    version = "5.0.4";
  };
  r10k = {
    dependencies = [
      "colored2"
      "cri"
      "gettext-setup"
      "jwt"
      "log4r"
      "minitar"
      "multi_json"
      "puppet_forge"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k3fr2f0pwyrabs12wqig31f37sqrqs8qza7jrn01d6blvhvkrb4";
      type = "gem";
    };
    version = "4.1.0";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  semantic_puppet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ndqm3jnpdlwkk1jwqdyyb7yw7gv6r4kmjs30g09ap8siv80ilaj";
      type = "gem";
    };
    version = "1.1.0";
  };
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qq54imvbksnckzf9hrq9bjzcdb0n8wfv6l5jc0di10n88277jx6";
      type = "gem";
    };
    version = "0.2.0";
  };
  text = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "094gk72ckazf495qc76gk09b5i318d5l9m7bicg2wxlrjcm3qm96";
      type = "gem";
    };
    version = "0.13.0";
  };
}
