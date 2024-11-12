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
      sha256 = "03zb6x4x68y91gywsyi4a6hxy4pdyng8mnxwd858bhjfymml8kkf";
      type = "gem";
    };
    version = "1.956.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ihl7iwndl3jjy89sh427wf8mdb7ii76bsjf6fkxq9ha30nz4f3g";
      type = "gem";
    };
    version = "3.201.1";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02g3l3lcyddqncrwjxgawxl33p2p715k1gbrdlgyiv0yvy88sn0k";
      type = "gem";
    };
    version = "1.88.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ika0xmmrkc7jiwdi5gqia5wywkcbw1nal2dhl436dkh38fxl0lk";
      type = "gem";
    };
    version = "1.156.0";
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
  cli-format = {
    dependencies = ["activesupport" "text-table" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rrjck5r25dlcg1gwz6pb5f4rllx77lg6a514a5l3lajfd95shm3";
      type = "gem";
    };
    version = "0.6.1";
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
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y24jabiz4cf9ni9vi4j8sab8b5phpf2mpw3981r0r94l4m6q0q8";
      type = "gem";
    };
    version = "3.1.2";
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
  dsl_evaluator = {
    dependencies = ["activesupport" "memoist" "rainbow" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hd079baa5pfyyc2wc9p5h82qjp7fnx0s0shn2i19ig186cizh2x";
      type = "gem";
    };
    version = "0.3.2";
  };
  eventmachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  eventmachine-tail = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x5ly7mnfr6gibjyxz6lrxb4jbf05p0r8257qcgkf8rkwg9ynw0c";
      type = "gem";
    };
    version = "0.6.5";
  };
  graph = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bwssjgl9nfq9jhn9bfc7pqfl2c2xi0wnpng66l029m03kmdq8k4";
      type = "gem";
    };
    version = "2.11.1";
  };
  hcl_parser = {
    dependencies = ["rhcl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09d55i9y187xkw0fi0b5aq8wyzvq8w73ryi939dvzdzgss25m7jj";
      type = "gem";
    };
    version = "0.2.2";
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
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
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
      sha256 = "0jj629q3vw5yn90q4di4dyb87pil4a8qfm2srhgy5nc8j2n33v1i";
      type = "gem";
    };
    version = "5.24.1";
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
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz1ychq2fhfqjgqdrx8bqkaxg5dzcgwnah00m57ydylczfy8pwk";
      type = "gem";
    };
    version = "1.16.6";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "021s7maw0c4d9a6s07vbmllrzqsj2sgmrwimlh8ffkvwqdjrld09";
      type = "gem";
    };
    version = "1.8.0";
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
  render_me_pretty = {
    dependencies = ["activesupport" "rainbow" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qx9pv0irkcqjx9f0mh5s6d9m0fck329bp845ryic34nsvnbsp4k";
      type = "gem";
    };
    version = "0.9.0";
  };
  rexml = {
    dependencies = ["strscan"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zr5qpa8lampaqzhdcjcvyqnrqcjl7439mqjlkjz43wdhmpnh4s5";
      type = "gem";
    };
    version = "3.3.2";
  };
  rhcl = {
    dependencies = ["deep_merge"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c7xp9y9438mnqrfrvjp1fwy2lk0b1ixz45qi2g2kbl91ilhn834";
      type = "gem";
    };
    version = "0.1.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xrp8vq6i9zx37vh0yp4h9m0anx9paw200l1r5ad9fmq559346l";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k252n7s80bvjvpskgfm285a3djjjqyjcarlh3aq7a4dx2s94xsm";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0022nxs9gqfhx35n4klibig770n0j31pnkd8anz00yvrvkdghk41";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f3vgp43hajw716vmgjv6f4ar6f97zf50snny6y3fy9kkj4qjw88";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec-support = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03z7gpqz5xkw9rf53835pa8a9vgj4lic54rnix9vfwmp2m7pv1s8";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec-terraspace = {
    dependencies = ["activesupport" "memoist" "rainbow" "rspec" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q8dlamvd11d5q2p6yvq0gkm3smz42mzsva4qimim7jn2yjbh58y";
      type = "gem";
    };
    version = "0.3.3";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
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
  terraspace = {
    dependencies = ["activesupport" "cli-format" "deep_merge" "dotenv" "dsl_evaluator" "eventmachine-tail" "graph" "hcl_parser" "memoist" "rainbow" "render_me_pretty" "rexml" "rspec-terraspace" "terraspace-bundler" "thor" "tty-tree" "zeitwerk" "zip_folder"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zmnp71fwcj453cafmb8iicbk93flk98wh0wdk0q9xd3mgm3qh6x";
      type = "gem";
    };
    version = "2.2.17";
  };
  terraspace-bundler = {
    dependencies = ["activesupport" "aws-sdk-s3" "dsl_evaluator" "memoist" "nokogiri" "rainbow" "rubyzip" "thor" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kn6is7zqlw8l4njj4pjwbdi95w651nz3qvqgc3vw07rchs08nnx";
      type = "gem";
    };
    version = "0.5.0";
  };
  text-table = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06yhlnb49fn0fhkmi6lrziyv2hd42gcm2zi3sggm2qab48qxn94j";
      type = "gem";
    };
    version = "1.2.4";
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
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kds7wkxmb038cwp6ravnwn8k65ixc68wpm8j5jx5bhx8ndg4x6z";
      type = "gem";
    };
    version = "2.4.0";
  };
  tty-tree = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w3nh9yppb7zaswa7d9hnhf6k64z5d3jd8xvpyg2mjfrzcw9rbgs";
      type = "gem";
    };
    version = "0.4.0";
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
  zeitwerk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08cfb35232p9s1r4jqv8wacv38vxh699mgbr9y03ga89gx9lipqp";
      type = "gem";
    };
    version = "2.6.16";
  };
  zip_folder = {
    dependencies = ["rubyzip"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1884a1ixy7bzm9yp8cjikhdfcn8205p4fsjq894ilby8i1whl58k";
      type = "gem";
    };
    version = "0.1.0";
  };
}
