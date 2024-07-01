{
  fusuma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vxlfda4mgff9kindrmr47xvn6b591hzvzzsx2y88zq20sn340vy";
      type = "gem";
    };
    version = "3.5.0";
  };
  fusuma-plugin-appmatcher = {
    dependencies = ["fusuma" "rexml" "ruby-dbus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cj3d1yz3jdxmapgk8wv5ra57nyb278x2fjxdllc0gqdfih6pxhq";
      type = "gem";
    };
    version = "0.7.1";
  };
  fusuma-plugin-keypress = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16csdj695y9b8bvl65cby57fsyfr30pb9qq6h0wyqrxily6cn6il";
      type = "gem";
    };
    version = "0.11.0";
  };
  fusuma-plugin-sendkey = {
    dependencies = ["fusuma" "revdev"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rdpxq4nanw85x1djdanwnz46b19fr46kdlkkgbxa4dnjk0zx4pp";
      type = "gem";
    };
    version = "0.10.1";
  };
  fusuma-plugin-wmctrl = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rgz1d6ahg5i9sr4z2kab5qk7pm3rm0h7r1vwkygi75rv2r3jy86";
      type = "gem";
    };
    version = "1.3.1";
  };
  revdev = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b6zg6vqlaik13fqxxcxhd4qnkfgdjnl4wy3a1q67281bl0qpsz9";
      type = "gem";
    };
    version = "0.2.1";
  };
  rexml = {
    dependencies = ["strscan"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d8ivcirrrxpkpjc1c835wknc9s2fl54xpw08s177yfrh5ish209";
      type = "gem";
    };
    version = "3.2.8";
  };
  ruby-dbus = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hf9y5lbi1xcadc2fw87wlif75s1359c2wwlvvd0gag7cq5dm0pm";
      type = "gem";
    };
    version = "0.23.1";
  };
  strscan = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mamrl7pxacbc79ny5hzmakc9grbjysm3yy6119ppgsg44fsif01";
      type = "gem";
    };
    version = "3.1.0";
  };
}
