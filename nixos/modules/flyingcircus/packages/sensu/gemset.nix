{
  xml-simple = {
    version = "1.1.5";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0xlqplda3fix5pcykzsyzwgnbamb3qrqkgbrhhfz2a2fxhrkvhw8";
    };
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
    version = "0.1.4";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
    };
  };
  tilt = {
    source = {
      sha256 = "0lkd40xfdqkp333vdfhrfjmi2y7k2hjs4azawfb62mrkfp7ivj84";
      type = "gem";
    };
    version = "2.0.2";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    source = {
      sha256 = "1m56aygh5rh8ncp3s2gnn8ghn5ibkk0bg6s3clmh1vzaasw2lj4i";
      type = "gem";
    };
    version = "1.6.3";
  };
  systemd-bindings = {
    version = "0.0.1.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1bprj8njmzbshjmrabra3djhw6737hn9mm0n8sxb7wv1znpr7lds";
    };
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      sha256 = "1hhmwqc81ram7lfwwziv0z70jh92sj1m7h7s9fr0cn2xq8mmn8l7";
      type = "gem";
    };
    version = "1.4.6";
  };
  sensu-transport = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "153r2wgqh2bxrgml2ag7iyw7w5r4jmcbqj96lcq5gr98761zzb8l";
      type = "gem";
    };
    version = "4.0.0";
  };
  sensu-spawn = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06krhrgdb1b83js185ljh32sd30r8irfb1rjs0wl2amn6w5nrdi6";
      type = "gem";
    };
    version = "1.7.0";
  };
  sensu-settings = {
    dependencies = ["multi_json"];
    source = {
      sha256 = "0fk5chvzv946yg6cqpjlpjw5alwimg8rsxs3knhbgdanyrbh6m32";
      type = "gem";
    };
    version = "3.3.0";
  };
  sensu-plugins-ssl = {
    version = "0.0.6";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "15md1czbvpw1d63x91k1x4rwhsgd88shmx0pv8083bywl2c87yqq";
    };
  };
  sensu-plugins-mailer = {
    version = "0.1.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0ysqwssa5jfn1wgsn9pmqiy85swkmk87xki4i7q3w260rl138bf9";
    };
  };
  sensu-plugin = {
    version = "1.2.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1k8mkkwb70z2j5lq457y7lsh5hr8gzd53sjbavpqpfgy6g4bxrg8";
    };
  };
  sensu-logger = {
    dependencies = ["eventmachine" "multi_json"];
    source = {
      sha256 = "1pbzbr83df4awndr49f1z7z1bl9n73nkf1xcnlkjcnpnb3yy07pw";
      type = "gem";
    };
    version = "1.1.0";
  };
  sensu-extensions = {
    dependencies = ["multi_json" "sensu-extension" "sensu-logger" "sensu-settings"];
    source = {
      sha256 = "16npdf1hcpcn47wmznkwcikynxzb2jv2irqlvprjlapy2m6m4c62";
      type = "gem";
    };
    version = "1.4.0";
  };
  sensu-extension = {
    dependencies = ["eventmachine"];
    source = {
      sha256 = "1ms7g76vng0dzaq86g4s8mdszjribm6v6vkbmh4psf988xw95a2b";
      type = "gem";
    };
    version = "1.3.0";
  };
  sensu = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vyk8m4acjzn4i2q41gabpmrlqcl2x4ivf58m0hqn3x7l45ma605";
      type = "gem";
    };
    version = "0.22.1";
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
    version = "1.8.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1m8z0c4yf6w47iqz6j2p7x1ip4qnnzvhdph9d5fgx081cvjly3p7";
    };
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
      type = "gem";
    };
    version = "1.5.3";
  };
  rack = {
    source = {
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
      type = "gem";
    };
    version = "1.6.4";
  };
  netrc = {
    version = "0.11.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
    };
  };
  multi_json = {
    source = {
      sha256 = "1rf3l4j3i11lybqzgq2jhszq7fh7gpmafjzd14ymp9cjfxqg596r";
      type = "gem";
    };
    version = "1.11.2";
  };
  mixlib-cli = {
    version = "1.5.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0im6jngj76azrz0nv69hgpy1af4smcgpfvmmwh5iwsqwa46zx0k0";
    };
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
    version = "1.0.3";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1aqa0ispfn27g20s8s517cykghycxps0bydqargx7687w6d320yb";
    };
  };
  mail = {
    version = "2.6.3";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
    };
  };
  json = {
    version = "1.8.3";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
    };
  };
  http_connection = {
    version = "1.4.4";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0gj3imp4yyys5x2awym1nwy5qandmmpsjpf66m76d0gxfd4zznk9";
    };
  };
  http-cookie = {
    version = "1.0.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0cz2fdkngs3jc5w32a6xcl511hy03a7zdiy988jk1sf3bf5v3hdw";
    };
  };
  ffi = {
    source = {
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
      type = "gem";
    };
    version = "1.9.10";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17jr1caa3ggg696dd02g2zqzdjqj9x9q2nl7va82l36f7c5v6k4z";
      type = "gem";
    };
    version = "1.0.9.1";
  };
  erubis = {
    version = "2.7.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  em-worker = {
    dependencies = ["eventmachine"];
    source = {
      sha256 = "0z4jx9z2q5hxvdvik4yp0ahwfk69qsmdnyp72ln22p3qlkq2z5wk";
      type = "gem";
    };
    version = "0.0.2";
  };
  em-redis-unified = {
    dependencies = ["eventmachine"];
    source = {
      sha256 = "0rzf2c2cbfc1k5jiahmgd3c4l9z5f74b6a549v44n5j1hyj03m9v";
      type = "gem";
    };
    version = "1.0.1";
  };
  domain_name = {
    version = "0.5.20160216";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0kwc0ddy28xjbrwzvcljxc6kxpyizdyj6788l82pli6ba2ihv26r";
    };
  };
  daemons = {
    source = {
      sha256 = "0b839hryy9sg7x3knsa1d6vfiyvn0mlsnhsb6an8zsalyrz1zgqg";
      type = "gem";
    };
    version = "1.2.3";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      sha256 = "1lv7axi1fhascm9njxh3lx1rbrnsm8wgvib0g7j26v4h1fcphqg0";
      type = "gem";
    };
    version = "0.5.8";
  };
  aws = {
    version = "2.10.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0fmlilz3gxml4frf5q0hnvrw9xfr7zhwfmac3f5k63czdf5qdzrc";
    };
  };
  async_sinatra = {
    dependencies = ["rack" "sinatra"];
    source = {
      sha256 = "0sjdvkchq5blvfdahhrlipsx5sr9kfmdx0zxssjlfkz54dbl14m0";
      type = "gem";
    };
    version = "1.2.0";
  };
  amqp = {
    dependencies = ["amq-protocol" "eventmachine"];
    source = {
      sha256 = "0jlcwyvjz0b28wxdabkyhdqyqp5ji56ckfywsy9mgp0m4wfbrh8c";
      type = "gem";
    };
    version = "1.5.0";
  };
  amq-protocol = {
    source = {
      sha256 = "1gl479j003vixfph5jmdskl20il8816y0flp4msrc8im3b5iiq3r";
      type = "gem";
    };
    version = "1.9.2";
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