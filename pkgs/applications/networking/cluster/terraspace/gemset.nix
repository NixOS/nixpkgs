{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1cjsf26656996hv48wgv2mkwxf0fy1qc68ikgzq7mzfq2mmvmayk";
      type = "gem";
    };
    version = "7.0.6";
=======
      sha256 = "183az13i4fsm28d0l5xhbjpmcj3l1lxzcxlx8pi8zrbd933jwqd0";
      type = "gem";
    };
    version = "7.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "05m0c3h1z0jhaqiciil55fshrjvc725cf1lc0g933pf98vqflb0r";
      type = "gem";
    };
    version = "1.785.0";
=======
      sha256 = "06878pd1kxbj54dh6jp11a1460dkyxvk4mzwp480gcdqy5jaqwhw";
      type = "gem";
    };
    version = "1.689.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "09firi4bin3ay4pd59qgxspq2f1isfi1li8rabpw6lvvbhnar168";
      type = "gem";
    };
    version = "3.177.0";
=======
      sha256 = "131acgw2hi893n0dfbczs42bkc41afhyrmd9w8zx5y8r1k5zd6rc";
      type = "gem";
    };
    version = "3.168.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1x73qj2c39ap926by14x56cjmp2cd5jpq5gv33xynypy1idyb0fj";
      type = "gem";
    };
    version = "1.70.0";
=======
      sha256 = "0ajp7yvnf95d60xmg618xznfwsy8h1vrkzj33r1bsf2gsfp50vzy";
      type = "gem";
    };
    version = "1.61.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "11cxk6b3p1bsl1gg3pi93qx2ynbjrrsrsc68nnqsjm4npvaj052v";
      type = "gem";
    };
    version = "1.128.0";
=======
      sha256 = "1xpb8c8zw1c0grbw1rcc0ynlys1301vm9kkqy4ls3i2zqk5v6n91";
      type = "gem";
    };
    version = "1.117.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0z889c4c1w7wsjm3szg64ay5j51kjl4pdf94nlr1yks2rlanm7na";
      type = "gem";
    };
    version = "1.6.0";
=======
      sha256 = "11hkna2av47bl0yprgp8k4ya70rc3m2ib5w10fn0piplgkkmhz7m";
      type = "gem";
    };
    version = "1.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
=======
      sha256 = "0s4fpn3mqiizpmpy2a24k4v365pv75y50292r8ajrv4i1p5b2k14";
      type = "gem";
    };
    version = "1.1.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
=======
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1kg9wh7jlc9zsr3hkhpzkbn0ynf4np5ap9m2d8xdrb8shy0y6pmb";
      type = "gem";
    };
    version = "5.18.1";
=======
      sha256 = "1kjy67qajw4rnkbjs5jyk7kc3lyhz5613fwj1i8f6ppdk4zampy0";
      type = "gem";
    };
    version = "5.17.0";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rapl1sfmfi3bfr68da4ca16yhc0pp93vjwkj7y3rdqrzy3b41hy";
      type = "gem";
    };
    version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1jw8a20a9k05fpz3q24im19b97idss3179z76yn5scc5b8lk2rl7";
      type = "gem";
    };
    version = "1.15.3";
=======
      sha256 = "0cam1455nmi3fzzpa9ixn2hsim10fbprmj62ajpd6d02mwdprwwn";
      type = "gem";
    };
    version = "1.13.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      type = "gem";
    };
    version = "1.7.1";
=======
      sha256 = "09jgz6r0f7v84a7jz9an85q8vvmp743dqcsdm3z9c8rqcqv6pljq";
      type = "gem";
    };
    version = "1.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "0qx9pv0irkcqjx9f0mh5s6d9m0fck329bp845ryic34nsvnbsp4k";
      type = "gem";
    };
    version = "0.9.0";
=======
      sha256 = "1cd64d59jx6jjzhi5xngfa031sfpgs7zyq8bhc9y4smlz121l1ij";
      type = "gem";
    };
    version = "0.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "0l95bnjxdabrn79hwdhn2q1n7mn26pj7y1w5660v5qi81x458nqm";
      type = "gem";
    };
    version = "3.12.2";
=======
      sha256 = "1ibb81slc35q5yp276sixp3yrvj9q92wlmi1glbnwlk6g49z8rn4";
      type = "gem";
    };
    version = "3.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "05j44jfqlv7j2rpxb5vqzf9hfv7w8ba46wwgxwcwd8p0wzi1hg89";
      type = "gem";
    };
    version = "3.12.3";
=======
      sha256 = "03ba3lfdsj9zl00v1yvwgcx87lbadf87livlfa5kgqssn9qdnll6";
      type = "gem";
    };
    version = "3.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1hfm17xakfvwya236graj6c2arr4sb9zasp35q5fykhyz8mhs0w2";
      type = "gem";
    };
    version = "3.12.5";
=======
      sha256 = "0k64i7ax6sqvh702s0xrll2g8isxx1x4zam95ck7122flsyh7van";
      type = "gem";
    };
    version = "3.12.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-support = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1ky86j3ksi26ng9ybd7j0qsdf1lpr8mzrmn98yy9gzv801fvhsgr";
      type = "gem";
    };
    version = "3.12.1";
=======
      sha256 = "12y52zwwb3xr7h91dy9k3ndmyyhr3mjcayk0nnarnrzz8yr48kfx";
      type = "gem";
    };
    version = "3.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-terraspace = {
    dependencies = ["activesupport" "memoist" "rainbow" "rspec" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1q8dlamvd11d5q2p6yvq0gkm3smz42mzsva4qimim7jn2yjbh58y";
      type = "gem";
    };
    version = "0.3.3";
=======
      sha256 = "16bi6x6aynnkp7yh341fmvpiasm1vg43mxf61ji57akdhx4mam5q";
      type = "gem";
    };
    version = "0.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "1zhcdaiq0sgk2gcy4krkzm4qrvcaibkf5n755qgqgcp1f1b0w6gl";
      type = "gem";
    };
    version = "2.2.8";
=======
      sha256 = "0m38gj4bpcafrbrfdck2pswknm2p6mqfq8mp6k3pkjkmk9p3w9a9";
      type = "gem";
    };
    version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "0k7j2wn14h1pl4smibasw0bp66kg626drxb59z7rzflch99cd4rg";
      type = "gem";
    };
    version = "1.2.2";
=======
      sha256 = "0inl77jh4ia03jw3iqm5ipr76ghal3hyjrd6r8zqsswwvi9j2xdi";
      type = "gem";
    };
    version = "1.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0bmjgbv8158klwp2r3klxjwaj93nh1sbl4xvj9wsha0ic478avz7";
      type = "gem";
    };
    version = "2.2.0";
=======
      sha256 = "186nfbcsk0l4l86gvng1fw6jq6p6s7rc0caxr23b3pnbfb20y63v";
      type = "gem";
    };
    version = "2.0.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
=======
      sha256 = "0rx114mpqnw2k4h98vc0rs0x0bmf0img84yh8mkkjkal07cjydf5";
      type = "gem";
    };
    version = "2.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  zeitwerk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0ck6bj7wa73dkdh13735jl06k6cfny98glxjkas82aivlmyzqqbk";
      type = "gem";
    };
    version = "2.6.8";
=======
      sha256 = "09pqhdi6q4sqv0p1gnjpbcy4az0yv8hrpykjngdgh9qiqd87nfdv";
      type = "gem";
    };
    version = "2.6.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
