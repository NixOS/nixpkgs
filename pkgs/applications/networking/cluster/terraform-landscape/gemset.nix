{
  colorize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133rqj85n400qk6g3dhf2bmfws34mak1wqihvh3bgy9jhajw580b";
      type = "gem";
    };
    version = "0.8.1";
  };
  commander = {
    dependencies = ["highline"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "165yr8qzan3gnk241mnwxsvdfwp6p1afg13z0mqdily6lh95acl9";
      type = "gem";
    };
    version = "4.4.4";
  };
  diffy = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "015nn9zaciqj43mfpjlw619r5dvnfkrjcka8nsa6j260v6qya941";
      type = "gem";
    };
    version = "3.2.0";
  };
  highline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ib7jp85xjc4gh4jg0wyzllm46hwv8p0w1m4c75pbgi41fps50y";
      type = "gem";
    };
    version = "1.7.10";
  };
  polyglot = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  terraform_landscape = {
    dependencies = ["colorize" "commander" "diffy" "treetop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bx8nfqbpxb2hnxnnl1m4sq6jlzf451c85m047jfq04b6w9691fl";
      type = "gem";
    };
    version = "0.1.17";
  };
  treetop = {
    dependencies = ["polyglot"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sdkd1v2h8dhj9ncsnpywmqv7w1mdwsyc5jwyxlxwriacv8qz8bd";
      type = "gem";
    };
    version = "1.6.9";
  };
}