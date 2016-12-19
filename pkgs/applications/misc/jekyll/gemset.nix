{
  "RedCloth" = {
    version = "4.2.9";
    source = {
      type = "gem";
      sha256 = "06pahxyrckhgb7alsxwhhlx1ib2xsx33793finj01jk8i054bkxl";
    };
  };
  "colorator" = {
    version = "0.1";
    source = {
      type = "gem";
      sha256 = "09zp15hyd9wlbgf1kmrf4rnry8cpvh1h9fj7afarlqcy4hrfdpvs";
    };
  };
  "ffi" = {
    version = "1.9.10";
    source = {
      type = "gem";
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
    };
  };
  "jekyll" = {
    version = "3.0.1";
    source = {
      type = "gem";
      sha256 = "107svn6r7pvkg9wwfi4r44d2rqppysjf9zf09h7z1ajsy8k2s65a";
    };
    dependencies = [
      "colorator"
      "jekyll-sass-converter"
      "jekyll-watch"
      "jekyll-paginate"
      "kramdown"
      "liquid"
      "mercenary"
      "rouge"
      "safe_yaml"
    ];
  };
  "jekyll-sass-converter" = {
    version = "1.4.0";
    source = {
      type = "gem";
      sha256 = "095757w0pg6qh3wlfg1j1mw4fsz7s89ia4zai5f2rhx9yxsvk1d8";
    };
    dependencies = [
      "sass"
    ];
  };
  "jekyll-watch" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1mqwvrd2hm6ah5zsxqsv2xdp31wl94pl8ybb1q324j79z8pvyarg";
    };
    dependencies = [
      "listen"
    ];
  };
  "jekyll-paginate" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0r7bcs8fq98zldih4787zk5i9w24nz5wa26m84ssja95n3sas2l8";
    };
  };
  "kramdown" = {
    version = "1.9.0";
    source = {
      type = "gem";
      sha256 = "12sral2xli39mnr4b9m2sxdlgam4ni0a1mkxawc5311z107zj3p0";
    };
  };
  "liquid" = {
    version = "3.0.6";
    source = {
      type = "gem";
      sha256 = "033png37ym4jrjz5bi7zb4ic4yxacwvnllm1xxmrnr4swgyyygc2";
    };
  };
  "listen" = {
    version = "3.0.5";
    source = {
      type = "gem";
      sha256 = "182wd2pkf690ll19lx6zbk01a3rqkk5lwsyin6kwydl7lqxj5z3g";
    };
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
  };
  "mercenary" = {
    version = "0.3.5";
    source = {
      type = "gem";
      sha256 = "0ls7z086v4xl02g4ia5jhl9s76d22crgmplpmj0c383liwbqi9pb";
    };
  };
  "rb-fsevent" = {
    version = "0.9.7";
    source = {
      type = "gem";
      sha256 = "1xlkflgxngwkd4nyybccgd1japrba4v3kwnp00alikj404clqx4v";
    };
  };
  "rb-inotify" = {
    version = "0.9.5";
    source = {
      type = "gem";
      sha256 = "0kddx2ia0qylw3r52nhg83irkaclvrncgy2m1ywpbhlhsz1rymb9";
    };
    dependencies = [
      "ffi"
    ];
  };
  "rdiscount" = {
    version = "2.1.8";
    source = {
      type = "gem";
      sha256 = "0vcyy90r6wfg0b0y5wqp3d25bdyqjbwjhkm1xy9jkz9a7j72n70v";
    };
  };
  "rouge" = {
    version = "1.10.1";
    source = {
      type = "gem";
      sha256 = "0wp8as9ypdy18kdj9h70kny1rdfq71mr8cj2bpahr9vxjjvjasqz";
    };
  };
  "safe_yaml" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
    };
  };
  "sass" = {
    version = "3.4.20";
    source = {
      type = "gem";
      sha256 = "04rpdcp258arh2wgdk9shbqnzd6cbbbpi3wpi9a0wby8awgpxmyf";
    };
  };
}
