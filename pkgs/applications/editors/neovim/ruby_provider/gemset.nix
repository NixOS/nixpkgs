{
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ck7w17d6b4jbb8inh1q57bghi9cjkiaxql1d3glmj1yavbpmlh7";
      type = "gem";
    };
    version = "1.1.0";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1raim9ddjh672m32psaa9niw67ywzjbxbdb8iijx3wv9k5b0pk2x";
      type = "gem";
    };
    version = "1.12.2";
  };
  neovim = {
    dependencies = ["msgpack" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dnv2pdl8lwwy4av8bqc6kdlgxw88dmajm4fkdk6hc7qdx1sw234";
      type = "gem";
    };
    version = "0.6.1";
  };
}