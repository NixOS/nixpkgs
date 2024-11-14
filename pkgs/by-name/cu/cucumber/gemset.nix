{
  bigdecimal = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cq1c29zbkcxgdihqisirhcw76xc768z2zpd5vbccpq0l1lv76g7";
      type = "gem";
    };
    version = "3.1.7";
  };
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  cucumber = {
    dependencies = ["builder" "cucumber-ci-environment" "cucumber-core" "cucumber-cucumber-expressions" "cucumber-gherkin" "cucumber-html-formatter" "cucumber-messages" "diff-lcs" "mini_mime" "multi_test" "sys-uname"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19qsfgahkah4k0pajxc04mjn8pig7g4n9nkcarg1nzs2612c29s8";
      type = "gem";
    };
    version = "9.2.0";
  };
  cucumber-ci-environment = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cc6w7dqlmnp59ymi7pyspm3w4m7fn37x6b18pziv62wr373yvmv";
      type = "gem";
    };
    version = "10.0.1";
  };
  cucumber-core = {
    dependencies = ["cucumber-gherkin" "cucumber-messages" "cucumber-tag-expressions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jf5ngxfc1q2y7l2nci3p91gp253aqdhkhazkz0yxq72n6zrszvm";
      type = "gem";
    };
    version = "13.0.1";
  };
  cucumber-cucumber-expressions = {
    dependencies = ["bigdecimal"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wsczwaqws1hbkirjhl0lh5s5xhc7cpmj2f790lkx10nr85rbpxi";
      type = "gem";
    };
    version = "17.0.2";
  };
  cucumber-gherkin = {
    dependencies = ["cucumber-messages"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "063p0slf6fvigdn3jynp5pjf9b05byyyi0jhsyapy46hq4984sif";
      type = "gem";
    };
    version = "27.0.0";
  };
  cucumber-html-formatter = {
    dependencies = ["cucumber-messages"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wznhl3b8b47zff0yx69828bx33n0vc60kh6110ml0xni7lx8xw1";
      type = "gem";
    };
    version = "21.3.0";
  };
  cucumber-messages = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06d7dnixz68ivngf6qflmi6xrjshjyi85gmyjrl07pbmhqi6r2nh";
      type = "gem";
    };
    version = "22.0.0";
  };
  cucumber-tag-expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g0fl6v1677q71nkaib2g3p03jdzrwgfanpi96srb1743qd54bk1";
      type = "gem";
    };
    version = "6.1.0";
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
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yvii03hcgqj30maavddqamqy50h7y6xcn2wcyq72wn823zl4ckd";
      type = "gem";
    };
    version = "1.16.3";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_test = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "042d6a1416h3di57z107ygmjdgacrpyswi73ryz75yv3v36m1rg9";
      type = "gem";
    };
    version = "1.1.0";
  };
  sys-uname = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03j9qpqip89a0vk6s0gvhxzhbvafjcj5rss7i3jwha0831aivib3";
      type = "gem";
    };
    version = "1.2.3";
  };
}
