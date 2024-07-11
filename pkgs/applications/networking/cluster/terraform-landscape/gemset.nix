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
      sha256 = "11sd2sb0id2dbxkv4pvymdiia1xxhms45kh4nr8mryqybad0fwwf";
      type = "gem";
    };
    version = "4.4.6";
  };
  diffy = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "119imrkn01agwhx5raxhknsi331y5i4yda7r0ws0an6905ximzjg";
      type = "gem";
    };
    version = "3.2.1";
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
      sha256 = "1i93pih7r6zcqpjhsmvkpfkgbh0l66c60i6fkiymq7vy2xd6wnns";
      type = "gem";
    };
    version = "0.2.1";
  };
  treetop = {
    dependencies = ["polyglot"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g31pijhnv7z960sd09lckmw9h8rs3wmc8g4ihmppszxqm99zpv7";
      type = "gem";
    };
    version = "1.6.10";
  };
}
