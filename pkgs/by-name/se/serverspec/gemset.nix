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
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1040lr5y2phn7avdyam6zw6ikprlmk77biw3yhclsfwfh0qnl4p6";
      type = "gem";
    };
    version = "1.21.1";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p8s7l4pr6hkn0l6rxflsc11alwi1kfg5ysgvsq61lz5l690p6x9";
      type = "gem";
    };
    version = "4.1.0";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sp8hvrk1jkkb3wpizhrkkl0s8agglwjj3f0dvvcw7f5n9cfy7c3";
      type = "gem";
    };
    version = "7.3.3";
  };
  net-telnet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16nkxc79nqm7fd6w1fba4kb98vpgwnyfnlwxarpdcgywz300fc15";
      type = "gem";
    };
    version = "0.2.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-its = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pv0a8pvixgrwsi6j4nlpyn9m0jw9zn92dakjdg87wj9h71qp3m8";
      type = "gem";
    };
    version = "2.0.0";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iqxmw0knjiz5nf6pgr8ihs6cjzh89f0ppj3fqiz8cvms79x6sh8";
      type = "gem";
    };
    version = "3.13.8";
  };
  rspec-support = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    version = "3.13.7";
  };
  serverspec = {
    dependencies = [
      "multi_json"
      "rspec"
      "rspec-its"
      "specinfra"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xwf9cyri9bajkvx2fmkgc23qydgd8g22ckkx9kkg9k681gys1q2";
      type = "gem";
    };
    version = "2.43.0";
  };
  sfl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qm4hvhq9pszi9zs1cl9qgwx1n4wxq0af0hq9sbf6qihqd8rwwwr";
      type = "gem";
    };
    version = "2.3";
  };
  specinfra = {
    dependencies = [
      "base64"
      "net-scp"
      "net-ssh"
      "net-telnet"
      "sfl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17a1h7hxlsqhhigds64wb86kw96rf6kf6d6lqkjg0jw30dwb5vr6";
      type = "gem";
    };
    version = "2.95.1";
  };
}
