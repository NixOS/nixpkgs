{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cjsf26656996hv48wgv2mkwxf0fy1qc68ikgzq7mzfq2mmvmayk";
      type = "gem";
    };
    version = "7.0.6";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pyis1nvnbjxk12a43xvgj2gv0mvp4cnkc1gzw0v1018r61399gz";
      type = "gem";
    };
    version = "1.2.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05m0c3h1z0jhaqiciil55fshrjvc725cf1lc0g933pf98vqflb0r";
      type = "gem";
    };
    version = "1.785.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09firi4bin3ay4pd59qgxspq2f1isfi1li8rabpw6lvvbhnar168";
      type = "gem";
    };
    version = "3.177.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x73qj2c39ap926by14x56cjmp2cd5jpq5gv33xynypy1idyb0fj";
      type = "gem";
    };
    version = "1.70.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11cxk6b3p1bsl1gg3pi93qx2ynbjrrsrsc68nnqsjm4npvaj052v";
      type = "gem";
    };
    version = "1.128.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z889c4c1w7wsjm3szg64ay5j51kjl4pdf94nlr1yks2rlanm7na";
      type = "gem";
    };
    version = "1.6.0";
  };
  cli-format = {
    dependencies = ["activesupport" "text-table" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mr8vkw5zwb3flhhf8s923mi7r85g1ky0lmjz4q5xhwb48ji55qf";
      type = "gem";
    };
    version = "0.2.2";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
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
      sha256 = "0rwvjahnp7cpmracd8x732rjgnilqv2sx7d1gfrysslc3h039fa9";
      type = "gem";
    };
    version = "1.5.0";
  };
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n0pi8x8ql5h1mijvm8lgn6bhq4xjb5a500p5r1krq4s6j9lg565";
      type = "gem";
    };
    version = "2.8.1";
  };
  dsl_evaluator = {
    dependencies = ["activesupport" "memoist" "rainbow" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mck2j0gr851kj9l7pix97jmmwwazfjq83ryamx5rpdbgv5mrh51";
      type = "gem";
    };
    version = "0.3.1";
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
      sha256 = "10l1bdqc9yzdk6kqwh9vw918lyw846gpqw2z8kfcwl53zdjdzcl9";
      type = "gem";
    };
    version = "2.11.0";
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
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
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
      sha256 = "0z7f38iq37h376n9xbl4gajdrnwzq284c9v1py4imw3gri2d5cj6";
      type = "gem";
    };
    version = "2.8.2";
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kg9wh7jlc9zsr3hkhpzkbn0ynf4np5ap9m2d8xdrb8shy0y6pmb";
      type = "gem";
    };
    version = "5.18.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jw8a20a9k05fpz3q24im19b97idss3179z76yn5scc5b8lk2rl7";
      type = "gem";
    };
    version = "1.15.3";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      type = "gem";
    };
    version = "1.7.1";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
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
      sha256 = "171rc90vcgjl8p1bdrqa92ymrj8a87qf6w20x05xq29mljcigi6c";
      type = "gem";
    };
    version = "3.12.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l95bnjxdabrn79hwdhn2q1n7mn26pj7y1w5660v5qi81x458nqm";
      type = "gem";
    };
    version = "3.12.2";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05j44jfqlv7j2rpxb5vqzf9hfv7w8ba46wwgxwcwd8p0wzi1hg89";
      type = "gem";
    };
    version = "3.12.3";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hfm17xakfvwya236graj6c2arr4sb9zasp35q5fykhyz8mhs0w2";
      type = "gem";
    };
    version = "3.12.5";
  };
  rspec-support = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ky86j3ksi26ng9ybd7j0qsdf1lpr8mzrmn98yy9gzv801fvhsgr";
      type = "gem";
    };
    version = "3.12.1";
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
  terraspace = {
    dependencies = ["activesupport" "cli-format" "deep_merge" "dotenv" "dsl_evaluator" "eventmachine-tail" "graph" "hcl_parser" "memoist" "rainbow" "render_me_pretty" "rexml" "rspec-terraspace" "terraspace-bundler" "thor" "tty-tree" "zeitwerk" "zip_folder"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zhcdaiq0sgk2gcy4krkzm4qrvcaibkf5n755qgqgcp1f1b0w6gl";
      type = "gem";
    };
    version = "2.2.8";
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
      sha256 = "0k7j2wn14h1pl4smibasw0bp66kg626drxb59z7rzflch99cd4rg";
      type = "gem";
    };
    version = "1.2.2";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bmjgbv8158klwp2r3klxjwaj93nh1sbl4xvj9wsha0ic478avz7";
      type = "gem";
    };
    version = "2.2.0";
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
      sha256 = "0ck6bj7wa73dkdh13735jl06k6cfny98glxjkas82aivlmyzqqbk";
      type = "gem";
    };
    version = "2.6.8";
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
