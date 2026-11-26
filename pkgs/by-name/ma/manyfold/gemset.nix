{
  action_text-trix = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02a0yz97d12cf6wcj5r43ak57mhlcj4r84k5ma2g570046aga4kh";
      type = "gem";
    };
    version = "2.1.19";
  };
  actioncable = {
    dependencies = [
      "actionpack"
      "activesupport"
      "nio4r"
      "websocket-driver"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z67s63cwr400z6rcrlxdq5scyjac9b2mwz9154fjwvr57vp0xh0";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  actionmailbox = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activestorage"
      "activesupport"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y4g3bp6dk416j4kq9lbzhlc2j0yq8bpk2z3p0qkwfmz8bc3vd0q";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "rails-dom-testing"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rnhk9r93jyc5lrsrkpfgcprmkpd6h33b5qyfpb8vr24yznivdx7";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "nokogiri"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
      "useragent"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jybf0v6vw571dpybzva6r72cbiyxchgzqdx742yylr6pmy2wvwc";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  actiontext = {
    dependencies = [
      "action_text-trix"
      "actionpack"
      "activerecord"
      "activestorage"
      "activesupport"
      "globalid"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1niq5kk32ks2fn8kzvrm3r5xdkg6zan96ry6rsznnavfq4fn2ngv";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0azicca8i0l1rflz25vwzmaflvxyzkrjr2zyzigikh6hz2f4snyj";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ab2yd79h5xac0zmyzr3lvawl9v5kdghqjhkgxgns0d13qqwki42";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  activejob-status = {
    dependencies = [
      "activejob"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qfqjgk739y2ccw1vxqi9ws9vypnrvk0ihziw17g52sw6g9shcz3";
      type = "gem";
    };
    version = "1.0.2";
  };
  activejob-unique = {
    dependencies = [
      "activejob"
      "redlock"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r8kag0ij8n4f69lq9ffp0s1gdzd9zyv3jb1phzl5jgha2h730km";
      type = "gem";
    };
    version = "0.5.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "postgres"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "019806vxvjp20h7k7ngp8g0cafp67pi4p7kq5n5wkyvjac8ayg06";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [
      "default"
      "development"
      "postgres"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11vywsy6rgih4w1annn784bjg7gnmz3l4pc3gy9i1lmml2f5jrdx";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  activerecord-nulldb-adapter = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s7rkrfkaiab9j622q2l5ahm0g7vr7ca6x72j9mda6pikbjb5q01";
      type = "gem";
    };
    version = "1.2.2";
  };
  activestorage = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activesupport"
      "marcel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rjwy1wfs9ifg34qbhxjl1jyfw31rjm8kh52h0x7511m9w8jykhg";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  activesupport = {
    dependencies = [
      "base64"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "json"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
      "uri"
    ];
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mvy0408pvfs4wx9qvsa7jgaw6l9d0zwg2nvzjhqap563hs4zb0n";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  acts-as-taggable-on = {
    dependencies = [
      "activerecord"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0db1p8f1z1zd05z12ivhya1y5214d6nm8xdmfp8mii7bvp37d9yw";
      type = "gem";
    };
    version = "13.0.0";
  };
  acts_as_favoritor = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gpr4lq5nh1ydvcckj6h2xlrakdfpzzm64g1x58d6ck2ng64m8ca";
      type = "gem";
    };
    version = "6.0.2";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qnyv445xndwiks86azzq22pih1b3nlx5q6nbbb1vw5d070bj4sy";
      type = "gem";
    };
    version = "2.10.0";
  };
  aes_key_wrap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19bn0y70qm6mfj4y1m0j3s8ggh6dvxwrwrj5vfamhdrpddsz8ddr";
      type = "gem";
    };
    version = "1.1.0";
  };
  altcha-rails = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r1fyb35rak59nnrdqsgnskmjj9askzvxy8ql58kjgbzl2hjydp3";
      type = "gem";
    };
    version = "0.1.0";
  };
  arel_extensions = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l5l5np66r5fj0d2sw9v3m9k0zwc2cvwnkxih2pmr59f3k7723yf";
      type = "gem";
    };
    version = "2.5.0";
  };
  assimp-ffi = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "a36639b60556dcd9982e6305089fe32e6d716d6a";
      sha256 = "1g1nhz0cza8nqcg72a7fmfymzq29zzcqnzbqxcarlj5qzqqs1n17";
      type = "git";
      url = "https://github.com/Kerilk/assimp-ruby.git";
    };
    version = "0.1.8";
  };
  ast = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  attr_required = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16fbwr6nmsn97n0a6k1nwbpyz08zpinhd6g7196lz1syndbgrszh";
      type = "gem";
    };
    version = "1.0.2";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15nf544xhbhxgm4d38479yifqjspa41ysjp58h1v0jyzc6fakdnf";
      type = "gem";
    };
    version = "1.4.1";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14vgg9hbmsqqsvxvhq8lzsam0pzfwhgbyay0wwbl661z9nq8npfy";
      type = "gem";
    };
    version = "1.1311.0";
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
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03arjw4za7fpixsdcxibxkc2hipggip95mdkddss0pl6hmiipk6y";
      type = "gem";
    };
    version = "3.272.0";
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
      sha256 = "0lw8ypfa5jh0pdqb6hgxnraybfp81ky6h2s8s25s5y9llky8dgnx";
      type = "gem";
    };
    version = "1.145.0";
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
      sha256 = "0fpqv9g3xjpgi2zx35nm8p1s7jc5hr6a8qraya5wxcpzmxwcws7n";
      type = "gem";
    };
    version = "1.245.1";
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
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  bcp47_spec = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "043qld01c163yc7fxlar3046dac2833rlcg44jbbs9n1jvgjxmiz";
      type = "gem";
    };
    version = "0.2.1";
  };
  bcrypt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0clhya4p8lhjj7hp31inp321wgzb0b5wbwppmya5sw1dikl7400z";
      type = "gem";
    };
    version = "3.1.22";
  };
  better_content_security_policy = {
    dependencies = [ "rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bd8i6rfnliid7lqlqr8i33y4x9ixdk18rdhqljd0g15q0gld7hs";
      type = "gem";
    };
    version = "0.1.4";
  };
  better_html = {
    dependencies = [
      "actionview"
      "activesupport"
      "ast"
      "erubi"
      "parser"
      "smart_properties"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xngv2yj85hiw8lgb4kqp807a41wmbl3bgrv6c4bg5lnn1mbd2p6";
      type = "gem";
    };
    version = "2.2.0";
  };
  bigdecimal = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0612spks81fvpv2zrrv3371lbs6mwd7w6g5zafglyk75ici1x87a";
      type = "gem";
    };
    version = "3.3.1";
  };
  bindata = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n4ymlgik3xcg94h52dzmh583ss40rl3sn0kni63v56sq8g6l62k";
      type = "gem";
    };
    version = "2.5.1";
  };
  bindex = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zmirr3m02p52bzq4xgksq4pn8j641rx5d4czk68pv9rqnfwq7kv";
      type = "gem";
    };
    version = "0.8.1";
  };
  bootsnap = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1drb6a74qfzdilyjfx6vhcmps4mj15h14zmw4k9y7xbbvbf4kmzh";
      type = "gem";
    };
    version = "1.26.2";
  };
  brakeman = {
    dependencies = [ "racc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12j19z6yq4acga7g1qn4ih2bbx8zw5aj6b92f40r3ghiz5gd4f50";
      type = "gem";
    };
    version = "8.1.1";
  };
  browser = {
    groups = [
      "default"
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bffb8dddrg6zn8c74swhy8mq2mysb195hi7chwwj9c8g2am4798";
      type = "gem";
    };
    version = "6.2.0";
  };
  builder = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  bullet = {
    dependencies = [
      "activesupport"
      "uniform_notifier"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lxbp93zhjzmg3kbcli7y5blpv1g2pn083ra5ap3zky99761i173";
      type = "gem";
    };
    version = "8.3.1";
  };
  byebug = {
    dependencies = [ "reline" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pg05blj56sxdxq9d54386y9rlvj36vl95x21x9clh8rfpz3w9nj";
      type = "gem";
    };
    version = "13.0.0";
  };
  caber = {
    dependencies = [ "rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "501a9f4dba0df4772f41713fc69cfc8ec470a7ba";
      sha256 = "0549g458nl1z52rhwp7w8ms4jgsr1r7n3hi1iiablw5hhcl0nsyf";
      type = "git";
      url = "https://github.com/manyfold3d/caber.git";
    };
    version = "0.4.0";
  };
  capybara = {
    dependencies = [
      "addressable"
      "matrix"
      "mini_mime"
      "nokogiri"
      "rack"
      "rack-test"
      "regexp_parser"
      "xpath"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vxfah83j6zpw3v5hic0j70h519nvmix2hbszmjwm8cfawhagns2";
      type = "gem";
    };
    version = "3.40.0";
  };
  capybara-screenshot = {
    dependencies = [
      "capybara"
      "launchy"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "85521ff1b7e049219ef354372c76b84fac6939e3";
      sha256 = "1imascdgsdx9gqzs06kgia7s7409qy30h26fgfhzg9587skiwv2y";
      type = "git";
      url = "https://github.com/el-cms/capybara-screenshot.git";
    };
    version = "1.0.26";
  };
  cgi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fzqwshg1xzbdm97havskfp6wifsgbjii00dzba0y6bih4lk1jk1";
      type = "gem";
    };
    version = "0.5.2";
  };
  childprocess = {
    dependencies = [ "logger" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v5nalaarxnfdm6rxb7q6fmc6nx097jd630ax6h9ch7xw95li3cs";
      type = "gem";
    };
    version = "5.1.0";
  };
  chunky_png = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  climate_control = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "198aswdyqlvcw9jkd95b7b8dp3fg0wx89kd1dx9wia1z36b1icin";
      type = "gem";
    };
    version = "1.2.0";
  };
  cocooned = {
    dependencies = [ "rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fb5vwgjx62zjk32hkrlq69sklmglp72z7yd3hx8jjklcjq50w44";
      type = "gem";
    };
    version = "3.0.1";
  };
  coderay = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [
      {
        engine = "jruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qfi2ns3zwkgq616fc127xiqhan7g7m7gqpwriwcr34nds1vxwdj";
      type = "gem";
    };
    version = "1.3.8";
  };
  connection_pool = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pnbi727fxfsaxzyjafzyx08w0pgw3fs5s067rsrd4q3w0zfxy70";
      type = "gem";
    };
    version = "3.0.3";
  };
  content_disposition = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05m5ipc81fj2pphlz1ms1yxq80ymilfjhprz790lafjlq6lks5da";
      type = "gem";
    };
    version = "1.0.0";
  };
  crack = {
    dependencies = [
      "bigdecimal"
      "rexml"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zjcdl5i6lw508r01dym05ibhkc784cfn93m1d26c7fk1hwi0jpz";
      type = "gem";
    };
    version = "1.0.1";
  };
  crass = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zjfw8xs3zlqaa07s4m500x84i6437l9r9mk4dwqx7y5lb3la0bs";
      type = "gem";
    };
    version = "1.0.8";
  };
  cronex = {
    dependencies = [
      "tzinfo"
      "unicode"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11i1psgzcqzj4a7p62vy56i5p8s00d29y9rf9wf9blpshph99ir1";
      type = "gem";
    };
    version = "0.15.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y5rf6g10xb9yp526j84ag7in0r2gx767ssmsij8dni8crpz38qm";
      type = "gem";
    };
    version = "3.3.7";
  };
  data_migrate = {
    dependencies = [
      "activerecord"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ywg2qvpf1yxfbcdwmw2pl274i4bicjc4gsz6gaq5r0mklcb5f8q";
      type = "gem";
    };
    version = "11.3.1";
  };
  database_cleaner-active_record = {
    dependencies = [
      "activerecord"
      "database_cleaner-core"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1203q6zdw14vwmnr2hw0d6b1rdz4d07w3kjg1my1zhw862gnnac8";
      type = "gem";
    };
    version = "2.2.2";
  };
  database_cleaner-core = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v44bn386ipjjh4m2kl53dal8g4d41xajn2jggnmjbhn6965fil6";
      type = "gem";
    };
    version = "2.0.1";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "105m4y6iwannk0vmn43px6rh8mlczp1bispq6hsxksr49rf99b0q";
      type = "gem";
    };
    version = "3.6.0";
  };
  devise = {
    dependencies = [
      "bcrypt"
      "orm_adapter"
      "railties"
      "responders"
      "warden"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hacqyck22k7g9qr9n5wwq32vg02hwwjv7kqxrb4xrslb2wg41fn";
      type = "gem";
    };
    version = "5.0.4";
  };
  devise_invitable = {
    dependencies = [
      "actionmailer"
      "devise"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0id7ybs14qgxj4wgrnkw65rlgkpbaqwkh2c8y4pp0cdac4vq94n0";
      type = "gem";
    };
    version = "2.0.14";
  };
  devise_zxcvbn = {
    dependencies = [
      "devise"
      "zxcvbn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vp3gvbm9q268f6dvjx08aczb0j486s75yrd8zcifzv5a05mzd4j";
      type = "gem";
    };
    version = "6.0.0";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
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
  doorkeeper = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11pchqkzd0jp5alh0554yqybnhr3bj2jdghqal3prsn22mwch7v9";
      type = "gem";
    };
    version = "5.9.9";
  };
  doorkeeper-i18n = {
    dependencies = [ "doorkeeper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "195l8nfay1yb4igg348mjffikvh1m16b4899gyzz7ysgwkx3m9yy";
      type = "gem";
    };
    version = "5.2.9";
  };
  dotenv = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17b1zr9kih0i3wb7h4yq9i8vi6hjfq07857j437a8z7a44qvhxg3";
      type = "gem";
    };
    version = "3.2.0";
  };
  dotenv-rails = {
    dependencies = [
      "dotenv"
      "railties"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1axy0frn3xn3jf1gdafx5rzz843551q1ckwcbp4zy8m69dajazk5";
      type = "gem";
    };
    version = "3.2.0";
  };
  down = {
    dependencies = [
      "addressable"
      "base64"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14xm29krs5mklya6wg0lfvwiccrhi2rnnn82bm13pgwc0zdnvv28";
      type = "gem";
    };
    version = "5.6.0";
  };
  drb = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wrkl7yiix268s2md1h6wh91311w95ikd8fy8m5gx589npyxc00b";
      type = "gem";
    };
    version = "2.2.3";
  };
  dry-cli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x6qlxk6zp3jw748k6x3zkpywx9yjyagdyinb9qai2khdjvmn0dq";
      type = "gem";
    };
    version = "1.4.1";
  };
  ed25519 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01n5rbyws1ijwc5dw7s88xx3zzacxx9k97qn8x11b6k8k18pzs8n";
      type = "gem";
    };
    version = "1.4.0";
  };
  email_validator = {
    dependencies = [ "activemodel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0106y8xakq6frv2xc68zz76q2l2cqvhfjc7ji69yyypcbc4kicjs";
      type = "gem";
    };
    version = "2.2.4";
  };
  erb = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14pfj6zn0p1hxj6s6s0r7d424wap8zl9zxf89nj79y8fbg16vjn5";
      type = "gem";
    };
    version = "6.0.7";
  };
  erb_lint = {
    dependencies = [
      "activesupport"
      "better_html"
      "parser"
      "rainbow"
      "rubocop"
      "smart_properties"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cbwr8iv6d9g50w12a7ccvcrqk5clz4mxa3cspqd3s1rv05f9dfz";
      type = "gem";
    };
    version = "0.9.0";
  };
  erubi = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    version = "1.13.1";
  };
  et-orbi = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g785lz4z2k7jrdl7bnnjllzfrwpv9pyki94ngizj8cqfy83qzkc";
      type = "gem";
    };
    version = "1.4.0";
  };
  factory_bot = {
    dependencies = [ "activesupport" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12abilw8sgpr8250x5rfjs1cll62r1p1pv3slak81j8fcasv7h8z";
      type = "gem";
    };
    version = "6.6.0";
  };
  faker = {
    dependencies = [ "i18n" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z1yfmqwml3gr1hjnjx6qbchmvr29j6z317wlhkhzabkvw4b6iy1";
      type = "gem";
    };
    version = "3.8.0";
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
      sha256 = "0vmb5wpiz7mf2r6vjvhvfp38rrfvqjzmv7m3max0s6v28j641d4v";
      type = "gem";
    };
    version = "2.14.4";
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
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mzp9rlqiryyi99bm9ii80hfsbbafh9wl8r3c5pif51pd54sk2bx";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "125m3qri52vwh5v9dhq0dkqxf8629cxrf99yyc01pva72wasyy0f";
      type = "gem";
    };
    version = "3.4.4";
  };
  fasp_client = {
    dependencies = [
      "ed25519"
      "linzer"
      "rails"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x976mj330m151nnk6qn6zb9lcz58m33ifc3kngbq21nxh3a3yy1";
      type = "gem";
    };
    version = "0.6.0";
  };
  fedipub = {
    dependencies = [
      "faraday"
      "faraday-follow_redirects"
      "jbuilder"
      "json"
      "json-ld"
      "json-ld-preloaded"
      "kaminari"
      "linzer"
      "ostruct"
      "pundit"
      "rails"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wm96w9dhh38nq6525r8npb4h6zn4kasjhqqycnb51nwih7mdisp";
      type = "gem";
    };
    version = "0.11.2";
  };
  fedipub-moderation = {
    dependencies = [
      "fedipub"
      "public_suffix"
      "rails"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l5wnhgfarc2xld99prz1s82s0b7af549fmk1x81qb1nkda90y3w";
      type = "gem";
    };
    version = "0.6.0";
  };
  ffi = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kqasqvy8d7r09ri4n6bkdwbk63j7afd9ilsw34nzlgh0qp69ldw";
      type = "gem";
    };
    version = "1.17.4";
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
  fiber-storage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qa0j9qjwav9xb0n3isx0rbh0942xrfback392n6vs8bidnmp3pl";
      type = "gem";
    };
    version = "1.0.1";
  };
  formatador = {
    dependencies = [ "reline" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "156qa2wiizmdalz6cim04yaasdz1q6c6k7yhnpdnrhn26f0qkyhr";
      type = "gem";
    };
    version = "1.2.3";
  };
  forwardable = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f78rjpnhm4lgp1qzadnr6kr02b6afh1lvy7w607k4qjk3641kgi";
      type = "gem";
    };
    version = "1.4.0";
  };
  fugit = {
    dependencies = [
      "et-orbi"
      "raabro"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s5gg88f2d5wpppgrgzfhnyi9y2kzprvhhjfh3q1bd79xmwg962q";
      type = "gem";
    };
    version = "1.12.1";
  };
  get_process_mem = {
    dependencies = [
      "bigdecimal"
      "ffi"
    ];
    groups = [
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1amlw0v8mal01k0c8n6i5x7a8fxw44myqm81dr6nlxxzpkrj8h6m";
      type = "gem";
    };
    version = "1.0.0";
  };
  gettext = {
    dependencies = [
      "erubi"
      "locale"
      "prime"
      "racc"
      "text"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16h0kda5z4s4zqygyk0f52xzs9mlz9r4lnhjwk729hhmdbz68a19";
      type = "gem";
    };
    version = "3.4.9";
  };
  gitlab-sidekiq-fetcher = {
    dependencies = [
      "json"
      "sidekiq"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "c83c089b3e18ff14322b92b7c0fba0cf3bc8e538";
      sha256 = "1lj6nwg60inlqs7k89wimbzhag46jwnjn2qpmqrwmkgqh3si7crn";
      type = "git";
      url = "https://github.com/DocSpring/sidekiq-reliable-fetch.git";
    };
    version = "0.9.0";
  };
  glob = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pbi807vblcc3yb17sn8m3qsh6ksgsiw30x475mqjzzvkx0m13p6";
      type = "gem";
    };
    version = "0.4.1";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09zl0rkskfq0cwfrk9ypjvflvzanfg3xbhh1slaa1myry7xi4zq3";
      type = "gem";
    };
    version = "1.4.0";
  };
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [
      "default"
      "postgres"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1514wvzq5nz62khyyi644vbp3yk580lczk8cmcvasjp11bssz39g";
      type = "gem";
    };
    version = "4.36.2";
  };
  graphlient = {
    dependencies = [
      "faraday"
      "graphql-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15g5kys3m832nakrvswbc4vbrkhfg6lg9dkncbfqybqwa62la1gf";
      type = "gem";
    };
    version = "0.9.0";
  };
  graphql = {
    dependencies = [
      "base64"
      "fiber-storage"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pdicqvbdd16xjrgkd58kkyaydg957qjplpqzl44qp401s8xx74s";
      type = "gem";
    };
    version = "2.6.11";
  };
  graphql-client = {
    dependencies = [
      "activesupport"
      "graphql"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wcw8n2pml22c3fdifacxy901656sjg7jacj10vlkap00wki42qr";
      type = "gem";
    };
    version = "0.26.0";
  };
  guard = {
    dependencies = [
      "formatador"
      "listen"
      "logger"
      "lumberjack"
      "nenv"
      "notiffany"
      "pry"
      "shellany"
      "thor"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ka6s9qjp76fvc2xxpaivama917q47mmf3npgyh1cgbmjk91bn30";
      type = "gem";
    };
    version = "2.21.0";
  };
  guard-compat = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zj6sr1k8w59mmi27rsii0v8xyy2rnsi09nqvwpgj1q10yq1mlis";
      type = "gem";
    };
    version = "1.2.1";
  };
  guard-rspec = {
    dependencies = [
      "guard"
      "guard-compat"
      "rspec"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jkm5xp90gm4c5s51pmf92i9hc10gslwwic6mvk72g0yplya0yx4";
      type = "gem";
    };
    version = "4.7.3";
  };
  hashdiff = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jannv30qa4xanmcb71cs9zhpklqaqbrnj09rhd9dwzyyfw28rqb";
      type = "gem";
    };
    version = "1.3.0";
  };
  hashie = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0glfl7ns0l0x4rah5qb4yki45qdk4shb3fraw2zmk8n7kwg3k5h8";
      type = "gem";
    };
    version = "6.0.0";
  };
  highline = {
    dependencies = [ "reline" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jmvyhjp2v3iq47la7w6psrxbprnbnmzz0hxxski3vzn356x7jv7";
      type = "gem";
    };
    version = "3.1.2";
  };
  htmlentities = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hy5jvzd4wagk0k0yq7bjm6fa7ba7vjggzjfpri95jifkzvbvbxv";
      type = "gem";
    };
    version = "4.4.2";
  };
  http = {
    dependencies = [
      "http-cookie"
      "llhttp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09idshq01jz2vxasfj2ncxrwmlzqi9k1r27i4ja31a4y901gjs1p";
      type = "gem";
    };
    version = "6.0.4";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1aga7z4p0dka4zcqw9i05wa4ab1q7h7cgnj328ldqqfycjz84jxs";
      type = "gem";
    };
    version = "1.1.6";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dfikmmd9dllirsfq0kjiyxpmlq0afkxm5sslsr97r9g85ifpy80";
      type = "gem";
    };
    version = "1.15.2";
  };
  i18n-js = {
    dependencies = [
      "glob"
      "i18n"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m8k77hkbyci3vdlaj8z0fkw733ycmvxa1srbi4qr9lg5wvhsfb1";
      type = "gem";
    };
    version = "4.2.4";
  };
  i18n-tasks = {
    dependencies = [
      "activesupport"
      "ast"
      "erubi"
      "highline"
      "i18n"
      "parser"
      "prism"
      "rails-i18n"
      "rainbow"
      "ruby-progressbar"
      "terminal-table"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01vawb9lymaxq0mps22y5yc77wyamq7rq7cdlb0dpvnfxihh16sh";
      type = "gem";
    };
    version = "1.2.1";
  };
  i18n_data = {
    dependencies = [ "simple_po_parser" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vdj5f3hvaz2av04855sf30nia2sq2m2drv2dqpdri1ys0xy8ypv";
      type = "gem";
    };
    version = "1.1.0";
  };
  image_processing = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x393h8mpkhzw9rqgl4fy7r62cy6bdpmrb1gpfvw4nirlj99ijz0";
      type = "gem";
    };
    version = "2.2.0";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m8lcj26n7qchw21iaafk96mzsqj8b6kjnr455k430269jzrppc3";
      type = "gem";
    };
    version = "0.9.5";
  };
  irb = {
    dependencies = [
      "pp"
      "prism"
      "rdoc"
      "reline"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09qxdzs9q1780jmnp40nbzs42p2fl939z476l83gxjfnpnn5dvjm";
      type = "gem";
    };
    version = "1.19.0";
  };
  jbuilder = {
    dependencies = [
      "actionview"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dvn8m8lnah6id60r0fb7hq3rg6qz6f01cbmb35vmkmhiz1bwc14";
      type = "gem";
    };
    version = "2.15.1";
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
  job-iteration = {
    dependencies = [ "activejob" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v00xw1vshrxjplh5hgdm42c1gavbw382ksai7s5s56g8dh4q2ar";
      type = "gem";
    };
    version = "1.18.1";
  };
  json = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0shwgjqbj856mb6m9kgkpy08nhym2gdvc2yaprlimfmky9y3n78z";
      type = "gem";
    };
    version = "2.21.2";
  };
  json-canonicalization = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0illsmkly0hhi24lm1l6jjjdr6jykvydkwi1cxf4ad3mra68m16l";
      type = "gem";
    };
    version = "1.0.0";
  };
  json-jwt = {
    dependencies = [
      "activesupport"
      "aes_key_wrap"
      "base64"
      "bindata"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k64mp59jlbqd5hyy46pf93s3yl1xdngfy8i8flq2hn5nhk91ybg";
      type = "gem";
    };
    version = "1.17.0";
  };
  json-ld = {
    dependencies = [
      "htmlentities"
      "json-canonicalization"
      "link_header"
      "multi_json"
      "rack"
      "rdf"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09xbw6kc95qgmqcfjp0jjw8dnfm28lw9b5lf8bdh3p2vpy9ihlxr";
      type = "gem";
    };
    version = "3.3.2";
  };
  json-ld-preloaded = {
    dependencies = [
      "json-ld"
      "rdf"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q8y2f9c9940sgqdb57zmlbhjx3rvmq2l8kpi3a9bgzkx8kl6aa6";
      type = "gem";
    };
    version = "3.3.2";
  };
  json-schema = {
    dependencies = [
      "addressable"
      "bigdecimal"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gv3b0nry1sn1n7imfs2drqyfp4g8b2zcrizjc98j04pl7xszv3r";
      type = "gem";
    };
    version = "6.0.0";
  };
  kaminari = {
    dependencies = [
      "activesupport"
      "kaminari-actionview"
      "kaminari-activerecord"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gia8irryvfhcr6bsr64kpisbgdbqjsqfgrk12a11incmpwny1y4";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-actionview = {
    dependencies = [
      "actionview"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02f9ghl3a9b5q7l079d3yzmqjwkr4jigi7sldbps992rigygcc0k";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-activerecord = {
    dependencies = [
      "activerecord"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c148z97s1cqivzbwrak149z7kl1rdmj7dxk6rpkasimmdxsdlqd";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zw3pg6kj39y7jxakbx7if59pl28lhk98fx71ks5lr3hfgn6zliv";
      type = "gem";
    };
    version = "1.2.2";
  };
  kramdown = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h962hnykygkqfj0bmf1wa8kmk6n81xfgp8qn6n5m1wwnrwk9vzv";
      type = "gem";
    };
    version = "2.6.1";
  };
  kramdown-parser-gfm = {
    dependencies = [ "kramdown" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a8pb3v951f4x7h968rqfsa19c8arz21zw1vaj42jza22rap8fgv";
      type = "gem";
    };
    version = "1.1.0";
  };
  language_server-protocol = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w5p8c2145lmqzr25bxh4ikzjm6k8y1k5lriqqdpw9pq730w1wjy";
      type = "gem";
    };
    version = "3.17.0.6";
  };
  launchy = {
    dependencies = [
      "addressable"
      "childprocess"
      "logger"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17h522xhwi5m4n6n9m22kw8z0vy8100sz5f3wbfqj5cnrjslgf3j";
      type = "gem";
    };
    version = "3.1.1";
  };
  letter_opener = {
    dependencies = [ "launchy" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cnv3ggnzyagl50vzs1693aacv08bhwlprcvjp8jcg2w7cp3zwrg";
      type = "gem";
    };
    version = "1.10.0";
  };
  link_header = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yamrdq4rywmnpdhbygnkkl9fdy249fg5r851nrkkxr97gj5rihm";
      type = "gem";
    };
    version = "0.0.8";
  };
  lint_roller = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  linzer = {
    dependencies = [
      "cgi"
      "forwardable"
      "net-http"
      "starry"
      "uri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16zgw608sqmv5aijj6xmm4kf1wzbh3564xx006wcj9zcgl200qg4";
      type = "gem";
    };
    version = "0.8.1";
  };
  listen = {
    dependencies = [
      "logger"
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g3q0hnxnskhlchlyghxdc5dk41pzxr27pd4gms4iwspas2k4gsc";
      type = "gem";
    };
    version = "3.10.1";
  };
  llhttp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10j909ja0qbznas0s3zbj5d8yicpyrw38aa55ymr858yzfm5jg1w";
      type = "gem";
    };
    version = "0.6.2";
  };
  locale = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "107pm4ccmla23z963kyjldgngfigvchnv85wr6m69viyxxrrjbsj";
      type = "gem";
    };
    version = "2.1.4";
  };
  logger = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  lograge = {
    dependencies = [
      "actionpack"
      "activesupport"
      "logger"
      "railties"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14bas220zv5913lf8ginnv2z897rl8jp3wrw4ijsfmm3a8iyvm9j";
      type = "gem";
    };
    version = "0.16.0";
  };
  logstash-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bk7fhhryjxp1klr3hq6i6srrc21wl4p980bysjp0w66z9hdr9w9";
      type = "gem";
    };
    version = "1.2.02";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p0qn2srqbak6x75qp2igv0bfcijb46m6q7m1pl7sancy3p18psl";
      type = "gem";
    };
    version = "2.25.3";
  };
  lumberjack = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "158v35d1l1jjn5dmyawzs82a7fqk1wvw3g1ia21hqf11cgj5mpj0";
      type = "gem";
    };
    version = "1.4.2";
  };
  mail = {
    dependencies = [
      "logger"
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s30l5z7jkazgi4m6l6mh80rgsyhh2pp1pa5h70xclsj8z54wmq6";
      type = "gem";
    };
    version = "2.9.1";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17w53z6vka8ddmxvi936biqv443d5yg0503wj7xfmy9j1qvfjy0n";
      type = "gem";
    };
    version = "1.2.1";
  };
  matrix = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nscas3a4mmrp1rc07cdjlbbpb2rydkindmbj3v3z5y1viyspmd0";
      type = "gem";
    };
    version = "0.4.3";
  };
  memo_wise = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sviicsh5siay8flm7ipqs8jrp34hv2m6df7kf211x6fqhw0q8ih";
      type = "gem";
    };
    version = "1.13.0";
  };
  method_source = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";
      type = "gem";
    };
    version = "1.1.0";
  };
  mini_magick = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y0xs51dlzqlbd0x30pmv2qjn4axc1xacdbzqm9frm4y3mcay87i";
      type = "gem";
    };
    version = "5.4.0";
  };
  mini_mime = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [
      "default"
      "development"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  minitest = {
    dependencies = [
      "drb"
      "prism"
    ];
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vh733a365lw2dpa8zvdmr35715kfrm9hqsli8g67248maakadzz";
      type = "gem";
    };
    version = "6.1.0";
  };
  mittsu = {
    dependencies = [ "chunky_png" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pwcxd1nbdighr6lp7aymdac4lbvmpn2ipz36fywcdfwli55z183";
      type = "gem";
    };
    version = "0.5.0";
  };
  mittsu-mesh_analysis = {
    dependencies = [ "mittsu" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l6dm79bba68w2apkx1kf6xzfhrsryry2kr8x35i1kbbwlshqm8k";
      type = "gem";
    };
    version = "0.1.0";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cyzl8cshfjkvhm980aak1fp5czli9zjqpfrx3k4g42z3dvfrvyz";
      type = "gem";
    };
    version = "1.8.7";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13pabgwf4qd5qn4sl7ci15g5ql038n5z0psip9xabnsbypm32m94";
      type = "gem";
    };
    version = "1.21.2";
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
  mysql2 = {
    groups = [ "mysql" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cysv1wdfdbizwkd0d9s16s832khdwv31pgp01mw2g3bbpa4gx3h";
      type = "gem";
    };
    version = "0.5.6";
  };
  nanoid = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xmk9j0ixaf75ynkyrpi6771k98g2jclghl96b5b94d8gnc1vvvw";
      type = "gem";
    };
    version = "2.0.1";
  };
  naturally = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kcj32lml83mw9yby0xjybd1y84sfgpcy7jwcb7xi7d3c6w8kyqy";
      type = "gem";
    };
    version = "2.4.0";
  };
  nenv = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r97jzknll9bhd8yyg2bngnnkj8rjhal667n7d32h8h7ny7nvpnr";
      type = "gem";
    };
    version = "0.3.0";
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
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ngnmjc7vc4k06dyapgid2gxc4si6yr092sidfps6r3v49ibnc7b";
      type = "gem";
    };
    version = "0.6.8";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ly8x39gr23blbmfwfyy14lb2v9kg8bj5x0b2r2llyb4dy60rygr";
      type = "gem";
    };
    version = "0.4.0";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g4gcydr0hza3wiizny0p5q4phl3fkhfsa4r5xir8bbb9p03q41m";
      type = "gem";
    };
    version = "0.5.2";
  };
  nio4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18fwy5yqnvgixq3cn0h63lm8jaxsjjxkmj8rhiv8wpzv9271d43c";
      type = "gem";
    };
    version = "2.7.5";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f4jz6yhzj7i8gl2zif4pld2plxalkf6pcbp4y3qzcacql3lbsdb";
      type = "gem";
    };
    version = "1.19.7";
  };
  noticed = {
    dependencies = [ "rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08qi62d9ka4sggpnwynbn4j008g64nkpcvns8s7hklchm1x290ns";
      type = "gem";
    };
    version = "3.1.1";
  };
  notiffany = {
    dependencies = [
      "nenv"
      "shellany"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f47h3bmg1apr4x51szqfv3rh2vq58z3grh4w02cp3bzbdh6jxnk";
      type = "gem";
    };
    version = "0.1.3";
  };
  omniauth = {
    dependencies = [
      "hashie"
      "logger"
      "rack"
      "rack-protection"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r9ai368s111g4fgvm37w2vcw5n3h36rc30mj3ms86fyg2jlzjf2";
      type = "gem";
    };
    version = "2.4.2";
  };
  omniauth_openid_connect = {
    dependencies = [
      "omniauth"
      "openid_connect"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "099xg7s6450wlfzs77mbdx78g3dp0glx5q6f44i78akf7283hbqz";
      type = "gem";
    };
    version = "0.8.0";
  };
  openid_connect = {
    dependencies = [
      "activemodel"
      "attr_required"
      "email_validator"
      "faraday"
      "faraday-follow_redirects"
      "json-jwt"
      "mail"
      "rack-oauth2"
      "swd"
      "tzinfo"
      "validate_url"
      "webfinger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k3l4ak1mawrw74qy4xfh81hdfxvamijcjb3f1gadq0ixgprrfqd";
      type = "gem";
    };
    version = "2.3.0";
  };
  orm_adapter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fg9jpjlzf5y49qs9mlpdrgs5rpcyihq1s4k79nv9js0spjhnpda";
      type = "gem";
    };
    version = "0.5.0";
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
  pagy = {
    dependencies = [
      "json"
      "uri"
      "yaml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rsgp5z0859zm9z6dgifxqdnz4h86az898vq1hbmc15g8liqwhmc";
      type = "gem";
    };
    version = "43.8.5";
  };
  parallel = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vvs2sar7wnw70j1jc1kv1k23m5grc0ci3bbrcf6mkh18683wnpp";
      type = "gem";
    };
    version = "2.3.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13z5jwb190xmvxq9kmdz82mi306bkl78h4fqw9g446dryxmggy32";
      type = "gem";
    };
    version = "3.3.14.0";
  };
  pg = {
    groups = [ "postgres" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yval9rdbc0p01dmf8zwm953w1hk0ggdp1pgr7a87s442983ddgp";
      type = "gem";
    };
    version = "1.7.0";
  };
  pg_query = {
    dependencies = [ "google-protobuf" ];
    groups = [ "postgres" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vb7rlmjkx9b5y719zqfbszmd32xrskdpzb2rapmj4rwihid85r1";
      type = "gem";
    };
    version = "6.2.5";
  };
  pghero = {
    dependencies = [ "activerecord" ];
    groups = [ "postgres" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pn3vb9c51li1mrf5vs88c2lx1k7wbm1v2k44wf1f9d8mwaha078";
      type = "gem";
    };
    version = "4.1.0";
  };
  phlex = {
    dependencies = [
      "refract"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01p2x2wb6r5mr9y087jzlcvm4lv7anc56b37zf7bh32am2170frq";
      type = "gem";
    };
    version = "2.4.2";
  };
  phlex-rails = {
    dependencies = [
      "phlex"
      "railties"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xcm056il5zj0yiqpzs489j0w5dcsf3iiarvfljwn6k8i3adpk9b";
      type = "gem";
    };
    version = "2.4.0";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w5mha75hs8gdj75g8vl0sxpyp8rzvwq8a4jcmi4ah8cf370zjyz";
      type = "gem";
    };
    version = "0.6.4";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m5pqkp8rdk0bkxxz3bp3vn8pn3bd9a97dkl8wfh1kyplrzdamfm";
      type = "gem";
    };
    version = "0.2.1";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pi2g9sd9ssyrpvbybh4skrgzqrv0rrd1q7ylgrsd519gjzmwxad";
      type = "gem";
    };
    version = "0.1.4";
  };
  prism = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  private_address_check = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dmlwgv6lqy4hviqxvq91l1ipgbdqq90lglzyrv5b5c6cbkc79mw";
      type = "gem";
    };
    version = "0.8.0";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
      "reline"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k5ck0mfd3mkmg7d7vi2x9z53spmbhnqkln6xr5w6bbzdv484bfr";
      type = "gem";
    };
    version = "0.16.1";
  };
  public_suffix = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08znfv30pxmdkjyihvbjqbvv874dj3nybmmyscl958dy3f7v12qs";
      type = "gem";
    };
    version = "7.0.5";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p7fdhxg6kgxgnn389dw12z3xm5m74wp06yimdg1gl54r4s9lv9s";
      type = "gem";
    };
    version = "8.1.2";
  };
  pundit = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gcb23749jwggmgic4607ky6hm2c9fpkya980iihpy94m8miax73";
      type = "gem";
    };
    version = "2.5.2";
  };
  raabro = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10m8bln9d00dwzjil1k42i5r7l82x25ysbi45fwyv4932zsrzynl";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k0d8vpg160wjnp344wyn3jp70c8paz3nhglrzninihciz8c2dc2";
      type = "gem";
    };
    version = "3.2.9";
  };
  rack-contrib = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00idlf24sd64y5mcvs6w0f5snam7mv6w8c1i2zwp0cla5gl2rgai";
      type = "gem";
    };
    version = "2.5.0";
  };
  rack-cors = {
    dependencies = [
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s1zymxhk7pkzsrgrn5ax862p07s0drbv0qvnq36jq1rvdhvx5bv";
      type = "gem";
    };
    version = "3.0.0";
  };
  rack-oauth2 = {
    dependencies = [
      "activesupport"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
      "json-jwt"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19fi42hi9l474ki89y6cs8vrpfmc1h8zpd02iwjy4hw0a1yahfn7";
      type = "gem";
    };
    version = "2.2.1";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16as0s0hg7a7mhrcv4dpavawxwdiidbcwlj4ai0l0b26mr6pcx8f";
      type = "gem";
    };
    version = "4.2.2";
  };
  rack-proxy = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02zz3ym580wa317snbcq3d70nfrysbvjs3bigrj5k73dpqvnli0y";
      type = "gem";
    };
    version = "0.8.3";
  };
  rack-session = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s7zcxlmg88a6dam4aqbgk9xkpy6dkdfqmmcszkkliy3q3w38m2r";
      type = "gem";
    };
    version = "2.1.2";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s212a39z3v1ksgnhvwddsiq2n7dr4cqvzdnq4pmfb00rivx265i";
      type = "gem";
    };
    version = "2.3.0";
  };
  rackup = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s48d2a0z5f0cg4npvzznf933vipi6j7gmk16yc913kpadkw4ybc";
      type = "gem";
    };
    version = "2.3.1";
  };
  rails = {
    dependencies = [
      "actioncable"
      "actionmailbox"
      "actionmailer"
      "actionpack"
      "actiontext"
      "actionview"
      "activejob"
      "activemodel"
      "activerecord"
      "activestorage"
      "activesupport"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g2hjr78884v1rb7wnhbwvgahk1dc8kfir980vkdcfvis853lp1n";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  rails-controller-testing = {
    dependencies = [
      "actionpack"
      "actionview"
      "activesupport"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "151f303jcvs8s149mhx2g5mn67487x0blrf9dzl76q1nb7dlh53l";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07awj8bp7jib54d0khqw391ryw8nphvqgw4bb12cl4drlx9pkk4a";
      type = "gem";
    };
    version = "2.3.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0914z9493y3bjhm1c5hn4yp8djqlfma3qiw24a7gqfb6g9dz87m2";
      type = "gem";
    };
    version = "1.7.2";
  };
  rails-i18n = {
    dependencies = [
      "i18n"
      "railties"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03dy8nmq2gxvkg8zqq6c0wwz98mdwp3i9krn0slcknhb8nak2c0m";
      type = "gem";
    };
    version = "8.0.1";
  };
  rails-settings-cached = {
    dependencies = [
      "activerecord"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14qp6003fvsnjblivxf8q0404dr1wq879c2zylwh3wj5ssqg1z12";
      type = "gem";
    };
    version = "2.10.0";
  };
  rails_performance = {
    dependencies = [
      "browser"
      "railties"
      "redis"
    ];
    groups = [
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j3wwcgfmgr5chcczqsqyhvvynw5g8q9ink2lf6sj6q5bjljj83i";
      type = "gem";
    };
    version = "1.6.0";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "tsort"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10lpmaa7klwllkkfl4nh9nqp3vg2fv3i3gl83y0qkg1clssz8bpz";
      type = "gem";
    };
    version = "8.1.4.1";
  };
  rainbow = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "009p524zl0p0kfa65nii8wdmaigkmawv9pbvlcffky7islmmp0nb";
      type = "gem";
    };
    version = "13.4.2";
  };
  rb-fsevent = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  rbs = {
    dependencies = [
      "logger"
      "prism"
      "tsort"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x067q8cdam4kv5dc09iq2nzca8qm2kdl0dr22gc0ny0vj3bixsi";
      type = "gem";
    };
    version = "4.2.0";
  };
  rdf = {
    dependencies = [
      "bcp47_spec"
      "bigdecimal"
      "link_header"
      "logger"
      "ostruct"
      "readline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1har1346p7jwrs89d5w1gv98jk2nh3cwkdyvkzm2nkjv3s1a0zx7";
      type = "gem";
    };
    version = "3.3.4";
  };
  rdoc = {
    dependencies = [
      "erb"
      "prism"
      "rbs"
      "tsort"
    ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02pn63i2r5z44hcfhxbaag9rvqsyznsliivnn7f3dzaw1a43gz5y";
      type = "gem";
    };
    version = "8.1.0";
  };
  readline = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0shxkj3kbwl43rpg490k826ibdcwpxiymhvjnsc85fg2ggqywf31";
      type = "gem";
    };
    version = "0.0.4";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [
      "default"
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bpsh5dbvybsa8qnv4dg11a6f2zn4sndarf7pk4iaayjgaspbrmm";
      type = "gem";
    };
    version = "5.4.1";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [
      "default"
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0baj2r8wa6imzfndyz6cj732v8nq02wy7nicfciqdr5zgdfbqlai";
      type = "gem";
    };
    version = "0.30.1";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f92i9cwlp6xj6fyn7qn4qsaqvxfw4wqvayll7gbd26qnai1l6p9";
      type = "gem";
    };
    version = "1.11.0";
  };
  redlock = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pixi711vv0f7g16dkr55x2mrq1kfxmpcmmknqsj84bqgiyjy9ny";
      type = "gem";
    };
    version = "2.0.6";
  };
  refract = {
    dependencies = [
      "prism"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ix9qwgj250x2xgw1mgm5xcrml70fgfzxqh1261r4xlzwckrcfzf";
      type = "gem";
    };
    version = "1.1.0";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09yvadj15kzz9hbq0gvql92kpbn04q9b9ck1vkmhd5zw5av3x0y9";
      type = "gem";
    };
    version = "2.13.3";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gaq2lc463ap1srz7y5kh2p4dxazs7vjrpiby58d9yfvan72s0av";
      type = "gem";
    };
    version = "0.7.0";
  };
  request_store = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jw89j9s5p5cq2k7ffj5p4av4j4fxwvwjs1a4i9g85d38r9mvdz1";
      type = "gem";
    };
    version = "1.7.0";
  };
  responders = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "117sixdsf6w6a239bypmjs7cv0hyhmd2x19dfw74qrfsrdq2jxy2";
      type = "gem";
    };
    version = "3.2.1";
  };
  reverse_markdown = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1948p6kfc93w6jqrxdd5ypp5fg93s7cikr31cqywm44af3rnkibz";
      type = "gem";
    };
    version = "3.1.0";
  };
  rexml = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  roda = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01kwqzqg0ypcjh0nf0z8xhdfsb65iz4iv6jq23n3gl7wy6hcfh5z";
      type = "gem";
    };
    version = "3.107.0";
  };
  rolify = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dmmvqx8sh5f8s2y7lx59q2avskfjhmw1k7rlsnwqcs01kvznigy";
      type = "gem";
    };
    version = "6.0.1";
  };
  rouge = {
    dependencies = [ "strscan" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ljlr1da64kx3mimpzb4x2yczk08b0sg04h2ji3m2zxb88l66z5p";
      type = "gem";
    };
    version = "5.1.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0saldf4kdq8d6fipcnfjq8bj9hkwv2vg98y6rc2rh4c8jxnz2ky6";
      type = "gem";
    };
    version = "3.13.7";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d9gs81alv270yxfx8082g6z4f301ifdnzx8hl6mpzv7sfk8qlxz";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c1acydkadw3r27vx07glfldasgc1bwcxairc359hq2a0prpyp7a";
      type = "gem";
    };
    version = "3.13.9";
  };
  rspec-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gpkvfjb8dl2k54886y6m7jw30349y111m0jwib4nr3xgx76lv2y";
      type = "gem";
    };
    version = "8.1.0";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mpzl1c5537wd36h4m1g2rvwbz2xlchfgpv3k2fkwzlv60q005p4";
      type = "gem";
    };
    version = "3.13.8";
  };
  rswag = {
    dependencies = [
      "rswag-api"
      "rswag-specs"
      "rswag-ui"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k2125why1fx39j726bk701qj9gijwl1hxrjnn6ly3sz42yng8mb";
      type = "gem";
    };
    version = "2.17.0";
  };
  rswag-api = {
    dependencies = [
      "activesupport"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04ssahiw9fn3dvxzp7gbrlnc51dlcz9fbc14c2mvi2hncmmk72vj";
      type = "gem";
    };
    version = "2.17.0";
  };
  rswag-specs = {
    dependencies = [
      "activesupport"
      "json-schema"
      "railties"
      "rspec-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qx9mxhnwz8ia9ry1fwn3hzc2zg7n774gvm4whgp9y49vzvbvcm3";
      type = "gem";
    };
    version = "2.17.0";
  };
  rswag-ui = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04ij8kr28qg70f3511vks38rnhcyww0y9xhrypwxswc1bsdpnw2z";
      type = "gem";
    };
    version = "2.17.0";
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l4nh82hq54nxgyisdcf8vbkpzm149p9kff5k0vpwp8w76zvg0lw";
      type = "gem";
    };
    version = "1.91.0";
  };
  rubocop-ast = {
    dependencies = [
      "parser"
      "prism"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jygkajmq51dh7k4prmwgpljm5jf4wsql1q9v5r3h6qrdgii3hqf";
      type = "gem";
    };
    version = "1.51.0";
  };
  rubocop-capybara = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15jhizhr01p1598av8439xy1a7bvbwwgmgzp8fv750hp0h5r04hp";
      type = "gem";
    };
    version = "3.1.0";
  };
  rubocop-factory_bot = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jzhj9fi1h9rh7z2j6m78hl7c3av36fpacg12wrifi24281gq5sb";
      type = "gem";
    };
    version = "2.28.0";
  };
  rubocop-i18n = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sx970650mnw2pivf8bx251lnni2w3c2n39cjqs9xsy9x9x9gmbc";
      type = "gem";
    };
    version = "3.3.0";
  };
  rubocop-performance = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d0qyyw1332afi9glwfjkb4bd62gzlibar6j55cghv8rzwvbj6fd";
      type = "gem";
    };
    version = "1.26.1";
  };
  rubocop-pundit = {
    dependencies = [ "rubocop" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "1f511e087a58867279ca8d77e0bb97dc2ce2da75";
      sha256 = "1g9bx7rj7fglp5dlsr5scxb0d49vj4q85kvjj1jvcw020f630fqc";
      type = "git";
      url = "https://github.com/manyfold3d/rubocop-pundit.git";
    };
    version = "0.1.0";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "lint_roller"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1llsxc8wm2pq8glpv5mczd1h36fazbri3wwrh7dfqra80a4pklqh";
      type = "gem";
    };
    version = "2.34.3";
  };
  rubocop-rspec = {
    dependencies = [
      "lint_roller"
      "regexp_parser"
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qk5bx4vg7n17i9475h6dqkhay9m3s6vanq9y35hxl9cb762wghb";
      type = "gem";
    };
    version = "3.10.2";
  };
  rubocop-rspec_rails = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12anaszqq9y5y8b4cq4za7izvgdqnmjsqlzqr9n6vjjzk9x0m7k6";
      type = "gem";
    };
    version = "2.33.0";
  };
  rubocop-yard = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "yard"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vv48mxvk1mhws2bgi8s3hrwi89cc3bzxww56vdrcfvv01mvqwq5";
      type = "gem";
    };
    version = "1.4.0";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  rubyzip = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08g1sfv1s8vs9yaz27vjpmgihcycx9nm3wq6j29plabmvaa95hb5";
      type = "gem";
    };
    version = "3.7.0";
  };
  scoped_search = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cmf2bf54wv966c9765jfy9frd2g4642npbb4pkd2lcypgvplygb";
      type = "gem";
    };
    version = "5.0.0";
  };
  scout_apm = {
    dependencies = [ "parser" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g6p645b15c9m587i2lx11g6axl26rcnha9lap7lz9m2pibv1pnw";
      type = "gem";
    };
    version = "6.4.0";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cd0iriqfsf1z91qg271sm88xjnfd92b832z49p1nd542ka96lfc";
      type = "gem";
    };
    version = "0.4.1";
  };
  selenium-webdriver = {
    dependencies = [
      "base64"
      "logger"
      "rubyzip"
      "websocket"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13a19zsbbg72wmyxkc2ahfmqjlrcfkvzh8mgyamj1pk6ldnaa6i1";
      type = "gem";
    };
    version = "4.53.0";
  };
  shellany = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
      type = "gem";
    };
    version = "0.0.1";
  };
  shrine = {
    dependencies = [
      "content_disposition"
      "down"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ap62zhjmycv1vcnqv6v55xs6jhldbdlyqyl1xg5f2anwlp3j7y4";
      type = "gem";
    };
    version = "3.10.2";
  };
  shrine-tus = {
    dependencies = [
      "shrine"
      "shrine-url"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0va8dx605nldl0g8dv6hamczvkbjpc6fpv9kjl6jdsv98p2l88wk";
      type = "gem";
    };
    version = "3.0.0";
  };
  shrine-url = {
    dependencies = [
      "down"
      "http"
      "shrine"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1801dmblap1h2fndcq8n72hgsx8p6p5p7cfa43a6hay4845m003r";
      type = "gem";
    };
    version = "2.4.2";
  };
  sidekiq = {
    dependencies = [
      "connection_pool"
      "json"
      "logger"
      "rack"
      "redis-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "059lvv3qdmgq76shrv9zp54q0xa8g7178nqxpx31hbn3wv3libci";
      type = "gem";
    };
    version = "8.1.7";
  };
  sidekiq-cron = {
    dependencies = [
      "cronex"
      "fugit"
      "globalid"
      "sidekiq"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m3jjjihqq0sksrrk09qpz7s8zq4mw452vj6i4xd25hcxrd5qn95";
      type = "gem";
    };
    version = "2.4.0";
  };
  simple_po_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wybcipkfawg4pragmayiig03xc084x3hbwywsh1dr9x9pa8f9hj";
      type = "gem";
    };
    version = "1.1.6";
  };
  simplecov = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "118fdpg7h1ny1fz6kmiyz6gccvwmb23h6bhsi1hdpf7ib4byq8ia";
      type = "gem";
    };
    version = "1.3.2";
  };
  simplecov-cobertura = {
    dependencies = [
      "rexml"
      "simplecov"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sh15q3lv4imxn5awgnjibkj6lrh2632ligm8idm9spcn5ck3yz4";
      type = "gem";
    };
    version = "4.0.0";
  };
  singleton = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y2pc7lr979pab5n5lvk3jhsi99fhskl5f2s6004v8sabz51psl3";
      type = "gem";
    };
    version = "0.3.0";
  };
  smart_properties = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jrqssk9qhwrpq41arm712226vpcr458xv6xaqbk8cp94a0kycpr";
      type = "gem";
    };
    version = "1.17.0";
  };
  spdx = {
    dependencies = [ "treetop" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fx82gjvrs45ddd6655djkqxmp2c19ydsafhba5lisncx1cczr79";
      type = "gem";
    };
    version = "4.1.5";
  };
  spring = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b5pl0f4di45iff14n7iadhrrpdnbz3yb30js3aqwl853zagc6zq";
      type = "gem";
    };
    version = "4.7.0";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "sqlite3" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r39asq48zjcvmh4lgac75zlxvyh9fgar25076gs9y476b6nispi";
      type = "gem";
    };
    version = "2.10.2";
  };
  sqlite3_ar_regexp = {
    dependencies = [
      "activerecord"
      "sqlite3"
    ];
    groups = [ "sqlite3" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01f0qyl57w2hm81z4qw9933746g34yi5622m0h8p4mlj1gq9kklh";
      type = "gem";
    };
    version = "3.0.0";
  };
  standard = {
    dependencies = [
      "language_server-protocol"
      "lint_roller"
      "rubocop"
      "standard-custom"
      "standard-performance"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n18b7419mrxm9dc6qlgbcrrpxrw14b1xaadnmzzgfhz8a9flraa";
      type = "gem";
    };
    version = "1.57.0";
  };
  standard-custom = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0av55ai0nv23z5mhrwj1clmxpgyngk7vk6rh58d4y1ws2y2dqjj2";
      type = "gem";
    };
    version = "1.0.2";
  };
  standard-performance = {
    dependencies = [
      "lint_roller"
      "rubocop-performance"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wp3i2f6w6vgxh5b9iq3458c4xmmviyfdrc03nar50j4pqqksj29";
      type = "gem";
    };
    version = "1.9.0";
  };
  starry = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c99sj460hdshiv2jps5d4mxcvz7nrvqznfpgcbnjhk9cnhv15i6";
      type = "gem";
    };
    version = "0.2.0";
  };
  stimulus-rails = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01nbcxyi1mhikq8yjl0g9swy1cpzx146pli6w16gcfpkl7zpcmkn";
      type = "gem";
    };
    version = "1.3.4";
  };
  stopwords-filter2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1snbq3lxcsgymcx43sbn7fb0v4h5yamnpxxl2akcij8ks8pla91v";
      type = "gem";
    };
    version = "0.1.0";
  };
  string-similarity = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gx30368nj7wpcnhydyvdg9sj6b4aishm9669zvfvvpx77frp55b";
      type = "gem";
    };
    version = "2.1.0";
  };
  strscan = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17k75zrwf4ag9yl9wjjkcb90zrm4r5jigdzv3zr5jm9239hxpqma";
      type = "gem";
    };
    version = "3.1.8";
  };
  swd = {
    dependencies = [
      "activesupport"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m86fzmwgw0vc8p6fwvnsdbldpgbqdz9cbp2zj9z06bc4jjf5nsc";
      type = "gem";
    };
    version = "2.0.3";
  };
  sys-cpu = {
    dependencies = [ "ffi" ];
    groups = [
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ah67ln0n4ld05aiqpj0k5fm77jl8cdbjxzng4vms3nsdqiw1bzy";
      type = "gem";
    };
    version = "1.3.0";
  };
  sys-filesystem = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xj5icwr3fxf6vn1ikaaalf8cydlwfrnaz91l6m9b6vy2hz1i9z2";
      type = "gem";
    };
    version = "1.6.0";
  };
  terminal-table = {
    dependencies = [ "unicode-display_width" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lh18gwpksk25sbcjgh94vmfw2rz0lrq61n7lwp1n9gq0cr7j17m";
      type = "gem";
    };
    version = "4.0.0";
  };
  text = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  thor = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wsy88vg2mazl039392hqrcwvs5nb9kq8jhhrrclir2px1gybag3";
      type = "gem";
    };
    version = "1.5.0";
  };
  timeout = {
    groups = [
      "default"
      "development"
      "postgres"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jxcji88mh6xsqz0mfzwnxczpg7cyniph7wpavnavfz7lxl77xbq";
      type = "gem";
    };
    version = "0.6.1";
  };
  to_regexp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rgabfhnql6l4fx09mmj5d0vza924iczqf2blmn82l782b6qqi9v";
      type = "gem";
    };
    version = "0.2.1";
  };
  translation = {
    dependencies = [ "gettext" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00czq5nlywcfibqv1kq5yz100bkzb3mb23cjaggryywb2pxncvla";
      type = "gem";
    };
    version = "1.41";
  };
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nl3q5ai7ikaa5sjdbspfa4njbrdvf7898zkplmalln6y4r3y153";
      type = "gem";
    };
    version = "1.6.18";
  };
  tsort = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    version = "0.2.0";
  };
  turbo-rails = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0priz7ww23h2j9j5zicc4np3rr357n01xw8zymn0bzxg79rr03gf";
      type = "gem";
    };
    version = "2.0.23";
  };
  tus-server = {
    dependencies = [
      "content_disposition"
      "roda"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06garxcr11xvidn4df2cxj7y7v3qlajvh519bmrlw6sis8kjjnpv";
      type = "gem";
    };
    version = "2.3.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [
      {
        engine = "jruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "jruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f898y35w60mkx3sd8ld2ryzkj4cld04qlgxi3z3hzdlzfhpa8x9";
      type = "gem";
    };
    version = "1.2025.2";
  };
  unicode = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mx9lwzy021lpcqql5kn4yi20njhf5h7c7wxm2fx51p1r2zr9wj2";
      type = "gem";
    };
    version = "0.4.4.5";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04xnl0zwpjjvxipd6rdnxkm11pfhbhhi3179yzv51nqi9dmacyjb";
      type = "gem";
    };
    version = "3.3.0";
  };
  unicode-emoji = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kp89lja8ii7l6f0bq5vdxq1p3kxr3a2qmmhdc38qdwh6akjzh0i";
      type = "gem";
    };
    version = "4.3.0";
  };
  uniform_notifier = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "016j3xj6w74za5k3840yq8wc9a46hxdjyrlcy1fam3fqdqxbhi9p";
      type = "gem";
    };
    version = "1.18.1";
  };
  uri = {
    groups = [
      "default"
      "development"
      "postgres"
      "production"
      "sqlite3"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yv9n69g99wldlx04q3my61jy5cf75z5xvd0n1465vxvxac2wac9";
      type = "gem";
    };
    version = "1.1.2";
  };
  user_agent_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1isp7y7v8mc7ihlv6hsjksv1cd5csfbzwf10lscs8mcrmwadjifr";
      type = "gem";
    };
    version = "2.21.0";
  };
  useragent = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i1q2xdjam4d7gwwc35lfnz0wyyzvnca0zslcfxm9fabml9n83kh";
      type = "gem";
    };
    version = "0.16.11";
  };
  validate_url = {
    dependencies = [
      "activemodel"
      "public_suffix"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lblym140w5n88ijyfgcvkxvpfj8m6z00rxxf2ckmmhk0x61dzkj";
      type = "gem";
    };
    version = "1.0.15";
  };
  vcr = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ah6y34jvj67f88nzxc1wv6maplsmivpkxa7x0j1zpqvgp40z1vl";
      type = "gem";
    };
    version = "6.4.1";
  };
  vite_rails = {
    dependencies = [
      "railties"
      "vite_ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f6k3p9ca5d8i3c23ivnnx2zcydz2047dq055br2iz28j9y4myk1";
      type = "gem";
    };
    version = "3.11.1";
  };
  vite_ruby = {
    dependencies = [
      "dry-cli"
      "logger"
      "mutex_m"
      "rack-proxy"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11lsr9c9v7xpyz0z6yxvw992aaqxcxivm5pmh7fbn2hqxd8m8inv";
      type = "gem";
    };
    version = "3.10.2";
  };
  warden = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l7gl7vms023w4clg02pm4ky9j12la2vzsixi2xrv9imbn44ys26";
      type = "gem";
    };
    version = "1.2.9";
  };
  warning = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17kcvdmz9flxqzi4qkjvsaf9wxdbz12vxvzjzydd2xzv36pdz754";
      type = "gem";
    };
    version = "1.6.0";
  };
  web-console = {
    dependencies = [
      "actionview"
      "bindex"
      "railties"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "193ddancfznc34qp2bqz5mkv906v4aka6njv2lzhkhnz3hq72fz1";
      type = "gem";
    };
    version = "4.3.0";
  };
  webfinger = {
    dependencies = [
      "activesupport"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p39802sfnm62r4x5hai8vn6d1wqbxsxnmbynsk8rcvzwyym4yjn";
      type = "gem";
    };
    version = "2.1.3";
  };
  webmock = {
    dependencies = [
      "addressable"
      "crack"
      "hashdiff"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0010fp2iksh26x3iyh58r411lyj436hb3v9lmdp7x9iwy825g6hv";
      type = "gem";
    };
    version = "3.36.0";
  };
  websocket = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dr78vh3ag0d1q5gfd8960g1ca9g6arjd2w54mffid8h4i7agrxp";
      type = "gem";
    };
    version = "1.2.11";
  };
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ij19k6034x0c4hw0ywa7wnk5s912r8aq0hhjss10d5z36q5dicp";
      type = "gem";
    };
    version = "0.8.2";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  win32ole = {
    groups = [
      "default"
      "development"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15jdx4cd2g4spi50g2gad1cxiwr89a5m6kr0b1p6x00kvk2kvx01";
      type = "gem";
    };
    version = "1.9.3";
  };
  with_model = {
    dependencies = [ "activerecord" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13zg3wy18rxnw25j9wbszc9j3ys85yvab1dgj6pwim2w6ba70n1f";
      type = "gem";
    };
    version = "2.5.0";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
  yaml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hhr8z9m9yq2kf7ls0vf8ap1hqma1yd72y2r13b88dffwv8nj3i4";
      type = "gem";
    };
    version = "0.4.0";
  };
  yard = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lfwngmsz3xq9k9la9890cqpm4vk3rda4171yzms7f3w7x4i3qjj";
      type = "gem";
    };
    version = "0.9.45";
  };
  yard-activerecord = {
    dependencies = [
      "activesupport"
      "yard"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mg06j8ijih7jw7ggvm6a3xjinrdj3jydzwnqblw55cpg2zmsj5s";
      type = "gem";
    };
    version = "0.0.17";
  };
  yard-activesupport-concern = {
    dependencies = [ "yard" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vwhhgkkrw57anbbsyv5aihmhhxpr255jqvhcy3jwgn2xyq0qydy";
      type = "gem";
    };
    version = "0.0.1";
  };
  yard-lint = {
    dependencies = [
      "yard"
      "zeitwerk"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l909ah8y1xq5klxwnm6icz1q8c3bg49x4hsr9gp3zq72mlf95fn";
      type = "gem";
    };
    version = "1.13.1";
  };
  zaru = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sj0lkqxdb5fqpwapm40pi9iypqds1jd8sqlxmia13arv61qnbsw";
      type = "gem";
    };
    version = "1.1";
  };
  zeitwerk = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rcjpgyzmdxp8rdw466156fmr588k9q1wg8j42g0dkk7hid1519c";
      type = "gem";
    };
    version = "2.8.3";
  };
  zxcvbn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19day3xgw6xzhgwdd5pwmky9znbyc10m6wbk00xm9ayammy9mr26";
      type = "gem";
    };
    version = "0.1.10";
  };
}
