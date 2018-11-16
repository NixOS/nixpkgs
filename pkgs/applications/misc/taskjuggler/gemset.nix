{
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "10dyifazss9mgdzdv08p47p344wmphp5pkh5i73s7c04ra8y6ahz";
      type = "gem";
    };
    version = "2.7.0";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "1q4pshq387lzv9m39jv32vwb8wrq3wc4jwgl4jk209r4l33v09d3";
      type = "gem";
    };
    version = "1.0.1";
  };
  taskjuggler = {
    dependencies = ["mail" "term-ansicolor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "0ky3cydl3szhdyxsy4k6zxzjlbll7mlq025aj6xd5jmh49k3pfbp";
      type = "gem";
    };
    version = "3.6.0";
  };
  term-ansicolor = {
    dependencies = ["tins"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "1b1wq9ljh7v3qyxkk8vik2fqx2qzwh5lval5f92llmldkw7r7k7b";
      type = "gem";
    };
    version = "1.6.0";
  };
  tins = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["http://rubygems.org"];
      sha256 = "0g95xs4nvx5n62hb4fkbkd870l9q3y9adfc4h8j21phj9mxybkb8";
      type = "gem";
    };
    version = "1.16.3";
  };
}