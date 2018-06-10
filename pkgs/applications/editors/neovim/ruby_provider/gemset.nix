{
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09xy1wc4wfbd1jdrzgxwmqjzfdfxbz0cqdszq2gv6rmc3gv1c864";
      type = "gem";
    };
    version = "1.2.4";
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
      sha256 = "0b487dzz41im8cwzvfjqgf8kkrp6mpkvcbzhazrmqqw8gxyvfbq4";
      type = "gem";
    };
    version = "0.7.0";
  };
}
