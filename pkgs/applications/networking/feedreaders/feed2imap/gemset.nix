{
  feed2imap = {
    dependencies = ["rmail" "ruby-feedparser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rsc0himmspsi4m9k2nhk54cz6xijyk8smaj02m3cf9hs57l9gx8";
      type = "gem";
    };
    version = "1.3.3";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  magic = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18vkdq2748wxg0kr923fbhx92wikh2dwv2hp8xind57qs7gn26pr";
      type = "gem";
    };
    version = "0.2.9";
  };
  rmail = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m5npkmv764m725wzjzasgf3k8q5anf3vfr6k2cac1xj6jc8lcqi";
      type = "gem";
    };
    version = "1.1.4";
  };
  ruby-feedparser = {
    dependencies = ["magic"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vs9xqjp9a4a0342sqnn79fjgp3jdx7nldpi009dwjydmv4y4lfr";
      type = "gem";
    };
    version = "0.11.0";
  };
}
