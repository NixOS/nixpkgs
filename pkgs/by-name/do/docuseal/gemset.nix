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
      sha256 = "18nn95z23m7cpfsypfnlvpblj9rbnkddbs396nljiflznc6v473g";
      type = "gem";
    };
    version = "8.0.2.1";
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
      sha256 = "1bbc1a2m8zp0ci2js8wz00fgyamkflkjimn1dz0632a43viwda4f";
      type = "gem";
    };
    version = "8.0.2.1";
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
      sha256 = "176vgl9rhy9xqi5i1qdgw4ny8sr6jw32zjsq109sn7jl0j6lvq8d";
      type = "gem";
    };
    version = "8.0.2.1";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02ibk3ldqs1xk74b8lycqh1g6bm4vj5ph8bjlln1brfv64df3rv1";
      type = "gem";
    };
    version = "8.0.2.1";
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
      sha256 = "1f6n43v5r9d0nq09g66rfkqfmx6pv89v01bvd731bndrrysv7i0c";
      type = "gem";
    };
    version = "8.0.2.1";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0izkrdg7r7432mw99d7cwhsr5s9whl3aqh5946i88yqbrc6d59if";
      type = "gem";
    };
    version = "8.0.2.1";
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
      sha256 = "129bldx70vahaargg0spx5sdqw378591gbrq7b0zm3pc0zdg5rfn";
      type = "gem";
    };
    version = "8.0.2.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1i3y0ynf16cgc9p28603pxva528a91jgh8nz2d0q8cb5p36vdfhp";
      type = "gem";
    };
    version = "8.0.2.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wbdijshd3dqgzwhdpb32ig6rz8my5zkmanj32fqiwskvmxnwmd6";
      type = "gem";
    };
    version = "8.0.2.1";
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
      sha256 = "1y3nmzzr17fzxxi9vwi1lc3vc58x1j0i6s56wq0y4wal26g3vfs3";
      type = "gem";
    };
    version = "8.0.2.1";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ik1sm5sizrsnr3di0klh7rvsy9r9mmd805fv5srk66as5psf184";
      type = "gem";
    };
    version = "8.0.2.1";
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
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  annotaterb = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x89s0w2mh5vqk9r4fxwlak7a31pp6nb4z409isijsj18f2g4v26";
      type = "gem";
    };
    version = "4.14.0";
  };
  arabic-letter-connector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0myhflz0cqn4wz780ar8zdz834n1byvmdvkzp0sfh9yvyy98ngj0";
      type = "gem";
    };
    version = "0.1.1";
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
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gvdg4yx4p9av2glmp7vsxhs0n8fj1ga9kq2xdb8f95j7b04qhzi";
      type = "gem";
    };
    version = "1.3.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vyh7a709hj0qmb3yv95s0b57g1pgmsngv8pxxby7w6fi9grpmr1";
      type = "gem";
    };
    version = "1.1027.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12s8v199kb3vixl2896axfj4ifkglr0q7zyn73pdkdf3kpra1wi4";
      type = "gem";
    };
    version = "3.214.0";
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
      sha256 = "0xd3ddd9jiapkgv8im4pl9dcdy2ps7qjsssf2nz3q6sd1ca8x0di";
      type = "gem";
    };
    version = "1.96.0";
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
      sha256 = "1smmyhzfkxcin52arlsxi4rcysirvjmshb4zqlb7bgbxainig034";
      type = "gem";
    };
    version = "1.176.1";
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
      sha256 = "17vj7dnbk2dr5486rhva8x14m84kca716r9n7yczkp91cxbah0v9";
      type = "gem";
    };
    version = "1.110.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fq3lbvkgm1vk5wa8l7vdnq3vjnlmsnyf4bbd0jq3qadyd9hf54a";
      type = "gem";
    };
    version = "1.10.1";
  };
  azure-storage-blob = {
    dependencies = [
      "azure-storage-common"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qq3knsy7nj7a0r8m19spg2bgzns9b3j5vjbs9mpg49whhc63dv1";
      type = "gem";
    };
    version = "2.0.3";
  };
  azure-storage-common = {
    dependencies = [
      "faraday"
      "faraday_middleware"
      "net-http-persistent"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0swmsvvpmy8cdcl305p3dl2pi7m3dqjd7zywfcxmhsz0n2m4v3v0";
      type = "gem";
    };
    version = "2.0.4";
  };
  base64 = {
    groups = [
      "default"
      "development"
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
      sha256 = "16a0g2q40biv93i1hch3gw8rbmhp77qnnifj1k0a6m7dng3zh444";
      type = "gem";
    };
    version = "3.1.20";
  };
  benchmark = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kicilpma5l0lwayqjb5577bm0hbjndj2gh150xz09xsgc1l1vyl";
      type = "gem";
    };
    version = "0.4.1";
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
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mdgwlc02f43svy92p0k5v1hipibpzxcdjm774lkz2j8s58kav04";
      type = "gem";
    };
    version = "2.1.1";
  };
  bigdecimal = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p2szbr4jdvmwaaj2kxlbv1rp0m6ycbgfyp0kjkkkswmniv5y21r";
      type = "gem";
    };
    version = "3.2.2";
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
      sha256 = "0mdgj9yw1hmx3xh2qxyjc31y8igmxzd9h0c245ay2zkz76pl4k5c";
      type = "gem";
    };
    version = "1.18.4";
  };
  brakeman = {
    dependencies = [ "racc" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xw57fqs89g02mg482x17agc3b606aim72jlc6d525qgqyq2408s";
      type = "gem";
    };
    version = "7.0.0";
  };
  builder = {
    groups = [
      "default"
      "development"
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
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kfyg2j6a4sg94sajnmy0scv9dxjh7jka9dlil1fzpx137g2zw3p";
      type = "gem";
    };
    version = "8.0.0";
  };
  camertron-eprun = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jyfz769dqpipy0wi72la16c8brh5793akvaixj64pj42rwk73ls";
      type = "gem";
    };
    version = "1.1.1";
  };
  cancancan = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qkbqmj8hnljyl108mw7rl44c99xmrhpyaj5m54dzmaqpxf1sp4p";
      type = "gem";
    };
    version = "3.6.1";
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
  cldr-plurals-runtime-rb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1afzavyzb7rw15s75vzfg6lj8nw2fglr2266970gmscvz1d8flr3";
      type = "gem";
    };
    version = "1.1.0";
  };
  cmdparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f87jny4zk21iyrkyyw4kpnq8ymrwjay02ipagwapimy237cmigp";
      type = "gem";
    };
    version = "3.0.7";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ipbrgvf0pp6zxdk5ascp6i29aybz2bx9wdrlchjmpx6mhvkwfw1";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nrhsk7b3sjqbyl1cah6ibf1kvi3v93a7wf4637d355hp614mmyg";
      type = "gem";
    };
    version = "2.5.3";
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
      sha256 = "0jaa7is4fw1cxigm8vlyhg05bw4nqy4f91zjqxk7pp4c8bdyyfn8";
      type = "gem";
    };
    version = "1.0.0";
  };
  crass = {
    groups = [
      "default"
      "development"
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
      sha256 = "0625073hwx41c246v9dvkp0rk0xgh9d0sc0gm73dbmlxnjwgalv7";
      type = "gem";
    };
    version = "1.21.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kmx36jjh2sahd989vcvw74lrlv07dqc3rnxchc5sj2ywqsw3w3g";
      type = "gem";
    };
    version = "3.3.2";
  };
  csv-safe = {
    dependencies = [ "csv" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gx7j6976k0hl8nrgy8zw2yw149180djikd5jy0zb2im73649ay2";
      type = "gem";
    };
    version = "3.3.1";
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
      sha256 = "0nd2xdbvp7yax7nfsin76wvr27q2gxgbrs5sl3glbcq8wjr2afhb";
      type = "gem";
    };
    version = "0.15.1";
  };
  date = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kz6mc4b9m49iaans6cbx031j9y7ldghpi5fzsdh0n3ixwa8w9mz";
      type = "gem";
    };
    version = "3.4.1";
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
      sha256 = "1977s95s9ns6mpbhg68pg6ggnpxxf8wly4244ihrx5vm92kqrqhi";
      type = "gem";
    };
    version = "1.10.0";
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
      sha256 = "1y57fpcvy1kjd4nb7zk7mvzq62wqcpfynrgblj558k3hbvz4404j";
      type = "gem";
    };
    version = "4.9.4";
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
      sha256 = "041c6zrwm3za1scr07kdgmnlxj7lnrr1jcb832grkavf1sh9wf4h";
      type = "gem";
    };
    version = "6.1.0";
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
      sha256 = "1znxccz83m4xgpd239nyqxlifdb7m8rlfayk6s259186nkgj6ci7";
      type = "gem";
    };
    version = "1.5.1";
  };
  digest-crc = {
    dependencies = [ "rake" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09114ndpnnyamc2q07bmpzw7kp3rbbfv7plmxcbzzi9d6prmd92w";
      type = "gem";
    };
    version = "0.6.5";
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
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wrw6fm0s38cd6h55w79bkvjhcj2zfkargjpws4kilkmhr3xyw66";
      type = "gem";
    };
    version = "3.1.7";
  };
  drb = {
    groups = [
      "default"
      "development"
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
  email_typo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xwz5dyj4dd4v5rqlk37dkwlkiwnypy7gm4rialmqmmzbmxld5i0";
      type = "gem";
    };
    version = "0.2.3";
  };
  erb = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03vcq8g8rxdq8njp9j9k9fxwjw19q4m08c7lxjs0yc6l8f0ja3yk";
      type = "gem";
    };
    version = "5.0.2";
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
      sha256 = "1vn2ssgid25fknmcla3k3gxym4l5ymn7hvggs33q11frc9zp53ki";
      type = "gem";
    };
    version = "0.7.0";
  };
  erubi = {
    groups = [
      "default"
      "development"
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
  factory_bot = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q927lvgjqj0xaplxhicj5xv8xadx3957mank3p7g01vb6iv6x33";
      type = "gem";
    };
    version = "6.5.0";
  };
  factory_bot_rails = {
    dependencies = [
      "factory_bot"
      "railties"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "122wkrc3d2q1dlca27794hh3arw0kvrf3rgmvn7hj3y5lb51g7hk";
      type = "gem";
    };
    version = "6.4.4";
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
      sha256 = "1z4vhl6lbd0la2j0ab05sz8wq5mqvpikzhjrc142z24x4zmgpl8s";
      type = "gem";
    };
    version = "3.5.1";
  };
  faraday = {
    dependencies = [
      "faraday-em_http"
      "faraday-em_synchrony"
      "faraday-excon"
      "faraday-httpclient"
      "faraday-multipart"
      "faraday-net_http"
      "faraday-net_http_persistent"
      "faraday-patron"
      "faraday-rack"
      "faraday-retry"
      "ruby2_keywords"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "069gmdh5j90v06rbwlqvlhzhq45lxhx74mahz25xd276rm0wb153";
      type = "gem";
    };
    version = "1.10.4";
  };
  faraday-em_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vgrbhkp83sngv6k4mii9f2s9v5lmp693hylfxp2ssfc60fas3a6";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      type = "gem";
    };
    version = "1.1.0";
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
  faraday-httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l87r9jg06nsh24gwwd1jdnxb1zq89ffybnxab0dd90nfcf0ysw5";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-net_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10n6wikd442mfm15hd6gzm0qb527161w1wwch4h5m4iclkz2x6b3";
      type = "gem";
    };
    version = "1.0.2";
  };
  faraday-net_http_persistent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "153i967yrwnswqgvnnajgwp981k9p50ys1h80yz3q94rygs59ldd";
      type = "gem";
    };
    version = "1.0.3";
  };
  faraday_middleware = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s990pnapb3vci9c00bklqc7jjix4i2zhxn2zf1lfk46xv47hnyl";
      type = "gem";
    };
    version = "1.2.1";
  };
  ferrum = {
    dependencies = [
      "addressable"
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
      sha256 = "07fbv97g2dks2ais2b7f4vhhi8b30y752v4kwljjvv9hkv9cfjv4";
      type = "gem";
    };
    version = "0.15";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fgwn1grxf4zxmyqmb9i4z2hr111585n9jnk17y6y7hhs7dv1xi6";
      type = "gem";
    };
    version = "1.17.1";
  };
  foreman = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02m0iq43hrb99hca9ng834sx2p8zfc5xga1xwqn8lckabc925h2r";
      type = "gem";
    };
    version = "0.88.1";
  };
  geom2d = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nafcfznjqycxd062cais64ydgl99xddh4zy4hp7bwn4j3m9h2ga";
      type = "gem";
    };
    version = "0.4.1";
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
      sha256 = "1sbw6b66r7cwdx3jhs46s4lr991969hvigkjpbdl7y3i31qpdgvh";
      type = "gem";
    };
    version = "1.2.1";
  };
  google-apis-core = {
    dependencies = [
      "addressable"
      "googleauth"
      "httpclient"
      "mini_mime"
      "mutex_m"
      "representable"
      "retriable"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06m775rzhpdz9kalml04sysy5swgfh97jaglsgrv5x8sg4i42j4i";
      type = "gem";
    };
    version = "0.15.1";
  };
  google-apis-iamcredentials_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b9xgbp7wr39aggaxd8r27kvmwcjanxj98a1i0wh462l7n8xxh9q";
      type = "gem";
    };
    version = "0.22.0";
  };
  google-apis-storage_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18kw32kr2ily8mhacyppm9xan2ahjpn7fjmy72jxvdmzix25xd28";
      type = "gem";
    };
    version = "0.49.0";
  };
  google-cloud-core = {
    dependencies = [
      "google-cloud-env"
      "google-cloud-errors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh1yzv26mqn2qmzkqa0qwzmq4w0dcphjla4w5m2f2qlkj583wjs";
      type = "gem";
    };
    version = "1.7.1";
  };
  google-cloud-env = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ks9yv21d8bl9cw0sz5gy6npll1ig3m2bq9w7yw67j5mw2p64q1w";
      type = "gem";
    };
    version = "2.2.1";
  };
  google-cloud-errors = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "056yw9cg771c1xqvw15wpdfdw9lz3m13fh5b6a3p1c9xaq7jwkhb";
      type = "gem";
    };
    version = "1.4.0";
  };
  google-cloud-storage = {
    dependencies = [
      "addressable"
      "digest-crc"
      "google-apis-core"
      "google-apis-iamcredentials_v1"
      "google-apis-storage_v1"
      "google-cloud-core"
      "googleauth"
      "mini_mime"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kj31s7p0abgh6llknk9rymybnrhxjncma3lwzisyl4k9srx9sa4";
      type = "gem";
    };
    version = "1.54.0";
  };
  google-logging-utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mgw0n97prlvgvd81dci8rx93xranr3xnyhn5v7p6hii94g0p5bh";
      type = "gem";
    };
    version = "0.1.0";
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
      sha256 = "0zynv2s6s6i5d8x84p1axin21bfgmgy92ai2jb7a7aaknaqpfc9x";
      type = "gem";
    };
    version = "1.12.2";
  };
  hashdiff = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xqsnx25lm1wwgchvrl5xla5zzk3d6gbkdfj062cwggdsvgfwc1c";
      type = "gem";
    };
    version = "1.1.2";
  };
  hexapdf = {
    dependencies = [
      "cmdparse"
      "geom2d"
      "openssl"
      "strscan"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r17nzsh11yg4m4q1qyfwp180gb57rhs2x3bp2l9gh4im38jkw1z";
      type = "gem";
    };
    version = "1.4.0";
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
  httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03sx3ahz1v5kbqjwxj48msw3maplpp2iyzs22l4jrzrqh4zmgfnf";
      type = "gem";
    };
    version = "1.14.7";
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
      sha256 = "0rfxkhfsqz0bj2p32yb6kv7xibair2fn240bh2j1cfsp0wkzxkvi";
      type = "gem";
    };
    version = "1.13.0";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jszj95hazqqpnrjjzr326nn1j32xmsc9xvd97mbcrrgdc54858y";
      type = "gem";
    };
    version = "0.8.1";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
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
      sha256 = "1fpxa2m83rb7xlzs57daqwnzqjmz6j35xr7zb15s73975sak4br2";
      type = "gem";
    };
    version = "1.15.2";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p5dafxjp6kqkf3yx737gz9lwpaljlkc1raynkvcn6yql68d895w";
      type = "gem";
    };
    version = "2.15.0";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rba9mji57sfa1kjhj0bwff1377vj0i8yx2rd39j5ik4vp60gzam";
      type = "gem";
    };
    version = "2.9.3";
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
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b3zi9ydbibyyrrkr6l8mcs6l7yam18a4wg22ivgaz0rl2yn1ymp";
      type = "gem";
    };
    version = "3.0.1";
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
  logger = {
    groups = [
      "default"
      "development"
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dx316q03x6rpdbl610rdaj2vfd5s8fanixk21j4gv3h5f230nk5";
      type = "gem";
    };
    version = "2.24.1";
  };
  mail = {
    dependencies = [
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
      sha256 = "1bf9pysw1jfgynv692hhaycfxa8ckay1gjw5hz3madrbrynryfzc";
      type = "gem";
    };
    version = "2.8.1";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "190n2mk8m1l708kr88fh6mip9sdsh339d2s6sgrik3sbnvz4jmhd";
      type = "gem";
    };
    version = "1.0.4";
  };
  matrix = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nfxjpmka12ihbwd87d5k2hh7d2pv3aq95x0l2lh8gca1s72bmki";
      type = "gem";
    };
    version = "4.13.2";
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mn7q9yzrwinvfvkyjiz548a4rmcwbmz2fn9nyzh4j1snin6q6rr";
      type = "gem";
    };
    version = "5.25.5";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a5fsgchkpcca4wf3pipbb2jbj523l7fbaq37j10cr0yymwlkc7z";
      type = "gem";
    };
    version = "1.7.5";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cysv1wdfdbizwkd0d9s16s832khdwv31pgp01mw2g3bbpa4gx3h";
      type = "gem";
    };
    version = "0.5.6";
  };
  net-http-persistent = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13psmr8009wwknainvns5jidhvjsknffb6k7mzz0yrby6h5qhhkf";
      type = "gem";
    };
    version = "4.0.5";
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
      sha256 = "1z1kpshd0r09jv0091bcr4gfx3i1psbqdzy7zyag5n8v3qr0anfr";
      type = "gem";
    };
    version = "0.5.9";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a9www524fl1ykspznz54i0phfqya4x45hqaz67in9dvw1lfwpfr";
      type = "gem";
    };
    version = "2.7.4";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
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
      sha256 = "0czsh9d738kj0bmpkjnczq9j924hg103gc00i0wfyg0fzn9psnmc";
      type = "gem";
    };
    version = "1.18.9";
  };
  numo-narray = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1syw9bhkk0bnacadcpdbwvc66j1gi3qqgcvqv3zqh4myxr3npmzf";
      type = "gem";
    };
    version = "0.9.2.1";
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
      sha256 = "1cajn3ylwhby1x51d9hbchm964qwb5zp63f7sfdm55n85ffn1ara";
      type = "gem";
    };
    version = "3.16.11";
  };
  onnxruntime = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c8l82qff7vd6whh0ks1f72734gmghzm0h2hvy2gnnp7y8j7amhq";
      type = "gem";
    };
    version = "0.10.1";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ygfbbs3c61d32ymja2k6sznj5pr540cip9z91lhzcvsr4zmffpz";
      type = "gem";
    };
    version = "3.3.0";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  package_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mh2fwvldjpsjwdnfrckakkpixa8x4j36nplnr4cvbaxwk09ibr0";
      type = "gem";
    };
    version = "0.1.0";
  };
  pagy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q5vwaq9vqb53i68vy9nvf3055isricyazd5irjwaz7cnj742ca8";
      type = "gem";
    };
    version = "9.3.3";
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
      sha256 = "1wl7frfk68q6gsf6q6j32jl5m3yc0b9x8ycxz3hy79miaj9r5mll";
      type = "gem";
    };
    version = "3.3.9.0";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p2gqqrm895fzr9vi8d118zhql67bm8ydjvgqbq1crdnfggzn7kn";
      type = "gem";
    };
    version = "1.5.9";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zxnfxjni0r9l2x42fyq0sqpnaf5nakjbap8irgik4kg1h9c6zll";
      type = "gem";
    };
    version = "0.6.2";
  };
  premailer = {
    dependencies = [
      "addressable"
      "css_parser"
      "htmlentities"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ryivdnij1990hcqqmq4s0x1vjvfl0awjc9b91f8af17v2639qhg";
      type = "gem";
    };
    version = "1.27.0";
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
  pretender = {
    dependencies = [ "actionpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xxdizzp7l0cbccmh499rifr6q0khjgfqv0kir39haqwphjhy4h2";
      type = "gem";
    };
    version = "0.5.0";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d3i31npmlhmigcs1zlb9lksg7z7lv6nffams71wrz5rriv1n35l";
      type = "gem";
    };
    version = "1.5.1";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c0rxhgjlyq502q88w65bvg1d42jpcwsk8sqn1qyd24clmg95rwi";
      type = "gem";
    };
    version = "0.15.0";
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
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vii1xc7x81hicdbp7dlllhmbw5w3jy20shj696n0vfbbnm2hhw1";
      type = "gem";
    };
    version = "5.2.6";
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
      sha256 = "0vqcw3iwby3yc6avs1vb3gfd0vcp2v7q310665dvxfswmcf4xm31";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wl9q4fl8gvhwdpfxghx6jdqi4508287pcgiwi96sdbzmdfbglcl";
      type = "gem";
    };
    version = "6.5.0";
  };
  racc = {
    groups = [
      "default"
      "development"
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h9xr8ivrfr0i5f2n7czg74r3ri1pba8wb84bzr78iaqlqykg6i3";
      type = "gem";
    };
    version = "3.2.3";
  };
  rack-proxy = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12jw7401j543fj8cc83lmw72d8k6bxvkp9rvbifi88hh01blnsj4";
      type = "gem";
    };
    version = "0.7.7";
  };
  rack-session = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [
      "default"
      "development"
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13brkq5xkj6lcdxj3f0k7v28hgrqhqxjlhd4y2vlicy5slgijdzp";
      type = "gem";
    };
    version = "2.2.1";
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
      sha256 = "1b5k9608wxp8hksyvnc3vvdrairyv2qldcw48cv4xrv9amhrbaqk";
      type = "gem";
    };
    version = "8.0.2.1";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q55i6mpad20m2x1lg5pkqfpbmmapk0sjsrvr1sqgnj2hb5f5z1m";
      type = "gem";
    };
    version = "1.6.2";
  };
  rails-i18n = {
    dependencies = [
      "i18n"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03dy8nmq2gxvkg8zqq6c0wwz98mdwp3i9krn0slcknhb8nak2c0m";
      type = "gem";
    };
    version = "8.0.1";
  };
  rails_autolink = {
    dependencies = [
      "actionview"
      "activesupport"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fpwkc20bi7aynfgp2bqhvb7x6vsdiai4prflcsr9sicbwp9vjzv";
      type = "gem";
    };
    version = "1.1.8";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k0x630ipimzv6vzhwflsjl7n1fvrmvf196mfbspha7wf4bhxr2l";
      type = "gem";
    };
    version = "8.0.2.1";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14s4jdcs1a4saam9qmzbsa2bsh85rj9zfxny5z315x3gg0nhkxcn";
      type = "gem";
    };
    version = "13.3.0";
  };
  rdoc = {
    dependencies = [
      "erb"
      "psych"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09lj8d16wx5byj0nbcb9wc6v9farsvgn98n91kknm18g2ggl9pcz";
      type = "gem";
    };
    version = "6.14.2";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k0qbbxxzinffqmsvgw5avqbpzpwip0p2qyh98c872xhl578i0qz";
      type = "gem";
    };
    version = "0.23.0";
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ii8l0q5zkang3lxqlsamzfz5ja7jc8ln905isfdawl802k2db8x";
      type = "gem";
    };
    version = "0.6.2";
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
      sha256 = "06ilkbbwvc8d0vppf8ywn1f79ypyymlb9krrhqv4g0q215zaiwlj";
      type = "gem";
    };
    version = "3.1.1";
  };
  retriable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
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
      sha256 = "18v8if3jix029rr3j8iwisv73facw223353n0h7avl39ibxk6hh3";
      type = "gem";
    };
    version = "4.5.2";
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
      sha256 = "1hggzz8i1l62pkkiybhiqv6ypxw7q844sddrrbbfczjcnj5sivi3";
      type = "gem";
    };
    version = "2.2.0";
  };
  rqrcode_core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06ld6386hbdhy5h0k09axmgn424kavpc8f27k1vjhknjhbf8jjfg";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "001kazj244cb6fbkmh7ap74csbr78717qaskqzqpir1q8xpdmywl";
      type = "gem";
    };
    version = "3.13.2";
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
      sha256 = "0n3cyrhsa75x5wwvskrrqk56jbjgdi2q1zx0irllf0chkgsmlsqf";
      type = "gem";
    };
    version = "3.13.3";
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
      sha256 = "1vxxkb2sf2b36d8ca2nq84kjf85fz4x7wqcvb8r6a5hfxxfk69r3";
      type = "gem";
    };
    version = "3.13.2";
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
      sha256 = "0izfwfb9bfb5q3wjgjc85b9nlkribqn8vk75zadafv08qilmnn4l";
      type = "gem";
    };
    version = "7.1.0";
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
      sha256 = "1v6v6xvxcpkrrsrv7v1xgf7sl0d71vcfz1cnrjflpf6r7x3a58yf";
      type = "gem";
    };
    version = "3.13.2";
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
      sha256 = "0d8n87wx2r8vkva5qi4m3hi4s9b6qhmzgw85qgv14hsa65prlaim";
      type = "gem";
    };
    version = "1.81.1";
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
      sha256 = "1bh1kls2cs2j3cmj6f2j2zmfqfknj2a6i441d828nh2mg00q49jr";
      type = "gem";
    };
    version = "1.47.1";
  };
  rubocop-performance = {
    dependencies = [
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
      sha256 = "0wcilipyh890k0vwx8mgkj5qpjy2xvvgk89l9ars1wf53g5pibil";
      type = "gem";
    };
    version = "1.23.0";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
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
      sha256 = "1zplyab5n8gh7zzbwrrxrkzb2406afrjm6a3a3zdx72k17swx9n3";
      type = "gem";
    };
    version = "2.27.0";
  };
  rubocop-rspec = {
    dependencies = [ "rubocop" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zfdf688w6bsdbqfmsr5ghvcs1kc5qpcbyzy2qals149ls0v5qbr";
      type = "gem";
    };
    version = "3.3.0";
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
      sha256 = "0nyxwib3y2fc1lciaac0s03y3i915kyfq1kn9m19hyl5yblyhnxg";
      type = "gem";
    };
    version = "2.2.2";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyXL = {
    dependencies = [
      "nokogiri"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bkd50mpsrkz6agqvvbi8d0l1cic6jrkdsrjjzfkz5jzrzd349yw";
      type = "gem";
    };
    version = "3.4.33";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
  };
  securerandom = {
    groups = [
      "default"
      "development"
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
  semantic_range = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "189l1ajvpy8znkmbalrpc3fpg0b8gy1j3m4m5q282prf1zj1xh4z";
      type = "gem";
    };
    version = "3.1.0";
  };
  shakapacker = {
    dependencies = [
      "activesupport"
      "package_json"
      "rack-proxy"
      "railties"
      "semantic_range"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r12z3qr5zacak293za3k2cv453p50srg43x682x61ncsx3kddvl";
      type = "gem";
    };
    version = "8.0.2";
  };
  sidekiq = {
    dependencies = [
      "connection_pool"
      "logger"
      "rack"
      "redis-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05navs6f5904mqkrdmfafan448c5sn41aah2hb6rfbsn66a9rcjy";
      type = "gem";
    };
    version = "7.3.7";
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
      sha256 = "0cfxa11wy1nv9slmnzjczkdgld0gqizajsb03rliy53zylwkjzsk";
      type = "gem";
    };
    version = "0.19.0";
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
  simplecov-html = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02zi3rwihp7rlnp9x18c9idnkx7x68w6jmxdhyc0xrhjwrz0pasx";
      type = "gem";
    };
    version = "0.13.1";
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
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sqshkafxa1r34yj4yxisd4kddmjq9jrhx6azqy3z71nwqv01yl7";
      type = "gem";
    };
    version = "2.5.0";
  };
  stringio = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yh78pg6lm28c3k0pfd2ipskii1fsraq46m6zjs5yc9a4k5vfy2v";
      type = "gem";
    };
    version = "3.1.7";
  };
  strip_attributes = {
    dependencies = [ "activemodel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09ds8vspql76272yimasyc0mab91plvqy5zlg5k5r78yyawg8k54";
      type = "gem";
    };
    version = "1.14.1";
  };
  strscan = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0isr7v4d9z145hkk9qip8fkcs6smi264lhd416bad5ckxa83nhgq";
      type = "gem";
    };
    version = "3.1.5";
  };
  thor = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gcarlmpfbmqnjvwfz44gdjhcmm634di7plcx2zdgwdhrhifhqw7";
      type = "gem";
    };
    version = "1.4.0";
  };
  timeout = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03p31w5ghqfsbz5mcjzvwgkw3h9lbvbknqvrdliy8pxmn9wz02cm";
      type = "gem";
    };
    version = "0.4.3";
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
  turbo-rails = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kvz74g2j233zbbpqiba2p5gahpjps20vp54samq09rp6r3nfizw";
      type = "gem";
    };
    version = "2.0.11";
  };
  twitter_cldr = {
    dependencies = [
      "camertron-eprun"
      "cldr-plurals-runtime-rb"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00idwd8h5gsm6kbpzsrh1f6w2ncwsb37gd224jj1cilqp5nb3s8g";
      type = "gem";
    };
    version = "6.12.1";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
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
      sha256 = "1cw6xv9a525mcs7202bq9768aic1dwx353prm1bss4fp2nq24a3j";
      type = "gem";
    };
    version = "1.2024.2";
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
      sha256 = "1995yfjbvjlwrslq48gzzc9j0blkdzlbda9h90pjbm0yvzax55s9";
      type = "gem";
    };
    version = "4.1.0";
  };
  uniform_notifier = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dfvqixshwvm82b9qwdidvnkavdj7s0fbdbmyd4knkl6l3j9xcwr";
      type = "gem";
    };
    version = "1.16.0";
  };
  uri = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04bhfvc25b07jaiaf62yrach7khhr5jlr5bx6nygg8pf11329wp9";
      type = "gem";
    };
    version = "1.0.3";
  };
  useragent = {
    groups = [
      "default"
      "development"
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
  web-console = {
    dependencies = [
      "actionview"
      "activemodel"
      "bindex"
      "railties"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "087y4byl2s3fg0nfhix4s0r25cv1wk7d2j8n5324waza21xg7g77";
      type = "gem";
    };
    version = "4.2.1";
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
      sha256 = "08kixkdp41dw39kqfxf2wp5m4z9b6fxg6yfa6xin0wy7dxzka0dy";
      type = "gem";
    };
    version = "3.24.0";
  };
  webrick = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12d9n8hll67j737ym2zw4v23cn4vxyfkb6vyv1rzpwv6y6a3qbdl";
      type = "gem";
    };
    version = "1.9.1";
  };
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [
      "default"
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
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "119ypabas886gd0n9kiid3q41w76gz60s8qmiak6pljpkd56ps5j";
      type = "gem";
    };
    version = "2.7.3";
  };
}
