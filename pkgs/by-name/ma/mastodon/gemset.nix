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
    groups = [
      "default"
      "development"
    ];
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
      "pam_authentication"
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
      "pam_authentication"
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
  active_model_serializers = {
    dependencies = [
      "actionpack"
      "activemodel"
      "case_transform"
      "jsonapi-renderer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06h6rknvpapvx8l4sfd72msi422fghhchmqd1jn8zh7a4wd3gdma";
      type = "gem";
    };
    version = "0.10.16";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ab2yd79h5xac0zmyzr3lvawl9v5kdghqjhkgxgns0d13qqwki42";
      type = "gem";
    };
    version = "8.1.4.1";
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
      "pam_authentication"
      "production"
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
  android_key_attestation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02spc1sh7zsljl02v9d5rdb717b628vw2k7jkkplifyjk4db0zj6";
      type = "gem";
    };
    version = "0.3.0";
  };
  annotaterb = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05lm7jik8nkzxqvm0afldrk6nzjrmmf51hggp6w98y1gm76a317q";
      type = "gem";
    };
    version = "4.26.0";
  };
  ast = {
    groups = [
      "default"
      "development"
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
      sha256 = "0ymd9wa19ss5x8n29id6vhar50vacj1yfj1vdy68qwk9v6jxj0nz";
      type = "gem";
    };
    version = "1.245.2";
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
  azure-blob = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "198ndg8m0w54csxb3fidzpjp491ak9jcrmjc8zmp7axi0ncvbsmx";
      type = "gem";
    };
    version = "0.5.9.1";
  };
  base58 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gpk3g32c3w976k9kax2y13bm274s710jlqs1nnjkd58pp9wb9gx";
      type = "gem";
    };
    version = "0.2.3";
  };
  base64 = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0clhya4p8lhjj7hp31inp321wgzb0b5wbwppmya5sw1dikl7400z";
      type = "gem";
    };
    version = "3.1.22";
  };
  benchmark = {
    groups = [
      "default"
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
  better_errors = {
    dependencies = [
      "erubi"
      "rack"
      "rouge"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wqazisnn6hn1wsza412xribpw5wzx6b5z5p4mcpfgizr6xg367p";
      type = "gem";
    };
    version = "2.10.1";
  };
  bigdecimal = {
    groups = [
      "default"
      "development"
      "opentelemetry"
      "pam_authentication"
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
  binding_of_caller = {
    dependencies = [ "debug_inspector" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05yma8qd0c53dalkh2b9iddvi7j1wy1kmd77xmx5i1ca8bwfngp5";
      type = "gem";
    };
    version = "2.0.0";
  };
  bloom_fit = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wzxxrypw4lvf3ydyvd7g7x5rvxwllbzvvaryx4s50nhc4cgp7pv";
      type = "gem";
    };
    version = "1.2.0";
  };
  blurhash = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wni86h2mlb7sj51nq3iwsvkrzlaggls9xlf4p9dzr1ns79dphca";
      type = "gem";
    };
    version = "0.1.8";
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
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12j19z6yq4acga7g1qn4ih2bbx8zw5aj6b92f40r3ghiz5gd4f50";
      type = "gem";
    };
    version = "8.1.1";
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
  builder = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  bundler-audit = {
    dependencies = [ "thor" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sdlr4rj7x5nbrl8zkd3dqdg4fc50bnpx37rl0l0szg4f5n7dj41";
      type = "gem";
    };
    version = "0.9.3";
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
  capybara-playwright-driver = {
    dependencies = [
      "addressable"
      "capybara"
      "playwright-ruby-client"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d6vx1z33i1il3csi86jpbgmgdcm5la7p2ghkgjx2qq7nq5y6knj";
      type = "gem";
    };
    version = "0.5.15";
  };
  case_transform = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fzyws6spn5arqf6q604dh9mrj84a36k5hsc8z7jgcpfvhc49bg2";
      type = "gem";
    };
    version = "0.2";
  };
  cbor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kcqbgxqyb9bidf8ygfcw0f75knqli9sm4f9mavmcfcqis6rvc78";
      type = "gem";
    };
    version = "0.6.2.2";
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
  charlock_holmes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c1dws56r7p8y363dhyikg7205z59a3bn4amnv2y488rrq8qm7ml";
      type = "gem";
    };
    version = "0.7.9";
  };
  chewy = {
    dependencies = [
      "activesupport"
      "elasticsearch"
      "elasticsearch-dsl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1clkjg3n7c29c01cykjp6gbnvywjilfanzcrcrazhzf551ssndy6";
      type = "gem";
    };
    version = "8.4.1";
  };
  childprocess = {
    dependencies = [ "logger" ];
    groups = [
      "default"
      "development"
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
  cocoon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "038z97pkhvsqbh6cmyyzj58ya968p24k7r0f0rx7sa2kjvk193yh";
      type = "gem";
    };
    version = "1.2.15";
  };
  color_diff = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "094hvvpr7x7m6qq3yhmnzv7yv5clmmps1fy1rply10j6gcl1wpyf";
      type = "gem";
    };
    version = "0.2";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
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
      "pam_authentication"
      "production"
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
  cose = {
    dependencies = [
      "cbor"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0higp0ncrbjskq5qbxq1wnidc6i8ifrr3nsfn2ad38mm3b1nd39c";
      type = "gem";
    };
    version = "1.4.0";
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
      "pam_authentication"
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
  css_parser = {
    dependencies = [
      "addressable"
      "base64"
      "ssrf_filter"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05bx73hdg72qnvg3iyn01c0jlwn8d44v2inbshnqgysk9rf3bwqd";
      type = "gem";
    };
    version = "3.4.0";
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
  database_cleaner-active_record = {
    dependencies = [
      "activerecord"
      "database_cleaner-core"
    ];
    groups = [ "test" ];
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09v9zfbslyay5d15dv7jyqwhh9f504z8i736idp72sxjv5k551xj";
      type = "gem";
    };
    version = "2.1.0";
  };
  date = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "105m4y6iwannk0vmn43px6rh8mlczp1bispq6hsxksr49rf99b0q";
      type = "gem";
    };
    version = "3.6.0";
  };
  debug = {
    dependencies = [
      "irb"
      "reline"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1djjx5332d1hdh9s782dyr0f9d4fr9rllzdcz2k0f8lz2730l2rf";
      type = "gem";
    };
    version = "1.11.1";
  };
  debug_inspector = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18k8x9viqlkh7dbmjzh8crbjy8w480arpa766cw1dnn3xcpa1pwv";
      type = "gem";
    };
    version = "1.2.0";
  };
  devise = {
    dependencies = [
      "bcrypt"
      "orm_adapter"
      "railties"
      "responders"
      "warden"
    ];
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hacqyck22k7g9qr9n5wwq32vg02hwwjv7kqxrb4xrslb2wg41fn";
      type = "gem";
    };
    version = "5.0.4";
  };
  devise-two-factor = {
    dependencies = [
      "activesupport"
      "devise"
      "railties"
      "rotp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11i06910z2sjjr1r7s1mdd86s77ar6gvn5523mszlbhb3ny0xxw2";
      type = "gem";
    };
    version = "6.4.1";
  };
  devise_pam_authenticatable2 = {
    dependencies = [
      "devise"
      "rpam2"
    ];
    groups = [ "pam_authentication" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13ipl52pkhc6vxp8ca31viwv01237bi2bfk3b1fixq1x46nf87p2";
      type = "gem";
    };
    version = "9.2.0";
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
  discard = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h6j62g1rbwvhq27sabxrv942giwn7dxmcxjm0g9nysdddw21i8g";
      type = "gem";
    };
    version = "2.0.0";
  };
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17i6g4fv30vvspyrj44whsyyqn5kpy86sq0v0isjm2chc76adxhk";
      type = "gem";
    };
    version = "0.7.20261117";
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
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17b1zr9kih0i3wb7h4yq9i8vi6hjfq07857j437a8z7a44qvhxg3";
      type = "gem";
    };
    version = "3.2.0";
  };
  drb = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  elastic-transport = {
    dependencies = [
      "faraday"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0557k3r5hhmg67mvn1rm1jh5clhmqj8cj4ax20v6aan5wzx5fw2k";
      type = "gem";
    };
    version = "8.6.0";
  };
  elasticsearch = {
    dependencies = [
      "elastic-transport"
      "elasticsearch-api"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "167b9m3hqyc4g77kx7a9xbzd566hdnvwwcyfidvk0dx9fd82gq1z";
      type = "gem";
    };
    version = "8.19.3";
  };
  elasticsearch-api = {
    dependencies = [ "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wklwh659c0faknzaqlfihl8ai3b52hwip69m2izk0ncjssjk06w";
      type = "gem";
    };
    version = "8.19.3";
  };
  elasticsearch-dsl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "174m3fwm3mawbkjg2xbmqvljq7ava4s95m8vpg5khcvfj506wxfk";
      type = "gem";
    };
    version = "0.1.10";
  };
  erb = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  erubi = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
      sha256 = "036j7h9xq2q3ym8pq08yvzafd2z5f2hr78m2r8jcn6c4csp5smdv";
      type = "gem";
    };
    version = "1.4.2";
  };
  excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17jpbj0ard190pl7qiha4f1hdjs29radp51a2fflfy22lh94ybyf";
      type = "gem";
    };
    version = "1.12.0";
  };
  fabrication = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qrv8vvhjx9yi64bji6hrp08if14hmwdy08prg9qld3ij2nvz856";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "13r8mjqk8slscc8rxfhfrqglks131sb78ay4dklcafd7xm6ia247";
      type = "gem";
    };
    version = "2.15.1";
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
  faraday-httpclient = {
    dependencies = [ "httpclient" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z6nv0cxxk9rm69x84861f5zn8jck99prmjpg4apxa75rihbwpyr";
      type = "gem";
    };
    version = "2.0.2";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0difl8kbbhz1pirq8prpv42p0rgqfrrz8gfc93h4wx9q9v1r8w1f";
      type = "gem";
    };
    version = "3.5.0";
  };
  fast_blank = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1shpmamyzyhyxmv95r96ja5rylzaw60r19647d0fdm7y2h2c77r6";
      type = "gem";
    };
    version = "1.0.1";
  };
  fastimage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ff5gv6c2j27nnv7fsffp0qb55ia4arcmnpilgysxzavqgimfi1h";
      type = "gem";
    };
    version = "2.4.3";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kqasqvy8d7r09ri4n6bkdwbk63j7afd9ilsw34nzlgh0qp69ldw";
      type = "gem";
    };
    version = "1.17.4";
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
      sha256 = "0hzkg1j4ijs66b9rvbl6z5y5s345wsaydkfdzb356xyqakdldp2i";
      type = "gem";
    };
    version = "1.4.3";
  };
  flatware = {
    dependencies = [
      "benchmark"
      "drb"
      "logger"
      "thor"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0na5w1krrrmd9vkv43v30k43d880hs9yz2zr3qfwxcjk1mq3nqk7";
      type = "gem";
    };
    version = "2.4.0";
  };
  flatware-rspec = {
    dependencies = [
      "flatware"
      "rspec"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f19309xgbc6y008g6bkwjxq7962dspwr31lsznx7pdxp7x98x2w";
      type = "gem";
    };
    version = "2.4.0";
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
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p5piv69633qxzxl1zjgnvv3ppfpd7rmydha65m93iz6a6am5arw";
      type = "gem";
    };
    version = "1.5.0";
  };
  fog-openstack = {
    dependencies = [
      "fog-core"
      "fog-json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0imx2c7yrwnd1jk6xzh5903cazymfvs3iq37dl49jss1a2d2lis6";
      type = "gem";
    };
    version = "1.1.5";
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
  forwardable = {
    groups = [ "default" ];
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
      sha256 = "0zpkfvasg8vl33j41bgbr3ia30hjf870cifz95vbcjx5hp6aj4g3";
      type = "gem";
    };
    version = "1.14.0";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
    ];
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
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1514wvzq5nz62khyyi644vbp3yk580lczk8cmcvasjp11bssz39g";
      type = "gem";
    };
    version = "4.36.2";
  };
  googleapis-common-protos-types = {
    dependencies = [ "google-protobuf" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05cx0251jsfjrnh95as4sxjnsbwd9cl49nb8b9nm0bz5x6c7kb1y";
      type = "gem";
    };
    version = "1.25.0";
  };
  haml = {
    dependencies = [
      "prism"
      "temple"
      "thor"
      "tilt"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hhd6xpwgjj7y00vj6a934vxxcb5gvg1m2rk71dky5sz7i64kvzw";
      type = "gem";
    };
    version = "7.5.2";
  };
  haml-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "haml"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02v1vzzr1929vgx0fg1a9kzzw30mfch6y8fb4r9rsjryjx6lfrj3";
      type = "gem";
    };
    version = "3.1.0";
  };
  haml_lint = {
    dependencies = [
      "haml"
      "parallel"
      "rainbow"
      "rubocop"
      "sysexits"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19j0mp6i4idz1ag5y28bjj5vwlxjvimc98lfv375wd237cy0x178";
      type = "gem";
    };
    version = "0.78.0";
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
      sha256 = "0wid6cb8y13i47hamc1ayk8l722jgnddxhxv3y8y7hlma5ij4yim";
      type = "gem";
    };
    version = "5.2.0";
  };
  hcaptcha = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fh6391zlv2ikvzqj2gymb70k1avk1j9da8bzgw0scsz2wqq98m2";
      type = "gem";
    };
    version = "7.1.0";
  };
  highline = {
    dependencies = [ "reline" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jmvyhjp2v3iq47la7w6psrxbprnbnmzz0hxxski3vzn356x7jv7";
      type = "gem";
    };
    version = "3.1.2";
  };
  hiredis-client = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ma3l0lvjxl76diia5s7ma2jdmbj3y2220a4v77idal72rvf88jd";
      type = "gem";
    };
    version = "0.31.0";
  };
  hkdf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04fixg0a51n4vy0j6c1hvisa2yl33m3jrrpxpb5sq6j511vjriil";
      type = "gem";
    };
    version = "0.3.0";
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
      sha256 = "1aga7z4p0dka4zcqw9i05wa4ab1q7h7cgnj328ldqqfycjz84jxs";
      type = "gem";
    };
    version = "1.1.6";
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
  http_accept_language = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d0nlfz9vm4jr1l6q0chx4rp2hrnrfbx3gadc1dz930lbbaz0hq0";
      type = "gem";
    };
    version = "2.1.1";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12gaajypppvd98nfnkgh5a88agn0kns6sm1jd68z2598za9xpfly";
      type = "gem";
    };
    version = "2.11.0";
  };
  httplog = {
    dependencies = [
      "benchmark"
      "rack"
      "rainbow"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gq7cra0d9h5mc1295h3xknqwany9xbxasgliyq6axr74rmbs51b";
      type = "gem";
    };
    version = "1.8.0";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
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
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01vawb9lymaxq0mps22y5yc77wyamq7rq7cdlb0dpvnfxihh16sh";
      type = "gem";
    };
    version = "1.2.1";
  };
  idn-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dy04jx3n1ddz744b80mg7hp87miysnjp0h21lqr43hpmhdglxih";
      type = "gem";
    };
    version = "0.1.5";
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
  io-console = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m8lcj26n7qchw21iaafk96mzsqj8b6kjnr455k430269jzrppc3";
      type = "gem";
    };
    version = "0.9.5";
  };
  ipaddr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cryhxm6297bgczlzsgpr3h9ag9966w7nqq1hk8i9k7knw8r4vkv";
      type = "gem";
    };
    version = "1.3.1";
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
      "pam_authentication"
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
  jd-paperclip-azure = {
    dependencies = [
      "addressable"
      "azure-blob"
      "hashie"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gcikrlqv6r9pqvw2kfyvmia3rikp9irhq1c10njz4z7i5za4xk9";
      type = "gem";
    };
    version = "3.0.0";
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
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
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
      sha256 = "1jgivknk82sbcsqxpr96c9iqmp2wkhqpf38w9bby3s927qf7rqwp";
      type = "gem";
    };
    version = "1.17.2";
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
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wxxilfijidxfsv51smfbbif3cgf1fardc4z2pyqnd3jsw9n3gy0";
      type = "gem";
    };
    version = "6.2.1";
  };
  jsonapi-renderer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ys4drd0k9rw5ixf8n8fx8v0pjh792w4myh0cpdspd317l1lpi5m";
      type = "gem";
    };
    version = "0.2.2";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "115ll278g3zdvff7b05gfxqc9n74vw9xfzcc8jkv22bkphpkbng4";
      type = "gem";
    };
    version = "2.10.3";
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
      sha256 = "1pnhvy94f3f05g2pyrqw7cc4k10876rmnhriwqv52rfsnkmrxrcj";
      type = "gem";
    };
    version = "1.3.3";
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
      sha256 = "0q09a24gvi3pn05whhgl1clgamj2qs04a162ksc4jw8dja6r78y4";
      type = "gem";
    };
    version = "1.3.3";
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
      sha256 = "0hrh2vrara8k2dbda3b0vwh66hv2xy3c7yjs3n09rx0l016ip1sd";
      type = "gem";
    };
    version = "1.3.3";
  };
  kaminari-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x4mdk1k02sn3rngv3lkjza4dhspv6j5d5q1m5h2m1s17zhwn81i";
      type = "gem";
    };
    version = "1.3.3";
  };
  kt-paperclip = {
    dependencies = [
      "activemodel"
      "activesupport"
      "marcel"
      "mime-types"
      "terrapin"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vnammvg7i42az2zhqhvixhrhhda2yalb8pb01dwz9znax9kl1l3";
      type = "gem";
    };
    version = "8.0.1";
  };
  language_server-protocol = {
    groups = [
      "default"
      "development"
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
  logger = {
    groups = [
      "default"
      "development"
      "opentelemetry"
      "pam_authentication"
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
      "logger"
      "railties"
      "request_store"
    ];
    groups = [ "production" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14bas220zv5913lf8ginnv2z897rl8jp3wrw4ijsfmm3a8iyvm9j";
      type = "gem";
    };
    version = "0.16.0";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
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
    ];
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
  mario-redis-lock = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v9wdjcjqzpns2migxp4a5b4w82mipi0fwihbqz3q2qj2qm7wc17";
      type = "gem";
    };
    version = "1.2.1";
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
  memory_profiler = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y58ba08n4lx123c0hjcc752fc4x802mjy39qj1hq50ak3vpv8br";
      type = "gem";
    };
    version = "1.1.0";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r6w8jg4zdy84wd6qg8yhr61xlvf1s0fmb00w0rzvwcmv2aaz9yd";
      type = "gem";
    };
    version = "3.2026.1103";
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
      "pam_authentication"
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
      "pam_authentication"
      "production"
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
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ngnmjc7vc4k06dyapgid2gxc4si6yr092sidfps6r3v49ibnc7b";
      type = "gem";
    };
    version = "0.6.8";
  };
  net-ldap = {
    dependencies = [
      "base64"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ximwa5p19s0v9n96b9aclp18k07hwnmv9bdnzfav0g1f4r9xcyb";
      type = "gem";
    };
    version = "0.21.0";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [
      "default"
      "development"
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
    ];
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
    groups = [
      "default"
      "development"
    ];
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
      "pam_authentication"
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
  omniauth-cas = {
    dependencies = [
      "addressable"
      "nokogiri"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03b034imgj5jwflc4db7hsp0n5ivqyqkmsfhc5drlidrcdfv2f0q";
      type = "gem";
    };
    version = "3.0.2";
  };
  omniauth-rails_csrf_protection = {
    dependencies = [
      "actionpack"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bf3m2ds78scmgacb1wx38zjj1czzkym0bdmgi9vn99rgr6j1qy6";
      type = "gem";
    };
    version = "2.0.1";
  };
  omniauth-saml = {
    dependencies = [
      "omniauth"
      "ruby-saml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ndbsyhdalpijj8bri3imkrrr06y07c0m7hnzl6iywadarjd8ajm";
      type = "gem";
    };
    version = "2.2.5";
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
      sha256 = "1i1rksidmf0aj0z6y89mhyp3fadf4xgpx0znwfc7g470vj7gz6k5";
      type = "gem";
    };
    version = "2.5.0";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hj7wwp4r3jhvnyd8ik85wbs25cq1w61r28pv6ddyn5fd0lasdqh";
      type = "gem";
    };
    version = "4.0.2";
  };
  openssl-signature_algorithm = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
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
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xqzls5y2fn2d5080gjmw01y8n1wz5879pfmbvyv6h32xa3rjzyh";
      type = "gem";
    };
    version = "1.11.1";
  };
  opentelemetry-common = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07ci5alrvhq0fbn2s0zw9xbffkxl103qgszfizz5d4vqhx4x8df0";
      type = "gem";
    };
    version = "0.25.2";
  };
  opentelemetry-exporter-otlp = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-exporter-otlp-common"
      "opentelemetry-sdk"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dk1ly510q0jy3iz0vfy4icvnhs0sismywxc4zaz9rfwaykbvj7d";
      type = "gem";
    };
    version = "0.37.0";
  };
  opentelemetry-exporter-otlp-common = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
      "opentelemetry-api"
      "opentelemetry-common"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n2wch7wm0vrm0r17s89iq7nvmnnrmsxinq7n5hbjrw2n4sywbm5";
      type = "gem";
    };
    version = "0.4.0";
  };
  opentelemetry-helpers-sql = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yqa891zajjpaph2a25s4n5ycnfwxzjb7fsiz65aja6a5hx8q3mi";
      type = "gem";
    };
    version = "0.4.0";
  };
  opentelemetry-helpers-sql-processor = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09gqdkxl2hpfrchf2zr6y4rwrclxvg8rmbxp6fplkd99ck2m9860";
      type = "gem";
    };
    version = "0.5.1";
  };
  opentelemetry-instrumentation-action_mailer = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "029bhz8gqf89bwsm29zw3m7cw97dy8f1hf9k9r5jh3yy875889rg";
      type = "gem";
    };
    version = "0.8.1";
  };
  opentelemetry-instrumentation-action_pack = {
    dependencies = [ "opentelemetry-instrumentation-rack" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bawr2npzmp5dwdhxyqc2fh1gnrc9bxbvwinir2m2ada7dq7v0hb";
      type = "gem";
    };
    version = "0.18.1";
  };
  opentelemetry-instrumentation-action_view = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s0mgwqmch5d1cww3qsrily38gfciqijsj6l4z2p4f8ls485d1av";
      type = "gem";
    };
    version = "0.13.0";
  };
  opentelemetry-instrumentation-active_job = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qnd4lsplnb8wg32zf5js2dq411sjr31xgk8cb5dmaxv4ilibnj2";
      type = "gem";
    };
    version = "0.13.0";
  };
  opentelemetry-instrumentation-active_model_serializers = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mvag13gjqg38grmg6a7slr7n3pxx8v2di8zbx1gy6kq717h1fwq";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-active_record = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16d2ngy10qd3bsdpgh6sb0ha7gl830xwcyyqkpfq4bm4wnmcx7r3";
      type = "gem";
    };
    version = "0.13.0";
  };
  opentelemetry-instrumentation-active_storage = {
    dependencies = [ "opentelemetry-instrumentation-active_support" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nwvsvid7ma31l85nn75wg3a3rplwbklrnrgql0bzdjd321apjvs";
      type = "gem";
    };
    version = "0.5.1";
  };
  opentelemetry-instrumentation-active_support = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ga1hzx31pm35ixgirmfvykn8qds2j7nzrdyjm7n3aq25axw63f9";
      type = "gem";
    };
    version = "0.12.1";
  };
  opentelemetry-instrumentation-base = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-logs-api"
      "opentelemetry-metrics-api"
      "opentelemetry-registry"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dbp7nnj7fcn9877z8rgifvbf1fb6vx63gj6wy18w08brn1dnpp5";
      type = "gem";
    };
    version = "0.27.0";
  };
  opentelemetry-instrumentation-concurrent_ruby = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bbvpwn70d12fsdc31w1qnc7ah82aw4bdl159al2ac4f0zki4abj";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-excon = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1inkzvkn57yf4xvl0iiyh2p1sg6drfknxq5qnlfyh168yr91r7vs";
      type = "gem";
    };
    version = "0.29.1";
  };
  opentelemetry-instrumentation-faraday = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00gqhgbya6hcl7h9rklg0h69mf4r4ksyl8555g7bi5srwgn0ncpl";
      type = "gem";
    };
    version = "0.33.0";
  };
  opentelemetry-instrumentation-http = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j2m21smk0wfcjwi64ls2mas520qwcgxkq4rbsr8dlw1mfg67lin";
      type = "gem";
    };
    version = "0.30.0";
  };
  opentelemetry-instrumentation-http_client = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0czw0x62yyg2w7cv94dfqhcdvh03aznv75vbnc5kj31ni92vg75d";
      type = "gem";
    };
    version = "0.29.1";
  };
  opentelemetry-instrumentation-net_http = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gm06czad43sysmlk4pk15x4dqqk27xz4f7164qa06zaz2gbwbml";
      type = "gem";
    };
    version = "0.30.0";
  };
  opentelemetry-instrumentation-pg = {
    dependencies = [
      "opentelemetry-helpers-sql"
      "opentelemetry-helpers-sql-processor"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fl0d7lrgpf1whzrb4sq2k689dhdqks18ri19l7agkxy5klrydr0";
      type = "gem";
    };
    version = "0.37.1";
  };
  opentelemetry-instrumentation-rack = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lik2fv4b1cgg2ysag45fbdgfyslmwaa1b2bhca6gh11iz39mgw3";
      type = "gem";
    };
    version = "0.32.0";
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
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1czqxavga9djkaw60i56ivljh75d3d3kgwzcljgywwyaff1q18sy";
      type = "gem";
    };
    version = "0.42.0";
  };
  opentelemetry-instrumentation-redis = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v25jpq6s68qb5r7i5alr6jma57kx9and13yz6ggfwkzzwqmv1az";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-instrumentation-sidekiq = {
    dependencies = [ "opentelemetry-instrumentation-base" ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p5av36xg4imnq54cn971s3pzl1xkvcr8z7y751f39a1j35s1lmi";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-logs-api = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pdyzscij8nc8icml7fc5kv45gx7dmvw6kp4srlg02w3dgiq1sjk";
      type = "gem";
    };
    version = "0.7.0";
  };
  opentelemetry-metrics-api = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mf76qwfaaz1xq8dcc46639vh7n5dawxwkiyif8plvc80rvbmvmv";
      type = "gem";
    };
    version = "0.10.0";
  };
  opentelemetry-registry = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0266zhvzvrpy7imyvgn8svv3n35ik8rz1qzwyhllyfclxbmai3sn";
      type = "gem";
    };
    version = "0.6.3";
  };
  opentelemetry-sdk = {
    dependencies = [
      "logger"
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-registry"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m37xhf6mf8s92pckydx0aykj3fd4y5zzvj96lj31vy7b8qwrjci";
      type = "gem";
    };
    version = "1.13.1";
  };
  opentelemetry-semantic_conventions = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04w52rj08nj62c2prdfdggrlf7sibydz59pp10fb04rg8a9qg6xh";
      type = "gem";
    };
    version = "1.44.0";
  };
  orm_adapter = {
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fg9jpjlzf5y49qs9mlpdrgs5rpcyihq1s4k79nv9js0spjhnpda";
      type = "gem";
    };
    version = "0.5.0";
  };
  ostruct = {
    groups = [
      "default"
      "development"
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
  ox = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hidw64fs9l4j59kifnaxsinrbapq4mh4wng2359vpnsm3akcrr0";
      type = "gem";
    };
    version = "2.14.29";
  };
  parallel = {
    groups = [
      "default"
      "development"
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
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13z5jwb190xmvxq9kmdz82mi306bkl78h4fqw9g446dryxmggy32";
      type = "gem";
    };
    version = "3.3.14.0";
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
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yval9rdbc0p01dmf8zwm953w1hk0ggdp1pgr7a87s442983ddgp";
      type = "gem";
    };
    version = "1.7.0";
  };
  pghero = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pn3vb9c51li1mrf5vs88c2lx1k7wbm1v2k44wf1f9d8mwaha078";
      type = "gem";
    };
    version = "4.1.0";
  };
  playwright-ruby-client = {
    dependencies = [
      "base64"
      "concurrent-ruby"
      "mime-types"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cv8r3pmmm6ph2ga2qavk7zmr4yzihj2mzls9zgk0qw1jw3zkzyr";
      type = "gem";
    };
    version = "1.65.1";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  premailer = {
    dependencies = [
      "addressable"
      "css_parser"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ahda46gszk3wywlv9hfa9kcf7bfv4jhypz03kyrfbj8zhh6630s";
      type = "gem";
    };
    version = "1.33.0";
  };
  premailer-rails = {
    dependencies = [
      "actionmailer"
      "net-smtp"
      "premailer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0004f73kgrglida336fqkgx906m6n05nnfc17mypzg5rc78iaf61";
      type = "gem";
    };
    version = "1.12.0";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  prism = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wq1fqa52h90hynqcbwf35iydnv4fl03y4pvj0rii4qfx9npq2hw";
      type = "gem";
    };
    version = "2.1.0";
  };
  prometheus_exporter = {
    dependencies = [ "webrick" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "013azj8pmmn6fsj1grnq0960pzb5zbpzmv1f2mdm2frsdjjaf0f5";
      type = "gem";
    };
    version = "2.3.1";
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
      sha256 = "17iqn4sa59c9z5y3bpvxqka00srqnl379w6a57y1phljdbjs6mhx";
      type = "gem";
    };
    version = "1.3.2";
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
      sha256 = "02j4fyc9qljz0db8s5j1117xlnqa5r6n705m7bgq972gr1xqm69z";
      type = "gem";
    };
    version = "1.5.0";
  };
  racc = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
      "pam_authentication"
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
      sha256 = "0cn6a9v8nry9fx4zrzp1xakfp2n5xv5075j90q56m20k7zvjrq23";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "0i1cph3n7nr6wlkj63l38xdm1hxk9wlcnxwjjf7klif2q174dxw7";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-session = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
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
      "pam_authentication"
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
      "pam_authentication"
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
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
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
      "pam_authentication"
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
      "pam_authentication"
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
      "opentelemetry"
      "pam_authentication"
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
  rbs = {
    dependencies = [
      "logger"
      "prism"
      "tsort"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  rdf-normalize = {
    dependencies = [ "rdf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1glyhg7lmzbq1w7bvvf84g7kvqxcn0mw3gsh1f8w4qfvvnbl8dwj";
      type = "gem";
    };
    version = "0.7.0";
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
      "pam_authentication"
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hdj51dbcr186kh5jcs42dw17xddz4akaiwqrmlhdb0bjn2hnqdd";
      type = "gem";
    };
    version = "6.1.0";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xgxcc17p8h96ns37y4gvjwf4pb5bv90zxa16615lyg644mcn838";
      type = "gem";
    };
    version = "0.31.0";
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
      sha256 = "0fwarpnqm6b0vy4yx3mhrx12zi0v435d0ywm8q4z1rjp9y0lf18x";
      type = "gem";
    };
    version = "2.13.4";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gaq2lc463ap1srz7y5kh2p4dxazs7vjrpiby58d9yfvan72s0av";
      type = "gem";
    };
    version = "0.7.0";
  };
  request_store = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "production"
    ];
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
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "117sixdsf6w6a239bypmjs7cv0hyhmd2x19dfw74qrfsrdq2jxy2";
      type = "gem";
    };
    version = "3.2.1";
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
  rotp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wj9xm15l6ycl07jgjjp9wn41w1b8crn4kiq1x1rnwm5zl6qxpp2";
      type = "gem";
    };
    version = "6.4.0";
  };
  rouge = {
    dependencies = [ "strscan" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ljlr1da64kx3mimpzb4x2yczk08b0sg04h2ji3m2zxb88l66z5p";
      type = "gem";
    };
    version = "5.1.0";
  };
  rpam2 = {
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zvli3s4z1hf2l7gyfickm5i3afjrnycc3ihbiax6ji6arpbyf33";
      type = "gem";
    };
    version = "4.0.2";
  };
  rqrcode = {
    dependencies = [
      "chunky_png"
      "rqrcode_core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hlm1cfqs891irh4pl6wynsfm7nh7w7baf0g6cqxfrxvlr64khb4";
      type = "gem";
    };
    version = "3.2.0";
  };
  rqrcode_core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l9hl5nb7jx8sjchsrlv6bk30hywr449ihcdxv2qy6wwz1fvh0zk";
      type = "gem";
    };
    version = "2.1.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [
      "default"
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
  rspec-github = {
    dependencies = [ "rspec-core" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bv8b6ld7w3rccjnxqypfdg35i91wyv551sr41647r6krbc3rbs6";
      type = "gem";
    };
    version = "3.0.0";
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
  rspec-sidekiq = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "sidekiq"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1imkvngglyd3vs2k526fffb5g22a08bwgjhdd1nq1jb7hym0b554";
      type = "gem";
    };
    version = "5.3.0";
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
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xigcyc13kn6lc0gs59m2zw5p7y508bqm1jgacx1rsg88sngwxzx";
      type = "gem";
    };
    version = "1.92.3";
  };
  rubocop-ast = {
    dependencies = [
      "ast"
      "parser"
      "prism"
      "racc"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x6mrbfs8x8qz1abnpczb4wgam0g110r6by7whm51ml5hk988y82";
      type = "gem";
    };
    version = "1.53.0";
  };
  rubocop-capybara = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15jhizhr01p1598av8439xy1a7bvbwwgmgzp8fv750hp0h5r04hp";
      type = "gem";
    };
    version = "3.1.0";
  };
  rubocop-i18n = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [ "development" ];
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
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kk1dla4c2bn4ks6b18zrf2b3i0c1gmp0yvq3kp6i8v2s1s17szf";
      type = "gem";
    };
    version = "1.27.0";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "lint_roller"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01igzbkf7w1ixrqbrn7amii5c0jviw5w5gki0c2y75gs5r9pqavf";
      type = "gem";
    };
    version = "2.38.0";
  };
  rubocop-rspec = {
    dependencies = [
      "lint_roller"
      "regexp_parser"
      "rubocop"
    ];
    groups = [ "development" ];
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
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12anaszqq9y5y8b4cq4za7izvgdqnmjsqlzqr9n6vjjzk9x0m7k6";
      type = "gem";
    };
    version = "2.33.0";
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
      sha256 = "03kcdnip5zv7m529xc05pk6vsz6prfq5s5036g1qllw9408vbhyv";
      type = "gem";
    };
    version = "2.0.5";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-saml = {
    dependencies = [
      "nokogiri"
      "rexml"
    ];
    groups = [ "default" ];
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
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08g1sfv1s8vs9yaz27vjpmgihcycx9nm3wq6j29plabmvaa95hb5";
      type = "gem";
    };
    version = "3.7.0";
  };
  rufus-scheduler = {
    dependencies = [ "fugit" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f932ffh6v6gqpilm61rp9fcx6qcpax1fkw0ikrxfsgzn16rxyjm";
      type = "gem";
    };
    version = "3.9.2";
  };
  safety_net_attestation = {
    dependencies = [ "jwt" ];
    groups = [ "default" ];
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
      sha256 = "15vvlwryigvzndh24r8ac2yr837pw1gfz2nd9kd45vk97z54mhc4";
      type = "gem";
    };
    version = "7.0.2";
  };
  scenic = {
    dependencies = [
      "activerecord"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nb3an8af7f08jnhhbn8bxvgfxqb43qc9d5hgrz16ams96h3mv3f";
      type = "gem";
    };
    version = "1.9.0";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1202qsi1xsskl4qa9fwlzwhs3j783445w20v24js57avfvjldfsx";
      type = "gem";
    };
    version = "8.0.1";
  };
  sidekiq = {
    dependencies = [
      "connection_pool"
      "json"
      "logger"
      "rack"
      "redis-client"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "059lvv3qdmgq76shrv9zp54q0xa8g7178nqxpx31hbn3wv3libci";
      type = "gem";
    };
    version = "8.1.7";
  };
  sidekiq-bulk = {
    dependencies = [ "sidekiq" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08nyxzmgf742irafy3l4fj09d4s5pyvsh0dzlh8y4hl51rgkh4xv";
      type = "gem";
    };
    version = "0.2.0";
  };
  sidekiq-scheduler = {
    dependencies = [
      "rufus-scheduler"
      "sidekiq"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z6nl9aazi904qmc4vasxkb4w44c6cs1ygfjw6fq8l77i6lz2r8h";
      type = "gem";
    };
    version = "6.0.2";
  };
  sidekiq-unique-jobs = {
    dependencies = [
      "concurrent-ruby"
      "sidekiq"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dfwcz1v2a0xn41xm1glwb56ll3vd02zj39m8ajrg0a0mihslzka";
      type = "gem";
    };
    version = "8.1.0";
  };
  simple-navigation = {
    dependencies = [
      "activesupport"
      "json"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10mc6f4i3vnmvn7f82r7rkc7pxrjijnfglwazyjf71g2ih5vwcam";
      type = "gem";
    };
    version = "4.5.0";
  };
  simple_form = {
    dependencies = [
      "actionpack"
      "activemodel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0208na2s7q1hny77v78b6h677vrhy2v72cjw0d2mazjc0clx5hsq";
      type = "gem";
    };
    version = "5.4.1";
  };
  simplecov = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "118fdpg7h1ny1fz6kmiyz6gccvwmb23h6bhsi1hdpf7ib4byq8ia";
      type = "gem";
    };
    version = "1.3.2";
  };
  simplecov-lcov = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ka6cdwywd6a6pqjwggm0439437xdq2r7514n3a5wn8a40ga6xvs";
      type = "gem";
    };
    version = "0.9.0";
  };
  simpleidn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00sdym5q3d9zg7lv47mjamzv67z1lfyd3gz9256v0g9gxl5p7jhj";
      type = "gem";
    };
    version = "0.3.0";
  };
  ssrf_filter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16grvk48dxx5wljmzfcnpmb6a3mrrg0sj4kgyhqwk183dp15plbq";
      type = "gem";
    };
    version = "1.6.0";
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
  stoplight = {
    dependencies = [
      "concurrent-ruby"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01dmdksjn8qainn193786i69q6z2pl0hdxx4hsxks411s9jggw1h";
      type = "gem";
    };
    version = "6.0.1";
  };
  strong_migrations = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fa4hxwi075xxcfb93lfc6wja67nlrbqs2bn1sf3w3z6c20hz76b";
      type = "gem";
    };
    version = "2.8.0";
  };
  strscan = {
    groups = [
      "default"
      "development"
    ];
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
  sysexits = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qjng6pllznmprzx8vb0zg0c86hdrkyjs615q41s9fjpmv2430jr";
      type = "gem";
    };
    version = "1.2.0";
  };
  temple = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h6rgsjzgpzybsq5jlwwnay19xid4g19ja13rrs4clxnmmhfb7rn";
      type = "gem";
    };
    version = "0.10.7";
  };
  terminal-table = {
    dependencies = [ "unicode-display_width" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lh18gwpksk25sbcjgh94vmfw2rz0lrq61n7lwp1n9gq0cr7j17m";
      type = "gem";
    };
    version = "4.0.0";
  };
  terrapin = {
    dependencies = [ "climate_control" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aakswgqk6cfamq3h6fxdls81ia7v3fi1v825i5pdrgzbh293blw";
      type = "gem";
    };
    version = "1.1.1";
  };
  test-prof = {
    dependencies = [ "logger" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07gv4p6czd3n4nmjy9aqdyyl3vqdba98nxs13kk0rqgxcamhrpcm";
      type = "gem";
    };
    version = "1.6.4";
  };
  thor = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  tilt = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19d3k8ym9bj9j98zmc0pbjnwqdg4mqabnh8hm7lrdfhb5383amys";
      type = "gem";
    };
    version = "2.9.0";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g79w3f7kpfl8nxmlbb6m0vx033x6pybpkx9czz2x0j3yqwl569w";
      type = "gem";
    };
    version = "0.14.2";
  };
  tsort = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
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
      sha256 = "0w4n63aya77a10hxl17my6qjxjr1n3756a2g8vbk0rzjl3as7zgy";
      type = "gem";
    };
    version = "1.2026.6";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [
      "default"
      "development"
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
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kp89lja8ii7l6f0bq5vdxq1p3kxr3a2qmmhdc38qdwh6akjzh0i";
      type = "gem";
    };
    version = "4.3.0";
  };
  uri = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
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
  useragent = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
  uts58 = {
    dependencies = [
      "public_suffix"
      "simpleidn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m3q9p2fdndrldvhhnaps5hspq1732gi15d2jskw4xvrig6fcil5";
      type = "gem";
    };
    version = "0.2.6";
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
  warden = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l7gl7vms023w4clg02pm4ky9j12la2vzsixi2xrv9imbn44ys26";
      type = "gem";
    };
    version = "1.2.9";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02yyhbyzq31vqszc5swaspppgfz1izvyy7n7axyaxn9xq0d3k1cq";
      type = "gem";
    };
    version = "3.5.1";
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
      sha256 = "144pbagz5wfm20m1cgjqydfj0364fxq3w6hz8p21v48f4affk23d";
      type = "gem";
    };
    version = "3.40.0";
  };
  webpush = {
    dependencies = [
      "hkdf"
      "jwt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "9631ac63045cfabddacc69fc06e919b4c13eb913";
      sha256 = "01vqsj9162j0rzp455sggr8k4w4i9zq0igqb7x7hghp3c53ck1v6";
      type = "git";
      url = "https://github.com/mastodon/webpush.git";
    };
    version = "1.1.0";
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
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17xyml6kg0595nx6a2pa49cls7hkraxlrdazmwfpgdm11sncdz2d";
      type = "gem";
    };
    version = "0.9.0";
  };
  websocket-extensions = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12g5j493rhr7rr050l9jybmsimnz6vdnikm5my7dr2mahzvd1c3g";
      type = "gem";
    };
    version = "0.2.0";
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
  xorcist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dbbiy8xlcfvn9ais37xfb5rci4liwakkmxzbkp72wmvlgcrf339";
      type = "gem";
    };
    version = "1.1.3";
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
  zeitwerk = {
    groups = [
      "default"
      "development"
      "pam_authentication"
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
}
