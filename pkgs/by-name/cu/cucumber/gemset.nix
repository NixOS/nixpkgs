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
      sha256 = "0rng45p4vc3f6nac44cnylwch7rj4zsff3icdz6c7garwpjy3sv1";
      type = "gem";
    };
    version = "4.1.3";
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
      "cucumber-query"
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
      sha256 = "132clc7in3x4mvhcivawvabzwc8n7jzgbch6sz6rf318cc3xm8i1";
      type = "gem";
    };
    version = "12.0.1";
  };
  cucumber-ci-environment = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yv4qbc7gj5qw2z5xm2b38a7fsh1js6wjl1wnhj23xq77sa11hgi";
      type = "gem";
    };
    version = "13.0.0";
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
      sha256 = "14p2v8ld130kr4iakiz10rzdp10566v9yrsr5ls12lwf4rglq0qm";
      type = "gem";
    };
    version = "20.0.0";
  };
  cucumber-cucumber-expressions = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m0mxc2rg80p6f1df4qsb97q2i0gmx8h97apj899khx11f4bbi3c";
      type = "gem";
    };
    version = "20.1.0";
  };
  cucumber-gherkin = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bsyb7s8bzllnjfiix2n49l0hhb4icp3y3l6dqddj3vpjqczlzj2";
      type = "gem";
    };
    version = "42.0.1";
  };
  cucumber-html-formatter = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q6cr4a694h3sz02lf4l604dfrj09ypxznmhl3z9p7s51rrm1p3f";
      type = "gem";
    };
    version = "24.2.0";
  };
  cucumber-messages = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zmzqpn9ccshs57q8vd86ax1hcdz7xyrh25hiadr6dx2xbgibrqx";
      type = "gem";
    };
    version = "34.2.1";
  };
  cucumber-query = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kqknxjhbvvkdw5a3w8sk630daxbg4wgp6f6d8222bc9gkh5xxwn";
      type = "gem";
    };
    version = "16.1.1";
  };
  cucumber-tag-expressions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1igarcyv77fyrlvqhv1a6bbwx8hvs6fmm5v9ahgxw4xndcf2mmpa";
      type = "gem";
    };
    version = "11.0.1";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mb3nfmnv5gyaxcw10fzdr4jrvx198bq38akiw7vai99xi95v2kh";
      type = "gem";
    };
    version = "2.0.0";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kqasqvy8d7r09ri4n6bkdwbk63j7afd9ilsw34nzlgh0qp69ldw";
      type = "gem";
    };
    version = "1.17.4";
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
      sha256 = "1rwll1y88q5c08zj3rq61wc4xkylzg364p7fn2z5xxmnldrbzqaz";
      type = "gem";
    };
    version = "2.0.0";
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
      sha256 = "0yvd71lzd2k46940k9l3l3yyjyxc4j1w6nmyrcjkqfdhj5j7wkbq";
      type = "gem";
    };
    version = "1.5.1";
  };
}
