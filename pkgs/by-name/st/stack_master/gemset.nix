{
  activesupport = {
    dependencies = ["base64" "bigdecimal" "concurrent-ruby" "connection_pool" "drb" "i18n" "minitest" "mutex_m" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0283wk1zxb76lg79dk501kcf5xy9h25qiw15m86s4nrfv11vqns5";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  attribute_struct = {
    dependencies = ["bogo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sar9blf0lw04m1i54yqf3f3g6w9skr4l0lxcyvk1xs48frlaibb";
      type = "gem";
    };
    version = "0.4.4";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gvdg4yx4p9av2glmp7vsxhs0n8fj1ga9kq2xdb8f95j7b04qhzi";
      type = "gem";
    };
    version = "1.3.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "039s2hp6f1cy8f8xvrxhim4lc5snf01yd3hy5xa5rjwmw4a2laza";
      type = "gem";
    };
    version = "1.944.0";
  };
  aws-sdk-acm = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184a41gghm7k6m6g2sa3jzbfw65lysl68wzdsimvn67c6qismdrg";
      type = "gem";
    };
    version = "1.69.0";
  };
  aws-sdk-cloudformation = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gqi8flfy50vn8nl0jvilivjjn7fmvzakn600byhm7pcz1n6jw9v";
      type = "gem";
    };
    version = "1.110.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "146v6mhf8gma5vmzhz643sddwzhv3acapv7nhaisv4fcsf1lii1l";
      type = "gem";
    };
    version = "3.197.0";
  };
  aws-sdk-ec2 = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zp8zl4hwjyf8d6sfhpc2vh0r2p8vj6s4czmqdf2c0qnf42qh7zk";
      type = "gem";
    };
    version = "1.460.0";
  };
  aws-sdk-ecr = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17c3wkpx3g6nj0v89ik955h3whxxpknyzwxqywrp0pfv1nxzi725";
      type = "gem";
    };
    version = "1.73.0";
  };
  aws-sdk-iam = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mm82w7cqn16m4da9fq12m257rbrdcd63mdk1azaa4qrzl5g62dh";
      type = "gem";
    };
    version = "1.99.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gqnxilhrgnvcvp1914d24dscxrbyk1m9r5a50lfcdmxa9d8g70w";
      type = "gem";
    };
    version = "1.83.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w8sy334pnhmz0fvpsm8fxmf6a20rvns2w7vzhzn7ik67p6bfgxc";
      type = "gem";
    };
    version = "1.152.2";
  };
  aws-sdk-sns = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vj8ah12qybm16hyhwpq8m2p2pvgbl0lndpgxvk24rn98n11igqk";
      type = "gem";
    };
    version = "1.77.0";
  };
  aws-sdk-ssm = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14jamwq1a0l8aig6am2a4zgrghn3d9ix811wd0fafk9i27kijkmc";
      type = "gem";
    };
    version = "1.170.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g3w27wzjy4si6kp49w10as6ml6g6zl3xrfqs5ikpfciidv9kpc4";
      type = "gem";
    };
    version = "1.8.0";
  };
  base64 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01qml0yilb9basf7is2614skjp8384h2pycfx86cr8023arfj98g";
      type = "gem";
    };
    version = "0.2.0";
  };
  bigdecimal = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gi7zqgmqwi5lizggs1jhc3zlwaqayy9rx2ah80sxy24bbnng558";
      type = "gem";
    };
    version = "3.1.8";
  };
  bogo = {
    dependencies = ["hashie" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "139alszinqdnh9qdal23z7z9lypm3z63d54cl97d8m99x3b9w6sp";
      type = "gem";
    };
    version = "0.2.16";
  };
  cfn-model = {
    dependencies = ["kwalify" "psych"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b3ix36yfnfwyxb4w9ss8a7nc6w15m1wbj3q8rarsqjrs3xj6wjs";
      type = "gem";
    };
    version = "0.6.6";
  };
  cfn-nag = {
    dependencies = ["aws-sdk-s3" "cfn-model" "lightly" "logging" "netaddr" "optimist" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cyk4pimz1g5lqf4vw2p9kf8ji3v53zfi8jix8sgz4ndy81ylah5";
      type = "gem";
    };
    version = "0.8.10";
  };
  cfndsl = {
    dependencies = ["hana"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yr936fggbnajbllmvpl1y8bzblf4wf62z9wf2gbr0s5p304hyi1";
      type = "gem";
    };
    version = "1.6.0";
  };
  commander = {
    dependencies = ["highline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z95bzmxkg1w5hqd0yiwfjrpafyh4cd8774s7rzimvg5dj345ji2";
      type = "gem";
    };
    version = "5.0.0";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0skwdasxq7mnlcccn6aqabl7n9r3jd7k19ryzlzzip64cn4x572g";
      type = "gem";
    };
    version = "1.3.3";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x32mcpm2cl5492kd6lbjbaf17qsssmpx9kdyr7z1wcif2cwyh0g";
      type = "gem";
    };
    version = "2.4.1";
  };
  deep_merge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjn4civid68a3zxnbgyjj6krs3l30dy8b4djpg6fpzrsyix7kl3";
      type = "gem";
    };
    version = "1.2.2";
  };
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1znxccz83m4xgpd239nyqxlifdb7m8rlfayk6s259186nkgj6ci7";
      type = "gem";
    };
    version = "1.5.1";
  };
  diffy = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qcsv29ljfhy76gq4xi8zpn6dc6nv15c41r131bdr38kwpxjzd1n";
      type = "gem";
    };
    version = "3.4.2";
  };
  dotgpg = {
    dependencies = ["gpgme" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17mhijaz511sl2bjvkyjdf07bm2x8x8mbdrz1yi3kpz7dps8pak4";
      type = "gem";
    };
    version = "0.7.0";
  };
  drb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h5kbj9hvg5hb3c7l425zpds0vb42phvln2knab8nmazg2zp5m79";
      type = "gem";
    };
    version = "2.2.1";
  };
  ejson = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpry4i9ajh2h8fyljp0cb17iy03ar36yc9mpfxflmdznl7dwsjf";
      type = "gem";
    };
    version = "1.4.1";
  };
  ejson_wrapper = {
    dependencies = ["aws-sdk-kms" "base64" "ejson"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gaw7gkmqhsmx3ijgshxqgwk194gw6v32skmf3dj2ys035wq8ccc";
      type = "gem";
    };
    version = "0.5.0";
  };
  erubis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  gpgme = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r1vmql7w7ka5xzj1aqf8pk2a4sv0znwj2zkg1fgvd5b89qcvv2k";
      type = "gem";
    };
    version = "2.0.24";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jf9dxgjz6z7fvymyz2acyvn9iyvwkn6d9sk7y4fxwbmfc75yimm";
      type = "gem";
    };
    version = "1.1.0";
  };
  hashie = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nh3arcrbz1rc1cr59qm53sdhqm137b258y8rcb4cvd3y98lwv4x";
      type = "gem";
    };
    version = "5.0.0";
  };
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02ghhvigqbq4252gsi4w8a9klkdkybmbz29ghfp1y6sqzlcb466a";
      type = "gem";
    };
    version = "3.0.1";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ffix518y7976qih9k1lgnc17i3v6yrlh0a3mckpxdb4wc2vrp16";
      type = "gem";
    };
    version = "1.14.5";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  kwalify = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ngxg3ysq5vip9dn3d32ajc7ly61kdin86hfycm1hkrcvkkn1vjf";
      type = "gem";
    };
    version = "0.7.2";
  };
  lightly = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sgj2r6j7qxb9vqzkx5isjbphi38rplk4h8838am0cjcpq5h3jb3";
      type = "gem";
    };
    version = "0.3.3";
  };
  little-plugger = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logging = {
    dependencies = ["little-plugger" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q1f2sdw3y3y9mnym9dhjgsjr72sq975cfg5c4yx7gwv8nmzbvhk";
      type = "gem";
    };
    version = "2.8.7";
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gkslxvkhh44s21rbjvka3zsvfxxrf5pcl6f75rv2vyrzzbgis7i";
      type = "gem";
    };
    version = "5.23.1";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  mutex_m = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ma093ayps1m92q845hmpk0dmadicvifkbf05rpq9pifhin0rvxn";
      type = "gem";
    };
    version = "0.2.0";
  };
  netaddr = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d7iccg9cjcsfl0fd0iiqfc5s7yh2602dgscbji5lrn2q879ghz7";
      type = "gem";
    };
    version = "2.0.6";
  };
  optimist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vg2chy1cfmdj6c1gryl8zvjhhmb3plwgyh1jfnpq4fnfqv7asrk";
      type = "gem";
    };
    version = "3.0.1";
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
  psych = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "186i2hc6sfvg4skhqf82kxaf4mb60g65fsif8w8vg1hc9mbyiaph";
      type = "gem";
    };
    version = "3.3.4";
  };
  rainbow = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rbtree = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z0h1x7fpkzxamnvbw1nry64qd6n0nqkwprfair29z94kd3a9vhl";
      type = "gem";
    };
    version = "0.4.6";
  };
  rexml = {
    dependencies = ["strscan"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0428ady49qssmnmwnafzrjvyba8mzbridsgblv7c7kmd0vqgfn99";
      type = "gem";
    };
    version = "3.3.0";
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  set = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vmxa781w2983k5gi8wrirsva6hgbvfxfp57jxs2n8j7gr3l8sp";
      type = "gem";
    };
    version = "1.1.0";
  };
  sorted_set = {
    dependencies = ["rbtree" "set"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0brpwv68d7m9qbf5js4bg8bmg4v7h4ghz312jv9cnnccdvp8nasg";
      type = "gem";
    };
    version = "1.0.3";
  };
  sparkle_formation = {
    dependencies = ["attribute_struct" "bogo" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "179clm0gzyqv339q3iwsqvb17gwsiqjjnfd5rmqnn3m071manlgk";
      type = "gem";
    };
    version = "3.0.40";
  };
  stack_master = {
    dependencies = ["activesupport" "aws-sdk-acm" "aws-sdk-cloudformation" "aws-sdk-ec2" "aws-sdk-ecr" "aws-sdk-iam" "aws-sdk-s3" "aws-sdk-sns" "aws-sdk-ssm" "cfn-nag" "cfndsl" "commander" "deep_merge" "diff-lcs" "diffy" "ejson_wrapper" "erubis" "hashdiff" "multi_json" "os" "rainbow" "ruby-progressbar" "sorted_set" "sparkle_formation" "table_print"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wca9w89p3l2ww3dgx2i1n7an918xj19vqwpby0y6600f0m0gij7";
      type = "gem";
    };
    version = "2.14.1";
  };
  stack_master-gpg_parameter_resolver = {
    dependencies = ["dotgpg" "stack_master"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0knhz4skwmfffl7qg2b4320aqr278fk2kqjgmhdhz4hc8ad13ard";
      type = "gem";
    };
    version = "1.0.0";
  };
  strscan = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mamrl7pxacbc79ny5hzmakc9grbjysm3yy6119ppgsg44fsif01";
      type = "gem";
    };
    version = "3.1.0";
  };
  table_print = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jxmd1yg3h0g27wzfpvq1jnkkf7frwb5wy9m4f47nf4k3wl68rj3";
      type = "gem";
    };
    version = "1.5.7";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vq1fjp45az9hfp6fxljhdrkv75cvbab1jfrwcw738pnsiqk8zps";
      type = "gem";
    };
    version = "1.3.1";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
}
