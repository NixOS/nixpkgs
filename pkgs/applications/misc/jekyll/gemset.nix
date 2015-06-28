{
  "blankslate" = {
    version = "2.1.2.4";
    source = {
      type = "gem";
      sha256 = "0jnnq5q5dwy2rbfcl769vd9bk1yn0242f6yjlb9mnqdm9627cdcx";
    };
  };
  "celluloid" = {
    version = "0.16.0";
    source = {
      type = "gem";
      sha256 = "044xk0y7i1xjafzv7blzj5r56s7zr8nzb619arkrl390mf19jxv3";
    };
    dependencies = [
      "timers"
    ];
  };
  "classifier-reborn" = {
    version = "2.0.3";
    source = {
      type = "gem";
      sha256 = "0vca8jl7nbgzyb7zlvnq9cqgabwjdl59jqlpfkwzv6znkri7cpby";
    };
    dependencies = [
      "fast-stemmer"
    ];
  };
  "coffee-script" = {
    version = "2.4.1";
    source = {
      type = "gem";
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
    };
    dependencies = [
      "coffee-script-source"
      "execjs"
    ];
  };
  "coffee-script-source" = {
    version = "1.9.1.1";
    source = {
      type = "gem";
      sha256 = "1arfrwyzw4sn7nnaq8jji5sv855rp4c5pvmzkabbdgca0w1cxfq5";
    };
  };
  "colorator" = {
    version = "0.1";
    source = {
      type = "gem";
      sha256 = "09zp15hyd9wlbgf1kmrf4rnry8cpvh1h9fj7afarlqcy4hrfdpvs";
    };
  };
  "execjs" = {
    version = "2.5.2";
    source = {
      type = "gem";
      sha256 = "0y2193yhcyz9f97m7g3wanvwzdjb08sllrj1g84sgn848j12vyl0";
    };
  };
  "fast-stemmer" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0688clyk4xxh3kdb18vi089k90mca8ji5fwaknh3da5wrzcrzanh";
    };
  };
  "ffi" = {
    version = "1.9.8";
    source = {
      type = "gem";
      sha256 = "0ph098bv92rn5wl6rn2hwb4ng24v4187sz8pa0bpi9jfh50im879";
    };
  };
  "hitimes" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "17y3ggqxl3m6x9gqpgdn39z0pxpmw666d40r39bs7ngdmy680jn4";
    };
  };
  "jekyll" = {
    version = "2.5.3";
    source = {
      type = "gem";
      sha256 = "1ad3d62yd5rxkvn3xls3xmr2wnk8fiickjy27g098hs842wmw22n";
    };
    dependencies = [
      "classifier-reborn"
      "colorator"
      "jekyll-coffeescript"
      "jekyll-gist"
      "jekyll-paginate"
      "jekyll-sass-converter"
      "jekyll-watch"
      "kramdown"
      "liquid"
      "mercenary"
      "pygments.rb"
      "redcarpet"
      "safe_yaml"
      "toml"
    ];
  };
  "jekyll-coffeescript" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "19nkqbaxqbzqbfbi7sgshshj2krp9ap88m9fc5pa6mglb2ypk3hg";
    };
    dependencies = [
      "coffee-script"
    ];
  };
  "jekyll-gist" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "10hywgdwqafa21nwa5br54wvp4wsr3wnx64v8d81glj5cs17f9bv";
    };
  };
  "jekyll-paginate" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0r7bcs8fq98zldih4787zk5i9w24nz5wa26m84ssja95n3sas2l8";
    };
  };
  "jekyll-sass-converter" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1xqmlr87xmzpalf846gybkbfqkj48y3fva81r7c7175my9p4ykl1";
    };
    dependencies = [
      "sass"
    ];
  };
  "jekyll-watch" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0p9mc8m4bggsqlq567g1g67z5fvzlm7yyv4l8717l46nq0d52gja";
    };
    dependencies = [
      "listen"
    ];
  };
  "kramdown" = {
    version = "1.7.0";
    source = {
      type = "gem";
      sha256 = "070r81kz88zw28c8bs5p0p92ymn1nldci2fm1arkas0bnqrd3rna";
    };
  };
  "liquid" = {
    version = "2.6.2";
    source = {
      type = "gem";
      sha256 = "1k7lx7szwnz7vv3hqpdb6bgw8p73sa1ss9m1m5h0jaqb9xkqnfzb";
    };
  };
  "listen" = {
    version = "2.10.0";
    source = {
      type = "gem";
      sha256 = "131pgi5bsqln2kfkp72wpi0dfz5i124758xcl1h3c5gz75j0vg2i";
    };
    dependencies = [
      "celluloid"
      "rb-fsevent"
      "rb-inotify"
    ];
  };
  "mercenary" = {
    version = "0.3.5";
    source = {
      type = "gem";
      sha256 = "0ls7z086v4xl02g4ia5jhl9s76d22crgmplpmj0c383liwbqi9pb";
    };
  };
  "parslet" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "0qp1m8n3m6k6g22nn1ivcfkvccq5jmbkw53vvcjw5xssq179l9z3";
    };
    dependencies = [
      "blankslate"
    ];
  };
  "posix-spawn" = {
    version = "0.3.11";
    source = {
      type = "gem";
      sha256 = "052lnxbkvlnwfjw4qd7vn2xrlaaqiav6f5x5bcjin97bsrfq6cmr";
    };
  };
  "pygments.rb" = {
    version = "0.6.3";
    source = {
      type = "gem";
      sha256 = "160i761q2z8kandcikf2r5318glgi3pf6b45wa407wacjvz2966i";
    };
    dependencies = [
      "posix-spawn"
      "yajl-ruby"
    ];
  };
  "rb-fsevent" = {
    version = "0.9.4";
    source = {
      type = "gem";
      sha256 = "12if5xsik64kihxf5awsyavlp595y47g9qz77vfp2zvkxgglaka7";
    };
  };
  "rb-inotify" = {
    version = "0.9.5";
    source = {
      type = "gem";
      sha256 = "0kddx2ia0qylw3r52nhg83irkaclvrncgy2m1ywpbhlhsz1rymb9";
    };
    dependencies = [
      "ffi"
    ];
  };
  "rdiscount" = {
    version = "2.1.8";
    source = {
      type = "gem";
      sha256 = "0vcyy90r6wfg0b0y5wqp3d25bdyqjbwjhkm1xy9jkz9a7j72n70v";
    };
  };
  "redcarpet" = {
    version = "3.2.3";
    source = {
      type = "gem";
      sha256 = "0l6zr8wlqb648z202kzi7l9p89b6v4ivdhif5w803l1rrwyzvj0m";
    };
  };
  "safe_yaml" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
    };
  };
  "sass" = {
    version = "3.4.13";
    source = {
      type = "gem";
      sha256 = "0wxkjm41xr77pnfi06cbwv6vq0ypbni03jpbpskd7rj5b0zr27ig";
    };
  };
  "timers" = {
    version = "4.0.1";
    source = {
      type = "gem";
      sha256 = "03ahv07wn1f2g3c5843q7sf03a81518lq5624s9f49kbrswa2p7l";
    };
    dependencies = [
      "hitimes"
    ];
  };
  "toml" = {
    version = "0.1.2";
    source = {
      type = "gem";
      sha256 = "1wnvi1g8id1sg6776fvzf98lhfbscchgiy1fp5pvd58a8ds2fq9v";
    };
    dependencies = [
      "parslet"
    ];
  };
  "yajl-ruby" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0zvvb7i1bl98k3zkdrnx9vasq0rp2cyy5n7p9804dqs4fz9xh9vf";
    };
  };
}