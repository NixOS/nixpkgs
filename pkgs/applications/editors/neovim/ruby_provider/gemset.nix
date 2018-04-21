{
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ai0sfdv9jnr333fsvkn7a8vqvn0iwiw83yj603a3i68ds1x6di1";
      type = "gem";
    };
    version = "1.2.2";
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
      sha256 = "15r3j9bwlpm1ry7cp6059xb0irvsvvlmw53i28z6sf2khwfj5j53";
      type = "gem";
    };
    version = "0.6.2";
  };
}
