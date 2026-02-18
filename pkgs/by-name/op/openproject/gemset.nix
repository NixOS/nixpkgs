{
  action_text-trix = {
    dependencies = [ "railties" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hinzgbjfwgdjm3dz9mz218sy764gbacv0z2ic4ms57lpzw87nrz";
      type = "gem";
    };
    version = "2.1.18";
  };
  actioncable = {
    dependencies = [
      "actionpack"
      "activesupport"
      "nio4r"
      "websocket-driver"
      "zeitwerk"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w40bbkjd0lds57bfr24hbj9qfkwj9v33x6457g24sjfwispzg75";
      type = "gem";
    };
    version = "8.1.3";
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ndf98dpzmz8xs6m253zpwnhyfrvxdkfyvssxps0vrx0x9sa8zfz";
      type = "gem";
    };
    version = "8.1.3";
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
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13a4329lgrda8s9mqrfbaakvc90i6ak82rfpljmd0w5vj54747w3";
      type = "gem";
    };
    version = "8.1.3";
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18r93ii2ayw8n60qsx259dy8nwgbfxf3ndncla0xbia79np8r6dg";
      type = "gem";
    };
    version = "8.1.3";
  };
  actionpack-xml_parser = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rnm6jrw3mzcf2g3q498igmhsn0kfkxq79w0nm532iclx4g4djs0";
      type = "gem";
    };
    version = "2.0.1";
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ln7mwflqf7nsgkj9lm1p7bmc6h8yqaa47q1cdj9xsp102f034fj";
      type = "gem";
    };
    version = "8.1.3";
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pgxl9p2q2zbwb6626yw7rgpbmv2bvxykq2w1h83inrygy6chiqk";
      type = "gem";
    };
    version = "8.1.3";
  };
  active_record_doctor = {
    dependencies = [ "activerecord" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16h6hhmd3x07vgh2kwxabvb7kz5ifaz4w3kxyvrci1ak341arw3s";
      type = "gem";
    };
    version = "2.0.1";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lz8bxb6pcf9yvxwyj6355aws3ylxi5rwc577ly4q858d9vb2jd1";
      type = "gem";
    };
    version = "8.1.3";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06c23jww82grgvxw19g4bi9c957aj5hh24wzyyw4jdpg9jz5rh4h";
      type = "gem";
    };
    version = "8.1.3";
  };
  activemodel-serializers-xml = {
    dependencies = [
      "activemodel"
      "activesupport"
      "builder"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15y32sacv9xfbazd75dbr1ckln8a7hz86s4wlmccqm3jbqq1c6zs";
      type = "gem";
    };
    version = "1.0.3";
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1avhmih54xqyj14zrv6ciw2ndpb11bmkwq0fcwm0mfk64ixvw0w0";
      type = "gem";
    };
    version = "8.1.3";
  };
  activerecord-import = {
    dependencies = [ "activerecord" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jzs0y4dg84j14j2hmlzviw66rcz6wn1j78z7mr7a1z5jsqrkjpq";
      type = "gem";
    };
    version = "2.2.0";
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
  activerecord-session_store = {
    dependencies = [
      "actionpack"
      "activerecord"
      "cgi"
      "rack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hr7dv4qfimy3bqw3yhwsz4i9kpyw5jyg2dghx7vz0rnaxa814b5";
      type = "gem";
    };
    version = "2.2.0";
  };
  activestorage = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activesupport"
      "marcel"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k9q8sdlf576r8rp2hgdxy5lpr8f157bpq8mfsk52f8l169wwr05";
      type = "gem";
    };
    version = "8.1.3";
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03m2vjhq3nmc8c3hpivxhvkjd8igg16nmv0p2fgdsgacppgy1991";
      type = "gem";
    };
    version = "8.1.3";
  };
  acts_as_list = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j7xclldl8g34vs791cyihysyngfrj8hkl3sq0hfdgmp004khic3";
      type = "gem";
    };
    version = "1.2.6";
  };
  acts_as_tree = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wx2m64knv57g1q0bi09d7hci69x5n49xkzzcimn2f6ym08fnsdq";
      type = "gem";
    };
    version = "2.9.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1by7h2lwziiblizpd5yx87jsq8ppdhzvwf08ga34wzqgcv1nmpvz";
      type = "gem";
    };
    version = "2.9.0";
  };
  aes_key_wrap = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19bn0y70qm6mfj4y1m0j3s8ggh6dvxwrwrj5vfamhdrpddsz8ddr";
      type = "gem";
    };
    version = "1.1.0";
  };
  afm = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ia5iw9xvvy1igaxsa08vvv4b5ry9ipyr18917pi8w0y4kvddm2v";
      type = "gem";
    };
    version = "1.0.0";
  };
  airbrake = {
    dependencies = [ "airbrake-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1diirjch0znh2a53l0fpylj762j051xdwnvzv1zgfpjxq9s507wh";
      type = "gem";
    };
    version = "13.0.5";
  };
  airbrake-ruby = {
    dependencies = [ "rbtree3" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g1gvvbzbh0kiinw4w0sxaggxdn5wz689dbsssvf2qz76vxk8gi9";
      type = "gem";
    };
    version = "6.2.2";
  };
  android_key_attestation = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02spc1sh7zsljl02v9d5rdb717b628vw2k7jkkplifyjk4db0zj6";
      type = "gem";
    };
    version = "0.3.0";
  };
  anyway_config = {
    dependencies = [ "ruby-next-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01lkgif3mca80cc21lv1ww9mgr1nx2275h6hsgf044pq65r7lygn";
      type = "gem";
    };
    version = "2.8.0";
  };
  appsignal = {
    dependencies = [
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rzn3kdpyk5wq7b20hlp5djbykchl46i90g5kb8q6cwiq90qlw2w";
      type = "gem";
    };
    version = "4.8.4";
  };
  Ascii85 = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nmyxpngg5rycyryhq9l9hapz1y3iqyflskyksxkqm0832a5vjqm";
      type = "gem";
    };
    version = "2.0.1";
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16fbwr6nmsn97n0a6k1nwbpyz08zpinhd6g7196lz1syndbgrszh";
      type = "gem";
    };
    version = "1.0.2";
  };
  auto_strip_attributes = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c1rmrm33xz6kk6w2x0jr24cqavh41102s7x8zcvrqjdfk7y1qm7";
      type = "gem";
    };
    version = "2.6.0";
  };
  awesome_nested_set = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vdain55fil8lvj0z4lbj8jczakh01ij3rhqw56pzyahcn0rxs9w";
      type = "gem";
    };
    version = "3.9.0";
  };
  aws-eventstream = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b30n0gwidxrz72whgkd54cj37anib7fn8pfijg63ryplvg1nggs";
      type = "gem";
    };
    version = "1.1238.0";
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1shqk9frm15g1ygiy33krwj34jrphfjc6w63bglxwnqcic3qqi9y";
      type = "gem";
    };
    version = "3.244.0";
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
      sha256 = "080zh4g1lcjl0bz2l0gjm8vmpd60cvi0p658bh235ypqh9zg61fl";
      type = "gem";
    };
    version = "1.123.0";
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
      sha256 = "1iziq88dwja5gjimqm875g72h0d1lrf1ha9widsjb1cpfxrmsxba";
      type = "gem";
    };
    version = "1.219.0";
  };
  aws-sdk-sns = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03qva7pdyc1wyjhp6dpci50w3r9w8qy17wn2nhl4qvz82383gzhm";
      type = "gem";
    };
    version = "1.113.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    version = "1.12.1";
  };
  axe-core-api = {
    dependencies = [
      "dumb_delegator"
      "ostruct"
      "virtus"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0krl34rhil3lnax8ng3m9xj7p7nsawj30s02n0brzhp084lk8p60";
      type = "gem";
    };
    version = "4.11.2";
  };
  axe-core-rspec = {
    dependencies = [
      "axe-core-api"
      "dumb_delegator"
      "ostruct"
      "virtus"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1swm90zya8zglq2gkxy7hid2ib6z8mk4vpy5axldm4drnkqsbiah";
      type = "gem";
    };
    version = "4.11.2";
  };
  axiom-types = {
    dependencies = [
      "descendants_tracker"
      "ice_nine"
      "thread_safe"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
      type = "gem";
    };
    version = "0.1.1";
  };
  base64 = {
    groups = [
      "default"
      "development"
      "ldap"
      "opf_plugins"
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
      "test"
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jjlh2zkxdl4jm2xslmrmpgr3wqgxkd0qsrir01m590xjsmyy28w";
      type = "gem";
    };
    version = "4.1.1";
  };
  bindata = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n4ymlgik3xcg94h52dzmh583ss40rl3sn0kni63v56sq8g6l62k";
      type = "gem";
    };
    version = "2.5.1";
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
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vyg9l6xivamb49r4kzkcw12r9x943kv79wsvwslhm1qjvx23ybv";
      type = "gem";
    };
    version = "8.0.4";
  };
  browser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bffb8dddrg6zn8c74swhy8mq2mysb195hi7chwwj9c8g2am4798";
      type = "gem";
    };
    version = "6.2.0";
  };
  budgets = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/budgets;
      type = "path";
    };
    version = "1.0.0";
  };
  builder = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
    groups = [ "test" ];
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
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wklj5laypbvc23zy15amrhg0fwmwcy3p3affzhppxrxq9n8k8dg";
      type = "gem";
    };
    version = "1.0.27";
  };
  capybara_accessible_selectors = {
    dependencies = [ "capybara" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "5b9ce7840d04270e99f4f0cb03989e05437326a6";
      sha256 = "009rzrjv8hpj8gihqd8k3b4qjiax599wf4k81sd6qq4wpl16f4ll";
      type = "git";
      url = "https://github.com/citizensadvice/capybara_accessible_selectors";
    };
    version = "0.15.0";
  };
  carrierwave = {
    dependencies = [
      "activemodel"
      "activesupport"
      "addressable"
      "image_processing"
      "marcel"
      "mini_mime"
      "ssrf_filter"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hysq3ymzx7jz06xsvw1jqyg42cs66yn3idwgxzfji3mzh4636yd";
      type = "gem";
    };
    version = "2.2.6";
  };
  carrierwave_direct = {
    dependencies = [
      "carrierwave"
      "fog-aws"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bzwfsqlann3wnhba77c91r6agdyh58xjnmr2xw6i8pfggn0ahfs";
      type = "gem";
    };
    version = "3.0.0";
  };
  cbor = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b65lw8a5s0x7g6c4h0mfzhqn83nwaql2m2hwqii321clvvh8lfz";
      type = "gem";
    };
    version = "0.5.10.2";
  };
  cgi = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s8qdw1nfh3njd47q154njlfyc2llcgi4ik13vz39adqd7yclgz9";
      type = "gem";
    };
    version = "0.5.1";
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
  closure_tree = {
    dependencies = [
      "activerecord"
      "with_advisory_lock"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xv3zi94w177l4z27973mdvi1g8lh390zywgg24dh4za7lj13bzn";
      type = "gem";
    };
    version = "9.6.1";
  };
  coderay = {
    groups = [
      "default"
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
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  coercible = {
    dependencies = [ "descendants_tracker" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
      type = "gem";
    };
    version = "1.0.0";
  };
  color_conversion = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15jcp6i5xi083p0h5qmsir9ghps4mnk5m5w92fhjf59f87xabglr";
      type = "gem";
    };
    version = "0.1.2";
  };
  colored2 = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0drbrv5m3l3qpal7s87gvss81cbzl76gad1hqkpqfqlphf0h7qb3";
      type = "gem";
    };
    version = "4.0.3";
  };
  commonmarker = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gpniiv6b47mqxnbx2aldslx6kpvn2m9xx69hm7cc7v7zhyaz37p";
      type = "gem";
    };
    version = "2.8.1";
  };
  compare-xml = {
    dependencies = [ "nokogiri" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06aks0fjxwvs4l9bd8bl9q48kyadzn4cd5yrrrz1gwcyyv0aa6p2";
      type = "gem";
    };
    version = "0.66";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
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
      "opf_plugins"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02ifws3c4x7b54fv17sm4cca18d2pfw1saxpdji2lbd1f6xgbzrk";
      type = "gem";
    };
    version = "3.0.2";
  };
  cookiejar = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1px0zlnlkwwp9prdkm2lamgy412y009646n2cgsa1xxsqk7nmc8i";
      type = "gem";
    };
    version = "0.3.4";
  };
  cose = {
    dependencies = [
      "cbor"
      "openssl-signature_algorithm"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rbdzl9n8ppyp38y75hw06s17kp922ybj6jfvhz52p83dg6xpm6m";
      type = "gem";
    };
    version = "1.3.1";
  };
  costs = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/costs;
      type = "path";
    };
    version = "1.0.0";
  };
  counter_culture = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gs8677glyqpgkk7k01nv8lxfksvz9rrph7hkzn7mlnx883f5kd2";
      type = "gem";
    };
    version = "3.13.0";
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
      "opf_plugins"
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
  css_parser = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02jaf7n0jpzx2p2b68gcvvms35jvw31cd9h6a1imn4kv2ad7ap5g";
      type = "gem";
    };
    version = "2.0.0";
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
  cuprite = {
    dependencies = [
      "capybara"
      "ferrum"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ay1azfzslgqzxvgxpz9j7i31m0bbpcmrx5wajnrg2yhf3fdah5i";
      type = "gem";
    };
    version = "0.17";
  };
  daemons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";
      type = "gem";
    };
    version = "1.4.1";
  };
  dalli = {
    dependencies = [ "logger" ];
    groups = [ "production" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jc7k9g0hd2nz7lfayaqahah20nlfnpcapn67zddkkcsgci6k141";
      type = "gem";
    };
    version = "5.0.2";
  };
  date = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  date_validator = {
    dependencies = [
      "activemodel"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n1hrs9323q2430fiyzb2y350wim30x5a7242yf7nd20l96q7jb8";
      type = "gem";
    };
    version = "0.12.0";
  };
  deckar01-task_list = {
    dependencies = [ "html-pipeline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rqn9jh45gsw045c6fm05875bpj2xbhnff5m5drmk9wy01zdrav6";
      type = "gem";
    };
    version = "2.3.4";
  };
  declarative = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
  };
  dentaku = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c3xf9ifrmsrdzhgd84aki77klldwdvbnhi8vn8i93mc06la85cd";
      type = "gem";
    };
    version = "3.5.7";
  };
  descendants_tracker = {
    dependencies = [ "thread_safe" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
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
  disposable = {
    dependencies = [
      "declarative"
      "representable"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k44sg1gk7ba8znndc2ikch32dgcsi1l05jvya1wvxmza6r3yakz";
      type = "gem";
    };
    version = "0.6.3";
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
  dotenv = {
    groups = [
      "default"
      "development"
      "test"
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
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1axy0frn3xn3jf1gdafx5rzz843551q1ckwcbp4zy8m69dajazk5";
      type = "gem";
    };
    version = "3.2.0";
  };
  drb = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  dry-configurable = {
    dependencies = [
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a5g30p7kzp37n9w3idp3gy70hzkj30d8j951lhw2zsnb0l8cbc8";
      type = "gem";
    };
    version = "1.3.0";
  };
  dry-container = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aaj0ffwkbdagrry127x1gd4m6am88mhhfzi7czk8isdcj0r7gi3";
      type = "gem";
    };
    version = "0.11.0";
  };
  dry-core = {
    dependencies = [
      "concurrent-ruby"
      "logger"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18cn9s2p7cbgacy0z41h3sf9jvl75vjfmvj774apyffzi3dagi8c";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-inflector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k1dd35sqqqg2abd2g2w78m94pa3mcwvmrsjbkr3hxpn0jxw5c3z";
      type = "gem";
    };
    version = "1.3.1";
  };
  dry-initializer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qy4cv0j0ahabprdbp02nc3r1606jd5dp90lzqg0mp0jz6c9gm9p";
      type = "gem";
    };
    version = "3.2.0";
  };
  dry-logic = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18nf8mbnhgvkw34drj7nmvpx2afmyl2nyzncn3wl3z4h1yyfsvys";
      type = "gem";
    };
    version = "1.6.0";
  };
  dry-monads = {
    dependencies = [
      "concurrent-ruby"
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05jq44kmpa01d37q50wp2wygpwzx6x3xkns2cf3plb46bixscj4k";
      type = "gem";
    };
    version = "1.9.0";
  };
  dry-schema = {
    dependencies = [
      "concurrent-ruby"
      "dry-configurable"
      "dry-core"
      "dry-initializer"
      "dry-logic"
      "dry-types"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09spk1wfpg0v5fi2kblxifjs14pvqka9d452hbn6dbziq2mswfnd";
      type = "gem";
    };
    version = "1.16.0";
  };
  dry-types = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "dry-inflector"
      "dry-logic"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y7icwaa26ycikz6h97gwd1hji3r280n4yr2kmn5sfgqp76yxsxs";
      type = "gem";
    };
    version = "1.9.1";
  };
  dry-validation = {
    dependencies = [
      "concurrent-ruby"
      "dry-core"
      "dry-initializer"
      "dry-schema"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11c0zx0irrawi028xsljpyw8kwxzqrhf7lv6nnmch4frlashp43h";
      type = "gem";
    };
    version = "1.11.1";
  };
  dumb_delegator = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13hq81z3yimhw6xd1czia68mqgcgcw6b8qjcaxm218lmn3jmblhs";
      type = "gem";
    };
    version = "1.1.0";
  };
  em-http-request = {
    dependencies = [
      "addressable"
      "cookiejar"
      "em-socksify"
      "eventmachine"
      "http_parser.rb"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1azx5rgm1zvx7391sfwcxzyccs46x495vb34ql2ch83f58mwgyqn";
      type = "gem";
    };
    version = "1.1.7";
  };
  em-socksify = {
    dependencies = [
      "base64"
      "eventmachine"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vbl74x9m4hccmmhcnp36s50mn7d81annfj3fcqjdhdcm2khi3bx";
      type = "gem";
    };
    version = "0.3.3";
  };
  em-synchrony = {
    dependencies = [ "eventmachine" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jh6ygbcvapmarqiap79i6yl05bicldr2lnmc46w1fyrhjk70x3f";
      type = "gem";
    };
    version = "1.0.6";
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
  equivalent-xml = {
    dependencies = [ "nokogiri" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11zlqc600acqn1kli339c587xca6yvhqpzv9cf2d12l4z8g7c6c9";
      type = "gem";
    };
    version = "0.6.0";
  };
  erb = {
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ncmbdjf2bwmk0jf5cxywns9zbxyfiy4h4p3pzi7yddyjhv81qrq";
      type = "gem";
    };
    version = "6.0.4";
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
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cbwr8iv6d9g50w12a7ccvcrqk5clz4mxa3cspqd3s1rv05f9dfz";
      type = "gem";
    };
    version = "0.9.0";
  };
  erblint-github = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l7j646nma6bx34bsf9y5fxx5naf8brpmvwk025cc38s73fgfa4z";
      type = "gem";
    };
    version = "1.0.1";
  };
  erubi = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  escape_utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "029c7kynhkxw8fgq9q171xi68ajfqrb22r7drvkar018j8871yyz";
      type = "gem";
    };
    version = "1.3.0";
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
  eventmachine = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  eventmachine_httpserver = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02dq358cj7z6qh3n7gmsf345fz25c0hwqprfb51ls82l6yifidax";
      type = "gem";
    };
    version = "0.2.1";
  };
  excon = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ddab9a8ry37nb9jl3h8kc9w5dbg15g6gd23h2dpsw8rlvnxin1j";
      type = "gem";
    };
    version = "1.4.2";
  };
  factory_bot = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xz02xlnfhj418g51w06asfpcjccf7b66dx6ly3c1k2d45rv7ghj";
      type = "gem";
    };
    version = "6.5.6";
  };
  factory_bot_rails = {
    dependencies = [
      "factory_bot"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s3dpi8x754bwv4mlasdal8ffiahi4b4ajpccnkaipp4x98lik6k";
      type = "gem";
    };
    version = "6.5.1";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b8hgpci3wjm3rm41bzpasvsc5j253ljyg5rsajl62dkjk497pjw";
      type = "gem";
    };
    version = "0.5.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v4hfmc7d4lrqqj2wl366rm9551gd08zkv2ppwwnjlnkc217aizi";
      type = "gem";
    };
    version = "3.4.2";
  };
  ferrum = {
    dependencies = [
      "addressable"
      "base64"
      "concurrent-ruby"
      "webrick"
      "websocket-driver"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vp62wy85hr5fa0d29y3wh3zaj10sszj3pl19mps84dja2l4099c";
      type = "gem";
    };
    version = "0.17.2";
  };
  ffi = {
    groups = [
      "default"
      "development"
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
  flamegraph = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p785nmhdzbwj0qpxn5fzrmr4kgimcds83v4f95f387z6w3050x6";
      type = "gem";
    };
    version = "0.9.5";
  };
  fog-aws = {
    dependencies = [
      "base64"
      "fog-core"
      "fog-json"
      "fog-xml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19crlx2pnyxa8ncv874gz652hxh6yd9lr1354yznrgkqv5p37ir0";
      type = "gem";
    };
    version = "3.33.1";
  };
  fog-core = {
    dependencies = [
      "builder"
      "excon"
      "formatador"
      "mime-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rjv4iqr64arxv07bh84zzbr1y081h21592b5zjdrk937al8mq1z";
      type = "gem";
    };
    version = "2.6.0";
  };
  fog-json = {
    dependencies = [
      "fog-core"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-xml = {
    dependencies = [
      "fog-core"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1miv6zgglx4vddw2c17mpf6l36qn0abq7ngrxb9isih10yhzxfaj";
      type = "gem";
    };
    version = "0.1.5";
  };
  formatador = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "156qa2wiizmdalz6cim04yaasdz1q6c6k7yhnpdnrhn26f0qkyhr";
      type = "gem";
    };
    version = "1.2.3";
  };
  friendly_id = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hxhddr497v7cciwns9rw7fsi6qczp3c2r0i6a31blpvag6j3qi8";
      type = "gem";
    };
    version = "5.6.0";
  };
  front_matter_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yvvxcym75csvckkg3bcf739ild3f0b2yifnlj45gf8xl2yriqms";
      type = "gem";
    };
    version = "1.0.1";
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
  fuubar = {
    dependencies = [
      "rspec-core"
      "ruby-progressbar"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1028vn7j3kc5qqwswrf3has3qm4j9xva70xmzb3n29i89f0afwmj";
      type = "gem";
    };
    version = "2.5.1";
  };
  glob = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "131356zfr61zajgcz9pjhbrhys3gazd0rkh7m7fi7gjasbicjgc9";
      type = "gem";
    };
    version = "0.4.0";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04gzhqvsm4z4l12r9dkac9a75ah45w186ydhl0i4andldsnkkih5";
      type = "gem";
    };
    version = "1.3.0";
  };
  good_job = {
    dependencies = [
      "activejob"
      "activerecord"
      "concurrent-ruby"
      "fugit"
      "railties"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ldnb8j1kinw1ag04ij16p32qf5xl3hp7vfszfxj9rxf8r1id3zk";
      type = "gem";
    };
    version = "4.14.2";
  };
  google-apis-core = {
    dependencies = [
      "addressable"
      "faraday"
      "faraday-follow_redirects"
      "googleauth"
      "mini_mime"
      "representable"
      "retriable"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a961x3jq0wskwgb8ym83viza05bcvsqiny8gg6dc0n9mnm7jids";
      type = "gem";
    };
    version = "1.0.2";
  };
  google-apis-gmail_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vs9ivwh3jqxxcn2dax4hz8wzs049l7vpr4chbi8anx5dm5l6r1h";
      type = "gem";
    };
    version = "0.47.0";
  };
  google-cloud-env = {
    dependencies = [
      "base64"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rvqj6n6qhjmjy0lynpmga7ly48s7dk36i6nj4jqrrvvn8gc1ahg";
      type = "gem";
    };
    version = "2.3.1";
  };
  google-logging-utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yyzlgy9hx104xhrbl51ana0dl3m5p5989j4lcjsizssxas64m37";
      type = "gem";
    };
    version = "0.2.0";
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
      sha256 = "1p3cg5sf7if5vf17glhsm58ydk6cr68kgyi8y1h9qrcd5da82w9l";
      type = "gem";
    };
    version = "4.34.1";
  };
  googleapis-common-protos-types = {
    dependencies = [ "google-protobuf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iy4pxpsbxjdiyd03mslalbcvrrga57h1mb0r0c01nnngfvr4x7r";
      type = "gem";
    };
    version = "1.22.0";
  };
  googleauth = {
    dependencies = [
      "faraday"
      "google-cloud-env"
      "google-logging-utils"
      "jwt"
      "multi_json"
      "os"
      "signet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f56614nd955cxwy98c2d1zk4zg263r1iafd90czg2p3w819a00m";
      type = "gem";
    };
    version = "1.16.2";
  };
  grape = {
    dependencies = [
      "activesupport"
      "dry-configurable"
      "dry-types"
      "mustermann-grape"
      "rack"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b2d9rv8d13vvcs5p74mphk8zvn9j06x7a4crqa66pv0wlhb1via";
      type = "gem";
    };
    version = "3.2.0";
  };
  grape_logging = {
    dependencies = [
      "grape"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04ryg7m4nfszkcfiyl8wmicnlzihpvg6i1jh438ibpwnrs2djqkv";
      type = "gem";
    };
    version = "3.0.0";
  };
  gravatar_image_tag = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kzx81y56kdady6yv77byh15yy5riwbs0d5r2gki3ds6m3z30mpb";
      type = "gem";
    };
    version = "1.2.0";
  };
  grids = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/grids;
      type = "path";
    };
    version = "1.0.0";
  };
  hana = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03cvrv2wl25j9n4n509hjvqnmwa60k92j741b64a1zjisr1dn9al";
      type = "gem";
    };
    version = "1.3.7";
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
  hashery = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    version = "2.1.2";
  };
  hashie = {
    dependencies = [ "logger" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w1qrab701d3a63aj2qavwc2fpcqmkzzh1w2x93c88zkjqc4frn2";
      type = "gem";
    };
    version = "5.1.0";
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
  html-pipeline = {
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "180kjksi0sdlqb0aq0bhal96ifwqm25hzb3w709ij55j51qls7ca";
      type = "gem";
    };
    version = "2.14.3";
  };
  htmlbeautifier = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nrqvgja3pbmz4v27zc5ir58sk4mv177nq7hlssy2smawbvhhgdl";
      type = "gem";
    };
    version = "1.4.3";
  };
  htmldiff = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "188kw5694rhndd69dpzi8ygi50sx6s2ig9jl6756racfif60cvd9";
      type = "gem";
    };
    version = "0.0.1";
  };
  htmlentities = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  http-2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "170w2yzv5wazc38vb60c9bmn3hfqag0546la9zlvl7d16nfkfbqv";
      type = "gem";
    };
    version = "1.1.3";
  };
  "http_parser.rb" = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yh924g697spcv4hfigyxgidhyy6a7b9007rnac57airbcadzs4s";
      type = "gem";
    };
    version = "0.8.1";
  };
  httpx = {
    dependencies = [ "http-2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j5mqqv01ar26i6zgmld4fn7i12j1imcb4ilvhm16sl7r6mjbn42";
      type = "gem";
    };
    version = "1.7.6";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  icalendar = {
    dependencies = [
      "base64"
      "ice_cube"
      "logger"
      "ostruct"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xfr3686v5brfwhpz7cjj638rxzac5z0jh7cxay184jd9dwgngdn";
      type = "gem";
    };
    version = "2.12.2";
  };
  ice_cube = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gpwlpshsjlld53h1f999p0azd9jdlgmhbswa19wqjjbv9fv9pij";
      type = "gem";
    };
    version = "0.17.0";
  };
  ice_nine = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
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
  inline_svg = {
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03x1z55sh7cpb63g46cbd6135jmp13idcgqzqsnzinbg4cs2jrav";
      type = "gem";
    };
    version = "1.10.0";
  };
  interception = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01vrkn28psdx1ysh5js3hn17nfp1nvvv46wc1pwqsakm6vb1hf55";
      type = "gem";
    };
    version = "0.5";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
      "opf_plugins"
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
  iso8601 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18js898rhh6byp0znvchiv6mcxi5l8v3v0bj2ddajpxynwajp319";
      type = "gem";
    };
    version = "0.13.0";
  };
  jmespath = {
    groups = [
      "default"
      "opf_plugins"
    ];
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
      sha256 = "1qdpavs642sqcx8gr8q3zqqbyhqzismdc413zl3bv7rhh578801k";
      type = "gem";
    };
    version = "1.13.0";
  };
  json = {
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0il6qxkxqql7n7sgrws5bi5a36v51dswqcxb6j6gm8aj62shp6r8";
      type = "gem";
    };
    version = "2.19.3";
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k64mp59jlbqd5hyy46pf93s3yl1xdngfy8i8flq2hn5nhk91ybg";
      type = "gem";
    };
    version = "1.17.0";
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
      sha256 = "0rinh4347nvl9jm0r4mk7gi1zh1iz367w3dxn8d2r8j5v1pg9gz8";
      type = "gem";
    };
    version = "6.2.0";
  };
  json_schemer = {
    dependencies = [
      "bigdecimal"
      "hana"
      "regexp_parser"
      "simpleidn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15p31bq932bfpsi1wgrkgwm71l7z1h1w53q6vl44w6kjrr6gn09g";
      type = "gem";
    };
    version = "2.5.0";
  };
  json_spec = {
    dependencies = [
      "multi_json"
      "rspec"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03yiravv6q8lp37rip2i25w2qd63mwwi4jmw7ymf51y7j9xbjxvs";
      type = "gem";
    };
    version = "1.1.5";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dfm4bhl4fzn076igh0bmh2v1vphcrxdv6ldc46hdd3bkbqr2sdg";
      type = "gem";
    };
    version = "3.1.2";
  };
  ladle = {
    dependencies = [ "open4" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p4hv85nrcqg59hbcxm14d98wbk0smdsdljppx48sycc21j6jn78";
      type = "gem";
    };
    version = "1.0.1";
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
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cnv3ggnzyagl50vzs1693aacv08bhwlprcvjp8jcg2w7cp3zwrg";
      type = "gem";
    };
    version = "1.10.0";
  };
  letter_opener_web = {
    dependencies = [
      "actionmailer"
      "letter_opener"
      "railties"
      "rexml"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q4qfi5wnn5bv93zjf10agmzap3sn7gkfmdbryz296wb1vz1wf9z";
      type = "gem";
    };
    version = "3.0.0";
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
  listen = {
    dependencies = [
      "logger"
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ln9c0vx165hkfbn2817qw4m6i77xcxh6q0r5v6fqfhlcbdq5qf6";
      type = "gem";
    };
    version = "3.10.0";
  };
  lobby_boy = {
    dependencies = [
      "omniauth"
      "omniauth-openid-connect"
      "rails"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wl105faijn0pl6i8gcqwaw5d9wwczvvhdzinf71bvra0lybnq4l";
      type = "gem";
    };
    version = "0.1.3";
  };
  logger = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "011fdngxzr1p9dq2hxqz7qq1glj2g44xnhaadjqlf48cplywfdnl";
      type = "gem";
    };
    version = "2.25.1";
  };
  lookbook = {
    dependencies = [
      "activemodel"
      "css_parser"
      "htmlbeautifier"
      "htmlentities"
      "marcel"
      "railties"
      "redcarpet"
      "rouge"
      "view_component"
      "yard"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z6dchw3f446dgdsn27z1gwjj23mbsnl0d26qi9va5crvqxnj6n1";
      type = "gem";
    };
    version = "2.3.14";
  };
  mail = {
    dependencies = [
      "logger"
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ha9sgkfqna62c1basc17dkx91yk7ppgjq32k4nhrikirlz6g9kg";
      type = "gem";
    };
    version = "2.9.0";
  };
  marcel = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "190n2mk8m1l708kr88fh6mip9sdsh339d2s6sgrik3sbnvz4jmhd";
      type = "gem";
    };
    version = "1.0.4";
  };
  markly = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04ammhfwf91r7kh7iiz6kw1mjql250bchx0z2yggq7jv72gdfw3g";
      type = "gem";
    };
    version = "0.16.0";
  };
  matrix = {
    groups = [
      "default"
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
  mcp = {
    dependencies = [ "json-schema" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mrb4ijyfhqycx8g6d4dmcf4vkygi9y835cagg67bzvdn4g27f89";
      type = "gem";
    };
    version = "0.10.0";
  };
  md_to_pdf = {
    dependencies = [
      "base64"
      "bigdecimal"
      "color_conversion"
      "front_matter_parser"
      "json-schema"
      "markly"
      "matrix"
      "nokogiri"
      "prawn"
      "prawn-table"
      "text-hyphen"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "0cb4597becd2243b810e7ce53bbbbf28b5f05844";
      sha256 = "15l8kfcx66wa1gjykgf3nzgcv0lijvm713ybs5im4cnyklcgr7hz";
      type = "git";
      url = "https://github.com/opf/md-to-pdf";
    };
    version = "0.2.6";
  };
  messagebird-rest = {
    dependencies = [ "jwt" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "176m75m0bxmq9c8aa3b7wmn34sybq8k79l7s46h4lpixpbpw2k6s";
      type = "gem";
    };
    version = "5.0.0";
  };
  meta-tags = {
    dependencies = [ "actionpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hb2qync61pgdm3vhhqncn556jb0g1d6ycf3bbzy939rxrdqprzz";
      type = "gem";
    };
    version = "2.23.0";
  };
  method_source = {
    groups = [
      "default"
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
      sha256 = "1cxdij526ricyg5rqdc2wxg6b84fylds2yjj6r8kaccp0b7rb4wh";
      type = "gem";
    };
    version = "3.2026.0407";
  };
  mini_magick = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1i2ilgjfjqc6sw4cwa4g9w3ngs41yvvazr9y82vapp5sfvymsf99";
      type = "gem";
    };
    version = "5.3.1";
  };
  mini_mime = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
    groups = [ "default" ];
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18fw91yyphazl5bi9bkw1p7b0rpqa72gsiwj1130zm498mk084yz";
      type = "gem";
    };
    version = "6.0.4";
  };
  msgpack = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";
      type = "gem";
    };
    version = "1.8.0";
  };
  multi_json = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vfaab23d85617ps412ydb8ap4ci1sfzi8ainn8yyifc0pl38f9g";
      type = "gem";
    };
    version = "1.20.1";
  };
  mustermann = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fb8hy3qaq00kh9s4617abjy3n8d5ridd9q3jfp3wx3zzdph0fz7";
      type = "gem";
    };
    version = "3.1.0";
  };
  mustermann-grape = {
    dependencies = [ "mustermann" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iaqlj7kjm5dd207gxcwi3nsjs616yqc08y0whfg1j04c2c8l9cd";
      type = "gem";
    };
    version = "1.1.0";
  };
  my_page = {
    dependencies = [ "grids" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/my_page;
      type = "path";
    };
    version = "1.0.0";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [
      "default"
      "opf_plugins"
    ];
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
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bgjhb65r1bl52wdym6wpbb0r3j7va8s44grggp0jvarfvw7bawv";
      type = "gem";
    };
    version = "0.6.3";
  };
  net-ldap = {
    dependencies = [
      "base64"
      "ostruct"
    ];
    groups = [ "ldap" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wjkrvcwnxa6ggq0nfz004f1blm1c67fv7c6614sraak0wshn25j";
      type = "gem";
    };
    version = "0.20.0";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
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
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
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
    groups = [
      "default"
      "development"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    version = "0.5.1";
  };
  nio4r = {
    groups = [
      "default"
      "opf_plugins"
    ];
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mhp90nf3g3yy5vgjnwd34czi6rbi0p7057vgngfmmdkknsxiz9q";
      type = "gem";
    };
    version = "1.19.2";
  };
  oj = {
    dependencies = [
      "bigdecimal"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i4292l24jpsza7nknn76cki3c9isv48138sy4g2lqs3c5k8ys56";
      type = "gem";
    };
    version = "3.16.17";
  };
  okcomputer = {
    dependencies = [ "benchmark" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xqy9z5j15w2g0sr6ydk9krwn9rqas30fzs05391cj23d3kp1xvx";
      type = "gem";
    };
    version = "1.19.1";
  };
  omniauth = {
    dependencies = [
      "hashie"
      "rack"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "7eb21563ba047ef86d71f099975587b5ec88f9c9";
      sha256 = "1wfgqf5kxr7l2jyln3f2glzcpiqxqw0f3fn6fk96bcn4418wsvqh";
      type = "git";
      url = "https://github.com/opf/omniauth";
    };
    version = "1.9.2";
  };
  omniauth-openid-connect = {
    dependencies = [
      "addressable"
      "omniauth"
      "openid_connect"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "825d06235b64f6bc872bba709f1c2d48fd5cede4";
      sha256 = "1saz2a6f4n1nzxncccc1qc293ps8dybrbggribw18jbh5rvjw4ym";
      type = "git";
      url = "https://github.com/opf/omniauth-openid-connect.git";
    };
    version = "0.5.0";
  };
  omniauth-openid_connect-providers = {
    dependencies = [ "omniauth-openid-connect" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "c7e2498a8b093cfc5693d4960cae2e903a5e10cd";
      sha256 = "0zf64yfavsss240vpbasci5zxqa0dm4df39hlhq6n4040fzy6zlc";
      type = "git";
      url = "https://github.com/opf/omniauth-openid_connect-providers.git";
    };
    version = "0.2.0";
  };
  omniauth-saml = {
    dependencies = [
      "omniauth"
      "ruby-saml"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gdgjwiv60ladn48w3lrb7qr91dnyxvfbnnny87gzgni9wpy5p8k";
      type = "gem";
    };
    version = "1.10.6";
  };
  op-clamav-client = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r1907b0rqyy62n8n7k32zayq00shzsgs32kvjijp2km25ynk3gj";
      type = "gem";
    };
    version = "3.4.2";
  };
  open4 = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cgls3f9dlrpil846q0w7h66vsc33jqn84nql4gcqkk221rh7px1";
      type = "gem";
    };
    version = "1.3.4";
  };
  openid_connect = {
    dependencies = [
      "activemodel"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
      "json-jwt"
      "rack-oauth2"
      "swd"
      "tzinfo"
      "validate_email"
      "validate_url"
      "webfinger"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "009ibw3g0gzrbblxfq6261pw4xb12z6605g3ypgk6vm3nn2lw9ii";
      type = "gem";
    };
    version = "2.2.1";
  };
  openproject-auth_plugins = {
    dependencies = [ "omniauth" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/auth_plugins;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-auth_saml = {
    dependencies = [ "omniauth-saml" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/auth_saml;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-avatars = {
    dependencies = [ "gravatar_image_tag" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/avatars;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-backlogs = {
    dependencies = [ "acts_as_list" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/backlogs;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-bim = {
    dependencies = [
      "activerecord-import"
      "rubyzip"
    ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/bim;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-boards = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/boards;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-calendar = {
    dependencies = [ "icalendar" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/calendar;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-documents = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/documents;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-gantt = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/gantt;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-github_integration = {
    dependencies = [ "openproject-webhooks" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/github_integration;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-gitlab_integration = {
    dependencies = [ "openproject-webhooks" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/gitlab_integration;
      type = "path";
    };
    version = "3.0.0";
  };
  openproject-job_status = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/job_status;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-ldap_groups = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/ldap_groups;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-meeting = {
    dependencies = [ "icalendar" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/meeting;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-octicons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p1a0hd48zrwgh10zd8jvaj45ljgy2kyjdsbr5win1fql9c8mzjf";
      type = "gem";
    };
    version = "19.34.0";
  };
  openproject-octicons_helper = {
    dependencies = [
      "actionview"
      "openproject-octicons"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d7dp56fgxyf1yyv7i3l2277ipihmbmn8r67d49n68af47r7msqj";
      type = "gem";
    };
    version = "19.34.0";
  };
  openproject-openid_connect = {
    dependencies = [
      "lobby_boy"
      "omniauth-openid_connect-providers"
      "openproject-auth_plugins"
    ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/openid_connect;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-primer_view_components = {
    dependencies = [
      "actionview"
      "activesupport"
      "openproject-octicons"
      "view_component"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11py87j42ipzi46053qm8gd1sgrypm2yam533lnkna7vbh9x4yih";
      type = "gem";
    };
    version = "0.84.5";
  };
  openproject-recaptcha = {
    dependencies = [ "recaptcha" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/recaptcha;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-reporting = {
    dependencies = [ "costs" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/reporting;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-storages = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/storages;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-team_planner = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/team_planner;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-token = {
    dependencies = [ "activemodel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15ph5jy6hwqy1nwcpbggg9yx8w3vr04rwgnnl4psi4lx4vvvy708";
      type = "gem";
    };
    version = "8.8.2";
  };
  openproject-two_factor_authentication = {
    dependencies = [
      "aws-sdk-sns"
      "messagebird-rest"
      "rotp"
      "webauthn"
    ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/two_factor_authentication;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-webhooks = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/webhooks;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-wikis = {
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/wikis;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-xls_export = {
    dependencies = [ "spreadsheet" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/xls_export;
      type = "path";
    };
    version = "1.0.0";
  };
  openssl = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zazkk5q3p2ldd23ka04wypsz2g8gqwwainf3d58j0kvdc9p8yg2";
      type = "gem";
    };
    version = "4.0.1";
  };
  openssl-signature_algorithm = {
    dependencies = [ "openssl" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "103yjl68wqhl5kxaciir5jdnyi7iv9yckishdr52s5knh9g0pd53";
      type = "gem";
    };
    version = "1.3.0";
  };
  opentelemetry-api = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yvr0124j5hndqp520kizf9s3pvlbyiqxlwqskcanfsq4vfnah6j";
      type = "gem";
    };
    version = "1.9.0";
  };
  opentelemetry-common = {
    dependencies = [ "opentelemetry-api" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wx79z0y4kqb49f85bjsnnd8s002nxjnmmklxgz6gila7cipnr7i";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-exporter-otlp = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-sdk"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lra1dz61mv3kvyz95glgdv6c02a2wlb2mzvlfpbjziw767f773f";
      type = "gem";
    };
    version = "0.33.0";
  };
  opentelemetry-helpers-mysql = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jkf2yygrlb4b4q08l1v2haakn6l0s6iap72sakp3hmf51a5salc";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-helpers-sql = {
    dependencies = [ "opentelemetry-api" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y9p7xxn491pjdcb9n4m25lvpigr63ywflqw9lfd8vd1sqbq1c2b";
      type = "gem";
    };
    version = "0.3.0";
  };
  opentelemetry-helpers-sql-processor = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x13ig8z9fabw5l3p5lrm0ad80qsibmx0cfw8z99n8c751x8s8zc";
      type = "gem";
    };
    version = "0.4.0";
  };
  opentelemetry-instrumentation-action_mailer = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mqh8z6myff0j11zcnm34s1lc8qzmzzqdrhzk95y2sh6vdmqd143";
      type = "gem";
    };
    version = "0.6.1";
  };
  opentelemetry-instrumentation-action_pack = {
    dependencies = [ "opentelemetry-instrumentation-rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yd72bp4f2ilqpbrwj26rhgx97gpn7jiz5zv66pqkzvdp434imgl";
      type = "gem";
    };
    version = "0.16.0";
  };
  opentelemetry-instrumentation-action_view = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z7s35vscxi0dsd588ggc41j3rzikslzrmlkk70snbb7bl0rk876";
      type = "gem";
    };
    version = "0.11.2";
  };
  opentelemetry-instrumentation-active_job = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "129ajjrxigl4pag1nlzbdv1js5bij4ll92i1ix50c3f24h9338df";
      type = "gem";
    };
    version = "0.10.1";
  };
  opentelemetry-instrumentation-active_model_serializers = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05ff7yxy2v96kslsqn1y68669is00798i9fgk9fy85vx2r21xs4g";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-active_record = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14kwks0130mrggk3irg4qvx5fmwk9gxv6w23dy6ryi50xqs3y20v";
      type = "gem";
    };
    version = "0.11.1";
  };
  opentelemetry-instrumentation-active_storage = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17p8zmfyigdqvgy3d1691ayzm6nj4q4nx2n3qk01f7wjakphz6zq";
      type = "gem";
    };
    version = "0.3.1";
  };
  opentelemetry-instrumentation-active_support = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zf5kg2h9zgmrwnq7v7by2nyhkxa20gmi5nyqqrpwyaqf4v9isl2";
      type = "gem";
    };
    version = "0.10.1";
  };
  opentelemetry-instrumentation-all = {
    dependencies = [
      "opentelemetry-instrumentation-active_model_serializers"
      "opentelemetry-instrumentation-anthropic"
      "opentelemetry-instrumentation-aws_lambda"
      "opentelemetry-instrumentation-aws_sdk"
      "opentelemetry-instrumentation-bunny"
      "opentelemetry-instrumentation-concurrent_ruby"
      "opentelemetry-instrumentation-dalli"
      "opentelemetry-instrumentation-delayed_job"
      "opentelemetry-instrumentation-ethon"
      "opentelemetry-instrumentation-excon"
      "opentelemetry-instrumentation-faraday"
      "opentelemetry-instrumentation-grape"
      "opentelemetry-instrumentation-graphql"
      "opentelemetry-instrumentation-grpc"
      "opentelemetry-instrumentation-gruf"
      "opentelemetry-instrumentation-http"
      "opentelemetry-instrumentation-http_client"
      "opentelemetry-instrumentation-httpx"
      "opentelemetry-instrumentation-koala"
      "opentelemetry-instrumentation-lmdb"
      "opentelemetry-instrumentation-mongo"
      "opentelemetry-instrumentation-mysql2"
      "opentelemetry-instrumentation-net_http"
      "opentelemetry-instrumentation-pg"
      "opentelemetry-instrumentation-que"
      "opentelemetry-instrumentation-racecar"
      "opentelemetry-instrumentation-rack"
      "opentelemetry-instrumentation-rails"
      "opentelemetry-instrumentation-rake"
      "opentelemetry-instrumentation-rdkafka"
      "opentelemetry-instrumentation-redis"
      "opentelemetry-instrumentation-resque"
      "opentelemetry-instrumentation-restclient"
      "opentelemetry-instrumentation-ruby_kafka"
      "opentelemetry-instrumentation-sidekiq"
      "opentelemetry-instrumentation-sinatra"
      "opentelemetry-instrumentation-trilogy"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qi7axf6ajqa32l2rla18q5fsdsz80s6082pf4b0xrwlv93wwxxh";
      type = "gem";
    };
    version = "0.91.0";
  };
  opentelemetry-instrumentation-anthropic = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q1d9l7z05r0ba04kyfj3knd843kipr2yq9mrhrfyrlsgvcy0h00";
      type = "gem";
    };
    version = "0.4.0";
  };
  opentelemetry-instrumentation-aws_lambda = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k1ksgyaix82bpll1pymqfia0f3c0y6nd841vpnwk6zy7hwn2c8s";
      type = "gem";
    };
    version = "0.6.0";
  };
  opentelemetry-instrumentation-aws_sdk = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qqim5n5mnp0n6lw4d0gh3dxhn4im8bf2iiyijxy4lfz9msix8k7";
      type = "gem";
    };
    version = "0.11.0";
  };
  opentelemetry-instrumentation-base = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-registry"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09ysfv2x25svwl4yxrbgmjkwrlkylr7plci3jjb6wkim11zklak4";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-bunny = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1195m9jaaax2p0h3bmnr7q7xi3g7x73np3iyqg8a2hjzibj89i0y";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-concurrent_ruby = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lniyy8yzmvz1mrh7az0yn94j4d9p0vvd6v0jgk9vi8042vxi6r2";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-dalli = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kqg4ydg6qm0b12y4xfjyc8xx42n9pa8b0phqy494lnirrr2gf11";
      type = "gem";
    };
    version = "0.29.2";
  };
  opentelemetry-instrumentation-delayed_job = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v63h38nkngac0c3bxc45bdjabjs17m0vqdv5dyarndzs885pws7";
      type = "gem";
    };
    version = "0.25.1";
  };
  opentelemetry-instrumentation-ethon = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bbb4lk20n70ijb8811xcqn76w9i8l30j7vz0h077hpy6c3ypdas";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-excon = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16xr4siy4lq7rr1gjs499wiy9dlriq4l1i41mcjgkmc9wjyd1gq0";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-faraday = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zfdhvv6k4jknijrh01xi7b0fc7hdqgvqc53i6dnm66qqic8ixr1";
      type = "gem";
    };
    version = "0.32.0";
  };
  opentelemetry-instrumentation-grape = {
    dependencies = [ "opentelemetry-instrumentation-rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0myhjbs4v2m753qbrk78285vbmi66ccpkarjc04vyhkb871hlvxw";
      type = "gem";
    };
    version = "0.6.0";
  };
  opentelemetry-instrumentation-graphql = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07qv80fq0n3rkw2fyd9wj5kjb4xqa6rw1j27h82zky17ahi5yid4";
      type = "gem";
    };
    version = "0.31.2";
  };
  opentelemetry-instrumentation-grpc = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11xw3vr47k45d3byjbq5rr8h7833lp0xiq93zv8vqsgcsnqjpyjz";
      type = "gem";
    };
    version = "0.4.1";
  };
  opentelemetry-instrumentation-gruf = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kfsb3gy0s1ninv698s024990n324n11d1wsgj21prqjwcvbw8gf";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-instrumentation-http = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w92872isynzq2ifj8wfv5xxb6nj719qph4mhmvg34f7v8i1z662";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-instrumentation-http_client = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f7wb1niwwc5kd432c4jf84hi4d4sqg55cz059ixaxbd2vnxznpn";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-httpx = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00xasq9xgf41ckip7df7ll4kp9bvb32is09vzvcgcv06c9diha1r";
      type = "gem";
    };
    version = "0.7.0";
  };
  opentelemetry-instrumentation-koala = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yf61djnr45a5mylixawq17bd00crfj0bcdj9fcx8kx6l984nclg";
      type = "gem";
    };
    version = "0.23.0";
  };
  opentelemetry-instrumentation-lmdb = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jzmwlfdvaqapnmj9ll46hsymwas3ybn4405f97js97ahganck8y";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-mongo = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fclzfiqrzyj132r9lyjh2rg4f01slrl68nd5q1snq0cpd28asmn";
      type = "gem";
    };
    version = "0.25.1";
  };
  opentelemetry-instrumentation-mysql2 = {
    dependencies = [
      "opentelemetry-helpers-mysql"
      "opentelemetry-helpers-sql"
      "opentelemetry-helpers-sql-processor"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ydwf1afzqzcnx65nx4m2kb6b2aif2ikrgkkdq29xxgfsmbpk6xl";
      type = "gem";
    };
    version = "0.33.0";
  };
  opentelemetry-instrumentation-net_http = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x9623hrnycm7rmha16cnplkbg4vs61q7kiy576ibfngiwf0rc33";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-pg = {
    dependencies = [
      "opentelemetry-helpers-sql"
      "opentelemetry-helpers-sql-processor"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m5ajycnnpj683bjphqjd2zqlcgxp641pvpi45hbb0jjsj5yg9k5";
      type = "gem";
    };
    version = "0.35.0";
  };
  opentelemetry-instrumentation-que = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ys4k62dw3f45wd6236lap48fgq3lkmhm1jpii7s1xba3ws88yiv";
      type = "gem";
    };
    version = "0.12.0";
  };
  opentelemetry-instrumentation-racecar = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0idq6n6k8ql10jldx3jf5g9p952labnd8hg8fzsn3dkgj08ncgw3";
      type = "gem";
    };
    version = "0.6.1";
  };
  opentelemetry-instrumentation-rack = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g1hcbpw9gs9q77h6avwnf271i574l5yn81ac8wiiffl8ixlz99h";
      type = "gem";
    };
    version = "0.30.0";
  };
  opentelemetry-instrumentation-rails = {
    dependencies = [
      "opentelemetry-instrumentation-action_mailer"
      "opentelemetry-instrumentation-action_pack"
      "opentelemetry-instrumentation-action_view"
      "opentelemetry-instrumentation-active_job"
      "opentelemetry-instrumentation-active_record"
      "opentelemetry-instrumentation-active_storage"
      "opentelemetry-instrumentation-active_support"
      "opentelemetry-instrumentation-concurrent_ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10xr2x96vz0xgnmlqfbngxjabql8zhfzgfhxmikr33dlx1vx957p";
      type = "gem";
    };
    version = "0.40.0";
  };
  opentelemetry-instrumentation-rake = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vq118xmgp3lipccxn3hcxz71rjg9qlhdspacy5aqxc90wcx0szs";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-instrumentation-rdkafka = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12fadamq0fy1bgmv2ia43ndji0pglbjzciic3bcxg16551lbbgpk";
      type = "gem";
    };
    version = "0.9.0";
  };
  opentelemetry-instrumentation-redis = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "001rd4ix10hja64y2arhpcd0hlmjilx7zlb4slmx4zaj3iyra8c7";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-resque = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r85z37whl9z40hl224d09ipn53dw8vfsjaimrbxfg97svlxv7jm";
      type = "gem";
    };
    version = "0.8.0";
  };
  opentelemetry-instrumentation-restclient = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16gqqdd39s6v9sgdc3rga4qbzg11q29k7v53ixjgivs3by7j1ghs";
      type = "gem";
    };
    version = "0.27.0";
  };
  opentelemetry-instrumentation-ruby_kafka = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hjji7x52nix6h4yv6nl7i4wrbs4gd4qsh390qzblc769hgqjzi5";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-sidekiq = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1blpmqsn64p5zq94slcm8zh1rl09qzvgjypxm7kn4lvak5i5vj5b";
      type = "gem";
    };
    version = "0.28.1";
  };
  opentelemetry-instrumentation-sinatra = {
    dependencies = [ "opentelemetry-instrumentation-rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nwvanv0ml7p1aapk9j43r1q92wr4x5ypb4n3mcdz66i13n5yn88";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-instrumentation-trilogy = {
    dependencies = [
      "opentelemetry-helpers-mysql"
      "opentelemetry-helpers-sql"
      "opentelemetry-helpers-sql-processor"
      "opentelemetry-instrumentation-base"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pq2zn30bjkmix0sb1f2cq2kqs7pfj7apvasxwca8anrf4q4sfa0";
      type = "gem";
    };
    version = "0.67.0";
  };
  opentelemetry-registry = {
    dependencies = [ "opentelemetry-api" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kzv35x5jbpsbp3cjd99c0a1x2ksmfw83fzplpx3x8lkva5aav3j";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-sdk = {
    dependencies = [
      "logger"
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-registry"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ijh31xvjinglvm3h9g9b5f0h1qqp7nay4bclkzha8bkyh46fz22";
      type = "gem";
    };
    version = "1.11.0";
  };
  opentelemetry-semantic_conventions = {
    dependencies = [ "opentelemetry-api" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hzlz2h2izkyn1f42495jp9xikg50f9nyz7sn0pvl6cycjnwab8y";
      type = "gem";
    };
    version = "1.37.0";
  };
  optimist = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kp3f8g7g7cbw5vfkmpdv71pphhpcxk3lpc892mj9apkd7ys1y4c";
      type = "gem";
    };
    version = "3.2.1";
  };
  os = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      type = "gem";
    };
    version = "1.1.4";
  };
  ostruct = {
    groups = [
      "default"
      "development"
      "ldap"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  overviews = {
    dependencies = [ "grids" ];
    groups = [ "opf_plugins" ];
    platforms = [ ];
    source = {
      path = modules/overviews;
      type = "path";
    };
    version = "1.0.0";
  };
  ox = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rhv8qdnm3s34yvsvmrii15f2238rk3psa6pq6x5x367sssfv6ja";
      type = "gem";
    };
    version = "2.14.23";
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
      sha256 = "1ff0nwkkmc91krmflnxwmxrfw1rd08fq1s4glikyw7njcmnslnna";
      type = "gem";
    };
    version = "43.5.1";
  };
  paper_trail = {
    dependencies = [
      "activerecord"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "118w09wvy4s7jykv5b7j5ac9nkx158g853lh2mqclx1q3l344a0w";
      type = "gem";
    };
    version = "17.0.0";
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
      sha256 = "0z9cbfdfr83k8xhrh1nr4f4z8ryfivfr3gv3fpk22hczwg9q4xrk";
      type = "gem";
    };
    version = "2.0.1";
  };
  parallel_tests = {
    dependencies = [ "parallel" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w2xfc3jrj92w78yd4413s48lkjf3mjw47x4yw8b4qhld664a1fz";
      type = "gem";
    };
    version = "4.10.1";
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
      sha256 = "0m2xqvn1la62hji1mn04y59giikww95p2hs0r4y2rrz3mdxcwyni";
      type = "gem";
    };
    version = "3.3.11.1";
  };
  pdf-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fz0yj4zrlii2j08kaw11j769s373ayz8jrdhxwwjzmm28pqndjg";
      type = "gem";
    };
    version = "0.9.0";
  };
  pdf-inspector = {
    dependencies = [ "pdf-reader" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g853az4xzgqxr5xiwhb76g4sqmjg4s79mm35mp676zjsrwpa47w";
      type = "gem";
    };
    version = "1.3.0";
  };
  pdf-reader = {
    dependencies = [
      "Ascii85"
      "afm"
      "hashery"
      "ruby-rc4"
      "ttfunk"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kk8f1f5kkdwsbskv0vikcwx5xaivv19y9zl97x1fcaam23akihq";
      type = "gem";
    };
    version = "2.15.1";
  };
  pg = {
    groups = [ "postgres" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16caca7lcz5pwl82snarqrayjj9j7abmxqw92267blhk7rbd120k";
      type = "gem";
    };
    version = "1.6.3";
  };
  plaintext = {
    dependencies = [
      "activesupport"
      "nokogiri"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mbh7rrcahfg5cp273dvrlm4va6cr4p49sarsjc8inc4xr9334iv";
      type = "gem";
    };
    version = "0.3.7";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  prawn = {
    dependencies = [
      "pdf-core"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g9avv2rprsjisdk137s9ljr05r7ajhm78hxa1vjsv0jyx22f1l2";
      type = "gem";
    };
    version = "2.4.0";
  };
  prawn-table = {
    dependencies = [ "prawn" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nxd6qmxqwl850icp18wjh5k0s3amxcajdrkjyzpfgq0kvilcv9k";
      type = "gem";
    };
    version = "0.2.2";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  prism = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  prometheus-client-mmap = {
    dependencies = [
      "base64"
      "bigdecimal"
      "logger"
      "rb_sys"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05q1mwfrqq23k33d20f5s69gsdh4fpkgj0jymr20zbhrdj6vj7in";
      type = "gem";
    };
    version = "1.5.0";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
      "reline"
    ];
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
      fetchSubmodules = false;
      rev = "135640262879544c6bfecbf3e78511289bfe956c";
      sha256 = "0vv2r905a9f73gn027039f65518hb05m58wskz81k6y3j6rr17d6";
      type = "git";
      url = "https://github.com/pry/pry.git";
    };
    version = "0.16.0";
  };
  pry-byebug = {
    dependencies = [
      "byebug"
      "pry"
    ];
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
      sha256 = "1dyi2dr5zp08s4bp9ik44v84wc0kdvinmcy7six0lfd8x150jkjr";
      type = "gem";
    };
    version = "3.12.0";
  };
  pry-rails = {
    dependencies = [ "pry" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0garafb0lxbm3sx2r9pqgs7ky9al58cl3wmwc0gmvmrl9bi2i7m6";
      type = "gem";
    };
    version = "0.3.11";
  };
  pry-rescue = {
    dependencies = [
      "interception"
      "pry"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nx6mf97vv11bgy2giljgwds8rjj8kw0qyc6zn3varlqdm8gsnwq";
      type = "gem";
    };
    version = "1.6.0";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [
      "default"
      "development"
      "opf_plugins"
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
      "opf_plugins"
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
  puffing-billy = {
    dependencies = [
      "addressable"
      "cgi"
      "em-http-request"
      "em-synchrony"
      "eventmachine"
      "eventmachine_httpserver"
      "http_parser.rb"
      "multi_json"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vw4m8l216snvk31ssh13jm5hgzx620smid0f4hjnwp08465n0c7";
      type = "gem";
    };
    version = "4.0.4";
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
  puma-plugin-statsd = {
    dependencies = [ "puma" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12yhv8dnh8pzmczpc4g71a8sa66f5d9a7w961vn0ck9z4fkl7wh4";
      type = "gem";
    };
    version = "2.7.0";
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
      "opf_plugins"
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "175ni9qsai9x2ykwvdbd5dzfyncaxpyn6dhjxjw70iq60xz9vzm8";
      type = "gem";
    };
    version = "2.2.23";
  };
  rack-attack = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wpcxspprm187k6mch9fxhaaq1a3s9bzybd2fdaw1g45pzg9yjgj";
      type = "gem";
    };
    version = "6.8.0";
  };
  rack-cors = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06ysmn14pdf2wyr7agm0qvvr9pzcgyf39w4yvk2n05w9k4alwpa1";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-mini-profiler = {
    dependencies = [ "rack" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y1x4rc7bz8x3zn8p6g21rw6ivbjml6a2vl9dhchiy8i6b110n28";
      type = "gem";
    };
    version = "4.0.1";
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cn6a9v8nry9fx4zrzp1xakfp2n5xv5075j90q56m20k7zvjrq23";
      type = "gem";
    };
    version = "2.3.0";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zzvivmdb4dkscc58i3gmcyrnypynsjwp6xgc4ylarlhqmzvlx1w";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xhxhlsz6shh8nm44jsmd9276zcnyzii364vhcvf0k8b8bjia8d0";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  rack-timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nc7kis61n4q7g78gxxsxygam022glmgwq9snydrkjiwg7lkfwvm";
      type = "gem";
    };
    version = "0.7.0";
  };
  rack_session_access = {
    dependencies = [
      "builder"
      "rack"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0swd35lg7qmqhc3pglvsanq2indnvw360m8qxfxwqabl0br9isq3";
      type = "gem";
    };
    version = "0.2.0";
  };
  rackup = {
    dependencies = [
      "rack"
      "webrick"
    ];
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jf2ncj2nx56vh96hh2nh6h4r530nccxh87z7c2f37wq515611ms";
      type = "gem";
    };
    version = "1.0.1";
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
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lww7i686rm9s50d34hb596y2kfl46dida2kjy8gr64c6jjpn0bd";
      type = "gem";
    };
    version = "8.1.3";
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
      "opf_plugins"
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
      "opf_plugins"
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
      sha256 = "1wvcbdslb5gfvs9dw7kscd9da3xfyr3mdh1w4a28vwmy19ngvmaj";
      type = "gem";
    };
    version = "8.1.0";
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
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08nyhsigcvjpj9i3r0s73yi8zm16sxmr2x7xgxlaq2jjrghb0gli";
      type = "gem";
    };
    version = "8.1.3";
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
      "opf_plugins"
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
  rake-compiler-dock = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hpq52ab86s70yv5hk56f0z14izhh59af95nlv73bsrksln1zdga";
      type = "gem";
    };
    version = "1.11.0";
  };
  rb-fsevent = {
    groups = [
      "default"
      "development"
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
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  rb_sys = {
    dependencies = [
      "json"
      "rake-compiler-dock"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y5fjlnf5hmix54klxxh19zc7clyh16bc91x1fpfx2abic5qx5ds";
      type = "gem";
    };
    version = "0.9.126";
  };
  rbtrace = {
    dependencies = [
      "ffi"
      "msgpack"
      "optimist"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gwjrdawjv630xhzwld9b0vrh391sph255vxshpv36jx60pjjcn4";
      type = "gem";
    };
    version = "0.5.3";
  };
  rbtree3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fnq4rpr1pgmvghpr0cz66svm3dih3hnah2gvxq1njd553bylq5b";
      type = "gem";
    };
    version = "0.7.1";
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
      "opf_plugins"
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
  recaptcha = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0an16d2lcaqdwz41ysdkzhslqcgiqnvjd0gkygzj7i84kz6bcywg";
      type = "gem";
    };
    version = "5.21.2";
  };
  redcarpet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iglapqs4av4za9yfaac0lna7s16fq2xn36wpk380m55d8792i6l";
      type = "gem";
    };
    version = "3.6.1";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "production" ];
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
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jw2xjzz24dwn85y8v1jf1vzzpsnypsvs06f1qfa91w7rpwr5248";
      type = "gem";
    };
    version = "0.28.0";
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
      sha256 = "1fwfw26a32rps78920nn29shqg2zmqv72i89j1fap41isshida9m";
      type = "gem";
    };
    version = "2.12.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
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
      sha256 = "0d8q5c4nh2g9pp758kizh8sfrvngynrjlm0i1zn3cnsnfd4v160i";
      type = "gem";
    };
    version = "0.6.3";
  };
  representable = {
    dependencies = [
      "declarative"
      "trailblazer-option"
      "uber"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kms3r6w6pnryysnaqqa9fsn0v73zx1ilds9d1c565n3xdzbyafc";
      type = "gem";
    };
    version = "3.2.0";
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
  retriable = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g634lvyriq8pk87fn0dnz2ib9mma98ks7y0b30j28a9gm5i2gzv";
      type = "gem";
    };
    version = "3.4.1";
  };
  rexml = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  rinku = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zcdha17s1wzxyc5814j6319wqg33jbn58pg6wmxpws36476fq4b";
      type = "gem";
    };
    version = "2.0.6";
  };
  roar = {
    dependencies = [ "representable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "024xjaidpll8d80xqlwm7pgf1hypc5b0sv618svmyyn5g75d3d4d";
      type = "gem";
    };
    version = "1.2.0";
  };
  rotp = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m48hv6wpmmm6cjr6q92q78h1i610riml19k5h1dil2yws3h1m3m";
      type = "gem";
    };
    version = "6.3.0";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fd77qcz603mli4lyi97cjzkv02hsfk60m495qv5qcn02mkqk9fv";
      type = "gem";
    };
    version = "4.7.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "test" ];
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
      sha256 = "0iqxmw0knjiz5nf6pgr8ihs6cjzh89f0ppj3fqiz8cvms79x6sh8";
      type = "gem";
    };
    version = "3.13.8";
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
      sha256 = "1pr29snnnlgkqv80vbi4795l6rxq3l47x5rl7lyni4h8zj95c8q6";
      type = "gem";
    };
    version = "8.0.4";
  };
  rspec-retry = {
    dependencies = [ "rspec-core" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n6qc0d16h6bgh1xarmc8vc58728mgjcsjj8wcd822c8lcivl0b1";
      type = "gem";
    };
    version = "0.6.2";
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
  rspec-wait = {
    dependencies = [ "rspec" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04m9nmk55layv26s5ldara5vbn45sjyx9phhzhk3sp9j74994pw6";
      type = "gem";
    };
    version = "1.0.2";
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
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ca5inh368d4l24a2v2nbd3p4xc6s0pqs91j27h226nh04zmyha4";
      type = "gem";
    };
    version = "1.86.1";
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
      sha256 = "0dahfpnzz63hyqxa03x8rypnrxzwyvh4i5a8ri34bzpnf3pg64j4";
      type = "gem";
    };
    version = "1.49.1";
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
  rubocop-openproject = {
    dependencies = [ "rubocop" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bk6mqaznc4niy8rg3s0brx5bc346nki0nqjk16mmgprj7jxjmnf";
      type = "gem";
    };
    version = "0.4.0";
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
  ruby-duration = {
    dependencies = [
      "activesupport"
      "i18n"
      "iso8601"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "114p0rbg7lklznvcjiqyf8xjm17c3s7yvclgb80pl1l5vyqi6ggb";
      type = "gem";
    };
    version = "3.2.3";
  };
  ruby-next-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11lvg530sgxyr7swyv2vsf49fb1s1xd89wgp0axyqv0qnl5x19zn";
      type = "gem";
    };
    version = "1.2.0";
  };
  ruby-ole = {
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wnblgzz0fax0746yd4i8z16fpsjr6r6yv18l4sjnykr5bfi13ap";
      type = "gem";
    };
    version = "1.2.13.1";
  };
  ruby-prof = {
    dependencies = [
      "base64"
      "ostruct"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d8lbpqw6hlrb5xy5h39f7pi68a4hczgd7dkb2fml18fhzv0y6a2";
      type = "gem";
    };
    version = "2.0.4";
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
  ruby-rc4 = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    version = "0.1.5";
  };
  ruby-saml = {
    dependencies = [
      "nokogiri"
      "rexml"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01wi1csw4kjmlxmd1igx5hj2wrwkslay1xamg4cv8l7imr27l3hv";
      type = "gem";
    };
    version = "1.18.1";
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
  rubytree = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dkfj3pxl1mv90dmfsl8604dc7xcrbk655kxnn1ka58lv0gdq4p3";
      type = "gem";
    };
    version = "2.2.0";
  };
  rubyzip = {
    groups = [
      "default"
      "opf_plugins"
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
  safety_net_attestation = {
    dependencies = [ "jwt" ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1apjjd99bqsc22bfq66j27dp4im0amisy619hr9qbghdapfh3kf8";
      type = "gem";
    };
    version = "0.5.0";
  };
  sanitize = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "111r4xdcf6ihdnrs6wkfc6nqdzrjq0z69x9sf83r7ri6fffip796";
      type = "gem";
    };
    version = "7.0.0";
  };
  scimitar = {
    dependencies = [ "rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qvdn5hc1pj89ahj938nkf0w7qryfg6l8xpkm02vf0wkmfph22bh";
      type = "gem";
    };
    version = "2.15.0";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  selenium-devtools = {
    dependencies = [ "selenium-webdriver" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wv81mq839vlxa9bbrn2b6xyflmr5y8lfc3pdghwgbxzqg3n54lf";
      type = "gem";
    };
    version = "0.147.0";
  };
  selenium-webdriver = {
    dependencies = [
      "base64"
      "logger"
      "rexml"
      "rubyzip"
      "websocket"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p56552x321hgvasdsbz3qgfqd7s10xcw2d0q1m1qw2bjrxkfd56";
      type = "gem";
    };
    version = "4.43.0";
  };
  semantic = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qy1s2kpf9z2p99v23b126ij424yamxviprz59wbp3hrb67v9nrw";
      type = "gem";
    };
    version = "1.6.1";
  };
  shoulda-context = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d1clcp92jv8756h09kbc55qiqncn666alx0s83za06q5hs4bpvs";
      type = "gem";
    };
    version = "2.0.0";
  };
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xwwfj48d6mpc66lhl4yabnjazpf47wqg9n1i9na7q0h9isdigxl";
      type = "gem";
    };
    version = "7.0.1";
  };
  signet = {
    dependencies = [
      "addressable"
      "faraday"
      "jwt"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nydm087m5c3j85gvzvz30w1qb9pl2lzpznw746jha29ybxyj5yn";
      type = "gem";
    };
    version = "0.21.0";
  };
  simpleidn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a9c1mdy12y81ck7mcn9f9i2s2wwzjh1nr92ps354q517zq9dkh8";
      type = "gem";
    };
    version = "0.2.3";
  };
  smart_properties = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jrqssk9qhwrpq41arm712226vpcr458xv6xaqbk8cp94a0kycpr";
      type = "gem";
    };
    version = "1.17.0";
  };
  spreadsheet = {
    dependencies = [
      "bigdecimal"
      "logger"
      "ruby-ole"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lwjqmmr01c3sh9r8hi0b778akxm9pazpxq9h59472ywvzrxdvqa";
      type = "gem";
    };
    version = "1.3.4";
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
  spring-commands-rspec = {
    dependencies = [ "spring" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b0svpq3md1pjz5drpa5pxwg8nk48wrshq8lckim4x3nli7ya0k2";
      type = "gem";
    };
    version = "1.0.4";
  };
  spring-commands-rubocop = {
    dependencies = [ "spring" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hcharzqmi0dpy9vxs21fl0mpmfmcsgbdgq4dyc8mbi7i8n7lrry";
      type = "gem";
    };
    version = "0.4.0";
  };
  sprockets = {
    dependencies = [
      "base64"
      "concurrent-ruby"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10ykzsa76cf8kvbfkszlvbyn4ckcx1mxjhfvwxzs7y28cljhzhkj";
      type = "gem";
    };
    version = "3.7.5";
  };
  sprockets-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17hiqkdpcjyyhlm997mgdcr45v35j5802m5a979i5jgqx5n8xs59";
      type = "gem";
    };
    version = "3.5.2";
  };
  ssrf_filter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xlpb8y555frl82cx4q2i922mps36mmn0ajk21kpy3bks6wwsgg0";
      type = "gem";
    };
    version = "1.5.0";
  };
  stackprof = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "014s1zxlxcw35shislar3y1i3mqa0c6gh3m21js14q1q5zharhjf";
      type = "gem";
    };
    version = "0.2.28";
  };
  statesman = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0km82ypvhl818qzdhwixhp3bird059rafdgk6gj849pxdm37ijry";
      type = "gem";
    };
    version = "13.1.0";
  };
  store_attribute = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f7mjr20wga7s0p6ivjcgh0qvl8vhq445bypw28lryyk04f62lyy";
      type = "gem";
    };
    version = "2.1.1";
  };
  stringex = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1i19x7snfbw0fsfjifvg57b8gm283hhdympj8qb1wym4nb985cy7";
      type = "gem";
    };
    version = "2.8.6";
  };
  stringio = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  structured_warnings = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10q5ldvpsnri5igdfkyg5gs1rbwqaizwv7cgjhxcsqvb9mdcljl6";
      type = "gem";
    };
    version = "0.5.0";
  };
  svg-graph = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fji14c525hvql7jw04zphm8n44d4vvbbnnzmwwnaph50dj8ca7r";
      type = "gem";
    };
    version = "2.2.2";
  };
  swd = {
    dependencies = [
      "activesupport"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m86fzmwgw0vc8p6fwvnsdbldpgbqdz9cbp2zj9z06bc4jjf5nsc";
      type = "gem";
    };
    version = "2.0.3";
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
  table_print = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jxmd1yg3h0g27wzfpvq1jnkkf7frwb5wy9m4f47nf4k3wl68rj3";
      type = "gem";
    };
    version = "1.5.7";
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
  test-prof = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17j9cai2ykcndgn0800m9nb297sx0lpminxj8bcqw4bwkb1xjch3";
      type = "gem";
    };
    version = "1.6.1";
  };
  text-hyphen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01js0wxz84cc5hzxgqbcqnsa0y6crhdi6plmgkzyfm55p0rlajn4";
      type = "gem";
    };
    version = "1.5.0";
  };
  thor = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  thread_safe = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  timecop = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hkmrkg46qvfla31734d5y28q422z5kfgb41yy2227q4wp34sa21";
      type = "gem";
    };
    version = "0.9.11";
  };
  timeout = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  tpm-key_attestation = {
    dependencies = [
      "bindata"
      "openssl"
      "openssl-signature_algorithm"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gqr27hrmg35j7kcb6c2cx3xvkqfs42zpp9jcqw0mzbs79jy9m3z";
      type = "gem";
    };
    version = "0.14.1";
  };
  trailblazer-option = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18s48fndi2kfvrfzmq6rxvjfwad347548yby0341ixz1lhpg3r10";
      type = "gem";
    };
    version = "0.1.2";
  };
  tsort = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  ttfunk = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15iaxz9iak5643bq2bc0jkbjv8w2zn649lxgvh5wg48q9d4blw13";
      type = "gem";
    };
    version = "1.7.0";
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
  turbo_power = {
    dependencies = [ "turbo-rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ryrj2r22nsxflijxjm8pgvdvdy7502s175d4c01sxpsw13x35dd";
      type = "gem";
    };
    version = "0.7.0";
  };
  turbo_tests = {
    dependencies = [
      "parallel_tests"
      "rspec"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "c1c4707f536a5642a168650d273d714dfb62d842";
      sha256 = "1nczxr3g7s28m3rwsqimvajwlmmwar652fb4a9285ak9msvp44jz";
      type = "git";
      url = "https://github.com/opf/turbo_tests.git";
    };
    version = "2.2.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
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
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z896q8kzig9x6g3bcp38apns05y36jhf4j7ml7wzqjsmqcnb8sf";
      type = "gem";
    };
    version = "1.2026.1";
  };
  uber = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
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
  uri = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  useragent = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
  validate_email = {
    dependencies = [
      "activemodel"
      "mail"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r1fz29l699arka177c9xw7409d1a3ff95bf7a6pmc97slb91zlx";
      type = "gem";
    };
    version = "0.1.6";
  };
  validate_url = {
    dependencies = [
      "activemodel"
      "public_suffix"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lblym140w5n88ijyfgcvkxvpfj8m6z00rxxf2ckmmhk0x61dzkj";
      type = "gem";
    };
    version = "1.0.15";
  };
  vcr = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rjalag6mjd796idhil076jnqpiv2lc2ljchxc25kz3fq4ncjyh7";
      type = "gem";
    };
    version = "6.4.0";
  };
  vernier = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gv997yvx5zbwwspqk23m154a38l80sr9lpl2hzd53p029qca7av";
      type = "gem";
    };
    version = "1.10.0";
  };
  view_component = {
    dependencies = [
      "actionview"
      "activesupport"
      "concurrent-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zpdyhsr2vnbhrgmd8hsc75q088klkhqix6kbc9s1y2amdlcrfxa";
      type = "gem";
    };
    version = "4.6.0";
  };
  virtus = {
    dependencies = [
      "axiom-types"
      "coercible"
      "descendants_tracker"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hniwgbdsjxa71qy47n6av8faf8qpwbaapms41rhkk3zxgjdlhc8";
      type = "gem";
    };
    version = "2.0.0";
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
  warden-basic_auth = {
    dependencies = [ "warden" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0viw3wwx3shlb4mynjim99xixs71qn2054wywv1q40cw23h55ixz";
      type = "gem";
    };
    version = "0.2.1";
  };
  webauthn = {
    dependencies = [
      "android_key_attestation"
      "bindata"
      "cbor"
      "cose"
      "openssl"
      "safety_net_attestation"
      "tpm-key_attestation"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z710ndfr9yajywhji8mr5gc3j3wnr0alq754q15nh7k73wgbrlv";
      type = "gem";
    };
    version = "3.4.3";
  };
  webfinger = {
    dependencies = [
      "activesupport"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [
      "default"
      "opf_plugins"
    ];
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
      sha256 = "142cbab47mjxmg8gc89d94sd3h7an9ligh38r9n88wb3xbr5cibp";
      type = "gem";
    };
    version = "3.26.2";
  };
  webrick = {
    groups = [
      "default"
      "development"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    version = "1.9.2";
  };
  websocket = {
    groups = [
      "default"
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
    groups = [
      "default"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qj9dmkmgahmadgh88kydb7cv15w13l1fj3kk9zz28iwji5vl3gd";
      type = "gem";
    };
    version = "0.8.0";
  };
  websocket-extensions = {
    groups = [
      "default"
      "opf_plugins"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  will_paginate = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fbmm0amshidnw0qx0nqjzfyy7if8xy6m5bm8lkksf8xprp24yqh";
      type = "gem";
    };
    version = "4.0.1";
  };
  with_advisory_lock = {
    dependencies = [
      "activerecord"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gqm78w1va32w6kbhpm86pvn9g28d2g7d9j9jrxys42sscg2znys";
      type = "gem";
    };
    version = "7.5.0";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
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
  yabeda = {
    dependencies = [
      "anyway_config"
      "concurrent-ruby"
      "dry-initializer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fjc70yxdg2jc21w6grb67qq4j52f97q9hx81s2iv9frsyn52vkz";
      type = "gem";
    };
    version = "0.16.0";
  };
  yabeda-activerecord = {
    dependencies = [
      "activerecord"
      "anyway_config"
      "yabeda"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qp0lcspci6f9qjhv75bx6bs627ak7khbahqcxd48hjp9sk83lhx";
      type = "gem";
    };
    version = "0.1.2";
  };
  yabeda-prometheus-mmap = {
    dependencies = [
      "prometheus-client-mmap"
      "yabeda"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jg2x5bgfbyzhx99yfpq3xl72386g67f113p7bq33yfnaq3i4rhs";
      type = "gem";
    };
    version = "0.4.0";
  };
  yabeda-puma-plugin = {
    dependencies = [
      "json"
      "puma"
      "yabeda"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j0bam5s3x0q2h8da01rhh0ih71c0avl3p0xd58bqc7fqzn771mp";
      type = "gem";
    };
    version = "0.9.0";
  };
  yabeda-rails = {
    dependencies = [
      "activesupport"
      "anyway_config"
      "railties"
      "yabeda"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aavkbb4hp65s7swmxvn0k1igy20zgvgkfzjnff433scshdmi8mg";
      type = "gem";
    };
    version = "0.11.0";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s5spcxxhpfxl8spmv2rjxy0sq0yh16d8cbp969n0m93hqgy0asf";
      type = "gem";
    };
    version = "0.9.42";
  };
  zeitwerk = {
    groups = [
      "default"
      "development"
      "opf_plugins"
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
}
