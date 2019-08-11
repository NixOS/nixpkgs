{
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0031gd2mjyba6jb7m97sqa149zjkr0vzn2s2gpb3m9nb67gqkm13";
      type = "gem";
    };
    version = "1.2.6";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  neovim = {
    dependencies = ["msgpack" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07scrdfk7pyn5jgx5m2yajdqpbdv42833vbw568qqag6xp99j3yk";
      type = "gem";
    };
    version = "0.8.0";
  };
}
