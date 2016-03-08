{
  xml-simple = {
    source = {
      sha256 = "0xlqplda3fix5pcykzsyzwgnbamb3qrqkgbrhhfz2a2fxhrkvhw8";
      type = "gem";
    };
    version = "1.1.5";
  };
  uuidtools = {
    source = {
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
      type = "gem";
    };
    version = "2.1.5";
  };
  unf_ext = {
    version = "0.0.7.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "04d13bp6lyg695x94whjwsmzc2ms72d94vx861nx1y40k3817yp8";
    };
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  systemd-bindings = {
    version = "0.0.1.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1bprj8njmzbshjmrabra3djhw6737hn9mm0n8sxb7wv1znpr7lds";
    };
  };
  sensu-plugins-ssl = {
    dependencies = ["rest-client" "sensu-plugin"];
    source = {
      sha256 = "15md1czbvpw1d63x91k1x4rwhsgd88shmx0pv8083bywl2c87yqq";
      type = "gem";
    };
    version = "0.0.6";
  };
  sensu-plugins-mailer = {
    dependencies = ["aws" "erubis" "mail" "mailgun-ruby" "sensu-plugin"];
    source = {
      sha256 = "0ysqwssa5jfn1wgsn9pmqiy85swkmk87xki4i7q3w260rl138bf9";
      type = "gem";
    };
    version = "0.1.2";
  };
  sensu-plugin = {
    dependencies = ["json" "mixlib-cli"];
    source = {
      sha256 = "1k8mkkwb70z2j5lq457y7lsh5hr8gzd53sjbavpqpfgy6g4bxrg8";
      type = "gem";
    };
    version = "1.2.0";
  };
  ruby-dbus = {
    version = "0.11.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1ga8q959i8j8iljnw9hgxnjlqz1q0f95p9r3hyx6r5fl657qbx8z";
    };
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      sha256 = "1m8z0c4yf6w47iqz6j2p7x1ip4qnnzvhdph9d5fgx081cvjly3p7";
      type = "gem";
    };
    version = "1.8.0";
  };
  netrc = {
    source = {
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  mixlib-cli = {
    source = {
      sha256 = "0im6jngj76azrz0nv69hgpy1af4smcgpfvmmwh5iwsqwa46zx0k0";
      type = "gem";
    };
    version = "1.5.0";
  };
  mime-types = {
    version = "2.99.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0lwxaah0kafigggdpp1hgswffsdsyy7y9cwhsfaw5irqx21823ip";
    };
  };
  mailgun-ruby = {
    dependencies = ["json" "rest-client"];
    source = {
      sha256 = "1aqa0ispfn27g20s8s517cykghycxps0bydqargx7687w6d320yb";
      type = "gem";
    };
    version = "1.0.3";
  };
  mail = {
    dependencies = ["mime-types"];
    source = {
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
      type = "gem";
    };
    version = "2.6.3";
  };
  json = {
    source = {
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
      type = "gem";
    };
    version = "1.8.3";
  };
  http_connection = {
    source = {
      sha256 = "0gj3imp4yyys5x2awym1nwy5qandmmpsjpf66m76d0gxfd4zznk9";
      type = "gem";
    };
    version = "1.4.4";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      sha256 = "0cz2fdkngs3jc5w32a6xcl511hy03a7zdiy988jk1sf3bf5v3hdw";
      type = "gem";
    };
    version = "1.0.2";
  };
  erubis = {
    source = {
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  domain_name = {
    version = "0.5.20160216";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0kwc0ddy28xjbrwzvcljxc6kxpyizdyj6788l82pli6ba2ihv26r";
    };
  };
  aws = {
    dependencies = ["http_connection" "uuidtools" "xml-simple"];
    source = {
      sha256 = "0fmlilz3gxml4frf5q0hnvrw9xfr7zhwfmac3f5k63czdf5qdzrc";
      type = "gem";
    };
    version = "2.10.2";
  };
  sensu-plugins-systemd = {
    version = "0.0.1";
    source = {
      type = "git";
      url = "https://github.com/nyxcharon/sensu-plugins-systemd.git";
      rev = "be972959c5f6cdc989b1122db72a4b10a1ecce77";
      sha256 = "123fnj9yiwbzxax9c14zy5iwc3qaldn5nqibs9k0nysr9zwkygpa";
      fetchSubmodules = false;
    };
  };
}