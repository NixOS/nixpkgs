{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mxhjgihzsx45l9wh2n0ywl9w0c6k70igm5r0d63dxkcagwvh4vw";
      type = "gem";
    };
    version = "2.8.8";
  };
  ast = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pp0sagj31zvmv8ca0hf0kgdfb7wwkq733sv2812gvs43pck5hay";
      type = "gem";
    };
    version = "1.1213.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "bigdecimal"
      "jmespath"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1819b99lgs3i637j2y6f95vlsppw3id2hys3m30q13f7mh1k0yy1";
      type = "gem";
    };
    version = "3.242.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q015l5gm3f230jz9l6si9s3hlw7ra76q8biqvxlwxdmnk7w2qym";
      type = "gem";
    };
    version = "1.121.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03g5k3jl0sgp60ppmxa267qflxlj174mrs8hnrnl10j5ak7nqndg";
      type = "gem";
    };
    version = "1.213.0";
  };
  aws-sdk-secretsmanager = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16ib5p04fk66qr2vfps0qr340ld5xb5dsypbdii9f40n6hfxwb6n";
      type = "gem";
    };
    version = "1.128.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    version = "1.12.1";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    version = "0.5.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19y406nx17arzsbc515mjmr6k5p59afprspa1k423yd9cp8d61wb";
      type = "gem";
    };
    version = "4.0.1";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  chef = {
    dependencies = [
      "addressable"
      "aws-sdk-s3"
      "aws-sdk-secretsmanager"
      "chef-config"
      "chef-utils"
      "chef-vault"
      "chef-zero"
      "corefoundation"
      "diff-lcs"
      "erubis"
      "ffi"
      "ffi-libarchive"
      "ffi-yajl"
      "iniparse"
      "inspec-core"
      "license-acceptance"
      "mixlib-archive"
      "mixlib-authentication"
      "mixlib-cli"
      "mixlib-log"
      "mixlib-shellout"
      "net-ftp"
      "net-sftp"
      "ohai"
      "plist"
      "proxifier2"
      "syslog-logger"
      "train-core"
      "train-rest"
      "train-winrm"
      "unf_ext"
      "uuidtools"
      "vault"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iafkrjiwkrv3mn420byr96y3g8ik4bqbfms3yqvhyfjx1c2z6fz";
      type = "gem";
    };
    version = "18.3.0";
  };
  chef-cli = {
    dependencies = [
      "addressable"
      "chef"
      "cookbook-omnifetch"
      "diff-lcs"
      "ffi-yajl"
      "license-acceptance"
      "minitar"
      "mixlib-cli"
      "mixlib-shellout"
      "pastel"
      "solve"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mx7scgzkzsz5z9fpzk7ccng7yjv45pjp705h386fzmj6gl2w1rg";
      type = "gem";
    };
    version = "5.6.23";
  };
  chef-config = {
    dependencies = [
      "addressable"
      "chef-utils"
      "fuzzyurl"
      "mixlib-config"
      "mixlib-shellout"
      "tomlrb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pvjf3qbb3apg9vdy4zykamm7801qz4m6256wjqn73fs87zs50y1";
      type = "gem";
    };
    version = "18.3.0";
  };
  chef-gyoku = {
    dependencies = [
      "builder"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dpqrxpn5xx0jahga8kny2vagx7vxiinw4xcz6xwjg14z37s6m3k";
      type = "gem";
    };
    version = "1.5.0";
  };
  chef-licensing = {
    dependencies = [
      "chef-config"
      "faraday"
      "faraday-http-cache"
      "mixlib-log"
      "ostruct"
      "pstore"
      "tty-prompt"
      "tty-spinner"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xwk8dq0rbzirfxksx5yxfzwwkslxqi4ym024ayf0kd60i88cxdz";
      type = "gem";
    };
    version = "1.4.0";
  };
  chef-telemetry = {
    dependencies = [
      "chef-config"
      "concurrent-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l9icc3nfdj28mip85vf31v5l60qsfqq3a5dscv7jryh1k94y05x";
      type = "gem";
    };
    version = "1.1.1";
  };
  chef-utils = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0087jwhqslfm3ygj507dmmdp3k0589j5jl54mkwgbabbwan7lzw2";
      type = "gem";
    };
    version = "18.3.0";
  };
  chef-vault = {
    dependencies = [ "syslog" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "021lnj0w1lmbf5r7b4yjh8xrdxqqwi9qpynzncnsfd7v75qppjg2";
      type = "gem";
    };
    version = "4.2.5";
  };
  chef-winrm = {
    dependencies = [
      "builder"
      "chef-gyoku"
      "erubi"
      "gssapi"
      "httpclient"
      "logging"
      "nori"
      "rexml"
      "rubyntlm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ww5iclrsl1fpzj7lm6ds5dza7ifn7px0a6wic787mrr5v3ly8fh";
      type = "gem";
    };
    version = "2.5.0";
  };
  chef-winrm-elevated = {
    dependencies = [
      "chef-winrm"
      "chef-winrm-fs"
      "erubi"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01sqzw2vdjkvg2wznb6mwzkfjpkplllymfz4p4fvxgsv3vmv91cr";
      type = "gem";
    };
    version = "1.2.5";
  };
  chef-winrm-fs = {
    dependencies = [
      "benchmark"
      "chef-winrm"
      "csv"
      "erubi"
      "logging"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fk8p20cgz392h03l6nilk8wpwwwkx3819c8svy0q1zbz3x9dmp8";
      type = "gem";
    };
    version = "1.4.2";
  };
  chef-zero = {
    dependencies = [
      "ffi-yajl"
      "hashie"
      "mixlib-log"
      "rack"
      "rackup"
      "unf_ext"
      "uuidtools"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12jqa1a1px56j5qkrl0bjb14pg7hyylbl23zd780rvmq7nghw8l5";
      type = "gem";
    };
    version = "15.1.0";
  };
  coderay = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1aymcakhzl83k77g2f2krz07bg1cbafbcd2ghvwr4lky3rz86mkb";
      type = "gem";
    };
    version = "1.3.6";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b8nlxr5z843ii7hfk6igpr5acw3k2ih9yjrgkyz2gbmallgjkz5";
      type = "gem";
    };
    version = "2.5.5";
  };
  cookbook-omnifetch = {
    dependencies = [ "mixlib-archive" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gqh66p6fxg438qpvc67s0y7ji9mvan6layyd7w9ljwva1snvy2n";
      type = "gem";
    };
    version = "0.12.2";
  };
  cookstyle = {
    dependencies = [ "rubocop" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04xbjydimr144rnl1azhc3hignpdpi0s1rb0xzzbi1v2may7lwn0";
      type = "gem";
    };
    version = "8.5.3";
  };
  corefoundation = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14rgy3d636l9zy7zmw04j7pjkf3bn41vx7kb265l4zhxrik7gh19";
      type = "gem";
    };
    version = "0.3.13";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gz7r2kazwwwyrwi95hbnhy54kwkfac5swh2gy5p5vw36fn38lbf";
      type = "gem";
    };
    version = "3.3.5";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h0db8r2v5llxdbzkzyllkfniqw9gm092qn7cbaib73v9lw0c3bm";
      type = "gem";
    };
    version = "3.5.1";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1znxccz83m4xgpd239nyqxlifdb7m8rlfayk6s259186nkgj6ci7";
      type = "gem";
    };
    version = "1.5.1";
  };
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cyr2xm576gqhqicsyqnhanni47408w2pgvrfi8pd13h2li3nsaz";
      type = "gem";
    };
    version = "0.6.20240107";
  };
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    version = "1.13.1";
  };
  erubis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "077n5ss3z3ds4vj54w201kd12smai853dp9c9n7ii7g3q7nwwg54";
      type = "gem";
    };
    version = "2.14.1";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b8hgpci3wjm3rm41bzpasvsc5j253ljyg5rsajl62dkjk497pjw";
      type = "gem";
    };
    version = "0.5.0";
  };
  faraday-http-cache = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11a27jbbbkawakwf8dll9qqc7g0mkc31zv1d8m1h477yqmhswwkp";
      type = "gem";
    };
    version = "2.6.1";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v4hfmc7d4lrqqj2wl366rm9551gd08zkv2ppwwnjlnkc217aizi";
      type = "gem";
    };
    version = "3.4.2";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k1xaqw2jk13q3ss7cnyvkp8fzp75dk4kazysrxgfd1rpgvkk7qf";
      type = "gem";
    };
    version = "1.17.3";
  };
  ffi-libarchive = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19hnz16hmzzqsrrl29iw8v8lhvb8295c3z04mmadfjpfhjacmr53";
      type = "gem";
    };
    version = "1.1.14";
  };
  ffi-yajl = {
    dependencies = [
      "libyajl2"
      "yajl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04m8c2bp7hgw2b1zrwanalkh1s2smyv2nl84vw0dzsn0253pca06";
      type = "gem";
    };
    version = "2.7.7";
  };
  fuzzyurl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03qchs33vfwbsv5awxg3acfmlcrf5xbhnbrc83fdpamwya0glbjl";
      type = "gem";
    };
    version = "0.9.0";
  };
  gssapi = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qdfhj12aq8v0y961v4xv96a1y2z80h3xhvzrs9vsfgf884g6765";
      type = "gem";
    };
    version = "1.3.1";
  };
  hashie = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w1qrab701d3a63aj2qavwc2fpcqmkzzh1w2x93c88zkjqc4frn2";
      type = "gem";
    };
    version = "5.1.0";
  };
  http-accept = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      type = "gem";
    };
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06dvmngd4hwrr6k774i1h6c50h2l8nww9f1id0wvrvi72l6yd99q";
      type = "gem";
    };
    version = "1.1.0";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j4qwj1nv66v3n9s4xqf64x2galvjm630bwa5xngicllwic5jr2b";
      type = "gem";
    };
    version = "2.9.0";
  };
  iniparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wb1qy4i2xrrd92dc34pi7q7ibrjpapzk9y465v0n9caiplnb89n";
      type = "gem";
    };
    version = "1.5.0";
  };
  inspec-core = {
    dependencies = [
      "addressable"
      "chef-licensing"
      "chef-telemetry"
      "cookstyle"
      "csv"
      "faraday"
      "faraday-follow_redirects"
      "hashie"
      "license-acceptance"
      "method_source"
      "mixlib-log"
      "multipart-post"
      "ostruct"
      "parallel"
      "parslet"
      "pry"
      "rspec"
      "rspec-its"
      "rubyzip"
      "semverse"
      "sslshake"
      "syslog"
      "thor"
      "tomlrb"
      "train-core"
      "tty-prompt"
      "tty-table"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mghshl98py0q1wwd2dbmx72b1641y0nqz7y68bpws1b8n2hy5df";
      type = "gem";
    };
    version = "7.0.95";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k0lk3pwadm2myvpg893n8jshmrf2sigrd4ki15lymy7gixaxqyn";
      type = "gem";
    };
    version = "0.8.2";
  };
  ipaddress = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
      type = "gem";
    };
    version = "0.8.3";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11prr7nrxh1y4rfsqa51gy4ixx63r18cz9mdnmk0938va1ajf4gy";
      type = "gem";
    };
    version = "2.18.1";
  };
  language_server-protocol = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k0311vah76kg5m6zr7wmkwyk5p2f9d9hyckjpn3xgr83ajkj7px";
      type = "gem";
    };
    version = "3.17.0.5";
  };
  libyajl2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vx0mv0bbcy0qh3ik08b42vrq4kw1zg51121r18c0vvp4p3zcpda";
      type = "gem";
    };
    version = "2.1.0";
  };
  license-acceptance = {
    dependencies = [
      "pastel"
      "tomlrb"
      "tty-box"
      "tty-prompt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12h5a3j57h50xkfpdz9gr42k0v8g1qxn2pnj5hbbzbmdhydjbjzf";
      type = "gem";
    };
    version = "2.1.13";
  };
  lint_roller = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  little-plugger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  logging = {
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jqcq2yxh973f3aw63nd3wxhqyhkncz3pf8v2gs3df0iqair725s";
      type = "gem";
    };
    version = "2.4.0";
  };
  method_source = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";
      type = "gem";
    };
    version = "1.1.0";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bradmf21c9g4z6f3hvqmnf6i2sbgp0630y2j5rq8a7h79lksdal";
      type = "gem";
    };
    version = "3.2026.0203";
  };
  minitar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gm2ksf678gr5cqr4a3mzx0zvwrc7z2qvkfd8rwh209qdzxhrnrq";
      type = "gem";
    };
    version = "1.1.0";
  };
  mixlib-archive = {
    dependencies = [ "mixlib-log" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mkhk1wz2skjijacygdak81i41syp9bwdi9kasij22p6bqjyqrhy";
      type = "gem";
    };
    version = "1.3.3";
  };
  mixlib-authentication = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07m6q8icjjzrv7k2vsjqmviswqv6cigc577hf48liy7b1i4l9gn5";
      type = "gem";
    };
    version = "3.0.10";
  };
  mixlib-cli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ydxlfgd7nnj3rp1y70k4yk96xz5cywldjii2zbnw3sq9pippwp6";
      type = "gem";
    };
    version = "2.1.8";
  };
  mixlib-config = {
    dependencies = [ "tomlrb" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j0122lv2qgccl61njqi0pj6sp6nb85y07gcmw16bwg4k0c8nx6p";
      type = "gem";
    };
    version = "3.0.27";
  };
  mixlib-log = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s57cq8qx3823pcfzizshp8vagvp3f87r0lksknj18r26nl3y79a";
      type = "gem";
    };
    version = "3.2.3";
  };
  mixlib-shellout = {
    dependencies = [ "chef-utils" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "032z85m9w8kpf232xspd9r8im6wwq4lj2s7df642m4lhdid6r2kw";
      type = "gem";
    };
    version = "3.4.10";
  };
  molinillo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p846facmh1j5xmbrpgzadflspvk7bzs3sykrh5s7qi4cdqz5gzg";
      type = "gem";
    };
    version = "0.8.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1drisvysgvnjlz49a0qcbs294id6mvj3i8iik5rvym68ybwfzvvs";
      type = "gem";
    };
    version = "1.19.1";
  };
  multipart-post = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a5lrlvmg2kb2dhw3lxcsv6x276bwgsxpnka1752082miqxd0wlq";
      type = "gem";
    };
    version = "2.4.1";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l875dw0lk7b2ywa54l0wjcggs94vb7gs8khfw9li75n2sn09jyg";
      type = "gem";
    };
    version = "0.3.0";
  };
  net-ftp = {
    dependencies = [
      "net-protocol"
      "time"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r9vn7q6c66y4iw048qdbqviv7bankdkcziz12fzfa7lyz61fy1h";
      type = "gem";
    };
    version = "0.3.9";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15k96fj6qwbaiv6g52l538ass95ds1qwgynqdridz29yqrkhpfi5";
      type = "gem";
    };
    version = "0.9.1";
  };
  net-http-persistent = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rk03449disq3azyiymv1c3qnpqr6cxawgq556rkf5b9klqyhggg";
      type = "gem";
    };
    version = "4.0.8";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a32l4x73hz200cm587bc29q8q9az278syw3x6fkc9d1lv5y0wxa";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p8s7l4pr6hkn0l6rxflsc11alwi1kfg5ysgvsq61lz5l690p6x9";
      type = "gem";
    };
    version = "4.1.0";
  };
  net-sftp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r33aa2d61hv1psm0l0mm6ik3ycsnq8symv7h84kpyf2b7493fv5";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w1ypxa3n6mskkwb00b489314km19l61p5h3bar6zr8cng27c80p";
      type = "gem";
    };
    version = "7.3.0";
  };
  netrc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  nori = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qb84bbi74q0zgs09sdkq750jf2ri3lblbry0xi4g1ard4rwsrk1";
      type = "gem";
    };
    version = "2.7.1";
  };
  ohai = {
    dependencies = [
      "chef-config"
      "chef-utils"
      "ffi"
      "ffi-yajl"
      "ipaddress"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-log"
      "mixlib-shellout"
      "plist"
      "train-core"
      "wmi-lite"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w0zrk1n6n7jl493k4vv5xaiszbmxsmaffy9xvykbfawjjb83vj2";
      type = "gem";
    };
    version = "18.1.18";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c719bfgcszqvk9z47w2p8j2wkz5y35k48ywwas5yxbbh3hm3haa";
      type = "gem";
    };
    version = "1.27.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1256ws3w3gnfqj7r3yz2i9y1y7k38fhjphxpybkyb4fds8jsgxh6";
      type = "gem";
    };
    version = "3.3.10.1";
  };
  parslet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01pnw6ymz6nynklqvqxs4bcai25kcvnd5x4id9z3vd1rbmlk0lfl";
      type = "gem";
    };
    version = "2.0.0";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      type = "gem";
    };
    version = "0.8.0";
  };
  plist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hlaf4b3d8grxm9fqbnam5gwd55wvghl0jyzjd1hc5hirhklaynk";
      type = "gem";
    };
    version = "3.7.2";
  };
  prism = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  proxifier2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cmk01qdk3naa86grjd5arf6xxy9axf5y6a0sqm7zis9lr4d43h3";
      type = "gem";
    };
    version = "1.1.0";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kh5nv8v74k1ccy6gc7nd04aaf1cjkbk7g8pwy2izvcqaq36jv6p";
      type = "gem";
    };
    version = "0.16.0";
  };
  pstore = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11mvc9s72fq7bl6h3f1rcng4ffa0nbjy1fr9wpshgzn4b9zznxm2";
      type = "gem";
    };
    version = "0.1.4";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mx84s7gn3xabb320hw8060v7amg6gmcyyhfzp0kawafiq60j54i";
      type = "gem";
    };
    version = "7.0.2";
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
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xmnrk076sqymilydqgyzhkma3hgqhcv8xhy7ks479l2a3vvcx2x";
      type = "gem";
    };
    version = "3.2.4";
  };
  rackup = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s48d2a0z5f0cg4npvzznf933vipi6j7gmk16yc913kpadkw4ybc";
      type = "gem";
    };
    version = "2.3.1";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  regexp_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "192mzi0wgwl024pwpbfa6c2a2xlvbh3mjd75a0sakdvkl60z64ya";
      type = "gem";
    };
    version = "2.11.3";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d8q5c4nh2g9pp758kizh8sfrvngynrjlm0i1zn3cnsnfd4v160i";
      type = "gem";
    };
    version = "0.6.3";
  };
  rest-client = {
    dependencies = [
      "http-accept"
      "http-cookie"
      "mime-types"
      "netrc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      type = "gem";
    };
    version = "2.1.0";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-its = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pv0a8pvixgrwsi6j4nlpyn9m0jw9zn92dakjdg87wj9h71qp3m8";
      type = "gem";
    };
    version = "2.0.0";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "071bqrk2rblk3zq3jk1xxx0dr92y0szi5pxdm8waimxici706y89";
      type = "gem";
    };
    version = "3.13.7";
  };
  rspec-support = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    version = "3.13.7";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "lint_roller"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "157hg99cq6ys670sw8xbggnvxc9yl50h1zhllki925kkihlwrdbg";
      type = "gem";
    };
    version = "1.81.7";
  };
  rubocop-ast = {
    dependencies = [
      "parser"
      "prism"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zbikzd6237fvlzjfxdlhwi2vbmavg1cc81y6cyr581365nnghs9";
      type = "gem";
    };
    version = "1.49.0";
  };
  ruby-progressbar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  rubyntlm = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x8l0d1v88m40mby4jvgal46137cv8gga2lk7zlrxqlsp41380a7";
      type = "gem";
    };
    version = "0.6.5";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05an0wz87vkmqwcwyh5rjiaavydfn5f4q1lixcsqkphzvj7chxw5";
      type = "gem";
    };
    version = "2.4.1";
  };
  semverse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vrh6p0756n3gjnk6am1cc4kmw6wzzd02hcajj27rlsqg3p6lwn9";
      type = "gem";
    };
    version = "3.0.2";
  };
  socksify = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mm8m7zfvszbf9l750c2x693p8100rrk6ckvcp6909631ir02ang";
      type = "gem";
    };
    version = "1.8.1";
  };
  solve = {
    dependencies = [
      "molinillo"
      "semverse"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "059lrsf40rl5kclp1w8pb0fzz5sv8aikg073cwcvn5mndk14ayky";
      type = "gem";
    };
    version = "4.0.4";
  };
  sslshake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r3ifksx8a05yqhv7nc4cwan8bwmxgq5kyv7q7hy2h9lv5zcjs8h";
      type = "gem";
    };
    version = "1.3.1";
  };
  strings = {
    dependencies = [
      "strings-ansi"
      "unicode-display_width"
      "unicode_utils"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yynb0qhhhplmpzavfrrlwdnd1rh7rkwzcs4xf0mpy2wr6rr6clk";
      type = "gem";
    };
    version = "0.2.1";
  };
  strings-ansi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "120wa6yjc63b84lprglc52f40hx3fx920n4dmv14rad41rv2s9lh";
      type = "gem";
    };
    version = "0.2.0";
  };
  syslog = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wklh86rhpiff34ja0hda5pwdfywybjvb50hqhz90wpyhblqmhy4";
      type = "gem";
    };
    version = "0.4.0";
  };
  syslog-logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14y20phq1khdla4z9wvf98k7j3x6n0rjgs4f7vb0xlf7h53g6hbm";
      type = "gem";
    };
    version = "1.6.8";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gcarlmpfbmqnjvwfz44gdjhcmm634di7plcx2zdgwdhrhifhqw7";
      type = "gem";
    };
    version = "1.4.0";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1arxpii25xgb3fkgqp5acyc0x6179j3qzld78lflgsdxqfcf897k";
      type = "gem";
    };
    version = "0.4.2";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bz11pq7n1g51f50jqmgyf5b1v64p1pfqmy5l21y6vpr37b2lwkd";
      type = "gem";
    };
    version = "0.6.0";
  };
  tomlrb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00x5y9h4fbvrv4xrjk4cqlkm4vq8gv73ax4alj3ac2x77zsnnrk8";
      type = "gem";
    };
    version = "1.3.0";
  };
  train-core = {
    dependencies = [
      "addressable"
      "ffi"
      "json"
      "mixlib-shellout"
      "net-scp"
      "net-ssh"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1paxsm06cbhq73k8p4fnb184774w0rrycwzg78lh9awlv6s3wgxw";
      type = "gem";
    };
    version = "3.16.1";
  };
  train-rest = {
    dependencies = [
      "aws-sigv4"
      "rest-client"
      "train-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qwa4vwzz9lipvibd83ra6lb7a345xxyg8r13z7p0982jsrspp33";
      type = "gem";
    };
    version = "0.5.0";
  };
  train-winrm = {
    dependencies = [
      "chef-winrm"
      "chef-winrm-elevated"
      "chef-winrm-fs"
      "socksify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yl4hzwksa89xd7hzfhr299q1w8hqmvzcfqxxi7rhm22y9k5d8sg";
      type = "gem";
    };
    version = "0.4.3";
  };
  tty-box = {
    dependencies = [
      "pastel"
      "strings"
      "tty-cursor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12yzhl3s165fl8pkfln6mi6mfy3vg7p63r3dvcgqfhyzq6h57x0p";
      type = "gem";
    };
    version = "0.7.0";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-prompt = {
    dependencies = [
      "pastel"
      "tty-reader"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j4y8ik82azjxshgd4i1v4wwhsv3g9cngpygxqkkz69qaa8cxnzw";
      type = "gem";
    };
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = [
      "tty-cursor"
      "tty-screen"
      "wisper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cf2k7w7d84hshg4kzrjvk9pkyc2g1m3nx2n1rpmdcf0hp4p4af6";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l4vh6g333jxm9lakilkva2gn17j6gb052626r1pdbmy2lhnb460";
      type = "gem";
    };
    version = "0.8.2";
  };
  tty-spinner = {
    dependencies = [ "tty-cursor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hh5awmijnzw9flmh5ak610x1d00xiqagxa5mbr63ysggc26y0qf";
      type = "gem";
    };
    version = "0.9.3";
  };
  tty-table = {
    dependencies = [
      "pastel"
      "strings"
      "tty-screen"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fcrbfb0hjd9vkkazkksri93dv9wgs2hp6p1xwb1lp43a13pmhpx";
      type = "gem";
    };
    version = "0.12.0";
  };
  unf_ext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sf6bxvf6x8gihv6j63iakixmdddgls58cpxpg32chckb2l18qcj";
      type = "gem";
    };
    version = "0.0.9.1";
  };
  unicode-display_width = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nkz7fadlrdbkf37m0x7sw8bnz8r355q3vwcfb9f9md6pds9h9qj";
      type = "gem";
    };
    version = "2.6.0";
  };
  unicode_utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h1a5yvrxzlf0lxxa1ya31jcizslf774arnsd89vgdhk4g7x08mr";
      type = "gem";
    };
    version = "1.4.0";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    version = "1.1.1";
  };
  uuidtools = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s8h35ia80p919kidb66nfp8904rhdmn41z9ghsx4ihp2ild3bn4";
      type = "gem";
    };
    version = "2.2.0";
  };
  vault = {
    dependencies = [
      "aws-sigv4"
      "base64"
      "connection_pool"
      "net-http-persistent"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wycd7g00ji9fqlk4ka0qm5fbs37xxd273g8zsnfql61vhf5h83w";
      type = "gem";
    };
    version = "0.20.0";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    version = "1.9.2";
  };
  wisper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rpsi0ziy78cj82sbyyywby4d0aw0a5q84v65qd28vqn79fbq5yf";
      type = "gem";
    };
    version = "2.0.1";
  };
  wmi-lite = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nnx4xz8g40dpi3ccqk5blj1ck06ydx09f9diksn1ghd8yxzavhi";
      type = "gem";
    };
    version = "1.0.7";
  };
  yajl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r1i0jjxbnnll8336y144sphn1cdns5n8ygb31z826i6xirq8w8d";
      type = "gem";
    };
    version = "0.3.4";
  };
}
