{
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19y406nx17arzsbc515mjmr6k5p59afprspa1k423yd9cp8d61wb";
      type = "gem";
    };
    version = "4.0.1";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  cucumber = {
    dependencies = [
      "base64"
      "builder"
      "cucumber-ci-environment"
      "cucumber-core"
      "cucumber-cucumber-expressions"
      "cucumber-html-formatter"
      "diff-lcs"
      "logger"
      "mini_mime"
      "multi_test"
      "sys-uname"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n41b80fg8bz49m9rhms1g1zai2wl4m3z1841yv5h27lxhqvvvgx";
      type = "gem";
    };
    version = "10.2.0";
  };
  cucumber-ci-environment = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qnif57qqcvaz361jkbg43pnzn80jac0ys7gklymn08b3ng9mxqd";
      type = "gem";
    };
    version = "11.0.0";
  };
  cucumber-core = {
    dependencies = [
      "cucumber-gherkin"
      "cucumber-messages"
      "cucumber-tag-expressions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02wprwvf2f3ffzvbrzv8clxvm11p6s7gcjd3wpwfwbzlbjlmhasr";
      type = "gem";
    };
    version = "16.2.0";
  };
  cucumber-cucumber-expressions = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fnrr6hzcgg5ayfmf26f3vvm8c1418x9jiibsjzcjakk0kr8y81k";
      type = "gem";
    };
    version = "19.0.0";
  };
  cucumber-gherkin = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m9yb7icwn4s1clah4x495qjwaya50050fzfbhy1rx0hx63ivxa6";
      type = "gem";
    };
    version = "39.0.0";
  };
  cucumber-html-formatter = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a873ll5305g8gbp4sbf4006pn4bck6c491qbwxdgnw8ap88wxpr";
      type = "gem";
    };
    version = "22.3.0";
  };
  cucumber-messages = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06kk01xnpgkiw1jnpdw9azrxmyry4fqji2k7pw3rvpgprin0bi22";
      type = "gem";
    };
    version = "32.2.0";
  };
  cucumber-tag-expressions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "089fynlhyzcjng7x8ffda1gafdi1yfv2k4y9m7r5p3jgcnvc9n4v";
      type = "gem";
    };
    version = "8.1.0";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k1xaqw2jk13q3ss7cnyvkp8fzp75dk4kazysrxgfd1rpgvkk7qf";
      type = "gem";
    };
    version = "1.17.3";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  memoist3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vyma0mpjibqigzl6j9lij7zh3kvqlyi88qc0mia6l7i5i044vk8";
      type = "gem";
    };
    version = "1.0.0";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_test = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "042d6a1416h3di57z107ygmjdgacrpyswi73ryz75yv3v36m1rg9";
      type = "gem";
    };
    version = "1.1.0";
  };
  sys-uname = {
    dependencies = [
      "ffi"
      "memoist3"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lrh3h15s3mpf0sa5cf7jwwr9wjlkjaf9qim8519cdsqpihnja0m";
      type = "gem";
    };
    version = "1.5.0";
  };
}
