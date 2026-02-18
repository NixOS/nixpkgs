{
  actioncable = {
    dependencies = ["actionpack" "activesupport" "nio4r" "websocket-driver" "zeitwerk"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17z0flj504z9d5hmzmd8g2gmaiz1a3yndvkxmbz6qrkvjzr2pnxa";
      type = "gem";
    };
    version = "8.0.4";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03yqbiiz9z1nqy4n7rhjpavn20lx5rvjbq0sl0dkvdiga15662zd";
      type = "gem";
    };
    version = "8.0.4";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "activesupport" "mail" "rails-dom-testing"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jyyfp786csg4hmsxfywi8131p1pk51jzi8i9d9zn2lzw7c714iv";
      type = "gem";
    };
    version = "8.0.4";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "nokogiri" "rack" "rack-session" "rack-test" "rails-dom-testing" "rails-html-sanitizer" "useragent"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nyd4f58r11b0x5gsjlnyk2k9y2kd0zhv8szf82g9j1j5xccfr03";
      type = "gem";
    };
    version = "8.0.4";
  };
  actionpack-xml_parser = {
    dependencies = ["actionpack" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rnm6jrw3mzcf2g3q498igmhsn0kfkxq79w0nm532iclx4g4djs0";
      type = "gem";
    };
    version = "2.0.1";
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "globalid" "nokogiri"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h13x9y767i9nan09jyhiw32s1gmdmcb4mjld1jvhadcd019gcs0";
      type = "gem";
    };
    version = "8.0.4";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j0n38p02s73r9a8fg615z8m78n9agpf9d9b0v7i97m5wwgc9lsv";
      type = "gem";
    };
    version = "8.0.4";
  };
  active_record_doctor = {
    dependencies = ["activerecord"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16h6hhmd3x07vgh2kwxabvb7kz5ifaz4w3kxyvrci1ak341arw3s";
      type = "gem";
    };
    version = "2.0.1";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1knc9xwfnyqcxqzfsfix210ai2yhw9ps7j19aq5bk30n1rfsij6b";
      type = "gem";
    };
    version = "8.0.4";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z8dff84qgqinhwsj0i91r674vvg412kg72162zv216i7jn4yklg";
      type = "gem";
    };
    version = "8.0.4";
  };
  activemodel-serializers-xml = {
    dependencies = ["activemodel" "activesupport" "builder"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15y32sacv9xfbazd75dbr1ckln8a7hz86s4wlmccqm3jbqq1c6zs";
      type = "gem";
    };
    version = "1.0.3";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "timeout"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cmz9k27zy0746zpljg28ir4857df9r3nza4c1acmrcr2wbjr8xx";
      type = "gem";
    };
    version = "8.0.4";
  };
  activerecord-import = {
    dependencies = ["activerecord"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jzs0y4dg84j14j2hmlzviw66rcz6wn1j78z7mr7a1z5jsqrkjpq";
      type = "gem";
    };
    version = "2.2.0";
  };
  activerecord-nulldb-adapter = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "084q7vqglfl2bzw09kjjx2ws5wddhqklr8gvfaq59fc3c4892k03";
      type = "gem";
    };
    version = "1.1.1";
  };
  activerecord-session_store = {
    dependencies = ["actionpack" "activerecord" "cgi" "rack" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hr7dv4qfimy3bqw3yhwsz4i9kpyw5jyg2dghx7vz0rnaxa814b5";
      type = "gem";
    };
    version = "2.2.0";
  };
  activestorage = {
    dependencies = ["actionpack" "activejob" "activerecord" "activesupport" "marcel"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hx0chzrszc3kbjn8psagxaaas4ns5479kr0kxkc36685yb15ws7";
      type = "gem";
    };
    version = "8.0.4";
  };
  activesupport = {
    dependencies = ["base64" "benchmark" "bigdecimal" "concurrent-ruby" "connection_pool" "drb" "i18n" "logger" "minitest" "securerandom" "tzinfo" "uri"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0np97w7kc9dx7kx092nzhy3g6qxmqivcsfnzlzjzmd9kfxn3ljl9";
      type = "gem";
    };
    version = "8.0.4";
  };
  acts_as_list = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j7xclldl8g34vs791cyihysyngfrj8hkl3sq0hfdgmp004khic3";
      type = "gem";
    };
    version = "1.2.6";
  };
  acts_as_tree = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wx2m64knv57g1q0bi09d7hci69x5n49xkzzcimn2f6ym08fnsdq";
      type = "gem";
    };
    version = "2.9.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  aes_key_wrap = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bn0y70qm6mfj4y1m0j3s8ggh6dvxwrwrj5vfamhdrpddsz8ddr";
      type = "gem";
    };
    version = "1.1.0";
  };
  afm = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ia5iw9xvvy1igaxsa08vvv4b5ry9ipyr18917pi8w0y4kvddm2v";
      type = "gem";
    };
    version = "1.0.0";
  };
  airbrake = {
    dependencies = ["airbrake-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1diirjch0znh2a53l0fpylj762j051xdwnvzv1zgfpjxq9s507wh";
      type = "gem";
    };
    version = "13.0.5";
  };
  airbrake-ruby = {
    dependencies = ["rbtree3"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g1gvvbzbh0kiinw4w0sxaggxdn5wz689dbsssvf2qz76vxk8gi9";
      type = "gem";
    };
    version = "6.2.2";
  };
  android_key_attestation = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02spc1sh7zsljl02v9d5rdb717b628vw2k7jkkplifyjk4db0zj6";
      type = "gem";
    };
    version = "0.3.0";
  };
  anyway_config = {
    dependencies = ["ruby-next-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bablxxackpbp8x4bawx92l55w0nbbb82v747zags6mlq23v1xih";
      type = "gem";
    };
    version = "2.7.2";
  };
  appsignal = {
    dependencies = ["logger" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "155lrbj1a56i6jfxagyp3447b9jsyf0s4v3n6fzx9qj2lwf79gxz";
      type = "gem";
    };
    version = "4.7.5";
  };
  Ascii85 = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmyxpngg5rycyryhq9l9hapz1y3iqyflskyksxkqm0832a5vjqm";
      type = "gem";
    };
    version = "2.0.1";
  };
  ast = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  attr_required = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16fbwr6nmsn97n0a6k1nwbpyz08zpinhd6g7196lz1syndbgrszh";
      type = "gem";
    };
    version = "1.0.2";
  };
  auto_strip_attributes = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1rmrm33xz6kk6w2x0jr24cqavh41102s7x8zcvrqjdfk7y1qm7";
      type = "gem";
    };
    version = "2.6.0";
  };
  awesome_nested_set = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nhfqvmwvlk2bxa9qlf2mykli0297q9p668dp3dr20nq27saz7a6";
      type = "gem";
    };
    version = "3.8.0";
  };
  aws-eventstream = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16mg10xb1413jfqs30swwb8fcg9j8236122z55qpmcw1jfz3bw6z";
      type = "gem";
    };
    version = "1.1188.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "base64" "bigdecimal" "jmespath" "logger"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fgjki9wja72m5ip1dq5zx8msn1sdw9qid4z7wd0dnqbxr2ii056";
      type = "gem";
    };
    version = "3.239.2";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gbgf7xgg2hrrc51g3mpf0isba801w0r0z45mjnh45agdmcm3iy9";
      type = "gem";
    };
    version = "1.118.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s9fxa6y7v4ry7jjicwqwam85fdciz2v1rw6pjjnnbgxbm4vvzyw";
      type = "gem";
    };
    version = "1.205.0";
  };
  aws-sdk-sns = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04dq77gdqd3575jwc51cv0222dggvwqblkzyrs2s924a39lk7fvi";
      type = "gem";
    };
    version = "1.109.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    version = "1.12.1";
  };
  axe-core-api = {
    dependencies = ["dumb_delegator" "ostruct" "virtus"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06v91n5bs61vcqfybrbxpgvsnbgc7mmh7km3akqviygqr3ir971x";
      type = "gem";
    };
    version = "4.11.0";
  };
  axe-core-rspec = {
    dependencies = ["axe-core-api" "dumb_delegator" "ostruct" "virtus"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mw62ij61mvlpns9nafs5mlbdh1ji4rdmdsnw11m57rxhvrkwgiw";
      type = "gem";
    };
    version = "4.11.0";
  };
  axiom-types = {
    dependencies = ["descendants_tracker" "ice_nine" "thread_safe"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
      type = "gem";
    };
    version = "0.1.1";
  };
  base64 = {
    groups = ["default" "development" "ldap" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16a0g2q40biv93i1hch3gw8rbmhp77qnnifj1k0a6m7dng3zh444";
      type = "gem";
    };
    version = "3.1.20";
  };
  benchmark = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    version = "0.5.0";
  };
  better_html = {
    dependencies = ["actionview" "activesupport" "ast" "erubi" "parser" "smart_properties"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mdgwlc02f43svy92p0k5v1hipibpzxcdjm774lkz2j8s58kav04";
      type = "gem";
    };
    version = "2.1.1";
  };
  bigdecimal = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0612spks81fvpv2zrrv3371lbs6mwd7w6g5zafglyk75ici1x87a";
      type = "gem";
    };
    version = "3.3.1";
  };
  bindata = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n4ymlgik3xcg94h52dzmh583ss40rl3sn0kni63v56sq8g6l62k";
      type = "gem";
    };
    version = "2.5.1";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1db0kz71iv1syq4qhjvnspa3zs0sja7fpcay175i1sm9q5c4brfk";
      type = "gem";
    };
    version = "1.19.0";
  };
  brakeman = {
    dependencies = ["racc"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "164l8dh3c22c8448hgd0zqhsffxvn4d9wad2zzipav29sssjd532";
      type = "gem";
    };
    version = "7.1.1";
  };
  browser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bffb8dddrg6zn8c74swhy8mq2mysb195hi7chwwj9c8g2am4798";
      type = "gem";
    };
    version = "6.2.0";
  };
  budgets = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/budgets;
      type = "path";
    };
    version = "1.0.0";
  };
  builder = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  byebug = {
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07hsr9zzl2mvf5gk65va4smdizlk9rsiz8wwxik0p96cj79518fl";
      type = "gem";
    };
    version = "12.0.0";
  };
  capybara = {
    dependencies = ["addressable" "matrix" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vxfah83j6zpw3v5hic0j70h519nvmix2hbszmjwm8cfawhagns2";
      type = "gem";
    };
    version = "3.40.0";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqc7hdiw1ql42mklpfvqd2pyfsxmy55cpx0h9y0jlkpl1q96sw1";
      type = "gem";
    };
    version = "1.0.26";
  };
  capybara_accessible_selectors = {
    dependencies = ["capybara"];
    groups = ["test"];
    platforms = [];
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
    dependencies = ["activemodel" "activesupport" "mime-types" "ssrf_filter"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "089s8rbwddzcyw1ky34h90flz5wzqzi2lvajykbxn3l3s6mjsxw1";
      type = "gem";
    };
    version = "1.3.4";
  };
  carrierwave_direct = {
    dependencies = ["carrierwave" "fog-aws"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gyxbl6akxj89cbv556lsqi6955jld2gdkw8wi05k80p3nfc3mdh";
      type = "gem";
    };
    version = "2.1.0";
  };
  cbor = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w3d5dhx4vjd707ihkcmq7fy78p5fgawcjdqw2byxnfw32gzgkbr";
      type = "gem";
    };
    version = "0.5.10.1";
  };
  cgi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1njrjznc2j5xqqw71sp9130b9hyv59h2gfrf6yaf4in1n9dzd6gy";
      type = "gem";
    };
    version = "0.5.0";
  };
  childprocess = {
    dependencies = ["logger"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v5nalaarxnfdm6rxb7q6fmc6nx097jd630ax6h9ch7xw95li3cs";
      type = "gem";
    };
    version = "5.1.0";
  };
  climate_control = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "198aswdyqlvcw9jkd95b7b8dp3fg0wx89kd1dx9wia1z36b1icin";
      type = "gem";
    };
    version = "1.2.0";
  };
  closure_tree = {
    dependencies = ["activerecord" "with_advisory_lock" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sfw8gx75n2abnqs1av2kfw859xsw4bi4psbkga62f4nhdy5i98d";
      type = "gem";
    };
    version = "9.3.0";
  };
  coderay = {
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
    version = "1.1.3";
  };
  coercible = {
    dependencies = ["descendants_tracker"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
      type = "gem";
    };
    version = "1.0.0";
  };
  color_conversion = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15jcp6i5xi083p0h5qmsir9ghps4mnk5m5w92fhjf59f87xabglr";
      type = "gem";
    };
    version = "0.1.2";
  };
  colored2 = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0drbrv5m3l3qpal7s87gvss81cbzl76gad1hqkpqfqlphf0h7qb3";
      type = "gem";
    };
    version = "4.0.3";
  };
  commonmarker = {
    dependencies = ["rb_sys"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m7jl0382w8alic7jrl8mhg6c7k99hpig1nailcm4vngkgrvzwia";
      type = "gem";
    };
    version = "2.6.0";
  };
  compare-xml = {
    dependencies = ["nokogiri"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06aks0fjxwvs4l9bd8bl9q48kyadzn4cd5yrrrz1gwcyyv0aa6p2";
      type = "gem";
    };
    version = "0.66";
  };
  concurrent-ruby = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ipbrgvf0pp6zxdk5ascp6i29aybz2bx9wdrlchjmpx6mhvkwfw1";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = ["default" "development" "opf_plugins" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02p7l47gvchbvnbag6kb4x2hg8n28r25ybslyvrr2q214wir5qg9";
      type = "gem";
    };
    version = "2.5.4";
  };
  cookiejar = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1px0zlnlkwwp9prdkm2lamgy412y009646n2cgsa1xxsqk7nmc8i";
      type = "gem";
    };
    version = "0.3.4";
  };
  cose = {
    dependencies = ["cbor" "openssl-signature_algorithm"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rbdzl9n8ppyp38y75hw06s17kp922ybj6jfvhz52p83dg6xpm6m";
      type = "gem";
    };
    version = "1.3.1";
  };
  costs = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/costs;
      type = "path";
    };
    version = "1.0.0";
  };
  counter_culture = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f6aq9jif5qxa9prl686jn34nddfd3m2ca0nlxbm0xd257jbcr5g";
      type = "gem";
    };
    version = "3.11.4";
  };
  crack = {
    dependencies = ["bigdecimal" "rexml"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zjcdl5i6lw508r01dym05ibhkc784cfn93m1d26c7fk1hwi0jpz";
      type = "gem";
    };
    version = "1.0.1";
  };
  crass = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1izp5vna86s7xivqzml4nviy01bv76arrd5is8wkncwp1by3zzbc";
      type = "gem";
    };
    version = "1.21.1";
  };
  csv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gz7r2kazwwwyrwi95hbnhy54kwkfac5swh2gy5p5vw36fn38lbf";
      type = "gem";
    };
    version = "3.3.5";
  };
  cuprite = {
    dependencies = ["capybara" "ferrum"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ay1azfzslgqzxvgxpz9j7i31m0bbpcmrx5wajnrg2yhf3fdah5i";
      type = "gem";
    };
    version = "0.17";
  };
  daemons = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";
      type = "gem";
    };
    version = "1.4.1";
  };
  dalli = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19daxf5n5gr3pr57k4wqg701c3zwsk2h4jjialkaw7yrhi85jqrf";
      type = "gem";
    };
    version = "3.2.8";
  };
  date = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rbfqkzr6i8b6538z16chvrkgywf5p5vafsgmnbmvrmh0ingsx2y";
      type = "gem";
    };
    version = "3.5.0";
  };
  date_validator = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n1hrs9323q2430fiyzb2y350wim30x5a7242yf7nd20l96q7jb8";
      type = "gem";
    };
    version = "0.12.0";
  };
  deckar01-task_list = {
    dependencies = ["html-pipeline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rqn9jh45gsw045c6fm05875bpj2xbhnff5m5drmk9wy01zdrav6";
      type = "gem";
    };
    version = "2.3.4";
  };
  declarative = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
  };
  dentaku = {
    dependencies = ["bigdecimal" "concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dadsiyy1gn6iqq0khmzwl4qphxs5hlfx7jyqfwa6idlx4f29mw8";
      type = "gem";
    };
    version = "3.5.6";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  disposable = {
    dependencies = ["declarative" "representable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k44sg1gk7ba8znndc2ikch32dgcsi1l05jvya1wvxmza6r3yakz";
      type = "gem";
    };
    version = "0.6.3";
  };
  doorkeeper = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lsh9lzrglqlwm9icmn0ggrwjc9iy9308f9m59z1w2srmyp0fgd7";
      type = "gem";
    };
    version = "5.8.2";
  };
  dotenv = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hwjsddv666wpp42bip3fqx7c5qq6s8lwf74dj71yn7d1h37c4cy";
      type = "gem";
    };
    version = "3.1.8";
  };
  dotenv-rails = {
    dependencies = ["dotenv" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i40g6kzwp8yxsxzpzgsq2hww9gxryl5lck1bwxshn4bd8id3ja6";
      type = "gem";
    };
    version = "3.1.8";
  };
  drb = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wrkl7yiix268s2md1h6wh91311w95ikd8fy8m5gx589npyxc00b";
      type = "gem";
    };
    version = "2.2.3";
  };
  dry-configurable = {
    dependencies = ["dry-core" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a5g30p7kzp37n9w3idp3gy70hzkj30d8j951lhw2zsnb0l8cbc8";
      type = "gem";
    };
    version = "1.3.0";
  };
  dry-container = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aaj0ffwkbdagrry127x1gd4m6am88mhhfzi7czk8isdcj0r7gi3";
      type = "gem";
    };
    version = "0.11.0";
  };
  dry-core = {
    dependencies = ["concurrent-ruby" "logger" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15di39ssfkwigyyqla65n4x6cfhgwa4cv8j5lmyrlr07jwd840q9";
      type = "gem";
    };
    version = "1.1.0";
  };
  dry-inflector = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0blgyg9l4gpzhb7rs9hqq9j7br80ngiigjp2ayp78w6m1ysx1x92";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-initializer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qy4cv0j0ahabprdbp02nc3r1606jd5dp90lzqg0mp0jz6c9gm9p";
      type = "gem";
    };
    version = "3.2.0";
  };
  dry-logic = {
    dependencies = ["bigdecimal" "concurrent-ruby" "dry-core" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18nf8mbnhgvkw34drj7nmvpx2afmyl2nyzncn3wl3z4h1yyfsvys";
      type = "gem";
    };
    version = "1.6.0";
  };
  dry-monads = {
    dependencies = ["concurrent-ruby" "dry-core" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05jq44kmpa01d37q50wp2wygpwzx6x3xkns2cf3plb46bixscj4k";
      type = "gem";
    };
    version = "1.9.0";
  };
  dry-schema = {
    dependencies = ["concurrent-ruby" "dry-configurable" "dry-core" "dry-initializer" "dry-logic" "dry-types" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wczkg5wd29c8gg1r10wxfpyavw4q6ia7xi2dapar709lwwpbk9g";
      type = "gem";
    };
    version = "1.14.1";
  };
  dry-types = {
    dependencies = ["bigdecimal" "concurrent-ruby" "dry-core" "dry-inflector" "dry-logic" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g61cnmmwzff05sf8bh95qjd3hikasgvrmf3q0qk29zdw12pmndm";
      type = "gem";
    };
    version = "1.8.3";
  };
  dry-validation = {
    dependencies = ["concurrent-ruby" "dry-core" "dry-initializer" "dry-schema" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11c0zx0irrawi028xsljpyw8kwxzqrhf7lv6nnmch4frlashp43h";
      type = "gem";
    };
    version = "1.11.1";
  };
  dumb_delegator = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13hq81z3yimhw6xd1czia68mqgcgcw6b8qjcaxm218lmn3jmblhs";
      type = "gem";
    };
    version = "1.1.0";
  };
  em-http-request = {
    dependencies = ["addressable" "cookiejar" "em-socksify" "eventmachine" "http_parser.rb"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1azx5rgm1zvx7391sfwcxzyccs46x495vb34ql2ch83f58mwgyqn";
      type = "gem";
    };
    version = "1.1.7";
  };
  em-socksify = {
    dependencies = ["base64" "eventmachine"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vbl74x9m4hccmmhcnp36s50mn7d81annfj3fcqjdhdcm2khi3bx";
      type = "gem";
    };
    version = "0.3.3";
  };
  em-synchrony = {
    dependencies = ["eventmachine"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jh6ygbcvapmarqiap79i6yl05bicldr2lnmc46w1fyrhjk70x3f";
      type = "gem";
    };
    version = "1.0.6";
  };
  email_validator = {
    dependencies = ["activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0106y8xakq6frv2xc68zz76q2l2cqvhfjc7ji69yyypcbc4kicjs";
      type = "gem";
    };
    version = "2.2.4";
  };
  equivalent-xml = {
    dependencies = ["nokogiri"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11zlqc600acqn1kli339c587xca6yvhqpzv9cf2d12l4z8g7c6c9";
      type = "gem";
    };
    version = "0.6.0";
  };
  erb = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y95ynlfngs0s5x1w6mwralszhbi9d75lcdbdkqk75wcklzqjc17";
      type = "gem";
    };
    version = "6.0.0";
  };
  erb_lint = {
    dependencies = ["activesupport" "better_html" "parser" "rainbow" "rubocop" "smart_properties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cbwr8iv6d9g50w12a7ccvcrqk5clz4mxa3cspqd3s1rv05f9dfz";
      type = "gem";
    };
    version = "0.9.0";
  };
  erblint-github = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l7j646nma6bx34bsf9y5fxx5naf8brpmvwk025cc38s73fgfa4z";
      type = "gem";
    };
    version = "1.0.1";
  };
  erubi = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    version = "1.13.1";
  };
  escape_utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "029c7kynhkxw8fgq9q171xi68ajfqrb22r7drvkar018j8871yyz";
      type = "gem";
    };
    version = "1.3.0";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g785lz4z2k7jrdl7bnnjllzfrwpv9pyki94ngizj8cqfy83qzkc";
      type = "gem";
    };
    version = "1.4.0";
  };
  eventmachine = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  eventmachine_httpserver = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02dq358cj7z6qh3n7gmsf345fz25c0hwqprfb51ls82l6yifidax";
      type = "gem";
    };
    version = "0.2.1";
  };
  excon = {
    dependencies = ["logger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gj6h2r9ylkmz9wjlf6p04d3hw99qfnf0wb081lzjx3alk13ngfq";
      type = "gem";
    };
    version = "1.3.0";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xz02xlnfhj418g51w06asfpcjccf7b66dx6ly3c1k2d45rv7ghj";
      type = "gem";
    };
    version = "6.5.6";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s3dpi8x754bwv4mlasdal8ffiahi4b4ajpccnkaipp4x98lik6k";
      type = "gem";
    };
    version = "6.5.1";
  };
  faraday = {
    dependencies = ["faraday-net_http" "json" "logger"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ka175ci0q9ylpcy651pjj580diplkaskycn4n7jcmbyv7jwz6c6";
      type = "gem";
    };
    version = "2.14.0";
  };
  faraday-follow_redirects = {
    dependencies = ["faraday"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nfmmnmqgbxci7dlca0qnwxn8j29yv7v8wm26m0f4l0kmcc13ynk";
      type = "gem";
    };
    version = "0.4.0";
  };
  faraday-net_http = {
    dependencies = ["net-http"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v4hfmc7d4lrqqj2wl366rm9551gd08zkv2ppwwnjlnkc217aizi";
      type = "gem";
    };
    version = "3.4.2";
  };
  fastimage = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s67b9n7ki3iaycypq8sh02377gjkaxadg4dq53bpgfk4xg3gkjz";
      type = "gem";
    };
    version = "2.4.0";
  };
  ferrum = {
    dependencies = ["addressable" "base64" "concurrent-ruby" "webrick" "websocket-driver"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rybr2bd1da7n7m3c7m9jaxlalcz71s697ax7fhyb4y51w993mai";
      type = "gem";
    };
    version = "0.17.1";
  };
  ffi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19kdyjg3kv7x0ad4xsd4swy5izsbb1vl1rpb6qqcqisr5s23awi9";
      type = "gem";
    };
    version = "1.17.2";
  };
  flamegraph = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p785nmhdzbwj0qpxn5fzrmr4kgimcds83v4f95f387z6w3050x6";
      type = "gem";
    };
    version = "0.9.5";
  };
  fog-aws = {
    dependencies = ["base64" "fog-core" "fog-json" "fog-xml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19crlx2pnyxa8ncv874gz652hxh6yd9lr1354yznrgkqv5p37ir0";
      type = "gem";
    };
    version = "3.33.1";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador" "mime-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rjv4iqr64arxv07bh84zzbr1y081h21592b5zjdrk937al8mq1z";
      type = "gem";
    };
    version = "2.6.0";
  };
  fog-json = {
    dependencies = ["fog-core" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-xml = {
    dependencies = ["fog-core" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1miv6zgglx4vddw2c17mpf6l36qn0abq7ngrxb9isih10yhzxfaj";
      type = "gem";
    };
    version = "0.1.5";
  };
  formatador = {
    dependencies = ["reline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "177nzz8z4pqzf0yqhi3zf2glxdi3fgk2bqym50r1mxkmil53f9y3";
      type = "gem";
    };
    version = "1.2.2";
  };
  friendly_id = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v2q0cyqn8za374ygfxzpa5qf4j8yk7ilz6zrv3457wkfwg4670";
      type = "gem";
    };
    version = "5.5.1";
  };
  front_matter_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yvvxcym75csvckkg3bcf739ild3f0b2yifnlj45gf8xl2yriqms";
      type = "gem";
    };
    version = "1.0.1";
  };
  fugit = {
    dependencies = ["et-orbi" "raabro"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s5gg88f2d5wpppgrgzfhnyi9y2kzprvhhjfh3q1bd79xmwg962q";
      type = "gem";
    };
    version = "1.12.1";
  };
  fuubar = {
    dependencies = ["rspec-core" "ruby-progressbar"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1028vn7j3kc5qqwswrf3has3qm4j9xva70xmzb3n29i89f0afwmj";
      type = "gem";
    };
    version = "2.5.1";
  };
  glob = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "131356zfr61zajgcz9pjhbrhys3gazd0rkh7m7fi7gjasbicjgc9";
      type = "gem";
    };
    version = "0.4.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04gzhqvsm4z4l12r9dkac9a75ah45w186ydhl0i4andldsnkkih5";
      type = "gem";
    };
    version = "1.3.0";
  };
  good_job = {
    dependencies = ["activejob" "activerecord" "concurrent-ruby" "fugit" "railties" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fzyxa1hay2pvc00knysv4snspkspzi2rn8jajl4175cyax83ad8";
      type = "gem";
    };
    version = "4.12.1";
  };
  google-apis-core = {
    dependencies = ["addressable" "faraday" "faraday-follow_redirects" "googleauth" "mini_mime" "representable" "retriable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a961x3jq0wskwgb8ym83viza05bcvsqiny8gg6dc0n9mnm7jids";
      type = "gem";
    };
    version = "1.0.2";
  };
  google-apis-gmail_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15kixbp2khianpjvv5mybv4jl43wffaap33j8fds9s00hhwvi1lm";
      type = "gem";
    };
    version = "0.46.0";
  };
  google-cloud-env = {
    dependencies = ["base64" "faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rvqj6n6qhjmjy0lynpmga7ly48s7dk36i6nj4jqrrvvn8gc1ahg";
      type = "gem";
    };
    version = "2.3.1";
  };
  google-logging-utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yyzlgy9hx104xhrbl51ana0dl3m5p5989j4lcjsizssxas64m37";
      type = "gem";
    };
    version = "0.2.0";
  };
  google-protobuf = {
    dependencies = ["bigdecimal" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rqmj1sl0bs42jjxdfpcqs8sgq6zvhjdixbsciaj1043l993zv6r";
      type = "gem";
    };
    version = "4.32.1";
  };
  googleapis-common-protos-types = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iy4pxpsbxjdiyd03mslalbcvrrga57h1mb0r0c01nnngfvr4x7r";
      type = "gem";
    };
    version = "1.22.0";
  };
  googleauth = {
    dependencies = ["faraday" "google-cloud-env" "google-logging-utils" "jwt" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "096bsg1z4yyqxrdmnxdbb45g94dr2fb8hf2av40kcmqd7n4n06fn";
      type = "gem";
    };
    version = "1.15.1";
  };
  grape = {
    dependencies = ["activesupport" "dry-types" "mustermann-grape" "rack" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v3akcpm7wq13jy2p31igc2xqj2k9qs7h2r7hsx4j7gih0z6fn9x";
      type = "gem";
    };
    version = "2.4.0";
  };
  grape_logging = {
    dependencies = ["grape" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ryg7m4nfszkcfiyl8wmicnlzihpvg6i1jh438ibpwnrs2djqkv";
      type = "gem";
    };
    version = "3.0.0";
  };
  gravatar_image_tag = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kzx81y56kdady6yv77byh15yy5riwbs0d5r2gki3ds6m3z30mpb";
      type = "gem";
    };
    version = "1.2.0";
  };
  grids = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/grids;
      type = "path";
    };
    version = "1.0.0";
  };
  hana = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03cvrv2wl25j9n4n509hjvqnmwa60k92j741b64a1zjisr1dn9al";
      type = "gem";
    };
    version = "1.3.7";
  };
  hashdiff = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lbw8lqzjv17vnwb9vy5ki4jiyihybcc5h2rmcrqiz1xa6y9s1ww";
      type = "gem";
    };
    version = "1.2.1";
  };
  hashery = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    version = "2.1.2";
  };
  hashie = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nh3arcrbz1rc1cr59qm53sdhqm137b258y8rcb4cvd3y98lwv4x";
      type = "gem";
    };
    version = "5.0.0";
  };
  highline = {
    dependencies = ["reline"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jmvyhjp2v3iq47la7w6psrxbprnbnmzz0hxxski3vzn356x7jv7";
      type = "gem";
    };
    version = "3.1.2";
  };
  html-pipeline = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "180kjksi0sdlqb0aq0bhal96ifwqm25hzb3w709ij55j51qls7ca";
      type = "gem";
    };
    version = "2.14.3";
  };
  htmlbeautifier = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrqvgja3pbmz4v27zc5ir58sk4mv177nq7hlssy2smawbvhhgdl";
      type = "gem";
    };
    version = "1.4.3";
  };
  htmldiff = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "188kw5694rhndd69dpzi8ygi50sx6s2ig9jl6756racfif60cvd9";
      type = "gem";
    };
    version = "0.0.1";
  };
  htmlentities = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  http-2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fibasarsbi1fzapxk8ifwwgc7qyb3g988x65y6nnkig7jhaah8i";
      type = "gem";
    };
    version = "1.1.1";
  };
  "http_parser.rb" = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gj4fmls0mf52dlr928gaq0c0cb0m3aqa9kaa6l0ikl2zbqk42as";
      type = "gem";
    };
    version = "0.8.0";
  };
  httpx = {
    dependencies = ["http-2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12if78kjp46wpl4f83lf8p66gx5m16zfpmlscjgq6y1baywi2jhv";
      type = "gem";
    };
    version = "1.6.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03sx3ahz1v5kbqjwxj48msw3maplpp2iyzs22l4jrzrqh4zmgfnf";
      type = "gem";
    };
    version = "1.14.7";
  };
  i18n-js = {
    dependencies = ["glob" "i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m8k77hkbyci3vdlaj8z0fkw733ycmvxa1srbi4qr9lg5wvhsfb1";
      type = "gem";
    };
    version = "4.2.4";
  };
  i18n-tasks = {
    dependencies = ["activesupport" "ast" "erubi" "highline" "i18n" "parser" "prism" "rails-i18n" "rainbow" "ruby-progressbar" "terminal-table"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s5h2g8zl7ccqraq4xf3yzjvhr2ywdh9mxrix43q6hcnr92y3hgb";
      type = "gem";
    };
    version = "1.1.0";
  };
  icalendar = {
    dependencies = ["base64" "ice_cube" "logger" "ostruct"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r77iy9q5mvsplla88mgvxi27xjbll6svynikbr53mdfa32mdzzc";
      type = "gem";
    };
    version = "2.12.1";
  };
  ice_cube = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gpwlpshsjlld53h1f999p0azd9jdlgmhbswa19wqjjbv9fv9pij";
      type = "gem";
    };
    version = "0.17.0";
  };
  ice_nine = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
  inline_svg = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03x1z55sh7cpb63g46cbd6135jmp13idcgqzqsnzinbg4cs2jrav";
      type = "gem";
    };
    version = "1.10.0";
  };
  interception = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01vrkn28psdx1ysh5js3hn17nfp1nvvv46wc1pwqsakm6vb1hf55";
      type = "gem";
    };
    version = "0.5";
  };
  io-console = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jszj95hazqqpnrjjzr326nn1j32xmsc9xvd97mbcrrgdc54858y";
      type = "gem";
    };
    version = "0.8.1";
  };
  irb = {
    dependencies = ["pp" "rdoc" "reline"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aja320qnimlnfc80wf2i2x8i99kl5sdzfacsfzzfzzs3vzysja3";
      type = "gem";
    };
    version = "1.15.3";
  };
  iso8601 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18js898rhh6byp0znvchiv6mcxi5l8v3v0bj2ddajpxynwajp319";
      type = "gem";
    };
    version = "0.13.0";
  };
  jmespath = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "098m3q2jrx4xbf0knrbmflsynmmb5x9q9b0bzpmj7jmm1cr30mna";
      type = "gem";
    };
    version = "2.16.0";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "base64" "bindata" "faraday" "faraday-follow_redirects"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k64mp59jlbqd5hyy46pf93s3yl1xdngfy8i8flq2hn5nhk91ybg";
      type = "gem";
    };
    version = "1.17.0";
  };
  json-schema = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bq393nrxa7hmphc3li8idgxdnb5hwgj15d0q5qsh4l5g1qvrnm";
      type = "gem";
    };
    version = "4.3.1";
  };
  json_schemer = {
    dependencies = ["bigdecimal" "hana" "regexp_parser" "simpleidn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "093wb42zyy0a7kk7zxdvs0jivm0knlaz9lrsncjxjj2ppcbn3jsn";
      type = "gem";
    };
    version = "2.4.0";
  };
  json_spec = {
    dependencies = ["multi_json" "rspec"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03yiravv6q8lp37rip2i25w2qd63mwwi4jmw7ymf51y7j9xbjxvs";
      type = "gem";
    };
    version = "1.1.5";
  };
  jwt = {
    dependencies = ["base64"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dfm4bhl4fzn076igh0bmh2v1vphcrxdv6ldc46hdd3bkbqr2sdg";
      type = "gem";
    };
    version = "3.1.2";
  };
  ladle = {
    dependencies = ["open4"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p4hv85nrcqg59hbcxm14d98wbk0smdsdljppx48sycc21j6jn78";
      type = "gem";
    };
    version = "1.0.1";
  };
  language_server-protocol = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k0311vah76kg5m6zr7wmkwyk5p2f9d9hyckjpn3xgr83ajkj7px";
      type = "gem";
    };
    version = "3.17.0.5";
  };
  launchy = {
    dependencies = ["addressable" "childprocess" "logger"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17h522xhwi5m4n6n9m22kw8z0vy8100sz5f3wbfqj5cnrjslgf3j";
      type = "gem";
    };
    version = "3.1.1";
  };
  lefthook = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ggix71mcxrk0p6mqjk9x6fngvpj4wq42kg2qgqmrd5l0gsm3ipd";
      type = "gem";
    };
    version = "2.0.4";
  };
  letter_opener = {
    dependencies = ["launchy"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cnv3ggnzyagl50vzs1693aacv08bhwlprcvjp8jcg2w7cp3zwrg";
      type = "gem";
    };
    version = "1.10.0";
  };
  letter_opener_web = {
    dependencies = ["actionmailer" "letter_opener" "railties" "rexml"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q4qfi5wnn5bv93zjf10agmzap3sn7gkfmdbryz296wb1vz1wf9z";
      type = "gem";
    };
    version = "3.0.0";
  };
  lint_roller = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rwwsmvq79qwzl6324yc53py02kbrcww35si720490z5w0j497nv";
      type = "gem";
    };
    version = "3.9.0";
  };
  lobby_boy = {
    dependencies = ["omniauth" "omniauth-openid-connect" "rails"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wl105faijn0pl6i8gcqwaw5d9wwczvvhdzinf71bvra0lybnq4l";
      type = "gem";
    };
    version = "0.1.3";
  };
  logger = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qcsvh9k4c0cp6agqm9a8m4x2gg7vifryqr7yxkg2x9ph9silds2";
      type = "gem";
    };
    version = "0.14.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dx316q03x6rpdbl610rdaj2vfd5s8fanixk21j4gv3h5f230nk5";
      type = "gem";
    };
    version = "2.24.1";
  };
  lookbook = {
    dependencies = ["activemodel" "css_parser" "htmlbeautifier" "htmlentities" "marcel" "railties" "redcarpet" "rouge" "view_component" "yard" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08bd7wvwhi1kk687bsa94pslcdbnf8nqmmr2q9bv11vspahh9ymc";
      type = "gem";
    };
    version = "2.3.13";
  };
  mail = {
    dependencies = ["logger" "mini_mime" "net-imap" "net-pop" "net-smtp"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ha9sgkfqna62c1basc17dkx91yk7ppgjq32k4nhrikirlz6g9kg";
      type = "gem";
    };
    version = "2.9.0";
  };
  marcel = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vhb1sbzlq42k2pzd9v0w5ws4kjx184y8h4d63296bn57jiwzkzx";
      type = "gem";
    };
    version = "1.1.0";
  };
  markly = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kxbrrnx9flk2g2gxad7ng5qlglgnvkscilxncd4cxyhy7f706ci";
      type = "gem";
    };
    version = "0.14.1";
  };
  matrix = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nscas3a4mmrp1rc07cdjlbbpb2rydkindmbj3v3z5y1viyspmd0";
      type = "gem";
    };
    version = "0.4.3";
  };
  md_to_pdf = {
    dependencies = ["base64" "bigdecimal" "color_conversion" "front_matter_parser" "json-schema" "markly" "matrix" "nokogiri" "prawn" "prawn-table" "text-hyphen" "ttfunk"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "6c565541bfa390c58d90d49aa9b487777704fc66";
      sha256 = "0z7cj80jm7cpw0z7xbxcpsz7i2y561iccar0az36k8rcv6lkkph5";
      type = "git";
      url = "https://github.com/opf/md-to-pdf";
    };
    version = "0.2.5";
  };
  messagebird-rest = {
    dependencies = ["jwt"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "176m75m0bxmq9c8aa3b7wmn34sybq8k79l7s46h4lpixpbpw2k6s";
      type = "gem";
    };
    version = "5.0.0";
  };
  meta-tags = {
    dependencies = ["actionpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10wyzx7x2v7p5lbi6i2cy8vvvpbb3yi89jvkyj8j1q9bm7s8mrvz";
      type = "gem";
    };
    version = "2.22.2";
  };
  method_source = {
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
    version = "1.1.0";
  };
  mime-types = {
    dependencies = ["logger" "mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a27k4jcrx7pvb0p59fn1frh14iy087c2aygrdkmgwsrbshvqxpj";
      type = "gem";
    };
    version = "3.2025.0924";
  };
  mini_magick = {
    dependencies = ["logger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i2ilgjfjqc6sw4cwa4g9w3ngs41yvvazr9y82vapp5sfvymsf99";
      type = "gem";
    };
    version = "5.3.1";
  };
  mini_mime = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  minitest = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qyda32pf9jivaw2m7yymxshqxxd0fhjn7zpbagvmfc5c65128gh";
      type = "gem";
    };
    version = "5.26.2";
  };
  msgpack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";
      type = "gem";
    };
    version = "1.8.0";
  };
  multi_json = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06sabsvnw0x1aqdcswc6bqrqz6705548bfd8z22jxgxfjrn1yn3n";
      type = "gem";
    };
    version = "1.17.0";
  };
  mustermann = {
    dependencies = ["ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ma2fmxlm6i7lih4mc3har2fzsbj1pl4hhva65kljf6nfvdryl5";
      type = "gem";
    };
    version = "3.0.4";
  };
  mustermann-grape = {
    dependencies = ["mustermann"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iaqlj7kjm5dd207gxcwi3nsjs616yqc08y0whfg1j04c2c8l9cd";
      type = "gem";
    };
    version = "1.1.0";
  };
  my_page = {
    dependencies = ["grids"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/my_page;
      type = "path";
    };
    version = "1.0.0";
  };
  net-http = {
    dependencies = ["uri"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vdlxiv9h9gzliz8722j6spw2nwl5z0rfz1i5b9mmsgrx5yc8hnz";
      type = "gem";
    };
    version = "0.8.0";
  };
  net-imap = {
    dependencies = ["date" "net-protocol"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i24prs7yy1p1zdps2x1ksb7lmvbn2f0llxwdjdw3z2ksddx136b";
      type = "gem";
    };
    version = "0.5.12";
  };
  net-ldap = {
    dependencies = ["base64" "ostruct"];
    groups = ["ldap"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wjkrvcwnxa6ggq0nfz004f1blm1c67fv7c6614sraak0wshn25j";
      type = "gem";
    };
    version = "0.20.0";
  };
  net-pop = {
    dependencies = ["net-protocol"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = ["timeout"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a32l4x73hz200cm587bc29q8q9az278syw3x6fkc9d1lv5y0wxa";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = ["net-protocol"];
    groups = ["default" "development" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    version = "0.5.1";
  };
  nio4r = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a9www524fl1ykspznz54i0phfqya4x45hqaz67in9dvw1lfwpfr";
      type = "gem";
    };
    version = "2.7.4";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hcwwr2h8jnqqxmf8mfb52b0dchr7pm064ingflb78wa00qhgk6m";
      type = "gem";
    };
    version = "1.18.10";
  };
  oj = {
    dependencies = ["bigdecimal" "ostruct"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mmmswza8f4divl0mvkfq62pcdvm8c56j854wv7z9g6s0rmav7xd";
      type = "gem";
    };
    version = "3.16.12";
  };
  okcomputer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n5lcgimwrhmfmyv89nf377b46qskxd94af3ybcbs9gph9d96j45";
      type = "gem";
    };
    version = "1.19.0";
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    groups = ["default" "opf_plugins"];
    platforms = [];
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
    dependencies = ["addressable" "omniauth" "openid_connect"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "f0c1ecdb26e39017a9e929af75a166c772d960bb";
      sha256 = "15gbr9dvp3xb30mfjbbnwlis2gz3yq66sg0x18x245kjjkqjxy9y";
      type = "git";
      url = "https://github.com/opf/omniauth-openid-connect.git";
    };
    version = "0.4.2";
  };
  omniauth-openid_connect-providers = {
    dependencies = ["omniauth-openid-connect"];
    groups = ["default" "opf_plugins"];
    platforms = [];
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
    dependencies = ["omniauth" "ruby-saml"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gdgjwiv60ladn48w3lrb7qr91dnyxvfbnnny87gzgni9wpy5p8k";
      type = "gem";
    };
    version = "1.10.6";
  };
  op-clamav-client = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r1907b0rqyy62n8n7k32zayq00shzsgs32kvjijp2km25ynk3gj";
      type = "gem";
    };
    version = "3.4.2";
  };
  open4 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cgls3f9dlrpil846q0w7h66vsc33jqn84nql4gcqkk221rh7px1";
      type = "gem";
    };
    version = "1.3.4";
  };
  openid_connect = {
    dependencies = ["activemodel" "attr_required" "faraday" "faraday-follow_redirects" "json-jwt" "rack-oauth2" "swd" "tzinfo" "validate_email" "validate_url" "webfinger"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009ibw3g0gzrbblxfq6261pw4xb12z6605g3ypgk6vm3nn2lw9ii";
      type = "gem";
    };
    version = "2.2.1";
  };
  openproject-auth_plugins = {
    dependencies = ["omniauth"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/auth_plugins;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-auth_saml = {
    dependencies = ["omniauth-saml"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/auth_saml;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-avatars = {
    dependencies = ["fastimage" "gravatar_image_tag"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/avatars;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-backlogs = {
    dependencies = ["acts_as_list"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/backlogs;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-bim = {
    dependencies = ["activerecord-import" "rubyzip"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/bim;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-boards = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/boards;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-calendar = {
    dependencies = ["icalendar"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/calendar;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-documents = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/documents;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-gantt = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/gantt;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-github_integration = {
    dependencies = ["openproject-webhooks"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/github_integration;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-gitlab_integration = {
    dependencies = ["openproject-webhooks"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/gitlab_integration;
      type = "path";
    };
    version = "3.0.0";
  };
  openproject-job_status = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/job_status;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-ldap_groups = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/ldap_groups;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-meeting = {
    dependencies = ["icalendar"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/meeting;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-octicons = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12ylcfvsfmlgkra7vdmkcy5z2qlq6c3cb3yfvvhmf39iqkkhijg9";
      type = "gem";
    };
    version = "19.32.0";
  };
  openproject-octicons_helper = {
    dependencies = ["actionview" "openproject-octicons" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ciq7vkp44im0gpimk558lkyaxd5n02iyz27jx1n6dk47hbqnyk8";
      type = "gem";
    };
    version = "19.32.0";
  };
  openproject-openid_connect = {
    dependencies = ["lobby_boy" "omniauth-openid_connect-providers" "openproject-auth_plugins"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/openid_connect;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-primer_view_components = {
    dependencies = ["actionview" "activesupport" "openproject-octicons" "view_component"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ji52i657k9s9m64wfp7cm29am4ahf9nkvn66lfy37as1g33f1w";
      type = "gem";
    };
    version = "0.79.1";
  };
  openproject-recaptcha = {
    dependencies = ["recaptcha"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/recaptcha;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-reporting = {
    dependencies = ["costs"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/reporting;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-storages = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/storages;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-team_planner = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/team_planner;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-token = {
    dependencies = ["activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dxpbmqzym6mrm1fhjzcjig9qn58d5vlfw799svf8l7034ivrz37";
      type = "gem";
    };
    version = "8.3.0";
  };
  openproject-two_factor_authentication = {
    dependencies = ["aws-sdk-sns" "messagebird-rest" "rotp" "webauthn"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/two_factor_authentication;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-webhooks = {
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/webhooks;
      type = "path";
    };
    version = "1.0.0";
  };
  openproject-xls_export = {
    dependencies = ["spreadsheet"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/xls_export;
      type = "path";
    };
    version = "1.0.0";
  };
  openssl = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dzq3k5hmqlav2mwf7bc10mr1mlmlnpin498g7jhbhpdpa324s6n";
      type = "gem";
    };
    version = "3.3.1";
  };
  openssl-signature_algorithm = {
    dependencies = ["openssl"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "103yjl68wqhl5kxaciir5jdnyi7iv9yckishdr52s5knh9g0pd53";
      type = "gem";
    };
    version = "1.3.0";
  };
  opentelemetry-api = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kr1jyk67zn4axafcb2fji5b8xvr56hhfg2y33s5pnzjlr72dzfc";
      type = "gem";
    };
    version = "1.7.0";
  };
  opentelemetry-common = {
    dependencies = ["opentelemetry-api"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b5k7qc81ln96ayba90hm6ww7qpk8y7lc1r2mphblmwx8y812wns";
      type = "gem";
    };
    version = "0.23.0";
  };
  opentelemetry-exporter-otlp = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types" "opentelemetry-api" "opentelemetry-common" "opentelemetry-sdk" "opentelemetry-semantic_conventions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "167v3wnza37yz4r90p1bhppz704w4ij0jny1qahzf48gbf6gx4pb";
      type = "gem";
    };
    version = "0.31.0";
  };
  opentelemetry-helpers-mysql = {
    dependencies = ["opentelemetry-api" "opentelemetry-common"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kssrgcm716blgn4qhhngp9xmzw1ng9y0xdw9m6x3g9512rc02fk";
      type = "gem";
    };
    version = "0.4.0";
  };
  opentelemetry-helpers-sql = {
    dependencies = ["opentelemetry-api"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y9p7xxn491pjdcb9n4m25lvpigr63ywflqw9lfd8vd1sqbq1c2b";
      type = "gem";
    };
    version = "0.3.0";
  };
  opentelemetry-helpers-sql-obfuscation = {
    dependencies = ["opentelemetry-common"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzgparc7ly1h9v0r3f4jl22d8v7a97dns7ghwxrxgy49bxp785h";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-instrumentation-action_mailer = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mqh8z6myff0j11zcnm34s1lc8qzmzzqdrhzk95y2sh6vdmqd143";
      type = "gem";
    };
    version = "0.6.1";
  };
  opentelemetry-instrumentation-action_pack = {
    dependencies = ["opentelemetry-instrumentation-rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wzj0xmivyx243slz526z54lqyhsiyzzrbha4szyxjl30xsdxyl4";
      type = "gem";
    };
    version = "0.15.1";
  };
  opentelemetry-instrumentation-action_view = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16gmwl1v4jnz1x670qprkbc35phnbpbljsp2mcr71dq4fvfk8qa2";
      type = "gem";
    };
    version = "0.11.1";
  };
  opentelemetry-instrumentation-active_job = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "129ajjrxigl4pag1nlzbdv1js5bij4ll92i1ix50c3f24h9338df";
      type = "gem";
    };
    version = "0.10.1";
  };
  opentelemetry-instrumentation-active_model_serializers = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05ff7yxy2v96kslsqn1y68669is00798i9fgk9fy85vx2r21xs4g";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-active_record = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14kwks0130mrggk3irg4qvx5fmwk9gxv6w23dy6ryi50xqs3y20v";
      type = "gem";
    };
    version = "0.11.1";
  };
  opentelemetry-instrumentation-active_storage = {
    dependencies = ["opentelemetry-instrumentation-active_support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17p8zmfyigdqvgy3d1691ayzm6nj4q4nx2n3qk01f7wjakphz6zq";
      type = "gem";
    };
    version = "0.3.1";
  };
  opentelemetry-instrumentation-active_support = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zf5kg2h9zgmrwnq7v7by2nyhkxa20gmi5nyqqrpwyaqf4v9isl2";
      type = "gem";
    };
    version = "0.10.1";
  };
  opentelemetry-instrumentation-all = {
    dependencies = ["opentelemetry-instrumentation-active_model_serializers" "opentelemetry-instrumentation-anthropic" "opentelemetry-instrumentation-aws_lambda" "opentelemetry-instrumentation-aws_sdk" "opentelemetry-instrumentation-bunny" "opentelemetry-instrumentation-concurrent_ruby" "opentelemetry-instrumentation-dalli" "opentelemetry-instrumentation-delayed_job" "opentelemetry-instrumentation-ethon" "opentelemetry-instrumentation-excon" "opentelemetry-instrumentation-faraday" "opentelemetry-instrumentation-grape" "opentelemetry-instrumentation-graphql" "opentelemetry-instrumentation-grpc" "opentelemetry-instrumentation-gruf" "opentelemetry-instrumentation-http" "opentelemetry-instrumentation-http_client" "opentelemetry-instrumentation-httpx" "opentelemetry-instrumentation-koala" "opentelemetry-instrumentation-lmdb" "opentelemetry-instrumentation-mongo" "opentelemetry-instrumentation-mysql2" "opentelemetry-instrumentation-net_http" "opentelemetry-instrumentation-pg" "opentelemetry-instrumentation-que" "opentelemetry-instrumentation-racecar" "opentelemetry-instrumentation-rack" "opentelemetry-instrumentation-rails" "opentelemetry-instrumentation-rake" "opentelemetry-instrumentation-rdkafka" "opentelemetry-instrumentation-redis" "opentelemetry-instrumentation-resque" "opentelemetry-instrumentation-restclient" "opentelemetry-instrumentation-ruby_kafka" "opentelemetry-instrumentation-sidekiq" "opentelemetry-instrumentation-sinatra" "opentelemetry-instrumentation-trilogy"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0any46vsxkbmq9r4mziiyfsjyqyszplnkfkzxhchzljj6ld6dab3";
      type = "gem";
    };
    version = "0.87.0";
  };
  opentelemetry-instrumentation-anthropic = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pj8ba95k2x46x8miaqinj9psf0zs7qlkfppq2k8k4qqlr5rpg89";
      type = "gem";
    };
    version = "0.3.0";
  };
  opentelemetry-instrumentation-aws_lambda = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k1ksgyaix82bpll1pymqfia0f3c0y6nd841vpnwk6zy7hwn2c8s";
      type = "gem";
    };
    version = "0.6.0";
  };
  opentelemetry-instrumentation-aws_sdk = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qqim5n5mnp0n6lw4d0gh3dxhn4im8bf2iiyijxy4lfz9msix8k7";
      type = "gem";
    };
    version = "0.11.0";
  };
  opentelemetry-instrumentation-base = {
    dependencies = ["opentelemetry-api" "opentelemetry-common" "opentelemetry-registry"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ysfv2x25svwl4yxrbgmjkwrlkylr7plci3jjb6wkim11zklak4";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-bunny = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1195m9jaaax2p0h3bmnr7q7xi3g7x73np3iyqg8a2hjzibj89i0y";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-concurrent_ruby = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lniyy8yzmvz1mrh7az0yn94j4d9p0vvd6v0jgk9vi8042vxi6r2";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-dalli = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bxw2ji4nzkkb1i9mkrdxxwbb6jjxwdgvjc1wbbyh2anai86cs52";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-instrumentation-delayed_job = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v63h38nkngac0c3bxc45bdjabjs17m0vqdv5dyarndzs885pws7";
      type = "gem";
    };
    version = "0.25.1";
  };
  opentelemetry-instrumentation-ethon = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mijs94727lq23irw7j19ci3whhibs0rnr8ipx623i1yb64ipdf7";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-excon = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01rwnxml7h9vcwfdf2n1zr6kfxfcplr1i00aga8xd76wmbvld8fg";
      type = "gem";
    };
    version = "0.26.0";
  };
  opentelemetry-instrumentation-faraday = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n32aqsqj9lf46mvm1pr5f2j386aq1jia00aajp4qpb9vgf0jnq1";
      type = "gem";
    };
    version = "0.30.0";
  };
  opentelemetry-instrumentation-grape = {
    dependencies = ["opentelemetry-instrumentation-rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "093nvx4zr7qgwi62y0haimca4z99ki0mpplbgdbn7dhmn09vxz5r";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-instrumentation-graphql = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07qv80fq0n3rkw2fyd9wj5kjb4xqa6rw1j27h82zky17ahi5yid4";
      type = "gem";
    };
    version = "0.31.2";
  };
  opentelemetry-instrumentation-grpc = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11xw3vr47k45d3byjbq5rr8h7833lp0xiq93zv8vqsgcsnqjpyjz";
      type = "gem";
    };
    version = "0.4.1";
  };
  opentelemetry-instrumentation-gruf = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kfsb3gy0s1ninv698s024990n324n11d1wsgj21prqjwcvbw8gf";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-instrumentation-http = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ad0rrw0a74dzlhpcyccas54cl9zggfvdjxs6hdklhwkdla0vmr7";
      type = "gem";
    };
    version = "0.27.0";
  };
  opentelemetry-instrumentation-http_client = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mfa0ma9kl5yjzm1kph01y7cwk99nib4vibwz7d76rrk7qmiisx8";
      type = "gem";
    };
    version = "0.26.0";
  };
  opentelemetry-instrumentation-httpx = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09f1snp0spa0l6ky7m3rd1k26226rx8qv9nmfjw6ycrk22mw0g3i";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-instrumentation-koala = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yf61djnr45a5mylixawq17bd00crfj0bcdj9fcx8kx6l984nclg";
      type = "gem";
    };
    version = "0.23.0";
  };
  opentelemetry-instrumentation-lmdb = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jzmwlfdvaqapnmj9ll46hsymwas3ybn4405f97js97ahganck8y";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-mongo = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ylwgxh6syn79z7mg397hkqqz7fkc5h9k7s6ghpai3ljkxk8aifh";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-mysql2 = {
    dependencies = ["opentelemetry-helpers-mysql" "opentelemetry-helpers-sql" "opentelemetry-helpers-sql-obfuscation" "opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z8i8xhmyjvshswk00ivdkl2d1mjxhgfn6sh03pdfbayhkjdqvz8";
      type = "gem";
    };
    version = "0.31.0";
  };
  opentelemetry-instrumentation-net_http = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hx651frq9hncd14vi3yh5isrjsj2nalziy68k5j8afh4ydrhaf";
      type = "gem";
    };
    version = "0.26.0";
  };
  opentelemetry-instrumentation-pg = {
    dependencies = ["opentelemetry-helpers-sql" "opentelemetry-helpers-sql-obfuscation" "opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bqkgmsdxc4smc3y7z9i6acn77l9wb7m91slm843drwd80bkdp16";
      type = "gem";
    };
    version = "0.33.0";
  };
  opentelemetry-instrumentation-que = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09zpr7whrzlkz5wx1vjd2k265byjjkqv7ib0jxbbx0al2s2b0gwc";
      type = "gem";
    };
    version = "0.11.1";
  };
  opentelemetry-instrumentation-racecar = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k3806v0x7h5yiihs8wwa6nplhqvz070z0yid8l7cazjz4d7l9ny";
      type = "gem";
    };
    version = "0.6.0";
  };
  opentelemetry-instrumentation-rack = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xzk88iiiggx3kdfy5y75cb79cc5gn8jsl1vwg5n8w086s1vnb4y";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-instrumentation-rails = {
    dependencies = ["opentelemetry-instrumentation-action_mailer" "opentelemetry-instrumentation-action_pack" "opentelemetry-instrumentation-action_view" "opentelemetry-instrumentation-active_job" "opentelemetry-instrumentation-active_record" "opentelemetry-instrumentation-active_storage" "opentelemetry-instrumentation-active_support" "opentelemetry-instrumentation-concurrent_ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vy93a3hpi8l8crljxwxzxwmvyf9gg1pff6dnpxl0c2ljmwdynbr";
      type = "gem";
    };
    version = "0.39.1";
  };
  opentelemetry-instrumentation-rake = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vq118xmgp3lipccxn3hcxz71rjg9qlhdspacy5aqxc90wcx0szs";
      type = "gem";
    };
    version = "0.5.0";
  };
  opentelemetry-instrumentation-rdkafka = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fadamq0fy1bgmv2ia43ndji0pglbjzciic3bcxg16551lbbgpk";
      type = "gem";
    };
    version = "0.9.0";
  };
  opentelemetry-instrumentation-redis = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "001rd4ix10hja64y2arhpcd0hlmjilx7zlb4slmx4zaj3iyra8c7";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-resque = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r85z37whl9z40hl224d09ipn53dw8vfsjaimrbxfg97svlxv7jm";
      type = "gem";
    };
    version = "0.8.0";
  };
  opentelemetry-instrumentation-restclient = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kmx71jqhi3fnsgisch323l2zd6399xy2xn04c84lmjixy9rskjx";
      type = "gem";
    };
    version = "0.26.0";
  };
  opentelemetry-instrumentation-ruby_kafka = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hjji7x52nix6h4yv6nl7i4wrbs4gd4qsh390qzblc769hgqjzi5";
      type = "gem";
    };
    version = "0.24.0";
  };
  opentelemetry-instrumentation-sidekiq = {
    dependencies = ["opentelemetry-instrumentation-base"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vi2ac1l66vsflslxv6ay4ml95svcq53v8rdmwf2c3vl94f6b3bl";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-sinatra = {
    dependencies = ["opentelemetry-instrumentation-rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09kz6j3w2j2s0kxgyj2xk6vdc1r7z7wa3b1kssniqhhab26dc4cz";
      type = "gem";
    };
    version = "0.28.0";
  };
  opentelemetry-instrumentation-trilogy = {
    dependencies = ["opentelemetry-helpers-mysql" "opentelemetry-helpers-sql" "opentelemetry-helpers-sql-obfuscation" "opentelemetry-instrumentation-base" "opentelemetry-semantic_conventions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1icz6147f7g1rlq6pwb9zwp5pzg91wngv8lrjzp5fvp84zvikam2";
      type = "gem";
    };
    version = "0.64.0";
  };
  opentelemetry-registry = {
    dependencies = ["opentelemetry-api"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13wns85c08hjy7gqqjxqad9pp5shp0lxskrssz0w3si9mazscgwh";
      type = "gem";
    };
    version = "0.4.0";
  };
  opentelemetry-sdk = {
    dependencies = ["opentelemetry-api" "opentelemetry-common" "opentelemetry-registry" "opentelemetry-semantic_conventions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06jjh25s94lv94ljgbq13baqgnkccdsvzsw6xg54vwldpr4rjwa3";
      type = "gem";
    };
    version = "1.10.0";
  };
  opentelemetry-semantic_conventions = {
    dependencies = ["opentelemetry-api"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05znn2iijg1qli52m09bgyq4b74nfs5nwgz2z73sllvqpiyn1cf1";
      type = "gem";
    };
    version = "1.36.0";
  };
  optimist = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kp3f8g7g7cbw5vfkmpdv71pphhpcxk3lpc892mj9apkd7ys1y4c";
      type = "gem";
    };
    version = "3.2.1";
  };
  os = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      type = "gem";
    };
    version = "1.1.4";
  };
  ostruct = {
    groups = ["default" "ldap" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  overviews = {
    dependencies = ["grids"];
    groups = ["opf_plugins"];
    platforms = [];
    source = {
      path = modules/overviews;
      type = "path";
    };
    version = "1.0.0";
  };
  ox = {
    dependencies = ["bigdecimal"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rhv8qdnm3s34yvsvmrii15f2238rk3psa6pq6x5x367sssfv6ja";
      type = "gem";
    };
    version = "2.14.23";
  };
  pagy = {
    dependencies = ["json" "yaml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hxmih7v10jwfj86lc6a0mv7cpwa4c1rk601hpx6cvfxdqma3f5l";
      type = "gem";
    };
    version = "43.1.5";
  };
  paper_trail = {
    dependencies = ["activerecord" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "118w09wvy4s7jykv5b7j5ac9nkx158g853lh2mqclx1q3l344a0w";
      type = "gem";
    };
    version = "17.0.0";
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c719bfgcszqvk9z47w2p8j2wkz5y35k48ywwas5yxbbh3hm3haa";
      type = "gem";
    };
    version = "1.27.0";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w2xfc3jrj92w78yd4413s48lkjf3mjw47x4yw8b4qhld664a1fz";
      type = "gem";
    };
    version = "4.10.1";
  };
  parser = {
    dependencies = ["ast" "racc"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mmb59323ldv6vxfmy98azgsla9k3di3fasvpb28hnn5bkx8fdff";
      type = "gem";
    };
    version = "3.3.10.0";
  };
  pdf-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fz0yj4zrlii2j08kaw11j769s373ayz8jrdhxwwjzmm28pqndjg";
      type = "gem";
    };
    version = "0.9.0";
  };
  pdf-inspector = {
    dependencies = ["pdf-reader"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g853az4xzgqxr5xiwhb76g4sqmjg4s79mm35mp676zjsrwpa47w";
      type = "gem";
    };
    version = "1.3.0";
  };
  pdf-reader = {
    dependencies = ["Ascii85" "afm" "hashery" "ruby-rc4" "ttfunk"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11h8dhhd2c8mxssibk9q6qn7ilj4p71crlfirw8pppn8pr85f0n5";
      type = "gem";
    };
    version = "2.15.0";
  };
  pg = {
    groups = ["postgres"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xf8i58shwvwlka4ld12nxcgqv0d5r1yizsvw74w5jaw83yllqaq";
      type = "gem";
    };
    version = "1.6.2";
  };
  plaintext = {
    dependencies = ["activesupport" "nokogiri" "rubyzip"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11gkc5xncdwv3bdm14z8c7hqm56ll5ar843983g6pqllkz73vqba";
      type = "gem";
    };
    version = "0.3.6";
  };
  pp = {
    dependencies = ["prettyprint"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xlxmg86k5kifci1xvlmgw56x88dmqf04zfzn7zcr4qb8ladal99";
      type = "gem";
    };
    version = "0.6.3";
  };
  prawn = {
    dependencies = ["pdf-core" "ttfunk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9avv2rprsjisdk137s9ljr05r7ajhm78hxa1vjsv0jyx22f1l2";
      type = "gem";
    };
    version = "2.4.0";
  };
  prawn-table = {
    dependencies = ["prawn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxd6qmxqwl850icp18wjh5k0s3amxcajdrkjyzpfgq0kvilcv9k";
      type = "gem";
    };
    version = "0.2.2";
  };
  prettyprint = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
      type = "gem";
    };
    version = "0.2.0";
  };
  prism = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sqwckzzpj1mmmjnqcvqmq6adlxbhkf5ij3b6ir4i33ih4d2ih5z";
      type = "gem";
    };
    version = "1.6.0";
  };
  prometheus-client-mmap = {
    dependencies = ["base64" "bigdecimal" "logger" "rb_sys"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i0l7v26vq8k6wvsfk9fzpswilbg4214d9p9xc87kmswl1kwxm26";
      type = "gem";
    };
    version = "1.2.10";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ssv704qg75mwlyagdfr9xxbzn1ziyqgzm0x474jkynk8234pm8j";
      type = "gem";
    };
    version = "0.15.2";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wpa3jd46h44rjz3hjwl5c0zfx3jav4a64nm8h0g1iwv61yvn2hb";
      type = "gem";
    };
    version = "3.11.0";
  };
  pry-rails = {
    dependencies = ["pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0garafb0lxbm3sx2r9pqgs7ky9al58cl3wmwc0gmvmrl9bi2i7m6";
      type = "gem";
    };
    version = "0.3.11";
  };
  pry-rescue = {
    dependencies = ["interception" "pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nx6mf97vv11bgy2giljgwds8rjj8kw0qyc6zn3varlqdm8gsnwq";
      type = "gem";
    };
    version = "1.6.0";
  };
  psych = {
    dependencies = ["date" "stringio"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vii1xc7x81hicdbp7dlllhmbw5w3jy20shj696n0vfbbnm2hhw1";
      type = "gem";
    };
    version = "5.2.6";
  };
  public_suffix = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1543ap9w3ydhx39ljcd675cdz9cr948x9mp00ab8qvq6118wv9xz";
      type = "gem";
    };
    version = "6.0.2";
  };
  puffing-billy = {
    dependencies = ["addressable" "em-http-request" "em-synchrony" "eventmachine" "eventmachine_httpserver" "http_parser.rb" "multi_json"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k5k92z8q5zqxbb59bqrjandrklxrpf43kv43wq4ff3yfc7n30y9";
      type = "gem";
    };
    version = "4.0.2";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pa9zpr51kqnsq549p6apvnr95s9flx6bnwqii24s8jg2b5i0p74";
      type = "gem";
    };
    version = "7.1.0";
  };
  puma-plugin-statsd = {
    dependencies = ["puma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12yhv8dnh8pzmczpc4g71a8sa66f5d9a7w961vn0ck9z4fkl7wh4";
      type = "gem";
    };
    version = "2.7.0";
  };
  raabro = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10m8bln9d00dwzjil1k42i5r7l82x25ysbi45fwyv4932zsrzynl";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fgpa9qm5qgza69fjnagg2alxs2wmj41aq7z4kj5yib50wpzgqhl";
      type = "gem";
    };
    version = "2.2.21";
  };
  rack-attack = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wpcxspprm187k6mch9fxhaaq1a3s9bzybd2fdaw1g45pzg9yjgj";
      type = "gem";
    };
    version = "6.8.0";
  };
  rack-cors = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ysmn14pdf2wyr7agm0qvvr9pzcgyf39w4yvk2n05w9k4alwpa1";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-mini-profiler = {
    dependencies = ["rack"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y1x4rc7bz8x3zn8p6g21rw6ivbjml6a2vl9dhchiy8i6b110n28";
      type = "gem";
    };
    version = "4.0.1";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects" "json-jwt" "rack"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19fi42hi9l474ki89y6cs8vrpfmc1h8zpd02iwjy4hw0a1yahfn7";
      type = "gem";
    };
    version = "2.2.1";
  };
  rack-protection = {
    dependencies = ["base64" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zzvivmdb4dkscc58i3gmcyrnypynsjwp6xgc4ylarlhqmzvlx1w";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-session = {
    dependencies = ["rack"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xhxhlsz6shh8nm44jsmd9276zcnyzii364vhcvf0k8b8bjia8d0";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qy4ylhcfdn65a5mz2hly7g9vl0g13p5a0rmm6sc0sih5ilkcnh0";
      type = "gem";
    };
    version = "2.2.0";
  };
  rack-timeout = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nc7kis61n4q7g78gxxsxygam022glmgwq9snydrkjiwg7lkfwvm";
      type = "gem";
    };
    version = "0.7.0";
  };
  rack_session_access = {
    dependencies = ["builder" "rack"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0swd35lg7qmqhc3pglvsanq2indnvw360m8qxfxwqabl0br9isq3";
      type = "gem";
    };
    version = "0.2.0";
  };
  rackup = {
    dependencies = ["rack" "webrick"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jf2ncj2nx56vh96hh2nh6h4r530nccxh87z7c2f37wq515611ms";
      type = "gem";
    };
    version = "1.0.1";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv2g40b3hks0gqp7pbapj26cxz78z73dl1mq7azkhrd5nir8i1n";
      type = "gem";
    };
    version = "8.0.4";
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "151f303jcvs8s149mhx2g5mn67487x0blrf9dzl76q1nb7dlh53l";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "minitest" "nokogiri"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07awj8bp7jib54d0khqw391ryw8nphvqgw4bb12cl4drlx9pkk4a";
      type = "gem";
    };
    version = "2.3.0";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah" "nokogiri"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q55i6mpad20m2x1lg5pkqfpbmmapk0sjsrvr1sqgnj2hb5f5z1m";
      type = "gem";
    };
    version = "1.6.2";
  };
  rails-i18n = {
    dependencies = ["i18n" "railties"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1brqyx0cn46lwgxni943ri9lcg12hskzw8d54j0d4pzqabv32kv2";
      type = "gem";
    };
    version = "8.0.2";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "irb" "rackup" "rake" "thor" "tsort" "zeitwerk"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iybsmr8yv8gg6a4cikmh0394sk707qr7h85vny4mazzvi9xh0w2";
      type = "gem";
    };
    version = "8.0.4";
  };
  rainbow = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "175iisqb211n0qbfyqd8jz2g01q6xj038zjf4q0nm8k6kz88k7lc";
      type = "gem";
    };
    version = "13.3.1";
  };
  rake-compiler-dock = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lsdrlj1f5xcgg2phycfv1hvlsggiq6wqfff513i375skai20dz7";
      type = "gem";
    };
    version = "1.9.1";
  };
  rb-fsevent = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  rb_sys = {
    dependencies = ["rake-compiler-dock"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nfbhpmrcf2khvpxjrimdvqlzzw7msqdyqlkgb5cxfj0qvvflpvm";
      type = "gem";
    };
    version = "0.9.117";
  };
  rbtrace = {
    dependencies = ["ffi" "msgpack" "optimist"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "158qydqnrn1r0gm806j0bn439y0dyzdpscwi1sm3ldl1mcid5mx2";
      type = "gem";
    };
    version = "0.5.2";
  };
  rbtree3 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnq4rpr1pgmvghpr0cz66svm3dih3hnah2gvxq1njd553bylq5b";
      type = "gem";
    };
    version = "0.7.1";
  };
  rdoc = {
    dependencies = ["erb" "psych" "tsort"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06j83bdhsmq10083ahz3h125pnycx965cfpmg606l8lbrmrsrgr8";
      type = "gem";
    };
    version = "6.15.1";
  };
  recaptcha = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nvsa14nd4sgx7m0n2xas8y6jiid5wcqr0ka1jgkm6cvpb7fj0z0";
      type = "gem";
    };
    version = "5.21.1";
  };
  redcarpet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iglapqs4av4za9yfaac0lna7s16fq2xn36wpk380m55d8792i6l";
      type = "gem";
    };
    version = "3.6.1";
  };
  redis = {
    dependencies = ["redis-client"];
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpsh5dbvybsa8qnv4dg11a6f2zn4sndarf7pk4iaayjgaspbrmm";
      type = "gem";
    };
    version = "5.4.1";
  };
  redis-client = {
    dependencies = ["connection_pool"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w6nz3k1kkg2xwdkbaflkjaj62fvk9j7lgk6p2qgsffs556f6dxa";
      type = "gem";
    };
    version = "0.25.2";
  };
  regexp_parser = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "192mzi0wgwl024pwpbfa6c2a2xlvbh3mjd75a0sakdvkl60z64ya";
      type = "gem";
    };
    version = "2.11.3";
  };
  reline = {
    dependencies = ["io-console"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d8q5c4nh2g9pp758kizh8sfrvngynrjlm0i1zn3cnsnfd4v160i";
      type = "gem";
    };
    version = "0.6.3";
  };
  representable = {
    dependencies = ["declarative" "trailblazer-option" "uber"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kms3r6w6pnryysnaqqa9fsn0v73zx1ilds9d1c565n3xdzbyafc";
      type = "gem";
    };
    version = "3.2.0";
  };
  request_store = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jw89j9s5p5cq2k7ffj5p4av4j4fxwvwjs1a4i9g85d38r9mvdz1";
      type = "gem";
    };
    version = "1.7.0";
  };
  responders = {
    dependencies = ["actionpack" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0npm7nyld47f516idsmslfhypp7gm3jcl90ml5c68vz11anddhl9";
      type = "gem";
    };
    version = "3.2.0";
  };
  retriable = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
  };
  rexml = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  rinku = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zcdha17s1wzxyc5814j6319wqg33jbn58pg6wmxpws36476fq4b";
      type = "gem";
    };
    version = "2.0.6";
  };
  roar = {
    dependencies = ["representable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "024xjaidpll8d80xqlwm7pgf1hypc5b0sv618svmyyn5g75d3d4d";
      type = "gem";
    };
    version = "1.2.0";
  };
  rotp = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m48hv6wpmmm6cjr6q92q78h1i610riml19k5h1dil2yws3h1m3m";
      type = "gem";
    };
    version = "6.3.0";
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pkp5icgm7s10b2n6b2pzbdsfiv0l5sxqyizx55qdmlpaxnk8xah";
      type = "gem";
    };
    version = "4.6.1";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0klv9mibmnfqw92w5bc1bab1x4dai60xfh0xz0mhgicibsp3gcbq";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kis8dfxlvi6gdzrv9nsn3ckw0c2z7armhni917qs1jx7yjkjc8i";
      type = "gem";
    };
    version = "8.0.2";
  };
  rspec-retry = {
    dependencies = ["rspec-core"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n6qc0d16h6bgh1xarmc8vc58728mgjcsjj8wcd822c8lcivl0b1";
      type = "gem";
    };
    version = "0.6.2";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cmgz34hwj5s3jwxhyl8mszs24nci12ffbrmr5jb1si74iqf739f";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-wait = {
    dependencies = ["rspec"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04m9nmk55layv26s5ldara5vbn45sjyx9phhzhk3sp9j74994pw6";
      type = "gem";
    };
    version = "1.0.2";
  };
  rubocop = {
    dependencies = ["json" "language_server-protocol" "lint_roller" "parallel" "parser" "rainbow" "regexp_parser" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "157hg99cq6ys670sw8xbggnvxc9yl50h1zhllki925kkihlwrdbg";
      type = "gem";
    };
    version = "1.81.7";
  };
  rubocop-ast = {
    dependencies = ["parser" "prism"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xifbp09jfl1hdy9wwgq9dq2l7mf8y2ycm5d1zgcqvks7yzrppr2";
      type = "gem";
    };
    version = "1.48.0";
  };
  rubocop-capybara = {
    dependencies = ["lint_roller" "rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "030wymq0jrblrdswl1lncj60dhcg5wszz6708qzsbziyyap8rn6f";
      type = "gem";
    };
    version = "2.22.1";
  };
  rubocop-factory_bot = {
    dependencies = ["lint_roller" "rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jzhj9fi1h9rh7z2j6m78hl7c3av36fpacg12wrifi24281gq5sb";
      type = "gem";
    };
    version = "2.28.0";
  };
  rubocop-openproject = {
    dependencies = ["rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a580684xlw96ih5r2h5mvwv88x2pzhvwcibvijwz8phgrp4jm4m";
      type = "gem";
    };
    version = "0.3.0";
  };
  rubocop-performance = {
    dependencies = ["lint_roller" "rubocop" "rubocop-ast"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d0qyyw1332afi9glwfjkb4bd62gzlibar6j55cghv8rzwvbj6fd";
      type = "gem";
    };
    version = "1.26.1";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "lint_roller" "rack" "rubocop" "rubocop-ast"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jzpkb3vx2w8mg25gg18rvxzqvxziaqrwv14cqq2yaf1b0dh3344";
      type = "gem";
    };
    version = "2.33.3";
  };
  rubocop-rspec = {
    dependencies = ["lint_roller" "rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cxb9i1brf1cks8anv8mdj65n9rq6jyldyd1ij9sj8zjng60si18";
      type = "gem";
    };
    version = "3.8.0";
  };
  rubocop-rspec_rails = {
    dependencies = ["lint_roller" "rubocop" "rubocop-rspec"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004i5a4iww7l3vpaxl70ijypmi321afrslsgadbvksznf8f683aa";
      type = "gem";
    };
    version = "2.32.0";
  };
  ruby-duration = {
    dependencies = ["activesupport" "i18n" "iso8601"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "114p0rbg7lklznvcjiqyf8xjm17c3s7yvclgb80pl1l5vyqi6ggb";
      type = "gem";
    };
    version = "3.2.3";
  };
  ruby-next-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04j51ipkpqhhgh2nd90j5kby87305gcvik9y3dcg4aarwki5y28v";
      type = "gem";
    };
    version = "1.1.2";
  };
  ruby-ole = {
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wnblgzz0fax0746yd4i8z16fpsjr6r6yv18l4sjnykr5bfi13ap";
      type = "gem";
    };
    version = "1.2.13.1";
  };
  ruby-prof = {
    dependencies = ["base64"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h23zjwma8car8jpq7af8gw39qi88rn24mass7r13ripmky28117";
      type = "gem";
    };
    version = "1.7.2";
  };
  ruby-progressbar = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-rc4 = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    version = "0.1.5";
  };
  ruby-saml = {
    dependencies = ["nokogiri" "rexml"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01wi1csw4kjmlxmd1igx5hj2wrwkslay1xamg4cv8l7imr27l3hv";
      type = "gem";
    };
    version = "1.18.1";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubytree = {
    dependencies = ["json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hdxda4vmi6lp8wd4xvcj0c1yinsz2sw7y7ihblk05x8arih29a9";
      type = "gem";
    };
    version = "2.1.1";
  };
  rubyzip = {
    groups = ["default" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05an0wz87vkmqwcwyh5rjiaavydfn5f4q1lixcsqkphzvj7chxw5";
      type = "gem";
    };
    version = "2.4.1";
  };
  safety_net_attestation = {
    dependencies = ["jwt"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1apjjd99bqsc22bfq66j27dp4im0amisy619hr9qbghdapfh3kf8";
      type = "gem";
    };
    version = "0.5.0";
  };
  sanitize = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "111r4xdcf6ihdnrs6wkfc6nqdzrjq0z69x9sf83r7ri6fffip796";
      type = "gem";
    };
    version = "7.0.0";
  };
  scimitar = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f1f8qyir7iv3l7hjrzgvza43m2xmwz9agnkh0vchc2i0xigwdw4";
      type = "gem";
    };
    version = "2.13.0";
  };
  securerandom = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cd0iriqfsf1z91qg271sm88xjnfd92b832z49p1nd542ka96lfc";
      type = "gem";
    };
    version = "0.4.1";
  };
  selenium-devtools = {
    dependencies = ["selenium-webdriver"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17wcah8bkgwl3g6dwrdsv9a95p5nv390f2m2cxmxf789r6x8w04n";
      type = "gem";
    };
    version = "0.142.0";
  };
  selenium-webdriver = {
    dependencies = ["base64" "logger" "rexml" "rubyzip" "websocket"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bqhpwc6494zq1zsayjssi4xwcsbq9dkl399v7l4lfb6xwgyg10a";
      type = "gem";
    };
    version = "4.38.0";
  };
  semantic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qy1s2kpf9z2p99v23b126ij424yamxviprz59wbp3hrb67v9nrw";
      type = "gem";
    };
    version = "1.6.1";
  };
  shoulda-context = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d1clcp92jv8756h09kbc55qiqncn666alx0s83za06q5hs4bpvs";
      type = "gem";
    };
    version = "2.0.0";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xwwfj48d6mpc66lhl4yabnjazpf47wqg9n1i9na7q0h9isdigxl";
      type = "gem";
    };
    version = "7.0.1";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nydm087m5c3j85gvzvz30w1qb9pl2lzpznw746jha29ybxyj5yn";
      type = "gem";
    };
    version = "0.21.0";
  };
  simpleidn = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a9c1mdy12y81ck7mcn9f9i2s2wwzjh1nr92ps354q517zq9dkh8";
      type = "gem";
    };
    version = "0.2.3";
  };
  smart_properties = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jrqssk9qhwrpq41arm712226vpcr458xv6xaqbk8cp94a0kycpr";
      type = "gem";
    };
    version = "1.17.0";
  };
  spreadsheet = {
    dependencies = ["bigdecimal" "logger" "ruby-ole"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lwjqmmr01c3sh9r8hi0b778akxm9pazpxq9h59472ywvzrxdvqa";
      type = "gem";
    };
    version = "1.3.4";
  };
  spring = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bs0qgbbc51wyf9hc00wcmxldwk2z50bn3m8r6g6pna8zgsnqkpc";
      type = "gem";
    };
    version = "4.4.0";
  };
  spring-commands-rspec = {
    dependencies = ["spring"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0svpq3md1pjz5drpa5pxwg8nk48wrshq8lckim4x3nli7ya0k2";
      type = "gem";
    };
    version = "1.0.4";
  };
  spring-commands-rubocop = {
    dependencies = ["spring"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hcharzqmi0dpy9vxs21fl0mpmfmcsgbdgq4dyc8mbi7i8n7lrry";
      type = "gem";
    };
    version = "0.4.0";
  };
  sprockets = {
    dependencies = ["base64" "concurrent-ruby" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10ykzsa76cf8kvbfkszlvbyn4ckcx1mxjhfvwxzs7y28cljhzhkj";
      type = "gem";
    };
    version = "3.7.5";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17hiqkdpcjyyhlm997mgdcr45v35j5802m5a979i5jgqx5n8xs59";
      type = "gem";
    };
    version = "3.5.2";
  };
  ssrf_filter = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nx0vap3mrh62v37lr45h77ipp4li8x77v4kxr1psh3yhda9zx03";
      type = "gem";
    };
    version = "1.0.8";
  };
  stackprof = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03788mbipmihq2w7rznzvv0ks0s9z1321k1jyr6ffln8as3d5xmg";
      type = "gem";
    };
    version = "0.2.27";
  };
  store_attribute = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axm4pd2qxn87949i1nqm69n0n7m4kaipc78g61vam86h3j5adk4";
      type = "gem";
    };
    version = "2.0.1";
  };
  stringex = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i19x7snfbw0fsfjifvg57b8gm283hhdympj8qb1wym4nb985cy7";
      type = "gem";
    };
    version = "2.8.6";
  };
  stringio = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v74k5yw7ndikr53wgbjn6j51p83qnzqbn9z4b53r102jcx3ri4r";
      type = "gem";
    };
    version = "3.1.8";
  };
  structured_warnings = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q5ldvpsnri5igdfkyg5gs1rbwqaizwv7cgjhxcsqvb9mdcljl6";
      type = "gem";
    };
    version = "0.5.0";
  };
  svg-graph = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fji14c525hvql7jw04zphm8n44d4vvbbnnzmwwnaph50dj8ca7r";
      type = "gem";
    };
    version = "2.2.2";
  };
  swd = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m86fzmwgw0vc8p6fwvnsdbldpgbqdz9cbp2zj9z06bc4jjf5nsc";
      type = "gem";
    };
    version = "2.0.3";
  };
  sys-filesystem = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9bhw3zp8haayafg8w4xn0f0d0i14wk8x98ysq43rnhlis1c456";
      type = "gem";
    };
    version = "1.5.4";
  };
  table_print = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jxmd1yg3h0g27wzfpvq1jnkkf7frwb5wy9m4f47nf4k3wl68rj3";
      type = "gem";
    };
    version = "1.5.7";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lh18gwpksk25sbcjgh94vmfw2rz0lrq61n7lwp1n9gq0cr7j17m";
      type = "gem";
    };
    version = "4.0.0";
  };
  test-prof = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vsk2ca9kfrxhyd2xiiyr28hmxkh9vd8j2vwl5f1yfnkv4z52n8s";
      type = "gem";
    };
    version = "1.4.4";
  };
  text-hyphen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01js0wxz84cc5hzxgqbcqnsa0y6crhdi6plmgkzyfm55p0rlajn4";
      type = "gem";
    };
    version = "1.5.0";
  };
  thor = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gcarlmpfbmqnjvwfz44gdjhcmm634di7plcx2zdgwdhrhifhqw7";
      type = "gem";
    };
    version = "1.4.0";
  };
  thread_safe = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  timecop = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1syq1hdxq13ggy5c4sfk2378kzc1cgxdyv6b8c86pkydaz74bfhj";
      type = "gem";
    };
    version = "0.9.10";
  };
  timeout = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nqf9rg974k4bjji7aggalg8pfvbkd9hys4hv5y450jb21qgkxph";
      type = "gem";
    };
    version = "0.4.4";
  };
  tpm-key_attestation = {
    dependencies = ["bindata" "openssl" "openssl-signature_algorithm"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gqr27hrmg35j7kcb6c2cx3xvkqfs42zpp9jcqw0mzbs79jy9m3z";
      type = "gem";
    };
    version = "0.14.1";
  };
  trailblazer-option = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18s48fndi2kfvrfzmq6rxvjfwad347548yby0341ixz1lhpg3r10";
      type = "gem";
    };
    version = "0.1.2";
  };
  tsort = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    version = "0.2.0";
  };
  ttfunk = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15iaxz9iak5643bq2bc0jkbjv8w2zn649lxgvh5wg48q9d4blw13";
      type = "gem";
    };
    version = "1.7.0";
  };
  turbo-rails = {
    dependencies = ["actionpack" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15gafkrlg8rdk2fra0w3rjc1jwicbdjv24grr5qn97z57kfv9jyb";
      type = "gem";
    };
    version = "2.0.20";
  };
  turbo_power = {
    dependencies = ["turbo-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ryrj2r22nsxflijxjm8pgvdvdy7502s175d4c01sxpsw13x35dd";
      type = "gem";
    };
    version = "0.7.0";
  };
  turbo_tests = {
    dependencies = ["parallel_tests" "rspec"];
    groups = ["test"];
    platforms = [];
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
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f898y35w60mkx3sd8ld2ryzkj4cld04qlgxi3z3hzdlzfhpa8x9";
      type = "gem";
    };
    version = "1.2025.2";
  };
  uber = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  unicode-display_width = {
    dependencies = ["unicode-emoji"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";
      type = "gem";
    };
    version = "3.2.0";
  };
  unicode-emoji = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1995yfjbvjlwrslq48gzzc9j0blkdzlbda9h90pjbm0yvzax55s9";
      type = "gem";
    };
    version = "4.1.0";
  };
  uri = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    version = "1.1.1";
  };
  useragent = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i1q2xdjam4d7gwwc35lfnz0wyyzvnca0zslcfxm9fabml9n83kh";
      type = "gem";
    };
    version = "0.16.11";
  };
  validate_email = {
    dependencies = ["activemodel" "mail"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r1fz29l699arka177c9xw7409d1a3ff95bf7a6pmc97slb91zlx";
      type = "gem";
    };
    version = "0.1.6";
  };
  validate_url = {
    dependencies = ["activemodel" "public_suffix"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lblym140w5n88ijyfgcvkxvpfj8m6z00rxxf2ckmmhk0x61dzkj";
      type = "gem";
    };
    version = "1.0.15";
  };
  vcr = {
    dependencies = ["base64"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v83xjgj5y1fzp7nm4s5dixwpy5yr8crklyjyjilc13jgqanxd9p";
      type = "gem";
    };
    version = "6.3.1";
  };
  vernier = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b2gb06k7vz58wpqhcc2hx9bciicy1w3pnff6klrb0d2vibzczri";
      type = "gem";
    };
    version = "1.8.1";
  };
  view_component = {
    dependencies = ["actionview" "activesupport" "concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zipgg0pj1dydckyz8jddxmxzg5jar26ip9myrm8y6hxvfq677qp";
      type = "gem";
    };
    version = "4.1.1";
  };
  virtus = {
    dependencies = ["axiom-types" "coercible" "descendants_tracker"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hniwgbdsjxa71qy47n6av8faf8qpwbaapms41rhkk3zxgjdlhc8";
      type = "gem";
    };
    version = "2.0.0";
  };
  warden = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l7gl7vms023w4clg02pm4ky9j12la2vzsixi2xrv9imbn44ys26";
      type = "gem";
    };
    version = "1.2.9";
  };
  warden-basic_auth = {
    dependencies = ["warden"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viw3wwx3shlb4mynjim99xixs71qn2054wywv1q40cw23h55ixz";
      type = "gem";
    };
    version = "0.2.1";
  };
  webauthn = {
    dependencies = ["android_key_attestation" "bindata" "cbor" "cose" "openssl" "safety_net_attestation" "tpm-key_attestation"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z710ndfr9yajywhji8mr5gc3j3wnr0alq754q15nh7k73wgbrlv";
      type = "gem";
    };
    version = "3.4.3";
  };
  webfinger = {
    dependencies = ["activesupport" "faraday" "faraday-follow_redirects"];
    groups = ["default" "opf_plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p39802sfnm62r4x5hai8vn6d1wqbxsxnmbynsk8rcvzwyym4yjn";
      type = "gem";
    };
    version = "2.1.3";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mqw7ca931zmqgad0fq4gw7z3gwb0pwx9cmd1b12ga4hgjsnysag";
      type = "gem";
    };
    version = "3.26.1";
  };
  webrick = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12d9n8hll67j737ym2zw4v23cn4vxyfkb6vyv1rzpwv6y6a3qbdl";
      type = "gem";
    };
    version = "1.9.1";
  };
  websocket = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dr78vh3ag0d1q5gfd8960g1ca9g6arjd2w54mffid8h4i7agrxp";
      type = "gem";
    };
    version = "1.2.11";
  };
  websocket-driver = {
    dependencies = ["base64" "websocket-extensions"];
    groups = ["default" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj9dmkmgahmadgh88kydb7cv15w13l1fj3kk9zz28iwji5vl3gd";
      type = "gem";
    };
    version = "0.8.0";
  };
  websocket-extensions = {
    groups = ["default" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  will_paginate = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fbmm0amshidnw0qx0nqjzfyy7if8xy6m5bm8lkksf8xprp24yqh";
      type = "gem";
    };
    version = "4.0.1";
  };
  with_advisory_lock = {
    dependencies = ["activerecord" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "001sswk3d1n8nf4pzxxc4rvxw47q05m0harl50ys25b18nxqai6z";
      type = "gem";
    };
    version = "7.0.2";
  };
  xpath = {
    dependencies = ["nokogiri"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
  yabeda = {
    dependencies = ["anyway_config" "concurrent-ruby" "dry-initializer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gs338sij92yfxd77chh5pwslmy28qigvjczla0bsbk95pr7nldw";
      type = "gem";
    };
    version = "0.14.0";
  };
  yabeda-activerecord = {
    dependencies = ["activerecord" "anyway_config" "yabeda"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qp0lcspci6f9qjhv75bx6bs627ak7khbahqcxd48hjp9sk83lhx";
      type = "gem";
    };
    version = "0.1.2";
  };
  yabeda-prometheus-mmap = {
    dependencies = ["prometheus-client-mmap" "yabeda"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jg2x5bgfbyzhx99yfpq3xl72386g67f113p7bq33yfnaq3i4rhs";
      type = "gem";
    };
    version = "0.4.0";
  };
  yabeda-puma-plugin = {
    dependencies = ["json" "puma" "yabeda"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ic15l0x101hjq4fa61wlng5yr1vv8ki9k00a3531850rqq1v4i";
      type = "gem";
    };
    version = "0.8.0";
  };
  yabeda-rails = {
    dependencies = ["activesupport" "anyway_config" "railties" "yabeda"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z130k5qsby0xahqc6gr6vw45l75d0iij80x4ik4yjb1k61bv18a";
      type = "gem";
    };
    version = "0.10.0";
  };
  yaml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hhr8z9m9yq2kf7ls0vf8ap1hqma1yd72y2r13b88dffwv8nj3i4";
      type = "gem";
    };
    version = "0.4.0";
  };
  yard = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14k9lb9a60r9z2zcqg08by9iljrrgjxdkbd91gw17rkqkqwi1sd6";
      type = "gem";
    };
    version = "0.9.37";
  };
  zeitwerk = {
    groups = ["default" "development" "opf_plugins" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "119ypabas886gd0n9kiid3q41w76gz60s8qmiak6pljpkd56ps5j";
      type = "gem";
    };
    version = "2.7.3";
  };
}
