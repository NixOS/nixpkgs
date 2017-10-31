{
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ck7w17d6b4jbb8inh1q57bghi9cjkiaxql1d3glmj1yavbpmlh7";
      type = "gem";
    };
    version = "1.1.0";
  };
  neovim = {
    dependencies = ["msgpack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1da0ha3mz63iyihldp7185b87wx86jg07023xjhbng6i28y1ksn7";
      type = "gem";
    };
    version = "0.5.0";
  };
}