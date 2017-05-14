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
      sha256 = "1gvwa1zkirai7605x4hn2lynbw1caviga272iyy472jv7hs2zn92";
      type = "gem";
    };
    version = "0.4.0";
  };
}
