{
  ast = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lUYVFXwdajgrwn1pDZcxleedt/Vel2WsfEgcYL2004M=";
      type = "gem";
    };
    version = "2.4.3";
  };
  colorize = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MLUjfwYD9mYquNH8K9SpYUK4BsZBXXnkXvX9xqDPyDc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  flatito = {
    dependencies = [ "colorize" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = ./.;
      type = "path";
    };
    version = "0.1.1";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NODq2pMCKyoKM0W7C179226f9b58SOQJz7VP+KNqiwY=";
      type = "gem";
    };
    version = "2.10.2";
  };
  language_server-protocol = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xIRiZHhmT9E0gtgYCUfFCoWQSEsSWLmbeu2ztp34lmk=";
      type = "gem";
    };
    version = "3.17.0.4";
  };
  lint_roller = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LAyEW2MqfRcsuEnMkMG86TeijFyMzMtQ39RqSFADzIc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ORtsbLQ6SAK/t8k68evirGaiECk/Sj+32zby/H3Cx1Y=";
      type = "gem";
    };
    version = "5.25.5";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2Gurt6K4FL6fS4FYe/C2zi2n1Flp+rJNiuS/K7TUx+8=";
      type = "gem";
    };
    version = "1.26.3";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xx3pB2vguERZomhYG1qnXl7qrIkrVkQwNx0fjrVftl8=";
      type = "gem";
    };
    version = "3.3.7.2";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  regexp_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y28N3eiHcs1kv/Hbv2jfZtN2BD/i5mqe93/LGwxUjGE=";
      type = "gem";
    };
    version = "2.10.0";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "lint_roller"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BhOKNdfRHJY9WrwBSLNV45mQB8sCJaYZlA2w51UhN5s=";
      type = "gem";
    };
    version = "1.74.0";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Du/5rTdD9Cgj48aHy8FfjFUv9jyfjj01+6/nRpd8fA0=";
      type = "gem";
    };
    version = "1.41.0";
  };
  rubocop-minitest = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3NzCyDWoWRk+ULxnKW2q+VrJn2QQg4EZN03zFJBGDTY=";
      type = "gem";
    };
    version = "0.37.1";
  };
  rubocop-performance = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5b05/z42g5W5r4hpJ8w39YkvQ9tL1shSZZQ1LVtEQLU=";
      type = "gem";
    };
    version = "1.24.0";
  };
  rubocop-rake = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-N5fytoEMPp33N2wm1fRPNHXtpZ6xrcOOb2Ls8CfLrk0=";
      type = "gem";
    };
    version = "0.7.1";
  };
  ruby-progressbar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gPycR6m2QNaDTg3Hs8lMnfN/CMsHK3dh5KceIs/ymzM=";
      type = "gem";
    };
    version = "1.13.0";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jK8q8cDy8H7InvnhjH2IwnkOIXxIK/x4qqZerdVBWsE=";
      type = "gem";
    };
    version = "3.1.4";
  };
  unicode-emoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LCxO9/NT5YCUlxJihaULIwVsxuYbZEM3ZKNe/2w2Uyo=";
      type = "gem";
    };
    version = "4.0.4";
  };
}
