{
  fusuma = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
<<<<<<< HEAD
      sha256 = "13kkqwd268haxap05282cizqrc7py4cn5r5mxk3z88qz950c8n02";
      type = "gem";
    };
    version = "3.9.0";
=======
      sha256 = "1h8lj3g5q6cg6lf5axnbw4bpvml3xkf3ipbviw5mg1jh9r3apk5m";
      type = "gem";
    };
    version = "3.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  fusuma-plugin-appmatcher = {
    dependencies = [
      "fusuma"
      "rexml"
      "ruby-dbus"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
<<<<<<< HEAD
      sha256 = "120imyw1ir7c94g4j16anfv4c61y4qmy9xj5rg75mypz97nq8xp7";
      type = "gem";
    };
    version = "0.8.0";
=======
      sha256 = "1cj3d1yz3jdxmapgk8wv5ra57nyb278x2fjxdllc0gqdfih6pxhq";
      type = "gem";
    };
    version = "0.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  fusuma-plugin-keypress = {
    dependencies = [ "fusuma" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16csdj695y9b8bvl65cby57fsyfr30pb9qq6h0wyqrxily6cn6il";
      type = "gem";
    };
    version = "0.11.0";
  };
  fusuma-plugin-sendkey = {
    dependencies = [
      "fusuma"
      "revdev"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
<<<<<<< HEAD
      sha256 = "1gy0gz2kyavfvq4sfqvybzaah8hiajfzi2mlcizv2n834vy9lwhj";
      type = "gem";
    };
    version = "0.14.0";
=======
      sha256 = "0rdpxq4nanw85x1djdanwnz46b19fr46kdlkkgbxa4dnjk0zx4pp";
      type = "gem";
    };
    version = "0.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  fusuma-plugin-wmctrl = {
    dependencies = [ "fusuma" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
<<<<<<< HEAD
      sha256 = "0v2g5a6qpzn7w2g0812qi3pxm0ilpb5wj00ivxfnflh74yyf69wi";
      type = "gem";
    };
    version = "1.4.2";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
=======
      sha256 = "1rgz1d6ahg5i9sr4z2kab5qk7pm3rm0h7r1vwkygi75rv2r3jy86";
      type = "gem";
    };
    version = "1.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  revdev = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b6zg6vqlaik13fqxxcxhd4qnkfgdjnl4wy3a1q67281bl0qpsz9";
      type = "gem";
    };
    version = "0.2.1";
  };
  rexml = {
<<<<<<< HEAD
=======
    dependencies = [ "strscan" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
<<<<<<< HEAD
      sha256 = "1jmbf6lf7pcyacpb939xjjpn1f84c3nw83dy3p1lwjx0l2ljfif7";
      type = "gem";
    };
    version = "3.4.1";
  };
  ruby-dbus = {
    dependencies = [
      "logger"
      "rexml"
    ];
=======
      sha256 = "0d8ivcirrrxpkpjc1c835wknc9s2fl54xpw08s177yfrh5ish209";
      type = "gem";
    };
    version = "3.2.8";
  };
  ruby-dbus = {
    dependencies = [ "rexml" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
<<<<<<< HEAD
      sha256 = "0528x9jm3frq3r10ilf1fkhsy3m5w2gkr93pa5xcixv1daliqhzy";
      type = "gem";
    };
    version = "0.25.0";
=======
      sha256 = "0hf9y5lbi1xcadc2fw87wlif75s1359c2wwlvvd0gag7cq5dm0pm";
      type = "gem";
    };
    version = "0.23.1";
  };
  strscan = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mamrl7pxacbc79ny5hzmakc9grbjysm3yy6119ppgsg44fsif01";
      type = "gem";
    };
    version = "3.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
