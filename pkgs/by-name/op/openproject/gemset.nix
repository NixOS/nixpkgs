{
  action_text-trix = {
    dependencies = ["railties"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12isf17cd4xyx5vg97nzxsi92703yh40fxyns6gl9f11331a4ign";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.16";
  };
  actioncable = {
    dependencies = ["actionpack" "activesupport" "nio4r" "websocket-driver" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8rp5zpcxqkpj610whkrnjhwk119f5xn7b9bkydx76a9k1yycfw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w8h4awh3k1v6b2anix20qjdij5zby7am379y4mlp8fk2qjz2q5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "activesupport" "mail" "rails-dom-testing"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sbmj65nzqzjh9ji94p91mkpjlhf3jkcbzd7ia8gwfv51w3d5hgl";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "nokogiri" "rack" "rack-session" "rack-test" "rails-dom-testing" "rails-html-sanitizer" "useragent"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08w49zj1skvviyakjy2cazfklkgx2dsnfzxb9fmaznphl53l3myf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  actionpack-xml_parser = {
    dependencies = ["actionpack" "railties"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rnm6jrw3mzcf2g3q498igmhsn0kfkxq79w0nm532iclx4g4djs0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.1";
  };
  actiontext = {
    dependencies = ["action_text-trix" "actionpack" "activerecord" "activestorage" "activesupport" "globalid" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b9dilsjx9saqqz7dwj0fqfbacdyar5f4g4wfxqdj6cw5ai7vx8b";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrf7qn2p6r645427whfh071az6bv8728bf2rrr9n74ii0jmnic0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  active_record_doctor = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16h6hhmd3x07vgh2kwxabvb7kz5ifaz4w3kxyvrci1ak341arw3s";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.1";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09gq0bivkb9qfmg69k1jqbsbs1vb2ps1jn1p6saqa0di2cvsp3ch";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  activemodel = {
    dependencies = ["activesupport"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gpkph1mq78yg1cl0vkc8js0gh3vjxjf9drqk0zyv2p63k0mh4z2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  activemodel-serializers-xml = {
    dependencies = ["activemodel" "activesupport" "builder"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15y32sacv9xfbazd75dbr1ckln8a7hz86s4wlmccqm3jbqq1c6zs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.3";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "timeout"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i6c9g3q0lx4bca5gvz0p8p6ibhwn176zzhih0hgll6cvz5f1yxc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  activerecord-import = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jzs0y4dg84j14j2hmlzviw66rcz6wn1j78z7mr7a1z5jsqrkjpq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  activerecord-nulldb-adapter = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s7rkrfkaiab9j622q2l5ahm0g7vr7ca6x72j9mda6pikbjb5q01";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.2";
  };
  activerecord-session_store = {
    dependencies = ["actionpack" "activerecord" "cgi" "rack" "railties"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hr7dv4qfimy3bqw3yhwsz4i9kpyw5jyg2dghx7vz0rnaxa814b5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  activestorage = {
    dependencies = ["actionpack" "activejob" "activerecord" "activesupport" "marcel"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xms9z8asdpqw5ybl6n4bk1iys4l7y0iyi2rdbifxjlr766a8qwa";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  activesupport = {
    dependencies = ["base64" "bigdecimal" "concurrent-ruby" "connection_pool" "drb" "i18n" "json" "logger" "minitest" "securerandom" "tzinfo" "uri"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpxnr83z1x78h3jxvmga7vrmzmc8b4fic49h9jhzm6hriw2b148";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  acts_as_list = {
    dependencies = ["activerecord" "activesupport"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j7xclldl8g34vs791cyihysyngfrj8hkl3sq0hfdgmp004khic3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.6";
  };
  acts_as_tree = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wx2m64knv57g1q0bi09d7hci69x5n49xkzzcimn2f6ym08fnsdq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.9.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mxhjgihzsx45l9wh2n0ywl9w0c6k70igm5r0d63dxkcagwvh4vw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.8.8";
  };
  aes_key_wrap = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bn0y70qm6mfj4y1m0j3s8ggh6dvxwrwrj5vfamhdrpddsz8ddr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.0";
  };
  afm = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ia5iw9xvvy1igaxsa08vvv4b5ry9ipyr18917pi8w0y4kvddm2v";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  airbrake = {
    dependencies = ["airbrake-ruby"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1diirjch0znh2a53l0fpylj762j051xdwnvzv1zgfpjxq9s507wh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "13.0.5";
  };
  airbrake-ruby = {
    dependencies = ["rbtree3"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g1gvvbzbh0kiinw4w0sxaggxdn5wz689dbsssvf2qz76vxk8gi9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.2.2";
  };
  android_key_attestation = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02spc1sh7zsljl02v9d5rdb717b628vw2k7jkkplifyjk4db0zj6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.0";
  };
  anyway_config = {
    dependencies = ["ruby-next-core"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01lkgif3mca80cc21lv1ww9mgr1nx2275h6hsgf044pq65r7lygn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.8.0";
  };
  appsignal = {
    dependencies = ["logger" "rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "199cr5yf0wgjf6s2761i3migb20pk5ki68jyllfm19jilhlk5kw8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.8.2";
  };
  Ascii85 = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmyxpngg5rycyryhq9l9hapz1y3iqyflskyksxkqm0832a5vjqm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.1";
  };
  ast = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.4.3";
  };
  attr_required = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16fbwr6nmsn97n0a6k1nwbpyz08zpinhd6g7196lz1syndbgrszh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.2";
  };
  auto_strip_attributes = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1rmrm33xz6kk6w2x0jr24cqavh41102s7x8zcvrqjdfk7y1qm7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.6.0";
  };
  awesome_nested_set = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vdain55fil8lvj0z4lbj8jczakh01ij3rhqw56pzyahcn0rxs9w";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.9.0";
  };
  aws-eventstream = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.4.0";
  };
  aws-partitions = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pp0sagj31zvmv8ca0hf0kgdfb7wwkq733sv2812gvs43pck5hay";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1213.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "base64" "bigdecimal" "jmespath" "logger"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1819b99lgs3i637j2y6f95vlsppw3id2hys3m30q13f7mh1k0yy1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.242.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q015l5gm3f230jz9l6si9s3hlw7ra76q8biqvxlwxdmnk7w2qym";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.121.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03g5k3jl0sgp60ppmxa267qflxlj174mrs8hnrnl10j5ak7nqndg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.213.0";
  };
  aws-sdk-sns = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m5j4jni4xfj4wysqizd3wdcvhch2yj5ii91j9cjjhnbpfsv3wdg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.112.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.12.1";
  };
  axe-core-api = {
    dependencies = ["dumb_delegator" "ostruct" "virtus"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k407b9m6kdz406n5xmvrwwcv9mgwzz7818ac8q20scs8h30aim6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.11.1";
  };
  axe-core-rspec = {
    dependencies = ["axe-core-api" "dumb_delegator" "ostruct" "virtus"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v2a07ayf7ja2hkidjn028f52nzf45jpz4x0qhl3mk85chb0wv6w";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.11.1";
  };
  axiom-types = {
    dependencies = ["descendants_tracker" "ice_nine" "thread_safe"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.1";
  };
  base64 = {
    gem_platform = "ruby";
    groups = ["default" "development" "ldap" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.0";
  };
  bcrypt = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1krd99p9828n07rcjjms56jaqv7v6s9pn7y6bppcfhhaflyn2r2r";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.1.21";
  };
  benchmark = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  better_html = {
    dependencies = ["actionview" "activesupport" "ast" "erubi" "parser" "smart_properties"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xngv2yj85hiw8lgb4kqp807a41wmbl3bgrv6c4bg5lnn1mbd2p6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  bigdecimal = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0612spks81fvpv2zrrv3371lbs6mwd7w6g5zafglyk75ici1x87a";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.3.1";
  };
  bindata = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n4ymlgik3xcg94h52dzmh583ss40rl3sn0kni63v56sq8g6l62k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.5.1";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "057jsch213i42qgdsz2vg1b190n2xvvbi3hgprc8nmaqim2ly9f1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.23.0";
  };
  brakeman = {
    dependencies = ["racc"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sj2haki5a9jd9awi5abch73gsz8g2nz5lzgkja97pmix1f0c0kv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.0.2";
  };
  browser = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bffb8dddrg6zn8c74swhy8mq2mysb195hi7chwwj9c8g2am4798";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.2.0";
  };
  budgets = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/budgets;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  builder = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.3.0";
  };
  byebug = {
    dependencies = ["reline"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pg05blj56sxdxq9d54386y9rlvj36vl95x21x9clh8rfpz3w9nj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "13.0.0";
  };
  capybara = {
    dependencies = ["addressable" "matrix" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vxfah83j6zpw3v5hic0j70h519nvmix2hbszmjwm8cfawhagns2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.40.0";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqc7hdiw1ql42mklpfvqd2pyfsxmy55cpx0h9y0jlkpl1q96sw1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.26";
  };
  capybara_accessible_selectors = {
    dependencies = ["capybara"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "5b9ce7840d04270e99f4f0cb03989e05437326a6";
      sha256 = "009rzrjv8hpj8gihqd8k3b4qjiax599wf4k81sd6qq4wpl16f4ll";
      type = "git";
      url = "https://github.com/citizensadvice/capybara_accessible_selectors";
    };
    target_platform = "ruby";
    version = "0.15.0";
  };
  carrierwave = {
    dependencies = ["activemodel" "activesupport" "mime-types" "ssrf_filter"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "089s8rbwddzcyw1ky34h90flz5wzqzi2lvajykbxn3l3s6mjsxw1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.4";
  };
  carrierwave_direct = {
    dependencies = ["carrierwave" "fog-aws"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gyxbl6akxj89cbv556lsqi6955jld2gdkw8wi05k80p3nfc3mdh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.0";
  };
  cbor = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w3d5dhx4vjd707ihkcmq7fy78p5fgawcjdqw2byxnfw32gzgkbr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.10.1";
  };
  cgi = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s8qdw1nfh3njd47q154njlfyc2llcgi4ik13vz39adqd7yclgz9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.1";
  };
  childprocess = {
    dependencies = ["logger"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v5nalaarxnfdm6rxb7q6fmc6nx097jd630ax6h9ch7xw95li3cs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.1.0";
  };
  climate_control = {
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "198aswdyqlvcw9jkd95b7b8dp3fg0wx89kd1dx9wia1z36b1icin";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.0";
  };
  closure_tree = {
    dependencies = ["activerecord" "with_advisory_lock" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nvbm7jnsmv790imlbkzr9nw42gml22i3gajw7g17b0338px7rqs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "9.5.0";
  };
  coderay = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.3";
  };
  coercible = {
    dependencies = ["descendants_tracker"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  color_conversion = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15jcp6i5xi083p0h5qmsir9ghps4mnk5m5w92fhjf59f87xabglr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.2";
  };
  colored2 = {
    gem_platform = "ruby";
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0drbrv5m3l3qpal7s87gvss81cbzl76gad1hqkpqfqlphf0h7qb3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.0.3";
  };
  commonmarker = {
    dependencies = ["rb_sys"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y1ng052vqapxqykmmgl7ymqiy0q078y6lradjzm3s9damb36c3f";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.6.3";
  };
  compare-xml = {
    dependencies = ["nokogiri"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06aks0fjxwvs4l9bd8bl9q48kyadzn4cd5yrrrz1gwcyyv0aa6p2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.66";
  };
  concurrent-ruby = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aymcakhzl83k77g2f2krz07bg1cbafbcd2ghvwr4lky3rz86mkb";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.6";
  };
  connection_pool = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02ifws3c4x7b54fv17sm4cca18d2pfw1saxpdji2lbd1f6xgbzrk";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.0.2";
  };
  cookiejar = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1px0zlnlkwwp9prdkm2lamgy412y009646n2cgsa1xxsqk7nmc8i";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.4";
  };
  cose = {
    dependencies = ["cbor" "openssl-signature_algorithm"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rbdzl9n8ppyp38y75hw06s17kp922ybj6jfvhz52p83dg6xpm6m";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.1";
  };
  costs = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/costs;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  counter_culture = {
    dependencies = ["activerecord" "activesupport"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101rwj3c80ycf4rqb7n2jx8qrw1z2fd49733z8mp6h8r6a90124a";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.12.1";
  };
  crack = {
    dependencies = ["bigdecimal" "rexml"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zjcdl5i6lw508r01dym05ibhkc784cfn93m1d26c7fk1hwi0jpz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.1";
  };
  crass = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.6";
  };
  css_parser = {
    dependencies = ["addressable"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1izp5vna86s7xivqzml4nviy01bv76arrd5is8wkncwp1by3zzbc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.21.1";
  };
  csv = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gz7r2kazwwwyrwi95hbnhy54kwkfac5swh2gy5p5vw36fn38lbf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.3.5";
  };
  cuprite = {
    dependencies = ["capybara" "ferrum"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ay1azfzslgqzxvgxpz9j7i31m0bbpcmrx5wajnrg2yhf3fdah5i";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.17";
  };
  daemons = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.4.1";
  };
  dalli = {
    dependencies = ["logger"];
    gem_platform = "ruby";
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s6llfgkfnlwk74gb59r1zf48cjn1sp0jzz7d2nqry9yv8hyhnkx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.0.0";
  };
  date = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h0db8r2v5llxdbzkzyllkfniqw9gm092qn7cbaib73v9lw0c3bm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.5.1";
  };
  date_validator = {
    dependencies = ["activemodel" "activesupport"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n1hrs9323q2430fiyzb2y350wim30x5a7242yf7nd20l96q7jb8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.12.0";
  };
  deckar01-task_list = {
    dependencies = ["html-pipeline"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rqn9jh45gsw045c6fm05875bpj2xbhnff5m5drmk9wy01zdrav6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.3.4";
  };
  declarative = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.0.20";
  };
  dentaku = {
    dependencies = ["bigdecimal" "concurrent-ruby"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c3xf9ifrmsrdzhgd84aki77klldwdvbnhi8vn8i93mc06la85cd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.5.7";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.0.4";
  };
  diff-lcs = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.6.2";
  };
  disposable = {
    dependencies = ["declarative" "representable"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k44sg1gk7ba8znndc2ikch32dgcsi1l05jvya1wvxmza6r3yakz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.3";
  };
  doorkeeper = {
    dependencies = ["railties"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lsh9lzrglqlwm9icmn0ggrwjc9iy9308f9m59z1w2srmyp0fgd7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.8.2";
  };
  dotenv = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17b1zr9kih0i3wb7h4yq9i8vi6hjfq07857j437a8z7a44qvhxg3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  dotenv-rails = {
    dependencies = ["dotenv" "railties"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axy0frn3xn3jf1gdafx5rzz843551q1ckwcbp4zy8m69dajazk5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  drb = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wrkl7yiix268s2md1h6wh91311w95ikd8fy8m5gx589npyxc00b";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.3";
  };
  dry-configurable = {
    dependencies = ["dry-core" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a5g30p7kzp37n9w3idp3gy70hzkj30d8j951lhw2zsnb0l8cbc8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.0";
  };
  dry-container = {
    dependencies = ["concurrent-ruby"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aaj0ffwkbdagrry127x1gd4m6am88mhhfzi7czk8isdcj0r7gi3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.0";
  };
  dry-core = {
    dependencies = ["concurrent-ruby" "logger" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18cn9s2p7cbgacy0z41h3sf9jvl75vjfmvj774apyffzi3dagi8c";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.0";
  };
  dry-inflector = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k1dd35sqqqg2abd2g2w78m94pa3mcwvmrsjbkr3hxpn0jxw5c3z";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.1";
  };
  dry-initializer = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qy4cv0j0ahabprdbp02nc3r1606jd5dp90lzqg0mp0jz6c9gm9p";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  dry-logic = {
    dependencies = ["bigdecimal" "concurrent-ruby" "dry-core" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18nf8mbnhgvkw34drj7nmvpx2afmyl2nyzncn3wl3z4h1yyfsvys";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.6.0";
  };
  dry-monads = {
    dependencies = ["concurrent-ruby" "dry-core" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05jq44kmpa01d37q50wp2wygpwzx6x3xkns2cf3plb46bixscj4k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.9.0";
  };
  dry-schema = {
    dependencies = ["concurrent-ruby" "dry-configurable" "dry-core" "dry-initializer" "dry-logic" "dry-types" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1licv1vqmm57961ivzyaxscf20mlj5v6n6zc8rnvs1j2pank8ahg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.15.0";
  };
  dry-types = {
    dependencies = ["bigdecimal" "concurrent-ruby" "dry-core" "dry-inflector" "dry-logic" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y7icwaa26ycikz6h97gwd1hji3r280n4yr2kmn5sfgqp76yxsxs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.9.1";
  };
  dry-validation = {
    dependencies = ["concurrent-ruby" "dry-core" "dry-initializer" "dry-schema" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11c0zx0irrawi028xsljpyw8kwxzqrhf7lv6nnmch4frlashp43h";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.11.1";
  };
  dumb_delegator = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13hq81z3yimhw6xd1czia68mqgcgcw6b8qjcaxm218lmn3jmblhs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.0";
  };
  em-http-request = {
    dependencies = ["addressable" "cookiejar" "em-socksify" "eventmachine" "http_parser.rb"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1azx5rgm1zvx7391sfwcxzyccs46x495vb34ql2ch83f58mwgyqn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.7";
  };
  em-socksify = {
    dependencies = ["base64" "eventmachine"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vbl74x9m4hccmmhcnp36s50mn7d81annfj3fcqjdhdcm2khi3bx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.3";
  };
  em-synchrony = {
    dependencies = ["eventmachine"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jh6ygbcvapmarqiap79i6yl05bicldr2lnmc46w1fyrhjk70x3f";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.6";
  };
  email_validator = {
    dependencies = ["activemodel"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0106y8xakq6frv2xc68zz76q2l2cqvhfjc7ji69yyypcbc4kicjs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.4";
  };
  equivalent-xml = {
    dependencies = ["nokogiri"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11zlqc600acqn1kli339c587xca6yvhqpzv9cf2d12l4z8g7c6c9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.0";
  };
  erb = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ar4nmvk1sk7drjigqyh9nnps3mxg625b8chfk42557p8i6jdrlz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.0.2";
  };
  erb_lint = {
    dependencies = ["activesupport" "better_html" "parser" "rainbow" "rubocop" "smart_properties"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cbwr8iv6d9g50w12a7ccvcrqk5clz4mxa3cspqd3s1rv05f9dfz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.0";
  };
  erblint-github = {
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l7j646nma6bx34bsf9y5fxx5naf8brpmvwk025cc38s73fgfa4z";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.1";
  };
  erubi = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.13.1";
  };
  escape_utils = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "029c7kynhkxw8fgq9q171xi68ajfqrb22r7drvkar018j8871yyz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.0";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g785lz4z2k7jrdl7bnnjllzfrwpv9pyki94ngizj8cqfy83qzkc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.4.0";
  };
  eventmachine = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.7";
  };
  eventmachine_httpserver = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02dq358cj7z6qh3n7gmsf345fz25c0hwqprfb51ls82l6yifidax";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.1";
  };
  excon = {
    dependencies = ["logger"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19a4ln8s8bz2vnv15mikgr908cqqplmjnm3x5825i3k3k2zbm2d0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.2";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xz02xlnfhj418g51w06asfpcjccf7b66dx6ly3c1k2d45rv7ghj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.5.6";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s3dpi8x754bwv4mlasdal8ffiahi4b4ajpccnkaipp4x98lik6k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.5.1";
  };
  faraday = {
    dependencies = ["faraday-net_http" "json" "logger"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "077n5ss3z3ds4vj54w201kd12smai853dp9c9n7ii7g3q7nwwg54";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.14.1";
  };
  faraday-follow_redirects = {
    dependencies = ["faraday"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b8hgpci3wjm3rm41bzpasvsc5j253ljyg5rsajl62dkjk497pjw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  faraday-net_http = {
    dependencies = ["net-http"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v4hfmc7d4lrqqj2wl366rm9551gd08zkv2ppwwnjlnkc217aizi";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.4.2";
  };
  fastimage = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s67b9n7ki3iaycypq8sh02377gjkaxadg4dq53bpgfk4xg3gkjz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.4.0";
  };
  ferrum = {
    dependencies = ["addressable" "base64" "concurrent-ruby" "webrick" "websocket-driver"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rybr2bd1da7n7m3c7m9jaxlalcz71s697ax7fhyb4y51w993mai";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.17.1";
  };
  ffi = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k1xaqw2jk13q3ss7cnyvkp8fzp75dk4kazysrxgfd1rpgvkk7qf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.17.3";
  };
  flamegraph = {
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p785nmhdzbwj0qpxn5fzrmr4kgimcds83v4f95f387z6w3050x6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.5";
  };
  fog-aws = {
    dependencies = ["base64" "fog-core" "fog-json" "fog-xml"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19crlx2pnyxa8ncv874gz652hxh6yd9lr1354yznrgkqv5p37ir0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.33.1";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador" "mime-types"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rjv4iqr64arxv07bh84zzbr1y081h21592b5zjdrk937al8mq1z";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.6.0";
  };
  fog-json = {
    dependencies = ["fog-core" "multi_json"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.0";
  };
  fog-xml = {
    dependencies = ["fog-core" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1miv6zgglx4vddw2c17mpf6l36qn0abq7ngrxb9isih10yhzxfaj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.5";
  };
  formatador = {
    dependencies = ["reline"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "156qa2wiizmdalz6cim04yaasdz1q6c6k7yhnpdnrhn26f0qkyhr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.3";
  };
  friendly_id = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hxhddr497v7cciwns9rw7fsi6qczp3c2r0i6a31blpvag6j3qi8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.6.0";
  };
  front_matter_parser = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yvvxcym75csvckkg3bcf739ild3f0b2yifnlj45gf8xl2yriqms";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.1";
  };
  fugit = {
    dependencies = ["et-orbi" "raabro"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s5gg88f2d5wpppgrgzfhnyi9y2kzprvhhjfh3q1bd79xmwg962q";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.12.1";
  };
  fuubar = {
    dependencies = ["rspec-core" "ruby-progressbar"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1028vn7j3kc5qqwswrf3has3qm4j9xva70xmzb3n29i89f0afwmj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.5.1";
  };
  glob = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "131356zfr61zajgcz9pjhbrhys3gazd0rkh7m7fi7gjasbicjgc9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04gzhqvsm4z4l12r9dkac9a75ah45w186ydhl0i4andldsnkkih5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.0";
  };
  good_job = {
    dependencies = ["activejob" "activerecord" "concurrent-ruby" "fugit" "railties" "thor"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fzyxa1hay2pvc00knysv4snspkspzi2rn8jajl4175cyax83ad8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.12.1";
  };
  google-apis-core = {
    dependencies = ["addressable" "faraday" "faraday-follow_redirects" "googleauth" "mini_mime" "representable" "retriable"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a961x3jq0wskwgb8ym83viza05bcvsqiny8gg6dc0n9mnm7jids";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.2";
  };
  google-apis-gmail_v1 = {
    dependencies = ["google-apis-core"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vs9ivwh3jqxxcn2dax4hz8wzs049l7vpr4chbi8anx5dm5l6r1h";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.47.0";
  };
  google-cloud-env = {
    dependencies = ["base64" "faraday"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rvqj6n6qhjmjy0lynpmga7ly48s7dk36i6nj4jqrrvvn8gc1ahg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.3.1";
  };
  google-logging-utils = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yyzlgy9hx104xhrbl51ana0dl3m5p5989j4lcjsizssxas64m37";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.0";
  };
  google-protobuf = {
    dependencies = ["bigdecimal" "rake"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "180dc99dgq6gsi65q8sxcdqxjkz09fifq8v97yn266qh9ivznr0v";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.33.5";
  };
  googleapis-common-protos-types = {
    dependencies = ["google-protobuf"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iy4pxpsbxjdiyd03mslalbcvrrga57h1mb0r0c01nnngfvr4x7r";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.22.0";
  };
  googleauth = {
    dependencies = ["faraday" "google-cloud-env" "google-logging-utils" "jwt" "multi_json" "os" "signet"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "173h8r5dzhn4dvq2idx59jaybkhd02dr7333qshc3n2mkp76nxrn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.16.1";
  };
  grape = {
    dependencies = ["activesupport" "dry-types" "mustermann-grape" "rack" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v3akcpm7wq13jy2p31igc2xqj2k9qs7h2r7hsx4j7gih0z6fn9x";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.4.0";
  };
  grape_logging = {
    dependencies = ["grape" "rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ryg7m4nfszkcfiyl8wmicnlzihpvg6i1jh438ibpwnrs2djqkv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.0.0";
  };
  gravatar_image_tag = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kzx81y56kdady6yv77byh15yy5riwbs0d5r2gki3ds6m3z30mpb";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.0";
  };
  grids = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/grids;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  hana = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03cvrv2wl25j9n4n509hjvqnmwa60k92j741b64a1zjisr1dn9al";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.7";
  };
  hashdiff = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lbw8lqzjv17vnwb9vy5ki4jiyihybcc5h2rmcrqiz1xa6y9s1ww";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.1";
  };
  hashery = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.2";
  };
  hashie = {
    dependencies = ["logger"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w1qrab701d3a63aj2qavwc2fpcqmkzzh1w2x93c88zkjqc4frn2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.1.0";
  };
  highline = {
    dependencies = ["reline"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jmvyhjp2v3iq47la7w6psrxbprnbnmzz0hxxski3vzn356x7jv7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.1.2";
  };
  html-pipeline = {
    dependencies = ["activesupport" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "180kjksi0sdlqb0aq0bhal96ifwqm25hzb3w709ij55j51qls7ca";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.14.3";
  };
  htmlbeautifier = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrqvgja3pbmz4v27zc5ir58sk4mv177nq7hlssy2smawbvhhgdl";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.4.3";
  };
  htmldiff = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "188kw5694rhndd69dpzi8ygi50sx6s2ig9jl6756racfif60cvd9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.0.1";
  };
  htmlentities = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.3.4";
  };
  http-2 = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h7d2lvl74jr8qv01csyjy981c67jvp9yl4iqhhvaq7w0c1b874c";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.2";
  };
  "http_parser.rb" = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yh924g697spcv4hfigyxgidhyy6a7b9007rnac57airbcadzs4s";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.8.1";
  };
  httpx = {
    dependencies = ["http-2"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12if78kjp46wpl4f83lf8p66gx5m16zfpmlscjgq6y1baywi2jhv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.6.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1994i044vdmzzkyr76g8rpl1fq1532wf0sb21xg5r1ilj5iphmr8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.14.8";
  };
  i18n-js = {
    dependencies = ["glob" "i18n"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m8k77hkbyci3vdlaj8z0fkw733ycmvxa1srbi4qr9lg5wvhsfb1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.2.4";
  };
  i18n-tasks = {
    dependencies = ["activesupport" "ast" "erubi" "highline" "i18n" "parser" "prism" "rails-i18n" "rainbow" "ruby-progressbar" "terminal-table"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yk3lgzmym02bvpqhvccrfjvnkyqh35idcqwcqq3yqiawm4vmksd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.2";
  };
  icalendar = {
    dependencies = ["base64" "ice_cube" "logger" "ostruct"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r77iy9q5mvsplla88mgvxi27xjbll6svynikbr53mdfa32mdzzc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.12.1";
  };
  ice_cube = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gpwlpshsjlld53h1f999p0azd9jdlgmhbswa19wqjjbv9fv9pij";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.17.0";
  };
  ice_nine = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.2";
  };
  inline_svg = {
    dependencies = ["activesupport" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03x1z55sh7cpb63g46cbd6135jmp13idcgqzqsnzinbg4cs2jrav";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.10.0";
  };
  interception = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01vrkn28psdx1ysh5js3hn17nfp1nvvv46wc1pwqsakm6vb1hf55";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5";
  };
  io-console = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k0lk3pwadm2myvpg893n8jshmrf2sigrd4ki15lymy7gixaxqyn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.8.2";
  };
  irb = {
    dependencies = ["pp" "prism" "rdoc" "reline"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bishrxfn2anwlagw8rzly7i2yicjnr947f48nh638yqjgdlv30n";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.17.0";
  };
  iso8601 = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18js898rhh6byp0znvchiv6mcxi5l8v3v0bj2ddajpxynwajp319";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.13.0";
  };
  jmespath = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.6.2";
  };
  job-iteration = {
    dependencies = ["activejob"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h66sqjsa14kn0wa8pwpagmihsqky4lz0j6m7sf6w3vm2xs0ar01";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.12.0";
  };
  json = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b888h9v2y4aasi9aapxqimiaj1i1csk56l22dczigs8kv2zv56x";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.19.1";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "base64" "bindata" "faraday" "faraday-follow_redirects"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k64mp59jlbqd5hyy46pf93s3yl1xdngfy8i8flq2hn5nhk91ybg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.17.0";
  };
  json-schema = {
    dependencies = ["addressable"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bq393nrxa7hmphc3li8idgxdnb5hwgj15d0q5qsh4l5g1qvrnm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.3.1";
  };
  json_schemer = {
    dependencies = ["bigdecimal" "hana" "regexp_parser" "simpleidn"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15p31bq932bfpsi1wgrkgwm71l7z1h1w53q6vl44w6kjrr6gn09g";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.5.0";
  };
  json_spec = {
    dependencies = ["multi_json" "rspec"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03yiravv6q8lp37rip2i25w2qd63mwwi4jmw7ymf51y7j9xbjxvs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.5";
  };
  jwt = {
    dependencies = ["base64"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dfm4bhl4fzn076igh0bmh2v1vphcrxdv6ldc46hdd3bkbqr2sdg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.1.2";
  };
  ladle = {
    dependencies = ["open4"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p4hv85nrcqg59hbcxm14d98wbk0smdsdljppx48sycc21j6jn78";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.1";
  };
  language_server-protocol = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k0311vah76kg5m6zr7wmkwyk5p2f9d9hyckjpn3xgr83ajkj7px";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.17.0.5";
  };
  launchy = {
    dependencies = ["addressable" "childprocess" "logger"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17h522xhwi5m4n6n9m22kw8z0vy8100sz5f3wbfqj5cnrjslgf3j";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.1.1";
  };
  lefthook = {
    gem_platform = "ruby";
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dpmygy7h8yyp5ml865sbaxjf3jn9qbakakxq226agyvpagy8k0v";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.1";
  };
  letter_opener = {
    dependencies = ["launchy"];
    gem_platform = "ruby";
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cnv3ggnzyagl50vzs1693aacv08bhwlprcvjp8jcg2w7cp3zwrg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.10.0";
  };
  letter_opener_web = {
    dependencies = ["actionmailer" "letter_opener" "railties" "rexml"];
    gem_platform = "ruby";
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q4qfi5wnn5bv93zjf10agmzap3sn7gkfmdbryz296wb1vz1wf9z";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.0.0";
  };
  lint_roller = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.0";
  };
  listen = {
    dependencies = ["logger" "rb-fsevent" "rb-inotify"];
    gem_platform = "ruby";
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ln9c0vx165hkfbn2817qw4m6i77xcxh6q0r5v6fqfhlcbdq5qf6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.10.0";
  };
  lobby_boy = {
    dependencies = ["omniauth" "omniauth-openid-connect" "rails"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wl105faijn0pl6i8gcqwaw5d9wwczvvhdzinf71bvra0lybnq4l";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.3";
  };
  logger = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.7.0";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qcsvh9k4c0cp6agqm9a8m4x2gg7vifryqr7yxkg2x9ph9silds2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.14.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rk0n13c9nmk8di2x5gqk5r04vf8bkp7ff6z0b44wsmc7fndfpnz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.25.0";
  };
  lookbook = {
    dependencies = ["activemodel" "css_parser" "htmlbeautifier" "htmlentities" "marcel" "railties" "redcarpet" "rouge" "view_component" "yard" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z6dchw3f446dgdsn27z1gwjj23mbsnl0d26qi9va5crvqxnj6n1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.3.14";
  };
  mail = {
    dependencies = ["logger" "mini_mime" "net-imap" "net-pop" "net-smtp"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ha9sgkfqna62c1basc17dkx91yk7ppgjq32k4nhrikirlz6g9kg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.9.0";
  };
  marcel = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vhb1sbzlq42k2pzd9v0w5ws4kjx184y8h4d63296bn57jiwzkzx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.0";
  };
  markly = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07jmm2cr4yhcci4af1vgxkgxmrqgrhxbjhxsgycwsknxsijyknk5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.15.2";
  };
  matrix = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nscas3a4mmrp1rc07cdjlbbpb2rydkindmbj3v3z5y1viyspmd0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.3";
  };
  mcp = {
    dependencies = ["json-schema"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1izi2hyyifn8m5b9s1yj8v1d4a453mrhga8yk06ssawmssapi5ps";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.7.1";
  };
  md_to_pdf = {
    dependencies = ["base64" "bigdecimal" "color_conversion" "front_matter_parser" "json-schema" "markly" "matrix" "nokogiri" "prawn" "prawn-table" "text-hyphen" "ttfunk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "6c565541bfa390c58d90d49aa9b487777704fc66";
      sha256 = "0z7cj80jm7cpw0z7xbxcpsz7i2y561iccar0az36k8rcv6lkkph5";
      type = "git";
      url = "https://github.com/opf/md-to-pdf";
    };
    target_platform = "ruby";
    version = "0.2.5";
  };
  messagebird-rest = {
    dependencies = ["jwt"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "176m75m0bxmq9c8aa3b7wmn34sybq8k79l7s46h4lpixpbpw2k6s";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.0.0";
  };
  meta-tags = {
    dependencies = ["actionpack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kshxlw5nfshcgnh6jz7nfcf98yay739qrfxrcbrg1j0f51xbsj1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.22.3";
  };
  method_source = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.0";
  };
  mime-types = {
    dependencies = ["logger" "mime-types-data"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.7.0";
  };
  mime-types-data = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bradmf21c9g4z6f3hvqmnf6i2sbgp0630y2j5rq8a7h79lksdal";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2026.0203";
  };
  mini_magick = {
    dependencies = ["logger"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i2ilgjfjqc6sw4cwa4g9w3ngs41yvvazr9y82vapp5sfvymsf99";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.3.1";
  };
  mini_mime = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.5";
  };
  mini_portile2 = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.8.9";
  };
  minitest = {
    dependencies = ["drb" "prism"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gdwmn2d4sznjdxyl3kz7hr95mvdgm38fk1vd0s63k3fdyamfvnv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.0.2";
  };
  msgpack = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.8.0";
  };
  multi_json = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1drisvysgvnjlz49a0qcbs294id6mvj3i8iik5rvym68ybwfzvvs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.19.1";
  };
  mustermann = {
    dependencies = ["ruby2_keywords"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ma2fmxlm6i7lih4mc3har2fzsbj1pl4hhva65kljf6nfvdryl5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.0.4";
  };
  mustermann-grape = {
    dependencies = ["mustermann"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iaqlj7kjm5dd207gxcwi3nsjs616yqc08y0whfg1j04c2c8l9cd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.0";
  };
  my_page = {
    dependencies = ["grids"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/my_page;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  net-http = {
    dependencies = ["uri"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15k96fj6qwbaiv6g52l538ass95ds1qwgynqdridz29yqrkhpfi5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.1";
  };
  net-imap = {
    dependencies = ["date" "net-protocol"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bgjhb65r1bl52wdym6wpbb0r3j7va8s44grggp0jvarfvw7bawv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.3";
  };
  net-ldap = {
    dependencies = ["base64" "ostruct"];
    gem_platform = "ruby";
    groups = ["ldap"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wjkrvcwnxa6ggq0nfz004f1blm1c67fv7c6614sraak0wshn25j";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.20.0";
  };
  net-pop = {
    dependencies = ["net-protocol"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = ["timeout"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a32l4x73hz200cm587bc29q8q9az278syw3x6fkc9d1lv5y0wxa";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = ["net-protocol"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.1";
  };
  nio4r = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18fwy5yqnvgixq3cn0h63lm8jaxsjjxkmj8rhiv8wpzv9271d43c";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.7.5";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lss1nh526n3h1qsig2kjchi8vlsjwc8pdjpplm1f2yz6rzk52sr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.19.1";
  };
  oj = {
    dependencies = ["bigdecimal" "ostruct"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kdjl69vg6103dmiv2kqz7cssvd14spv4l521x6gbzp8qg528csd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.16.15";
  };
  okcomputer = {
    dependencies = ["benchmark"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqy9z5j15w2g0sr6ydk9krwn9rqas30fzs05391cj23d3kp1xvx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.19.1";
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "7eb21563ba047ef86d71f099975587b5ec88f9c9";
      sha256 = "1wfgqf5kxr7l2jyln3f2glzcpiqxqw0f3fn6fk96bcn4418wsvqh";
      type = "git";
      url = "https://github.com/opf/omniauth";
    };
    target_platform = "ruby";
    version = "1.9.2";
  };
  omniauth-openid-connect = {
    dependencies = ["addressable" "omniauth" "openid_connect"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "825d06235b64f6bc872bba709f1c2d48fd5cede4";
      sha256 = "1saz2a6f4n1nzxncccc1qc293ps8dybrbggribw18jbh5rvjw4ym";
      type = "git";
      url = "https://github.com/opf/omniauth-openid-connect.git";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  omniauth-openid_connect-providers = {
    dependencies = ["omniauth-openid-connect"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "c7e2498a8b093cfc5693d4960cae2e903a5e10cd";
      sha256 = "0zf64yfavsss240vpbasci5zxqa0dm4df39hlhq6n4040fzy6zlc";
      type = "git";
      url = "https://github.com/opf/omniauth-openid_connect-providers.git";
    };
    target_platform = "ruby";
    version = "0.2.0";
  };
  omniauth-saml = {
    dependencies = ["omniauth" "ruby-saml"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gdgjwiv60ladn48w3lrb7qr91dnyxvfbnnny87gzgni9wpy5p8k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.10.6";
  };
  op-clamav-client = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r1907b0rqyy62n8n7k32zayq00shzsgs32kvjijp2km25ynk3gj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.4.2";
  };
  open4 = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cgls3f9dlrpil846q0w7h66vsc33jqn84nql4gcqkk221rh7px1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.4";
  };
  openid_connect = {
    dependencies = ["activemodel" "attr_required" "faraday" "faraday-follow_redirects" "json-jwt" "rack-oauth2" "swd" "tzinfo" "validate_email" "validate_url" "webfinger"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009ibw3g0gzrbblxfq6261pw4xb12z6605g3ypgk6vm3nn2lw9ii";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.1";
  };
  openproject-auth_plugins = {
    dependencies = ["omniauth"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/auth_plugins;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-auth_saml = {
    dependencies = ["omniauth-saml"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/auth_saml;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-avatars = {
    dependencies = ["fastimage" "gravatar_image_tag"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/avatars;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-backlogs = {
    dependencies = ["acts_as_list"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/backlogs;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-bim = {
    dependencies = ["activerecord-import" "rubyzip"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/bim;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-boards = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/boards;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-calendar = {
    dependencies = ["icalendar"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/calendar;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-documents = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/documents;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-gantt = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/gantt;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-github_integration = {
    dependencies = ["openproject-webhooks"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/github_integration;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-gitlab_integration = {
    dependencies = ["openproject-webhooks"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/gitlab_integration;
      type = "path";
    };
    target_platform = "ruby";
    version = "3.0.0";
  };
  openproject-job_status = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/job_status;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-ldap_groups = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/ldap_groups;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-meeting = {
    dependencies = ["icalendar"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/meeting;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-octicons = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07kqcbs1glxndq7vkna1a8gc08q62k75h9a46vn1lkmdaqr3y99j";
      type = "gem";
    };
    target_platform = "ruby";
    version = "19.32.1";
  };
  openproject-octicons_helper = {
    dependencies = ["actionview" "openproject-octicons" "railties"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qgv7zzqnj78sr1ngj81lzmm645p242zmhkzdq0355f4ychaxkn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "19.32.1";
  };
  openproject-openid_connect = {
    dependencies = ["lobby_boy" "omniauth-openid_connect-providers" "openproject-auth_plugins"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/openid_connect;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-primer_view_components = {
    dependencies = ["actionview" "activesupport" "openproject-octicons" "view_component"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qjsssnpl0clhkkiv169hys0kk01vr2h6lmgpzjacvvfs9w1bmn3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.82.0";
  };
  openproject-recaptcha = {
    dependencies = ["recaptcha"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/recaptcha;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-reporting = {
    dependencies = ["costs"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/reporting;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-storages = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/storages;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-team_planner = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/team_planner;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-token = {
    dependencies = ["activemodel"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15ph5jy6hwqy1nwcpbggg9yx8w3vr04rwgnnl4psi4lx4vvvy708";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.8.2";
  };
  openproject-two_factor_authentication = {
    dependencies = ["aws-sdk-sns" "messagebird-rest" "rotp" "webauthn"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/two_factor_authentication;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-webhooks = {
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/webhooks;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openproject-xls_export = {
    dependencies = ["spreadsheet"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/xls_export;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  openssl = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14gfk3j88gcfk2mzp4ingm7y1pq2nbnsgzkfvflwksfljgni2mqq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.0.0";
  };
  openssl-signature_algorithm = {
    dependencies = ["openssl"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "103yjl68wqhl5kxaciir5jdnyi7iv9yckishdr52s5knh9g0pd53";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.0";
  };
  opentelemetry-api = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kr1jyk67zn4axafcb2fji5b8xvr56hhfg2y33s5pnzjlr72dzfc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.7.0";
  };
  opentelemetry-common = {
    dependencies = ["opentelemetry-api"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b5k7qc81ln96ayba90hm6ww7qpk8y7lc1r2mphblmwx8y812wns";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.23.0";
  };
  opentelemetry-exporter-otlp = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types" "opentelemetry-api" "opentelemetry-common" "opentelemetry-sdk" "opentelemetry-semantic_conventions"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jj78y79mawj86v5g3kcz6k81izd0m0w47wyyk2br744swbvwn2k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.31.1";
  };
  opentelemetry-helpers-mysql = {
    dependencies = ["opentelemetry-api" "opentelemetry-common"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kssrgcm716blgn4qhhngp9xmzw1ng9y0xdw9m6x3g9512rc02fk";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.0";
  };
  opentelemetry-helpers-sql = {
    dependencies = ["opentelemetry-api"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y9p7xxn491pjdcb9n4m25lvpigr63ywflqw9lfd8vd1sqbq1c2b";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.0";
  };
  opentelemetry-helpers-sql-processor = {
    dependencies = ["opentelemetry-api" "opentelemetry-common"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x13ig8z9fabw5l3p5lrm0ad80qsibmx0cfw8z99n8c751x8s8zc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.0";
  };
  opentelemetry-instrumentation-action_mailer = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mqh8z6myff0j11zcnm34s1lc8qzmzzqdrhzk95y2sh6vdmqd143";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.1";
  };
  opentelemetry-instrumentation-action_pack = {
    dependencies = ["opentelemetry-instrumentation-rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wzj0xmivyx243slz526z54lqyhsiyzzrbha4szyxjl30xsdxyl4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.15.1";
  };
  opentelemetry-instrumentation-action_view = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z7s35vscxi0dsd588ggc41j3rzikslzrmlkk70snbb7bl0rk876";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.2";
  };
  opentelemetry-instrumentation-active_job = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "129ajjrxigl4pag1nlzbdv1js5bij4ll92i1ix50c3f24h9338df";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.10.1";
  };
  opentelemetry-instrumentation-active_model_serializers = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05ff7yxy2v96kslsqn1y68669is00798i9fgk9fy85vx2r21xs4g";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.24.0";
  };
  opentelemetry-instrumentation-active_record = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14kwks0130mrggk3irg4qvx5fmwk9gxv6w23dy6ryi50xqs3y20v";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.1";
  };
  opentelemetry-instrumentation-active_storage = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17p8zmfyigdqvgy3d1691ayzm6nj4q4nx2n3qk01f7wjakphz6zq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.1";
  };
  opentelemetry-instrumentation-active_support = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zf5kg2h9zgmrwnq7v7by2nyhkxa20gmi5nyqqrpwyaqf4v9isl2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.10.1";
  };
  opentelemetry-instrumentation-all = {
    dependencies = ["opentelemetry-instrumentation-active_model_serializers" "opentelemetry-instrumentation-anthropic" "opentelemetry-instrumentation-aws_lambda" "opentelemetry-instrumentation-aws_sdk" "opentelemetry-instrumentation-bunny" "opentelemetry-instrumentation-concurrent_ruby" "opentelemetry-instrumentation-dalli" "opentelemetry-instrumentation-delayed_job" "opentelemetry-instrumentation-ethon" "opentelemetry-instrumentation-excon" "opentelemetry-instrumentation-faraday" "opentelemetry-instrumentation-grape" "opentelemetry-instrumentation-graphql" "opentelemetry-instrumentation-grpc" "opentelemetry-instrumentation-gruf" "opentelemetry-instrumentation-http" "opentelemetry-instrumentation-http_client" "opentelemetry-instrumentation-httpx" "opentelemetry-instrumentation-koala" "opentelemetry-instrumentation-lmdb" "opentelemetry-instrumentation-mongo" "opentelemetry-instrumentation-mysql2" "opentelemetry-instrumentation-net_http" "opentelemetry-instrumentation-pg" "opentelemetry-instrumentation-que" "opentelemetry-instrumentation-racecar" "opentelemetry-instrumentation-rack" "opentelemetry-instrumentation-rails" "opentelemetry-instrumentation-rake" "opentelemetry-instrumentation-rdkafka" "opentelemetry-instrumentation-redis" "opentelemetry-instrumentation-resque" "opentelemetry-instrumentation-restclient" "opentelemetry-instrumentation-ruby_kafka" "opentelemetry-instrumentation-sidekiq" "opentelemetry-instrumentation-sinatra" "opentelemetry-instrumentation-trilogy"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r48zijdrwkrf0dvc9vdyavwq7l8f82jljk4irhj1wzv46riqskw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.90.1";
  };
  opentelemetry-instrumentation-anthropic = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pj8ba95k2x46x8miaqinj9psf0zs7qlkfppq2k8k4qqlr5rpg89";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.0";
  };
  opentelemetry-instrumentation-aws_lambda = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k1ksgyaix82bpll1pymqfia0f3c0y6nd841vpnwk6zy7hwn2c8s";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.0";
  };
  opentelemetry-instrumentation-aws_sdk = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qqim5n5mnp0n6lw4d0gh3dxhn4im8bf2iiyijxy4lfz9msix8k7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.0";
  };
  opentelemetry-instrumentation-base = {
    dependencies = ["opentelemetry-api" "opentelemetry-common" "opentelemetry-registry"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ysfv2x25svwl4yxrbgmjkwrlkylr7plci3jjb6wkim11zklak4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.25.0";
  };
  opentelemetry-instrumentation-bunny = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1195m9jaaax2p0h3bmnr7q7xi3g7x73np3iyqg8a2hjzibj89i0y";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.24.0";
  };
  opentelemetry-instrumentation-concurrent_ruby = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lniyy8yzmvz1mrh7az0yn94j4d9p0vvd6v0jgk9vi8042vxi6r2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.24.0";
  };
  opentelemetry-instrumentation-dalli = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bxw2ji4nzkkb1i9mkrdxxwbb6jjxwdgvjc1wbbyh2anai86cs52";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.29.0";
  };
  opentelemetry-instrumentation-delayed_job = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v63h38nkngac0c3bxc45bdjabjs17m0vqdv5dyarndzs885pws7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.25.1";
  };
  opentelemetry-instrumentation-ethon = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s1rkw02ycz91bcp90zbrjjcgim187ackq5h4x3i3irlbx5f7lmz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.27.0";
  };
  opentelemetry-instrumentation-excon = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fxmhgvj15w4ggamnzb3aic15nzgxwivpaj6cq9y2a031wb6wzix";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.27.0";
  };
  opentelemetry-instrumentation-faraday = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02w4157lmf5p9cjkxq35i5azcsskmrzg5vi09air1261sjbdq00w";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.31.0";
  };
  opentelemetry-instrumentation-grape = {
    dependencies = ["opentelemetry-instrumentation-rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "093nvx4zr7qgwi62y0haimca4z99ki0mpplbgdbn7dhmn09vxz5r";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  opentelemetry-instrumentation-graphql = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07qv80fq0n3rkw2fyd9wj5kjb4xqa6rw1j27h82zky17ahi5yid4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.31.2";
  };
  opentelemetry-instrumentation-grpc = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11xw3vr47k45d3byjbq5rr8h7833lp0xiq93zv8vqsgcsnqjpyjz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.1";
  };
  opentelemetry-instrumentation-gruf = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kfsb3gy0s1ninv698s024990n324n11d1wsgj21prqjwcvbw8gf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  opentelemetry-instrumentation-http = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kfafsrd6fx6w6ccwrkmn5q4jp4l86a1y13fs600fx347mcsjih9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.28.0";
  };
  opentelemetry-instrumentation-http_client = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03k96103fjz3pfjjj0wd42092psxxrdldmdj6hwnsfvd54hrlqva";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.27.0";
  };
  opentelemetry-instrumentation-httpx = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vgxngi5rhal8pn60lww4cg1l60xg9f6lnsqcl2nksnmnyf15vm4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.0";
  };
  opentelemetry-instrumentation-koala = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yf61djnr45a5mylixawq17bd00crfj0bcdj9fcx8kx6l984nclg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.23.0";
  };
  opentelemetry-instrumentation-lmdb = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jzmwlfdvaqapnmj9ll46hsymwas3ybn4405f97js97ahganck8y";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.25.0";
  };
  opentelemetry-instrumentation-mongo = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ylwgxh6syn79z7mg397hkqqz7fkc5h9k7s6ghpai3ljkxk8aifh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.25.0";
  };
  opentelemetry-instrumentation-mysql2 = {
    dependencies = ["opentelemetry-helpers-mysql" "opentelemetry-helpers-sql" "opentelemetry-helpers-sql-processor" "opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ydwf1afzqzcnx65nx4m2kb6b2aif2ikrgkkdq29xxgfsmbpk6xl";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.33.0";
  };
  opentelemetry-instrumentation-net_http = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1449gz1brzxd1wxqhaq3z1r752csgmqp6kjz7c20jsk4hxc7rbgp";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.27.0";
  };
  opentelemetry-instrumentation-pg = {
    dependencies = ["opentelemetry-helpers-sql" "opentelemetry-helpers-sql-processor" "opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m5ajycnnpj683bjphqjd2zqlcgxp641pvpi45hbb0jjsj5yg9k5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.35.0";
  };
  opentelemetry-instrumentation-que = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ys4k62dw3f45wd6236lap48fgq3lkmhm1jpii7s1xba3ws88yiv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.12.0";
  };
  opentelemetry-instrumentation-racecar = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0idq6n6k8ql10jldx3jf5g9p952labnd8hg8fzsn3dkgj08ncgw3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.1";
  };
  opentelemetry-instrumentation-rack = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xzk88iiiggx3kdfy5y75cb79cc5gn8jsl1vwg5n8w086s1vnb4y";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.29.0";
  };
  opentelemetry-instrumentation-rails = {
    dependencies = ["opentelemetry-instrumentation-action_mailer" "opentelemetry-instrumentation-action_pack" "opentelemetry-instrumentation-action_view" "opentelemetry-instrumentation-active_job" "opentelemetry-instrumentation-active_record" "opentelemetry-instrumentation-active_storage" "opentelemetry-instrumentation-active_support" "opentelemetry-instrumentation-concurrent_ruby"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vy93a3hpi8l8crljxwxzxwmvyf9gg1pff6dnpxl0c2ljmwdynbr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.39.1";
  };
  opentelemetry-instrumentation-rake = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vq118xmgp3lipccxn3hcxz71rjg9qlhdspacy5aqxc90wcx0szs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  opentelemetry-instrumentation-rdkafka = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fadamq0fy1bgmv2ia43ndji0pglbjzciic3bcxg16551lbbgpk";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.0";
  };
  opentelemetry-instrumentation-redis = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "001rd4ix10hja64y2arhpcd0hlmjilx7zlb4slmx4zaj3iyra8c7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.28.0";
  };
  opentelemetry-instrumentation-resque = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r85z37whl9z40hl224d09ipn53dw8vfsjaimrbxfg97svlxv7jm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.8.0";
  };
  opentelemetry-instrumentation-restclient = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kmx71jqhi3fnsgisch323l2zd6399xy2xn04c84lmjixy9rskjx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.26.0";
  };
  opentelemetry-instrumentation-ruby_kafka = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hjji7x52nix6h4yv6nl7i4wrbs4gd4qsh390qzblc769hgqjzi5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.24.0";
  };
  opentelemetry-instrumentation-sidekiq = {
    dependencies = ["opentelemetry-instrumentation-base"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1blpmqsn64p5zq94slcm8zh1rl09qzvgjypxm7kn4lvak5i5vj5b";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.28.1";
  };
  opentelemetry-instrumentation-sinatra = {
    dependencies = ["opentelemetry-instrumentation-rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09kz6j3w2j2s0kxgyj2xk6vdc1r7z7wa3b1kssniqhhab26dc4cz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.28.0";
  };
  opentelemetry-instrumentation-trilogy = {
    dependencies = ["opentelemetry-helpers-mysql" "opentelemetry-helpers-sql" "opentelemetry-helpers-sql-processor" "opentelemetry-instrumentation-base" "opentelemetry-semantic_conventions"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w5yxhqlhxrhc9v72x7l4jbm91hl6pfrpqx9higlxf09zk9fm7gh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.66.0";
  };
  opentelemetry-registry = {
    dependencies = ["opentelemetry-api"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13wns85c08hjy7gqqjxqad9pp5shp0lxskrssz0w3si9mazscgwh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.0";
  };
  opentelemetry-sdk = {
    dependencies = ["opentelemetry-api" "opentelemetry-common" "opentelemetry-registry" "opentelemetry-semantic_conventions"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06jjh25s94lv94ljgbq13baqgnkccdsvzsw6xg54vwldpr4rjwa3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.10.0";
  };
  opentelemetry-semantic_conventions = {
    dependencies = ["opentelemetry-api"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05znn2iijg1qli52m09bgyq4b74nfs5nwgz2z73sllvqpiyn1cf1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.36.0";
  };
  optimist = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kp3f8g7g7cbw5vfkmpdv71pphhpcxk3lpc892mj9apkd7ys1y4c";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.1";
  };
  os = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.4";
  };
  ostruct = {
    gem_platform = "ruby";
    groups = ["default" "ldap" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.3";
  };
  overviews = {
    dependencies = ["grids"];
    gem_platform = "ruby";
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/overviews;
      type = "path";
    };
    target_platform = "ruby";
    version = "1.0.0";
  };
  ox = {
    dependencies = ["bigdecimal"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rhv8qdnm3s34yvsvmrii15f2238rk3psa6pq6x5x367sssfv6ja";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.14.23";
  };
  pagy = {
    dependencies = ["json" "yaml"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vi7pp7d4f9grc2bgl6q6kwzjxsmizf2k3jciwz8i213ly6pq5ka";
      type = "gem";
    };
    target_platform = "ruby";
    version = "43.2.9";
  };
  paper_trail = {
    dependencies = ["activerecord" "request_store"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "118w09wvy4s7jykv5b7j5ac9nkx158g853lh2mqclx1q3l344a0w";
      type = "gem";
    };
    target_platform = "ruby";
    version = "17.0.0";
  };
  parallel = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c719bfgcszqvk9z47w2p8j2wkz5y35k48ywwas5yxbbh3hm3haa";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.27.0";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w2xfc3jrj92w78yd4413s48lkjf3mjw47x4yw8b4qhld664a1fz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.10.1";
  };
  parser = {
    dependencies = ["ast" "racc"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1256ws3w3gnfqj7r3yz2i9y1y7k38fhjphxpybkyb4fds8jsgxh6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.3.10.1";
  };
  pdf-core = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fz0yj4zrlii2j08kaw11j769s373ayz8jrdhxwwjzmm28pqndjg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.0";
  };
  pdf-inspector = {
    dependencies = ["pdf-reader"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g853az4xzgqxr5xiwhb76g4sqmjg4s79mm35mp676zjsrwpa47w";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.0";
  };
  pdf-reader = {
    dependencies = ["Ascii85" "afm" "hashery" "ruby-rc4" "ttfunk"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kk8f1f5kkdwsbskv0vikcwx5xaivv19y9zl97x1fcaam23akihq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.15.1";
  };
  pg = {
    gem_platform = "ruby";
    groups = ["postgres"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16caca7lcz5pwl82snarqrayjj9j7abmxqw92267blhk7rbd120k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.6.3";
  };
  plaintext = {
    dependencies = ["activesupport" "nokogiri" "rubyzip"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbh7rrcahfg5cp273dvrlm4va6cr4p49sarsjc8inc4xr9334iv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.7";
  };
  pp = {
    dependencies = ["prettyprint"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xlxmg86k5kifci1xvlmgw56x88dmqf04zfzn7zcr4qb8ladal99";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.3";
  };
  prawn = {
    dependencies = ["pdf-core" "ttfunk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9avv2rprsjisdk137s9ljr05r7ajhm78hxa1vjsv0jyx22f1l2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.4.0";
  };
  prawn-table = {
    dependencies = ["prawn"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxd6qmxqwl850icp18wjh5k0s3amxcajdrkjyzpfgq0kvilcv9k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.2";
  };
  prettyprint = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.0";
  };
  prism = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.9.0";
  };
  prometheus-client-mmap = {
    dependencies = ["base64" "bigdecimal" "logger" "rb_sys"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05q1mwfrqq23k33d20f5s69gsdh4fpkgj0jymr20zbhrdj6vj7in";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.5.0";
  };
  pry = {
    dependencies = ["coderay" "method_source" "reline"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kh5nv8v74k1ccy6gc7nd04aaf1cjkbk7g8pwy2izvcqaq36jv6p";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.16.0";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dyi2dr5zp08s4bp9ik44v84wc0kdvinmcy7six0lfd8x150jkjr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.12.0";
  };
  pry-rails = {
    dependencies = ["pry"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0garafb0lxbm3sx2r9pqgs7ky9al58cl3wmwc0gmvmrl9bi2i7m6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.11";
  };
  pry-rescue = {
    dependencies = ["interception" "pry"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nx6mf97vv11bgy2giljgwds8rjj8kw0qyc6zn3varlqdm8gsnwq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.6.0";
  };
  psych = {
    dependencies = ["date" "stringio"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x0r3gc66abv8i4dw0x0370b5hrshjfp6kpp7wbp178cy775fypb";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.3.1";
  };
  public_suffix = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mx84s7gn3xabb320hw8060v7amg6gmcyyhfzp0kawafiq60j54i";
      type = "gem";
    };
    target_platform = "ruby";
    version = "7.0.2";
  };
  puffing-billy = {
    dependencies = ["addressable" "cgi" "em-http-request" "em-synchrony" "eventmachine" "eventmachine_httpserver" "http_parser.rb" "multi_json"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g48c3hw4wf9118sq9m0kd9z034ph3dm6ld12j4d9y9zrkif4vrp";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.0.3";
  };
  puma = {
    dependencies = ["nio4r"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a3jd9qakasizrf7dkq5mqv51fjf02r2chybai2nskjaa6mz93mz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "7.2.0";
  };
  puma-plugin-statsd = {
    dependencies = ["puma"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12yhv8dnh8pzmczpc4g71a8sa66f5d9a7w961vn0ck9z4fkl7wh4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.7.0";
  };
  raabro = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10m8bln9d00dwzjil1k42i5r7l82x25ysbi45fwyv4932zsrzynl";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.4.0";
  };
  racc = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.8.1";
  };
  rack = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hj5yq200wlq1clpdvh44pqwllbxll0k3gjajxnrcn95hxzhpky5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.22";
  };
  rack-attack = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wpcxspprm187k6mch9fxhaaq1a3s9bzybd2fdaw1g45pzg9yjgj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.8.0";
  };
  rack-cors = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ysmn14pdf2wyr7agm0qvvr9pzcgyf39w4yvk2n05w9k4alwpa1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.2";
  };
  rack-mini-profiler = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y1x4rc7bz8x3zn8p6g21rw6ivbjml6a2vl9dhchiy8i6b110n28";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.0.1";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects" "json-jwt" "rack"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cn6a9v8nry9fx4zrzp1xakfp2n5xv5075j90q56m20k7zvjrq23";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.3.0";
  };
  rack-protection = {
    dependencies = ["base64" "rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zzvivmdb4dkscc58i3gmcyrnypynsjwp6xgc4ylarlhqmzvlx1w";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  rack-session = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xhxhlsz6shh8nm44jsmd9276zcnyzii364vhcvf0k8b8bjia8d0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.2";
  };
  rack-test = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qy4ylhcfdn65a5mz2hly7g9vl0g13p5a0rmm6sc0sih5ilkcnh0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  rack-timeout = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nc7kis61n4q7g78gxxsxygam022glmgwq9snydrkjiwg7lkfwvm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.7.0";
  };
  rack_session_access = {
    dependencies = ["builder" "rack"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0swd35lg7qmqhc3pglvsanq2indnvw360m8qxfxwqabl0br9isq3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.0";
  };
  rackup = {
    dependencies = ["rack" "webrick"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jf2ncj2nx56vh96hh2nh6h4r530nccxh87z7c2f37wq515611ms";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.1";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15bxpa0acs5qc9ls4y1i21cp6wimkn5swn81kxmp1a6z4cdhcsah";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "151f303jcvs8s149mhx2g5mn67487x0blrf9dzl76q1nb7dlh53l";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "minitest" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07awj8bp7jib54d0khqw391ryw8nphvqgw4bb12cl4drlx9pkk4a";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.3.0";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "128y5g3fyi8fds41jasrr4va1jrs7hcamzklk1523k7rxb64bc98";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.7.0";
  };
  rails-i18n = {
    dependencies = ["i18n" "railties"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wvcbdslb5gfvs9dw7kscd9da3xfyr3mdh1w4a28vwmy19ngvmaj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "irb" "rackup" "rake" "thor" "tsort" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mc0kz2vhld3gn5m91ddy98qfnrbk765aznh8vy6hxjgdgkyr28j";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.1.2";
  };
  rainbow = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.1.1";
  };
  rake = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "175iisqb211n0qbfyqd8jz2g01q6xj038zjf4q0nm8k6kz88k7lc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "13.3.1";
  };
  rake-compiler-dock = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hpq52ab86s70yv5hk56f0z14izhh59af95nlv73bsrksln1zdga";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.11.0";
  };
  rb-fsevent = {
    gem_platform = "ruby";
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    gem_platform = "ruby";
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.1";
  };
  rb_sys = {
    dependencies = ["rake-compiler-dock"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rvshyirm32lzf2sggcrhvz5hi828s3rznmkchvzgshjgdapcd2i";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.124";
  };
  rbtrace = {
    dependencies = ["ffi" "msgpack" "optimist"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gwjrdawjv630xhzwld9b0vrh391sph255vxshpv36jx60pjjcn4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.3";
  };
  rbtree3 = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnq4rpr1pgmvghpr0cz66svm3dih3hnah2gvxq1njd553bylq5b";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.7.1";
  };
  rdoc = {
    dependencies = ["erb" "psych" "tsort"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14iiyb4yi1chdzrynrk74xbhmikml3ixgdayjma3p700singfl46";
      type = "gem";
    };
    target_platform = "ruby";
    version = "7.2.0";
  };
  recaptcha = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nvsa14nd4sgx7m0n2xas8y6jiid5wcqr0ka1jgkm6cvpb7fj0z0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.21.1";
  };
  redcarpet = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iglapqs4av4za9yfaac0lna7s16fq2xn36wpk380m55d8792i6l";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.6.1";
  };
  redis = {
    dependencies = ["redis-client"];
    gem_platform = "ruby";
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpsh5dbvybsa8qnv4dg11a6f2zn4sndarf7pk4iaayjgaspbrmm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.4.1";
  };
  redis-client = {
    dependencies = ["connection_pool"];
    gem_platform = "ruby";
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "083i9ig39bc249mv24nsb2jlfwcdgmp9kbpy5ph569nsypphpmrs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.26.4";
  };
  regexp_parser = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "192mzi0wgwl024pwpbfa6c2a2xlvbh3mjd75a0sakdvkl60z64ya";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.11.3";
  };
  reline = {
    dependencies = ["io-console"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d8q5c4nh2g9pp758kizh8sfrvngynrjlm0i1zn3cnsnfd4v160i";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.3";
  };
  representable = {
    dependencies = ["declarative" "trailblazer-option" "uber"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kms3r6w6pnryysnaqqa9fsn0v73zx1ilds9d1c565n3xdzbyafc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  request_store = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jw89j9s5p5cq2k7ffj5p4av4j4fxwvwjs1a4i9g85d38r9mvdz1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.7.0";
  };
  responders = {
    dependencies = ["actionpack" "railties"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0npm7nyld47f516idsmslfhypp7gm3jcl90ml5c68vz11anddhl9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  retriable = {
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.1.2";
  };
  rexml = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.4.4";
  };
  rinku = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zcdha17s1wzxyc5814j6319wqg33jbn58pg6wmxpws36476fq4b";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.6";
  };
  roar = {
    dependencies = ["representable"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "024xjaidpll8d80xqlwm7pgf1hypc5b0sv618svmyyn5g75d3d4d";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.0";
  };
  rotp = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m48hv6wpmmm6cjr6q92q78h1i610riml19k5h1dil2yws3h1m3m";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.3.0";
  };
  rouge = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fd77qcz603mli4lyi97cjzkv02hsfk60m495qv5qcn02mkqk9fv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.7.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.13.5";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "071bqrk2rblk3zq3jk1xxx0dr92y0szi5pxdm8waimxici706y89";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.13.7";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hcxnxlcg6da7fy6s1y4k1r8cq36w994h0cai5yk2007l7kl195h";
      type = "gem";
    };
    target_platform = "ruby";
    version = "8.0.3";
  };
  rspec-retry = {
    dependencies = ["rspec-core"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n6qc0d16h6bgh1xarmc8vc58728mgjcsjj8wcd822c8lcivl0b1";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.2";
  };
  rspec-support = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.13.7";
  };
  rspec-wait = {
    dependencies = ["rspec"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04m9nmk55layv26s5ldara5vbn45sjyx9phhzhk3sp9j74994pw6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.2";
  };
  rubocop = {
    dependencies = ["json" "language_server-protocol" "lint_roller" "parallel" "parser" "rainbow" "regexp_parser" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pxzipl8a1bv62jdfykh7j4ymdr4aiffjvwsny6drwv886jwx4jn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.84.2";
  };
  rubocop-ast = {
    dependencies = ["parser" "prism"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zbikzd6237fvlzjfxdlhwi2vbmavg1cc81y6cyr581365nnghs9";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.49.0";
  };
  rubocop-capybara = {
    dependencies = ["lint_roller" "rubocop"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "030wymq0jrblrdswl1lncj60dhcg5wszz6708qzsbziyyap8rn6f";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.22.1";
  };
  rubocop-factory_bot = {
    dependencies = ["lint_roller" "rubocop"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jzhj9fi1h9rh7z2j6m78hl7c3av36fpacg12wrifi24281gq5sb";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.28.0";
  };
  rubocop-openproject = {
    dependencies = ["rubocop"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a580684xlw96ih5r2h5mvwv88x2pzhvwcibvijwz8phgrp4jm4m";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.0";
  };
  rubocop-performance = {
    dependencies = ["lint_roller" "rubocop" "rubocop-ast"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d0qyyw1332afi9glwfjkb4bd62gzlibar6j55cghv8rzwvbj6fd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.26.1";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "lint_roller" "rack" "rubocop" "rubocop-ast"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llsxc8wm2pq8glpv5mczd1h36fazbri3wwrh7dfqra80a4pklqh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.34.3";
  };
  rubocop-rspec = {
    dependencies = ["lint_roller" "rubocop"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qjmvcpk6qwxjdh3w5smr2n7c1glxsdzpv5fi7bkg0j034v0m9wg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.9.0";
  };
  rubocop-rspec_rails = {
    dependencies = ["lint_roller" "rubocop" "rubocop-rspec"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004i5a4iww7l3vpaxl70ijypmi321afrslsgadbvksznf8f683aa";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.32.0";
  };
  ruby-duration = {
    dependencies = ["activesupport" "i18n" "iso8601"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "114p0rbg7lklznvcjiqyf8xjm17c3s7yvclgb80pl1l5vyqi6ggb";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.3";
  };
  ruby-next-core = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11lvg530sgxyr7swyv2vsf49fb1s1xd89wgp0axyqv0qnl5x19zn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.0";
  };
  ruby-ole = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wnblgzz0fax0746yd4i8z16fpsjr6r6yv18l4sjnykr5bfi13ap";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.13.1";
  };
  ruby-prof = {
    dependencies = ["base64"];
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h23zjwma8car8jpq7af8gw39qi88rn24mass7r13ripmky28117";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.7.2";
  };
  ruby-progressbar = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.13.0";
  };
  ruby-rc4 = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.5";
  };
  ruby-saml = {
    dependencies = ["nokogiri" "rexml"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01wi1csw4kjmlxmd1igx5hj2wrwkslay1xamg4cv8l7imr27l3hv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.18.1";
  };
  ruby2_keywords = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.0.5";
  };
  rubytree = {
    dependencies = ["json"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dkfj3pxl1mv90dmfsl8604dc7xcrbk655kxnn1ka58lv0gdq4p3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  rubyzip = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05an0wz87vkmqwcwyh5rjiaavydfn5f4q1lixcsqkphzvj7chxw5";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.4.1";
  };
  safety_net_attestation = {
    dependencies = ["jwt"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1apjjd99bqsc22bfq66j27dp4im0amisy619hr9qbghdapfh3kf8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  sanitize = {
    dependencies = ["crass" "nokogiri"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "111r4xdcf6ihdnrs6wkfc6nqdzrjq0z69x9sf83r7ri6fffip796";
      type = "gem";
    };
    target_platform = "ruby";
    version = "7.0.0";
  };
  scimitar = {
    dependencies = ["rails"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1acsmih7cv7xc1ahfbcg8ibiih5i0rsa3j2n3pk7h3fmxcr93clk";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.14.0";
  };
  securerandom = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cd0iriqfsf1z91qg271sm88xjnfd92b832z49p1nd542ka96lfc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.1";
  };
  selenium-devtools = {
    dependencies = ["selenium-webdriver"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i3x862ch014hdlsscwh5skj6ah277vmydm0dsjr6jh7w5jb7s13";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.143.0";
  };
  selenium-webdriver = {
    dependencies = ["base64" "logger" "rexml" "rubyzip" "websocket"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nsys7ghl99zn2n4zjw3bi697qqnm6pmmi7aaafln79whnlpmvqn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.40.0";
  };
  semantic = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qy1s2kpf9z2p99v23b126ij424yamxviprz59wbp3hrb67v9nrw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.6.1";
  };
  shoulda-context = {
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d1clcp92jv8756h09kbc55qiqncn666alx0s83za06q5hs4bpvs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.0";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xwwfj48d6mpc66lhl4yabnjazpf47wqg9n1i9na7q0h9isdigxl";
      type = "gem";
    };
    target_platform = "ruby";
    version = "7.0.1";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nydm087m5c3j85gvzvz30w1qb9pl2lzpznw746jha29ybxyj5yn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.21.0";
  };
  simpleidn = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a9c1mdy12y81ck7mcn9f9i2s2wwzjh1nr92ps354q517zq9dkh8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.3";
  };
  smart_properties = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jrqssk9qhwrpq41arm712226vpcr458xv6xaqbk8cp94a0kycpr";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.17.0";
  };
  spreadsheet = {
    dependencies = ["bigdecimal" "logger" "ruby-ole"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lwjqmmr01c3sh9r8hi0b778akxm9pazpxq9h59472ywvzrxdvqa";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.3.4";
  };
  spring = {
    gem_platform = "ruby";
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rsw917r4k1lc1krhw57szj8phbzdpj8swywvk79b1fwv2n1pxi2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.4.2";
  };
  spring-commands-rspec = {
    dependencies = ["spring"];
    gem_platform = "ruby";
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0svpq3md1pjz5drpa5pxwg8nk48wrshq8lckim4x3nli7ya0k2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.4";
  };
  spring-commands-rubocop = {
    dependencies = ["spring"];
    gem_platform = "ruby";
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hcharzqmi0dpy9vxs21fl0mpmfmcsgbdgq4dyc8mbi7i8n7lrry";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.0";
  };
  sprockets = {
    dependencies = ["base64" "concurrent-ruby" "rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10ykzsa76cf8kvbfkszlvbyn4ckcx1mxjhfvwxzs7y28cljhzhkj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.7.5";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17hiqkdpcjyyhlm997mgdcr45v35j5802m5a979i5jgqx5n8xs59";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.5.2";
  };
  ssrf_filter = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nx0vap3mrh62v37lr45h77ipp4li8x77v4kxr1psh3yhda9zx03";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.8";
  };
  stackprof = {
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "014s1zxlxcw35shislar3y1i3mqa0c6gh3m21js14q1q5zharhjf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.28";
  };
  statesman = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0km82ypvhl818qzdhwixhp3bird059rafdgk6gj849pxdm37ijry";
      type = "gem";
    };
    target_platform = "ruby";
    version = "13.1.0";
  };
  store_attribute = {
    dependencies = ["activerecord"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f7mjr20wga7s0p6ivjcgh0qvl8vhq445bypw28lryyk04f62lyy";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.1";
  };
  stringex = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i19x7snfbw0fsfjifvg57b8gm283hhdympj8qb1wym4nb985cy7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.8.6";
  };
  stringio = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q92y9627yisykyscv0bdsrrgyaajc2qr56dwlzx7ysgigjv4z63";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  structured_warnings = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q5ldvpsnri5igdfkyg5gs1rbwqaizwv7cgjhxcsqvb9mdcljl6";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.5.0";
  };
  svg-graph = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fji14c525hvql7jw04zphm8n44d4vvbbnnzmwwnaph50dj8ca7r";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.2";
  };
  swd = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m86fzmwgw0vc8p6fwvnsdbldpgbqdz9cbp2zj9z06bc4jjf5nsc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.3";
  };
  sys-filesystem = {
    dependencies = ["ffi"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cshw6aqq7ws4sbl0b4g50fgvffykbchjpnzanmg1f9lly85i6bg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.5.5";
  };
  table_print = {
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jxmd1yg3h0g27wzfpvq1jnkkf7frwb5wy9m4f47nf4k3wl68rj3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.5.7";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lh18gwpksk25sbcjgh94vmfw2rz0lrq61n7lwp1n9gq0cr7j17m";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.0.0";
  };
  test-prof = {
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xl51w3g37isibhs2l3s6a6f5ygg31bkx3n41rvv6i9pgpxkjn0q";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.5.2";
  };
  text-hyphen = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01js0wxz84cc5hzxgqbcqnsa0y6crhdi6plmgkzyfm55p0rlajn4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.5.0";
  };
  thor = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wsy88vg2mazl039392hqrcwvs5nb9kq8jhhrrclir2px1gybag3";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.5.0";
  };
  thread_safe = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.6";
  };
  timecop = {
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1syq1hdxq13ggy5c4sfk2378kzc1cgxdyv6b8c86pkydaz74bfhj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.10";
  };
  timeout = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bz11pq7n1g51f50jqmgyf5b1v64p1pfqmy5l21y6vpr37b2lwkd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.6.0";
  };
  tpm-key_attestation = {
    dependencies = ["bindata" "openssl" "openssl-signature_algorithm"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gqr27hrmg35j7kcb6c2cx3xvkqfs42zpp9jcqw0mzbs79jy9m3z";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.14.1";
  };
  trailblazer-option = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18s48fndi2kfvrfzmq6rxvjfwad347548yby0341ixz1lhpg3r10";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.2";
  };
  tsort = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.0";
  };
  ttfunk = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15iaxz9iak5643bq2bc0jkbjv8w2zn649lxgvh5wg48q9d4blw13";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.7.0";
  };
  turbo-rails = {
    dependencies = ["actionpack" "railties"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0priz7ww23h2j9j5zicc4np3rr357n01xw8zymn0bzxg79rr03gf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.23";
  };
  turbo_power = {
    dependencies = ["turbo-rails"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ryrj2r22nsxflijxjm8pgvdvdy7502s175d4c01sxpsw13x35dd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.7.0";
  };
  turbo_tests = {
    dependencies = ["parallel_tests" "rspec"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "c1c4707f536a5642a168650d273d714dfb62d842";
      sha256 = "1nczxr3g7s28m3rwsqimvajwlmmwar652fb4a9285ak9msvp44jz";
      type = "git";
      url = "https://github.com/opf/turbo_tests.git";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qlm97fqcwhvfa7jg2gnq8la3mnk617b5bwsc460mi75wpqy4imm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2025.3";
  };
  uber = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.0";
  };
  unicode-display_width = {
    dependencies = ["unicode-emoji"];
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  unicode-emoji = {
    gem_platform = "ruby";
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03zqn207zypycbz5m9mn7ym763wgpk7hcqbkpx02wrbm1wank7ji";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.2.0";
  };
  uri = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.1";
  };
  useragent = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i1q2xdjam4d7gwwc35lfnz0wyyzvnca0zslcfxm9fabml9n83kh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.16.11";
  };
  validate_email = {
    dependencies = ["activemodel" "mail"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r1fz29l699arka177c9xw7409d1a3ff95bf7a6pmc97slb91zlx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.6";
  };
  validate_url = {
    dependencies = ["activemodel" "public_suffix"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lblym140w5n88ijyfgcvkxvpfj8m6z00rxxf2ckmmhk0x61dzkj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.15";
  };
  vcr = {
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rjalag6mjd796idhil076jnqpiv2lc2ljchxc25kz3fq4ncjyh7";
      type = "gem";
    };
    target_platform = "ruby";
    version = "6.4.0";
  };
  vernier = {
    gem_platform = "ruby";
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kg39cyd72mjmxvkrdgfla2i2m44z3w2ad8j8ivz4khl0jc1d9is";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.9.0";
  };
  view_component = {
    dependencies = ["actionview" "activesupport" "concurrent-ruby"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l4k6cigb82h24kfrrgx103imh9jvj92jf4kkxflljzfjnsfrk7c";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.4.0";
  };
  virtus = {
    dependencies = ["axiom-types" "coercible" "descendants_tracker"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hniwgbdsjxa71qy47n6av8faf8qpwbaapms41rhkk3zxgjdlhc8";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.0";
  };
  warden = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l7gl7vms023w4clg02pm4ky9j12la2vzsixi2xrv9imbn44ys26";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.9";
  };
  warden-basic_auth = {
    dependencies = ["warden"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viw3wwx3shlb4mynjim99xixs71qn2054wywv1q40cw23h55ixz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.2.1";
  };
  webauthn = {
    dependencies = ["android_key_attestation" "bindata" "cbor" "cose" "openssl" "safety_net_attestation" "tpm-key_attestation"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z710ndfr9yajywhji8mr5gc3j3wnr0alq754q15nh7k73wgbrlv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.4.3";
  };
  webfinger = {
    dependencies = ["activesupport" "faraday" "faraday-follow_redirects"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p39802sfnm62r4x5hai8vn6d1wqbxsxnmbynsk8rcvzwyym4yjn";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.3";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    gem_platform = "ruby";
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mqw7ca931zmqgad0fq4gw7z3gwb0pwx9cmd1b12ga4hgjsnysag";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.26.1";
  };
  webrick = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.9.2";
  };
  websocket = {
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dr78vh3ag0d1q5gfd8960g1ca9g6arjd2w54mffid8h4i7agrxp";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.11";
  };
  websocket-driver = {
    dependencies = ["base64" "websocket-extensions"];
    gem_platform = "ruby";
    groups = ["default" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj9dmkmgahmadgh88kydb7cv15w13l1fj3kk9zz28iwji5vl3gd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.8.0";
  };
  websocket-extensions = {
    gem_platform = "ruby";
    groups = ["default" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.5";
  };
  will_paginate = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fbmm0amshidnw0qx0nqjzfyy7if8xy6m5bm8lkksf8xprp24yqh";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.0.1";
  };
  with_advisory_lock = {
    dependencies = ["activerecord" "zeitwerk"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gqm78w1va32w6kbhpm86pvn9g28d2g7d9j9jrxys42sscg2znys";
      type = "gem";
    };
    target_platform = "ruby";
    version = "7.5.0";
  };
  xpath = {
    dependencies = ["nokogiri"];
    gem_platform = "ruby";
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "3.2.0";
  };
  yabeda = {
    dependencies = ["anyway_config" "concurrent-ruby" "dry-initializer"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gs338sij92yfxd77chh5pwslmy28qigvjczla0bsbk95pr7nldw";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.14.0";
  };
  yabeda-activerecord = {
    dependencies = ["activerecord" "anyway_config" "yabeda"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qp0lcspci6f9qjhv75bx6bs627ak7khbahqcxd48hjp9sk83lhx";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.2";
  };
  yabeda-prometheus-mmap = {
    dependencies = ["prometheus-client-mmap" "yabeda"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jg2x5bgfbyzhx99yfpq3xl72386g67f113p7bq33yfnaq3i4rhs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.0";
  };
  yabeda-puma-plugin = {
    dependencies = ["json" "puma" "yabeda"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j0bam5s3x0q2h8da01rhh0ih71c0avl3p0xd58bqc7fqzn771mp";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.0";
  };
  yabeda-rails = {
    dependencies = ["activesupport" "anyway_config" "railties" "yabeda"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aavkbb4hp65s7swmxvn0k1igy20zgvgkfzjnff433scshdmi8mg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.11.0";
  };
  yaml = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hhr8z9m9yq2kf7ls0vf8ap1hqma1yd72y2r13b88dffwv8nj3i4";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.4.0";
  };
  yard = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03q1hf12csqy5q2inafzi44179zaq9n5yrb0k2j2llqhzcmbh7vj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.9.38";
  };
  zeitwerk = {
    gem_platform = "ruby";
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pbkiwwla5gldgb3saamn91058nl1sq1344l5k36xsh9ih995nnq";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.7.5";
  };
}
