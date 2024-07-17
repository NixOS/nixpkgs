{
  activesupport = {
    dependencies = [
      "concurrent-ruby"
      "i18n"
      "minitest"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dmywys50074vj5rivpx188b00qimlc4jn84xzqlialrgp3ckq5f";
      type = "gem";
    };
    version = "7.0.4.2";
  };
  cli-ui = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1aghiy4qrh6y6q421lcpal81c98zypj8jki4wymqnc8vjvqsyiv4";
      type = "gem";
    };
    version = "1.5.1";
  };
  color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10kgsdy86p72q6cf2k92larmbjc0crvd5xq7hy919zm8yvn1518a";
      type = "gem";
    };
    version = "1.8";
  };
  coltrane = {
    dependencies = [
      "activesupport"
      "color"
      "dry-monads"
      "gambiarra"
      "paint"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hchdllbbx2n2fl3ydidl17rsl18mb9953c8k1r6rw1ibzw8sm7f";
      type = "gem";
    };
    version = "4.1.1";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
  };
  dry-core = {
    dependencies = [
      "concurrent-ruby"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dpm9dk11x2zcjsymkl5jcz5nxhffsg7qqy5p6h92cppzbwmm656";
      type = "gem";
    };
    version = "0.9.1";
  };
  dry-equalizer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rsqpk0gjja6j6pjm0whx2px06cxr3h197vrwxp6k042p52r4v46";
      type = "gem";
    };
    version = "0.3.0";
  };
  dry-monads = {
    dependencies = [
      "dry-core"
      "dry-equalizer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fbji6crgqh88j0p4j1qlfpjnhyf8h1b991dh5wypib0xwzlc5an";
      type = "gem";
    };
    version = "0.4.0";
  };
  gambiarra = {
    dependencies = [
      "activesupport"
      "cli-ui"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19kpbqp27fy6w990ciw3vx0z0bdmrcf14fr6dlfcn3r8xqpq56fr";
      type = "gem";
    };
    version = "0.0.5";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ic7i5z88zcaqnpzprf7saimq2f6sad57g5mkkqsrqrcd6h3mx06";
      type = "gem";
    };
    version = "5.18.0";
  };
  paint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r9vx3wcx0x2xqlh6zqc81wcsn9qjw3xprcsv5drsq9q80z64z9j";
      type = "gem";
    };
    version = "2.3.0";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18yhlvmfya23cs3pvhr1qy38y41b6mhr5q9vwv5lrgk16wmf3jna";
      type = "gem";
    };
    version = "1.1.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "028ld9qmgdllxrl7d0qkl65s58wb1n3gv8yjs28g43a8b1hplxk1";
      type = "gem";
    };
    version = "2.6.7";
  };
}
