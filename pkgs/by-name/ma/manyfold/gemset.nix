{
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
      sha256 = "17z0flj504z9d5hmzmd8g2gmaiz1a3yndvkxmbz6qrkvjzr2pnxa";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "03yqbiiz9z1nqy4n7rhjpavn20lx5rvjbq0sl0dkvdiga15662zd";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "0jyyfp786csg4hmsxfywi8131p1pk51jzi8i9d9zn2lzw7c714iv";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "1nyd4f58r11b0x5gsjlnyk2k9y2kd0zhv8szf82g9j1j5xccfr03";
      type = "gem";
    };
    version = "8.0.4";
  };
  actiontext = {
    dependencies = [
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
      sha256 = "0h13x9y767i9nan09jyhiw32s1gmdmcb4mjld1jvhadcd019gcs0";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "0j0n38p02s73r9a8fg615z8m78n9agpf9d9b0v7i97m5wwgc9lsv";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "1knc9xwfnyqcxqzfsfix210ai2yhw9ps7j19aq5bk30n1rfsij6b";
      type = "gem";
    };
    version = "8.0.4";
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
  activejob-uniqueness = {
    dependencies = [
      "activejob"
      "redlock"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13w24pfshl86r70d0xgnqzya2f8r0y2x59m2c1a8kbhb7bq2i4nk";
      type = "gem";
    };
    version = "0.4.0";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z8dff84qgqinhwsj0i91r674vvg412kg72162zv216i7jn4yklg";
      type = "gem";
    };
    version = "8.0.4";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cmz9k27zy0746zpljg28ir4857df9r3nza4c1acmrcr2wbjr8xx";
      type = "gem";
    };
    version = "8.0.4";
  };
  activerecord-enhancedsqlite3-adapter = {
    dependencies = [
      "activerecord"
      "sqlite3"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0agkari4bjq706mdg2mhhsd1pbf81s60024898ppki0446ja9yaw";
      type = "gem";
    };
    version = "0.8.0";
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
      sha256 = "0hx0chzrszc3kbjn8psagxaaas4ns5479kr0kxkc36685yb15ws7";
      type = "gem";
    };
    version = "8.0.4";
  };
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
      "uri"
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
      sha256 = "0np97w7kc9dx7kx092nzhy3g6qxmqivcsfnzlzjzmd9kfxn3ljl9";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "0mxhjgihzsx45l9wh2n0ywl9w0c6k70igm5r0d63dxkcagwvh4vw";
      type = "gem";
    };
    version = "2.8.8";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r7s6p68b1s8falb4z816fsx4sm4hrmjzawplwqfgfls8f0z180d";
      type = "gem";
    };
    version = "0.0.6";
  };
  arel_extensions = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rzbcmss825i769nc88m829hhr5ndsc4fmbkkmnya07n330mzlk2";
      type = "gem";
    };
    version = "2.4.0";
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
      sha256 = "1m8v8435x7y2pn51mznbfs9hcnld8j4b5wprhqjzbpyfymjiqsz8";
      type = "gem";
    };
    version = "1.1222.0";
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
      sha256 = "070gpczwmc6864wnx6zc4622yld14aj3yy15hg972jqjhpvyw550";
      type = "gem";
    };
    version = "3.243.0";
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
      sha256 = "1f2fzfmi51vq02a8r711sgn7605l2z5dzkvh29pxgmvbn98kzkj7";
      type = "gem";
    };
    version = "1.122.0";
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
      sha256 = "1kh17f4y1n7wghiiq0ravlk8hkvb48qc05fk5k6l7qw5v4h0ps8m";
      type = "gem";
    };
    version = "1.215.0";
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
      "production"
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
      sha256 = "1krd99p9828n07rcjjms56jaqv7v6s9pn7y6bppcfhhaflyn2r2r";
      type = "gem";
    };
    version = "3.1.21";
  };
  benchmark = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    version = "0.5.0";
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
      "production"
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
      sha256 = "057jsch213i42qgdsz2vg1b190n2xvvbi3hgprc8nmaqim2ly9f1";
      type = "gem";
    };
    version = "1.23.0";
  };
  brakeman = {
    dependencies = [ "racc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vyg9l6xivamb49r4kzkcw12r9x943kv79wsvwslhm1qjvx23ybv";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "1zwq7g98c1mdigahb50c980a0fcc4ib1m9ivmgf3f8gc6qk7wjv0";
      type = "gem";
    };
    version = "8.1.0";
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
        engine = "mingw";
      }
      {
        engine = "mingw";
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
      sha256 = "1rj7agrnd1a4282vg13qkpwky0379svdb2z2lc0wl8588q6ikjx3";
      type = "gem";
    };
    version = "0.4.2";
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
      sha256 = "18zyph1r5ladwyan68l4avmyy8wfccnkf4j9wkclrnzh0y0ddqxq";
      type = "gem";
    };
    version = "3.0.0";
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
      "production"
      "test"
    ];
    platforms = [
      {
        engine = "jruby";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1aymcakhzl83k77g2f2krz07bg1cbafbcd2ghvwr4lky3rz86mkb";
      type = "gem";
    };
    version = "1.3.6";
  };
  connection_pool = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b8nlxr5z843ii7hfk6igpr5acw3k2ih9yjrgkyz2gbmallgjkz5";
      type = "gem";
    };
    version = "2.5.5";
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
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
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
  cssbundling-rails = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hbfji8lddlvsk9x70s5xvafl3w31v6mm5wjrn7rrb14gmdcvbjk";
      type = "gem";
    };
    version = "1.4.3";
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
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h0db8r2v5llxdbzkzyllkfniqw9gm092qn7cbaib73v9lw0c3bm";
      type = "gem";
    };
    version = "3.5.1";
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
      sha256 = "1dmh9d26a2a8himr7bwiqddvj7x2db4ii2hyd3cjlq8f574k0hr5";
      type = "gem";
    };
    version = "5.0.2";
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
      sha256 = "0gvakadv96krsvrsr5j3k111f3qjj02k15x2jf6j2j489gvi803q";
      type = "gem";
    };
    version = "2.0.11";
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
  docile = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07pj4z3h8wk4fgdn6s62vw1lwvhj0ac0x10vfbdkr9xzk7krn5cn";
      type = "gem";
    };
    version = "1.4.1";
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
      sha256 = "0dk37d3fcg34g4ii5cmycf4a5yz76crl5z4164ggasyb7lxhbbgd";
      type = "gem";
    };
    version = "5.9.0";
  };
  doorkeeper-i18n = {
    dependencies = [ "doorkeeper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lpmvaglypxlmaiqv4sjrf1b1sc8f589cv7xq3rr4j26vw0lf1g4";
      type = "gem";
    };
    version = "5.2.8";
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
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kwaqnqi6m50yk05gj76i81r61bhdyn5l5fdwaki8qm9ww0mwvji";
      type = "gem";
    };
    version = "5.4.2";
  };
  drb = {
    groups = [
      "default"
      "development"
      "production"
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
      sha256 = "0ar4nmvk1sk7drjigqyh9nnps3mxg625b8chfk42557p8i6jdrlz";
      type = "gem";
    };
    version = "6.0.2";
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
      sha256 = "0xz02xlnfhj418g51w06asfpcjccf7b66dx6ly3c1k2d45rv7ghj";
      type = "gem";
    };
    version = "6.5.6";
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
      sha256 = "1pncl49j3sn6ka53dbf1sw8n0mqlnzh2afwi7ql2dd163lyd44y5";
      type = "gem";
    };
    version = "3.6.1";
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
      sha256 = "1nfmmnmqgbxci7dlca0qnwxn8j29yv7v8wm26m0f4l0kmcc13ynk";
      type = "gem";
    };
    version = "0.4.0";
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
  federails = {
    dependencies = [
      "faraday"
      "faraday-follow_redirects"
      "jbuilder"
      "json-ld"
      "json-ld-preloaded"
      "kaminari"
      "pundit"
      "rails"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "43d68af7e3c3577d705a87ec586dde7913fa57c7";
      sha256 = "0ky80x5q5k2k63ryqyfpbpsdqq7v41l1f5nrq8nfvf0ihmmgql76";
      type = "git";
      url = "https://gitlab.com/experimentslabs/federails.git";
    };
    version = "0.7.0";
  };
  federails-moderation = {
    dependencies = [
      "federails"
      "public_suffix"
      "rails"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jj7q8rxgclv74f1pvsvxsyihzy72izav3wf9f9kr2knplbrx95r";
      type = "gem";
    };
    version = "0.3.0";
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
      sha256 = "0k1xaqw2jk13q3ss7cnyvkp8fzp75dk4kazysrxgfd1rpgvkk7qf";
      type = "gem";
    };
    version = "1.17.3";
  };
  ffi-compiler = {
    dependencies = [
      "ffi"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1844j58cdg2q6g0rqfwg4rrambnhf059h4yg9rfmrbrcs60kskx9";
      type = "gem";
    };
    version = "1.3.2";
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
      sha256 = "1b5g1i3xdvmxxpq4qp0z4v78ivqnazz26w110fh4cvzsdayz8zgi";
      type = "gem";
    };
    version = "1.3.3";
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
      sha256 = "04gzhqvsm4z4l12r9dkac9a75ah45w186ydhl0i4andldsnkkih5";
      type = "gem";
    };
    version = "1.3.0";
  };
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05iwy5w6fhkl9ihhslp0kdl92v01g4p3i13f5n3hvv93n0sik4l6";
      type = "gem";
    };
    version = "4.33.4";
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
      sha256 = "1cbwirpx8hclxyrxfbjz5c62l7i6nsqg6x72yplm8d083pd0ii4q";
      type = "gem";
    };
    version = "0.8.0";
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
      sha256 = "15q74b32h7zbw59mgv1cv8gqcjkb9qppxl28kjlsd5k7rw26458w";
      type = "gem";
    };
    version = "2.5.16";
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
      sha256 = "0nh1fzwm9pq4b0b21nmx87j91qzk3xw9yn60h1hbgrjl723xg75b";
      type = "gem";
    };
    version = "2.20.1";
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
      sha256 = "1lbw8lqzjv17vnwb9vy5ki4jiyihybcc5h2rmcrqiz1xa6y9s1ww";
      type = "gem";
    };
    version = "1.2.1";
  };
  hashie = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nh3arcrbz1rc1cr59qm53sdhqm137b258y8rcb4cvd3y98lwv4x";
      type = "gem";
    };
    version = "5.0.0";
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
      "addressable"
      "http-cookie"
      "http-form_data"
      "llhttp-ffi"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z8x4c2bcg05x7ffrjy47cwarfqzlg8kcfxchk5jcfdyx7c04265";
      type = "gem";
    };
    version = "5.3.1";
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
  http-form_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wx591jdhy84901pklh1n9sgh74gnvq1qyqxwchni1yrc49ynknc";
      type = "gem";
    };
    version = "2.3.0";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1994i044vdmzzkyr76g8rpl1fq1532wf0sb21xg5r1ilj5iphmr8";
      type = "gem";
    };
    version = "1.14.8";
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
      sha256 = "0yk3lgzmym02bvpqhvccrfjvnkyqh35idcqwcqq3yqiawm4vmksd";
      type = "gem";
    };
    version = "1.1.2";
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
    dependencies = [
      "mini_magick"
      "ruby-vips"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ys28w0ayq3vl2sl4lpq6jnsy7gd4p9vzimyi449hqn2r5lw2k3m";
      type = "gem";
    };
    version = "1.14.0";
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
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k0lk3pwadm2myvpg893n8jshmrf2sigrd4ki15lymy7gixaxqyn";
      type = "gem";
    };
    version = "0.8.2";
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
      sha256 = "1bishrxfn2anwlagw8rzly7i2yicjnr947f48nh638yqjgdlv30n";
      type = "gem";
    };
    version = "1.17.0";
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
      sha256 = "0hmvz9lhx37x43gnms17hfczjwfj7i9xfvzxnh611vv0zxv67cjf";
      type = "gem";
    };
    version = "2.14.1";
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
      sha256 = "1h66sqjsa14kn0wa8pwpagmihsqky4lz0j6m7sf6w3vm2xs0ar01";
      type = "gem";
    };
    version = "1.12.0";
  };
  jsbundling-rails = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jn2n5i9qdw6iybb4f6gqkr7k61rafzdh8m0anzlqs8w0mnkz80g";
      type = "gem";
    };
    version = "1.3.1";
  };
  json = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11prr7nrxh1y4rfsqa51gy4ixx63r18cz9mdnmk0938va1ajf4gy";
      type = "gem";
    };
    version = "2.18.1";
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
      sha256 = "1yh2gwpwhh0p4vc0aabzn0hb55av0wkcq3gh3w8zkdk69hh4598v";
      type = "gem";
    };
    version = "2.5.2";
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
      sha256 = "1k0311vah76kg5m6zr7wmkwyk5p2f9d9hyckjpn3xgr83ajkj7px";
      type = "gem";
    };
    version = "3.17.0.5";
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
      "logger"
      "net-http"
      "openssl"
      "rack"
      "starry"
      "stringio"
      "uri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09rjxsmmnahxsaw0hc4f0ffw4rcncjxa01xd9v5z4q9radfidr5j";
      type = "gem";
    };
    version = "0.7.7";
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
      sha256 = "1ln9c0vx165hkfbn2817qw4m6i77xcxh6q0r5v6fqfhlcbdq5qf6";
      type = "gem";
    };
    version = "3.10.0";
  };
  llhttp-ffi = {
    dependencies = [
      "ffi-compiler"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g57iw0l3y7x50132x6a1jyssxa6pw7srh69g0d6j7ri37yaf9cs";
      type = "gem";
    };
    version = "0.5.1";
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
      "production"
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
      "railties"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qcsvh9k4c0cp6agqm9a8m4x2gg7vifryqr7yxkg2x9ph9silds2";
      type = "gem";
    };
    version = "0.14.0";
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
      sha256 = "1rk0n13c9nmk8di2x5gqk5r04vf8bkp7ff6z0b44wsmc7fndfpnz";
      type = "gem";
    };
    version = "2.25.0";
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
      sha256 = "0ha9sgkfqna62c1basc17dkx91yk7ppgjq32k4nhrikirlz6g9kg";
      type = "gem";
    };
    version = "2.9.0";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vhb1sbzlq42k2pzd9v0w5ws4kjx184y8h4d63296bn57jiwzkzx";
      type = "gem";
    };
    version = "1.1.0";
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
  memoist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
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
    dependencies = [
      "benchmark"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jiz4jqsrmgnkyvpmsq2vicmvdqa6q2ibzx93lnj8f0xvfzzymr7";
      type = "gem";
    };
    version = "5.2.0";
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
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gdwmn2d4sznjdxyl3kz7hr95mvdgm38fk1vd0s63k3fdyamfvnv";
      type = "gem";
    };
    version = "6.0.2";
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
  mittsu-3mf = {
    dependencies = [
      "builder"
      "mittsu"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j3cmmz0p6krlkkwkijbs45f5knmbzcnnywz0fpfnir42zsdxkyd";
      type = "gem";
    };
    version = "0.1.0";
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
      sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";
      type = "gem";
    };
    version = "1.8.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vsrfm36zlg7jbrd1fjbr8kmdvr8bfayrw0hdlza75987vvhrxr3";
      type = "gem";
    };
    version = "1.18.0";
  };
  mysql2 = {
    groups = [ "production" ];
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
      sha256 = "1z4bppz33wip4g3x7rakjmkmmw8yxbbnd88jfyriz64m2lyck9bq";
      type = "gem";
    };
    version = "2.0.0";
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
      sha256 = "1ysrwaabhf0sn24jrp0nnp51cdv0jf688mh5i6fsz63q2c6b48cn";
      type = "gem";
    };
    version = "0.6.0";
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
      sha256 = "1imc50a9ic3ynsl3k0japhmb0ggrgp2c186cfqbcclv892nsrjh8";
      type = "gem";
    };
    version = "0.6.2";
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
      sha256 = "1a32l4x73hz200cm587bc29q8q9az278syw3x6fkc9d1lv5y0wxa";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    version = "0.5.1";
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
      sha256 = "1lss1nh526n3h1qsig2kjchi8vlsjwc8pdjpplm1f2yz6rzk52sr";
      type = "gem";
    };
    version = "1.19.1";
  };
  noticed = {
    dependencies = [ "rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "164gzwv66rrakqaal91ssnd4wqpymipx7qg7zcbl20xr4hb8zcnb";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "0g3n12k5npmmgai2cs3snimy6r7h0bvalhjxv0fjxlphjq25p822";
      type = "gem";
    };
    version = "2.1.4";
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
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v0grpg9gi59zr3imxy1745k9rp3dd095mkir8gvxi69blhh2kkz";
      type = "gem";
    };
    version = "3.3.2";
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
  parallel = {
    groups = [
      "default"
      "development"
      "test"
    ];
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mwk9syajzdradzqzp3agf03d0cazqwbfd1439nxpkmxli5chq3g";
      type = "gem";
    };
    version = "3.3.10.2";
  };
  pg = {
    groups = [ "production" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16caca7lcz5pwl82snarqrayjj9j7abmxqw92267blhk7rbd120k";
      type = "gem";
    };
    version = "1.6.3";
  };
  pg_query = {
    dependencies = [ "google-protobuf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vwvfxz4gp5xqrv4jwyqigfkpldjqp6mbzvskapwiyncc10ijv1i";
      type = "gem";
    };
    version = "6.2.2";
  };
  pghero = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08pm154bx5zbpgcqhk7gq78qq1mb149s2l7y0fxniqfvjmq4kn58";
      type = "gem";
    };
    version = "3.7.0";
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
      sha256 = "04hbly864zi8f30z0a96w2951rzbg63parh2hiqm52z3pxzp35p5";
      type = "gem";
    };
    version = "2.4.1";
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
      sha256 = "1xlxmg86k5kifci1xvlmgw56x88dmqf04zfzn7zcr4qb8ladal99";
      type = "gem";
    };
    version = "0.6.3";
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
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
      type = "gem";
    };
    version = "0.2.0";
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
      "production"
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
  propshaft = {
    dependencies = [
      "actionpack"
      "activesupport"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14n3fhz5hzpsczp4spqc26csfgk2qga7mgcm7px9z0byyr76dk4s";
      type = "gem";
    };
    version = "1.3.1";
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
      sha256 = "0kh5nv8v74k1ccy6gc7nd04aaf1cjkbk7g8pwy2izvcqaq36jv6p";
      type = "gem";
    };
    version = "0.16.0";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
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
      sha256 = "0x0r3gc66abv8i4dw0x0370b5hrshjfp6kpp7wbp178cy775fypb";
      type = "gem";
    };
    version = "5.3.1";
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
      sha256 = "1543ap9w3ydhx39ljcd675cdz9cr948x9mp00ab8qvq6118wv9xz";
      type = "gem";
    };
    version = "6.0.2";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a3jd9qakasizrf7dkq5mqv51fjf02r2chybai2nskjaa6mz93mz";
      type = "gem";
    };
    version = "7.2.0";
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
      sha256 = "1lyn3rh71rlf50p44xmsbha0pip4c95004j8kc9pm7xpq1s0kgac";
      type = "gem";
    };
    version = "3.2.5";
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
      sha256 = "1b4bamcbpk29i7jvly3i7ayfj69yc1g03gm4s7jgamccvx12hvng";
      type = "gem";
    };
    version = "4.2.1";
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
      sha256 = "1sg4laz2qmllxh1c5sqlj9n1r7scdn08p3m4b0zmhjvyx9yw0v8b";
      type = "gem";
    };
    version = "2.1.1";
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
      sha256 = "0qy4ylhcfdn65a5mz2hly7g9vl0g13p5a0rmm6sc0sih5ilkcnh0";
      type = "gem";
    };
    version = "2.2.0";
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
      sha256 = "1nv2g40b3hks0gqp7pbapj26cxz78z73dl1mq7azkhrd5nir8i1n";
      type = "gem";
    };
    version = "8.0.4";
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
      sha256 = "128y5g3fyi8fds41jasrr4va1jrs7hcamzklk1523k7rxb64bc98";
      type = "gem";
    };
    version = "1.7.0";
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
      sha256 = "1f59b260w1pd208l52zxxk34jfiz4cg93cxqa0lic6hz48l627bn";
      type = "gem";
    };
    version = "2.9.6";
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
      sha256 = "0iybsmr8yv8gg6a4cikmh0394sk707qr7h85vny4mazzvi9xh0w2";
      type = "gem";
    };
    version = "8.0.4";
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
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "175iisqb211n0qbfyqd8jz2g01q6xj038zjf4q0nm8k6kz88k7lc";
      type = "gem";
    };
    version = "13.3.1";
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
      "psych"
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
      sha256 = "14iiyb4yi1chdzrynrk74xbhmikml3ixgdayjma3p700singfl46";
      type = "gem";
    };
    version = "7.2.0";
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
      sha256 = "16vplvxrsaq6as1hzw71mkfcpjdphk0m662k36vrilq2f9dgndhk";
      type = "gem";
    };
    version = "0.26.2";
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
      sha256 = "192mzi0wgwl024pwpbfa6c2a2xlvbh3mjd75a0sakdvkl60z64ya";
      type = "gem";
    };
    version = "2.11.3";
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
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d8q5c4nh2g9pp758kizh8sfrvngynrjlm0i1zn3cnsnfd4v160i";
      type = "gem";
    };
    version = "0.6.3";
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
      sha256 = "0npm7nyld47f516idsmslfhypp7gm3jcl90ml5c68vz11anddhl9";
      type = "gem";
    };
    version = "3.2.0";
  };
  reverse_markdown = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bxqlpwnixn8x4bnna958w6m6qkdkbnd23b9j6ib3nrrrs9bp3l1";
      type = "gem";
    };
    version = "3.0.2";
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
      sha256 = "0a146qc7ckj4rac9byvif7zb3x5dvjvi76hzz66ic1936917s561";
      type = "gem";
    };
    version = "3.98.0";
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
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
      sha256 = "071bqrk2rblk3zq3jk1xxx0dr92y0szi5pxdm8waimxici706y89";
      type = "gem";
    };
    version = "3.13.7";
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
      sha256 = "1hcxnxlcg6da7fy6s1y4k1r8cq36w994h0cai5yk2007l7kl195h";
      type = "gem";
    };
    version = "8.0.3";
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
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    version = "3.13.7";
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
      sha256 = "0pxzipl8a1bv62jdfykh7j4ymdr4aiffjvwsny6drwv886jwx4jn";
      type = "gem";
    };
    version = "1.84.2";
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
      sha256 = "1zbikzd6237fvlzjfxdlhwi2vbmavg1cc81y6cyr581365nnghs9";
      type = "gem";
    };
    version = "1.49.0";
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
      sha256 = "030wymq0jrblrdswl1lncj60dhcg5wszz6708qzsbziyyap8rn6f";
      type = "gem";
    };
    version = "2.22.1";
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
      sha256 = "1nib58p2kf7lbxz5dvjb80rajr6rmry3v9x3q3kc14i86y7j484n";
      type = "gem";
    };
    version = "3.2.3";
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
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qjmvcpk6qwxjdh3w5smr2n7c1glxsdzpv5fi7bkg0j034v0m9wg";
      type = "gem";
    };
    version = "3.9.0";
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
      sha256 = "004i5a4iww7l3vpaxl70ijypmi321afrslsgadbvksznf8f683aa";
      type = "gem";
    };
    version = "2.32.0";
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
  ruby-vips = {
    dependencies = [
      "ffi"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x2k5x272m2zs0vmznl2jac14bj9a2g0365xxcnr2s9rq41fr1g6";
      type = "gem";
    };
    version = "2.3.0";
  };
  rubyzip = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05an0wz87vkmqwcwyh5rjiaavydfn5f4q1lixcsqkphzvj7chxw5";
      type = "gem";
    };
    version = "2.4.1";
  };
  scoped_search = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h29yvja7pq65xqchnn9ihcadgv03abwd9k57s0r6wvdazv3l08b";
      type = "gem";
    };
    version = "4.3.1";
  };
  scout_apm = {
    dependencies = [ "parser" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17fsxd4qn6qzjfppnrds55hd14kpsmgrs1c0p94c47qfw0n7xqz7";
      type = "gem";
    };
    version = "6.1.1";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "production"
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
      "rexml"
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
      sha256 = "08nxpr0lxn95ml19n0vy6dnw1gnhq9n1b0za5h18dwawsly1ghfd";
      type = "gem";
    };
    version = "4.41.0";
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
      sha256 = "131mfc1mps2aq0ph2zp15hxhsg9lzscys9ik1y85vmjjlkjvfqfk";
      type = "gem";
    };
    version = "3.6.0";
  };
  shrine-tus = {
    dependencies = [
      "shrine"
      "shrine-url"
      "tus-server"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "168zhipg9jdbi7cfxa2s0vc29bpvnldjfqcdpaq66sc0gwdy25pw";
      type = "gem";
    };
    version = "2.1.1";
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
      sha256 = "0aa4cc4cx2kcl9azyaxyrdnvrhygd6rid9dam21i923v071sk1p0";
      type = "gem";
    };
    version = "2.4.1";
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
      sha256 = "1mjcm3csall2idnza3w9gvayq3fbpz0k1jsmhsdpgxj6ipddik1p";
      type = "gem";
    };
    version = "8.0.10";
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
      sha256 = "1b2aqj17izziipb6wvsa8jr60ng8w8mal7acfkf316i8faikvawn";
      type = "gem";
    };
    version = "2.3.1";
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
    dependencies = [
      "docile"
      "simplecov-html"
      "simplecov_json_formatter"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "198kcbrjxhhzca19yrdcd6jjj9sb51aaic3b0sc3pwjghg3j49py";
      type = "gem";
    };
    version = "0.22.0";
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
      sha256 = "1iaxj8lfcl5cfr4qa64mcapqw4qprf4bvrdjfhhwlrf96am3hzvd";
      type = "gem";
    };
    version = "3.1.0";
  };
  simplecov-html = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ikjfwydgs08nm3xzc4cn4b6z6rmcrj2imp84xcnimy2wxa8w2xx";
      type = "gem";
    };
    version = "0.13.2";
  };
  simplecov_json_formatter = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a5l0733hj7sk51j81ykfmlk2vd5vaijlq9d5fn165yyx3xii52j";
      type = "gem";
    };
    version = "0.1.4";
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
      sha256 = "1rsw917r4k1lc1krhw57szj8phbzdpj8swywvk79b1fwv2n1pxi2";
      type = "gem";
    };
    version = "4.4.2";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09np0n6zn63qinzbsf0yxfbn8jcdm9pzpgmmhhj2pnd429wsrl5c";
      type = "gem";
    };
    version = "2.8.1";
  };
  sqlite3_ar_regexp = {
    dependencies = [
      "activerecord"
      "sqlite3"
    ];
    groups = [ "default" ];
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
      sha256 = "0001x9klgvq3kj140fr3916sidpf1xplig03iwy0i4wq7pw0hjvs";
      type = "gem";
    };
    version = "1.54.0";
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
  stringio = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q92y9627yisykyscv0bdsrrgyaajc2qr56dwlzx7ysgigjv4z63";
      type = "gem";
    };
    version = "3.2.0";
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
      sha256 = "1m56q519p3n6wwhab6pr02r8wrrd2rrgb32lqwgsw2b5qw98f555";
      type = "gem";
    };
    version = "1.2.0";
  };
  sys-filesystem = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cshw6aqq7ws4sbl0b4g50fgvffykbchjpnzanmg1f9lly85i6bg";
      type = "gem";
    };
    version = "1.5.5";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bz11pq7n1g51f50jqmgyf5b1v64p1pfqmy5l21y6vpr37b2lwkd";
      type = "gem";
    };
    version = "0.6.0";
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
      "production"
      "test"
    ];
    platforms = [
      {
        engine = "jruby";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
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
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
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
      sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";
      type = "gem";
    };
    version = "3.2.0";
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
      sha256 = "03zqn207zypycbz5m9mn7ym763wgpk7hcqbkpx02wrbm1wank7ji";
      type = "gem";
    };
    version = "4.2.0";
  };
  uniform_notifier = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17ffzyq6482yn27r7rz2k3zslf9jigbz383d90c68vznarapi1s7";
      type = "gem";
    };
    version = "1.18.0";
  };
  uri = {
    groups = [
      "default"
      "development"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    version = "1.1.1";
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
      sha256 = "1rjalag6mjd796idhil076jnqpiv2lc2ljchxc25kz3fq4ncjyh7";
      type = "gem";
    };
    version = "6.4.0";
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
      sha256 = "0lwcf7fsz1sda1fdbqq1i4q9kzg4f5vwrzgfg1vpa1hcxagw84hg";
      type = "gem";
    };
    version = "1.5.0";
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
      sha256 = "1mqw7ca931zmqgad0fq4gw7z3gwb0pwx9cmd1b12ga4hgjsnysag";
      type = "gem";
    };
    version = "3.26.1";
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
      sha256 = "0qj9dmkmgahmadgh88kydb7cv15w13l1fj3kk9zz28iwji5vl3gd";
      type = "gem";
    };
    version = "0.8.0";
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
  with_model = {
    dependencies = [ "activerecord" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zi7k7ys65arm87ij4idvy4vnmip6hd9b459q3l1f69raa3lj3zb";
      type = "gem";
    };
    version = "2.2.0";
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
  yard = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03q1hf12csqy5q2inafzi44179zaq9n5yrb0k2j2llqhzcmbh7vj";
      type = "gem";
    };
    version = "0.9.38";
  };
  yard-lint = {
    dependencies = [
      "yard"
      "zeitwerk"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03qzz7wkmsqfvn9mc6r9j9nv65r8h5c9v2ga1f2cnxzx12xqzn3x";
      type = "gem";
    };
    version = "1.4.0";
  };
  zaru = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gqzr898al5153qwx8z34capkxady8kch01ah6pkw9fk4kmf7ilv";
      type = "gem";
    };
    version = "1.0.1";
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
      sha256 = "1pbkiwwla5gldgb3saamn91058nl1sq1344l5k36xsh9ih995nnq";
      type = "gem";
    };
    version = "2.7.5";
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
