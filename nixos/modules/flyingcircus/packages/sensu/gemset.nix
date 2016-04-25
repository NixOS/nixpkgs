{
  xml-simple = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xlqplda3fix5pcykzsyzwgnbamb3qrqkgbrhhfz2a2fxhrkvhw8";
      type = "gem";
    };
    version = "1.1.5";
  };
  whois = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ckr4w1gba1m1yabl2piy7y9wy3hc0gzdxnqkr74ffk5xqbn0k49";
      type = "gem";
    };
    version = "3.6.3";
  };
  uuidtools = {
    source = {
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
      type = "gem";
    };
    version = "2.1.5";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04d13bp6lyg695x94whjwsmzc2ms72d94vx861nx1y40k3817yp8";
      type = "gem";
    };
    version = "0.0.7.2";
  };
  unf = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  tzinfo = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
      type = "gem";
    };
    version = "1.2.2";
  };
  tilt = {
    source = {
      sha256 = "0lkd40xfdqkp333vdfhrfjmi2y7k2hjs4azawfb62mrkfp7ivj84";
      type = "gem";
    };
    version = "2.0.2";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
      type = "gem";
    };
    version = "0.3.5";
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
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bprj8njmzbshjmrabra3djhw6737hn9mm0n8sxb7wv1znpr7lds";
      type = "gem";
    };
    version = "0.0.1.1";
  };
  sys-filesystem = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08zi702aq7cgm3wmmai2f18ph30yvincnlk1crza8axrjvf7fr25";
      type = "gem";
    };
    version = "1.1.5";
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
  sensu-plugins-supervisor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1idds9x01ccxldzi00xz5nx3jizdn3ywm1ijwmw2yb6zb171k0zi";
      type = "gem";
    };
    version = "0.0.3";
  };
  sensu-plugins-ssl = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15md1czbvpw1d63x91k1x4rwhsgd88shmx0pv8083bywl2c87yqq";
      type = "gem";
    };
    version = "0.0.6";
  };
  sensu-plugins-postgres = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xh2gzpacmzrzxj7ibczdrzgf3hdja0yl5cskfqypiq007d48gr9";
      type = "gem";
    };
    version = "0.0.7";
  };
  sensu-plugins-network-checks = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n474lg1fdjd9908dfwdhs1d18rj2g11fqf1sp761addg3rlh0wx";
      type = "gem";
    };
    version = "0.1.4";
  };
  sensu-plugins-mysql = {
    version = "0.0.4";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0j4bqm4wi8i86cbpbmrp88q71bzcmsfaf4icb2ml4w2db0ccr2d9";
    };
  };
  sensu-plugins-mailer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ysqwssa5jfn1wgsn9pmqiy85swkmk87xki4i7q3w260rl138bf9";
      type = "gem";
    };
    version = "0.1.2";
  };
  sensu-plugins-logs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17vk6c3nr3f5cjdwdcm5a6547s5xy32w5kkdzzy2zvafwxgb6dh9";
      type = "gem";
    };
    version = "0.0.3";
  };
  sensu-plugins-entropy-checks = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sk9hkwzhx8vy0jy4gq9igadixbjzw3fvskskl29xcs92cqk1j32";
      type = "gem";
    };
    version = "0.0.3";
  };
  sensu-plugins-dns = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0267cr8lxim2cypqn3dbjz8r5kzbzadbkssx790z1ssncjgl8qa9";
      type = "gem";
    };
    version = "0.0.6";
  };
  sensu-plugins-disk-checks = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d2qcn2ffirvnrnpw98kll412jy7plhg5x2kkpky79a8nx8bbnp5";
      type = "gem";
    };
    version = "1.1.3";
  };
  sensu-plugin = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k8mkkwb70z2j5lq457y7lsh5hr8gzd53sjbavpqpfgy6g4bxrg8";
      type = "gem";
    };
    version = "1.2.0";
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
  ruby-supervisor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07g0030sb9psrnz3b8axyjrcgwrmd38p0m05nq24bvrlvav4vkc0";
      type = "gem";
    };
    version = "0.0.2";
  };
  ruby-dbus = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ga8q959i8j8iljnw9hgxnjlqz1q0f95p9r3hyx6r5fl657qbx8z";
      type = "gem";
    };
    version = "0.11.0";
  };
  rmagick = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11p3w5rjqb1js74y2d5wlwqny8l0qb5ld1l5q5izs3v3q8sndnv9";
      type = "gem";
    };
    version = "2.15.4";
  };
  rest-client = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m8z0c4yf6w47iqz6j2p7x1ip4qnnzvhdph9d5fgx081cvjly3p7";
      type = "gem";
    };
    version = "1.8.0";
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
  pg = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00g33hdixgync6gp4mn0g0kjz5qygshi47xw58kdpd9n5lzdpg8c";
      type = "gem";
    };
    version = "0.18.3";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  net-ping = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19p3d39109xvbr4dcjs3g3zliazhc1k3iiw69mgb1w204hc7wkih";
      type = "gem";
    };
    version = "1.7.8";
  };
  mysql2 = {
    version = "0.3.18";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0dap507ba8pj3hpc3y8ammsq51xqflb54p5g262m1z55y6m7fm6k";
    };
  };
  mysql = {
    version = "2.9.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1y2b5rnspa0lllvqd6694hbkjhdn45389nrm3xfx6xxx6gf35p36";
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
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0im6jngj76azrz0nv69hgpy1af4smcgpfvmmwh5iwsqwa46zx0k0";
      type = "gem";
    };
    version = "1.5.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05nlp0w2mfns9pd9ypfbz6zw0r9smlv1m5i4pbpijizm7v3kxmra";
      type = "gem";
    };
    version = "5.8.4";
  };
  mime-types = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lwxaah0kafigggdpp1hgswffsdsyy7y9cwhsfaw5irqx21823ip";
      type = "gem";
    };
    version = "2.99.1";
  };
  mailgun-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aqa0ispfn27g20s8s517cykghycxps0bydqargx7687w6d320yb";
      type = "gem";
    };
    version = "1.0.3";
  };
  mail = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
      type = "gem";
    };
    version = "2.6.3";
  };
  libxml-xmlrpc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqp6j529aa2ygp8xrlz9a0pnh64x458jr4pywqanfw7i64a3qdb";
      type = "gem";
    };
    version = "0.1.5";
  };
  libxml-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dhjqp4r9vkdp00l6h1cj8qfndzxlhlxk6b9g0w4v55gz857ilhb";
      type = "gem";
    };
    version = "2.8.0";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
      type = "gem";
    };
    version = "1.8.3";
  };
  inifile = {
    version = "3.0.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1c5zmk7ia63yw5l2k14qhfdydxwi1sah1ppjdiicr4zcalvfn0xi";
    };
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
      type = "gem";
    };
    version = "0.7.0";
  };
  http_connection = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gj3imp4yyys5x2awym1nwy5qandmmpsjpf66m76d0gxfd4zznk9";
      type = "gem";
    };
    version = "1.4.4";
  };
  http-cookie = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cz2fdkngs3jc5w32a6xcl511hy03a7zdiy988jk1sf3bf5v3hdw";
      type = "gem";
    };
    version = "1.0.2";
  };
  fileutils = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "046m22flkcwpfzm2g60mh3wax114z8l4hhp4sh4sn1ci7zm9xayz";
      type = "gem";
    };
    version = "0.7";
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
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
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
    version = "0.5.20160310";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0g1175zspkqhlvl9s11g7p2nbmqpvpxxv02q8csd0ryc81laapys";
    };
  };
  dnsruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vf1940vxh3f387b1albb7r90zxrybaiw8094hf5z4zxc97ys7dj";
      type = "gem";
    };
    version = "1.58.0";
  };
  dnsbl-client = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1357r0y8xfnay05l9h26rrcqrjlnz0hy421g18pfrwm1psf3pp04";
      type = "gem";
    };
    version = "1.0.2";
  };
  dentaku = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ga010bbhsgc876vf6z6swfnk2mgj30y96rcd4yafvmwnj5djgz";
      type = "gem";
    };
    version = "2.0.4";
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
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fmlilz3gxml4frf5q0hnvrw9xfr7zhwfmac3f5k63czdf5qdzrc";
      type = "gem";
    };
    version = "2.10.2";
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
  activesupport = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w2znchjbgzj3sgp0581q15rikcj1cji80ki2ky8fwdnjxlh54mb";
      type = "gem";
    };
    version = "4.2.5";
  };
  sensu-plugins-systemd = {
    source = {
      fetchSubmodules = false;
      rev = "be972959c5f6cdc989b1122db72a4b10a1ecce77";
      sha256 = "123fnj9yiwbzxax9c14zy5iwc3qaldn5nqibs9k0nysr9zwkygpa";
      type = "git";
      url = "https://github.com/nyxcharon/sensu-plugins-systemd.git";
    };
    version = "0.0.1";
  };
}
