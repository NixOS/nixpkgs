{
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sxa34f8zq0sw5gzxdigkrsfx8mqixv7nyrdxblgngvxqg9lcifk";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "15r3j9bwlpm1ry7cp6059xb0irvsvvlmw53i28z6sf2khwfj5j53";
      type = "gem";
    };
    version = "0.6.2";
  };
}
