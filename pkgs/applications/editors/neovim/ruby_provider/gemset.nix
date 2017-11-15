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
      sha256 = "08xn7r4g13wl4bhvkmp4hx3x0ppvifs1x2iiqh8jl9f1jb4jhfcp";
      type = "gem";
    };
    version = "0.5.1";
  };
}