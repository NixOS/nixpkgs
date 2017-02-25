{
  msgpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fb2my91j08plsbbry5kilsrh7slmzgbbf6f55zy6xk28p9036lg";
      type = "gem";
    };
    version = "1.0.2";
  };
  neovim = {
    dependencies = ["msgpack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "018mk4vqaxzbk4anq558h2rgj8prbn2rmi777iwrg3n0v8k5nxqw";
      type = "gem";
    };
    version = "0.3.1";
  };
}