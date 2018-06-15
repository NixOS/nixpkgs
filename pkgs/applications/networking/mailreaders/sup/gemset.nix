{
  xapian-ruby = {
    version = "1.2.22";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1xbarnxmhy6r0rxpspn4wk85j183w6b18nah73djcs06b3gfas15";
    };
    dependencies = [ "rake" ];
  };
  unicode = {
    version = "0.4.4.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "15fggljzan8zvmr8h12b5m7pcj1gvskmmnx367xs4p0rrpnpil8g";
    };
  };
  trollop = {
    version = "2.1.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0415y63df86sqj43c0l82and65ia5h64if7n0znkbrmi6y0jwhl8";
    };
  };
  sup = {
    version = "0.22.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "17s2sxismf46zdhgr6g2v53fw9f3sp1ijx7xdw3wx8qpcsgazcgi";
    };
    dependencies = ["chronic" "highline" "locale" "lockfile" "mime-types" "ncursesw" "rmail-sup" "trollop" "unicode" "rake" ];
  };
  rmail-sup = {
    version = "1.0.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1xswk101s560lxqaax3plqh8vjx7jjspnggdwb3q80m358f92q9g";
    };
  };
  rake = {
    version = "11.1.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0jfmy7kd543ldi3d4fg35a1w7q6jikpnzxqj4bzchfbn94cbabqz";
    };
  };
  ncursesw = {
    version = "1.4.9";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "154cls3b237imdbhih7rni5p85nw6mpbpkzdw08jxzvqaml7q093";
    };
  };
  mini_portile2 = {
    version = "2.1.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1y25adxb1hgg1wb2rn20g3vl07qziq6fz364jc5694611zz863hb";
    };
  };
  mime-types-data = {
    version = "3.2016.0221";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "05ygjn0nnfh6yp1wsi574jckk95wqg9a6g598wk4svvrkmkrzkpn";
    };
  };
  mime-types = {
    version = "3.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1snjc38a9vqvy8j41xld1i1byq9prbl955pbjw7dxqcfcirqlzra";
    };
    dependencies = ["mime-types-data"];
  };
  lockfile = {
    version = "2.1.3";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0dij3ijywylvfgrpi2i0k17f6w0wjhnjjw0k9030f54z56cz7jrr";
    };
  };
  locale = {
    version = "2.1.2";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
    };
  };
  highline = {
    version = "1.7.8";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "1nf5lgdn6ni2lpfdn4gk3gi47fmnca2bdirabbjbz1fk9w4p8lkr";
    };
  };
  gpgme = {
    version = "2.0.12";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0a04a76dw9dias0a8rp6dyk3vx2y024gim40lg2md6zdh2m1kx85";
    };
    dependencies = ["mini_portile2"];
  };
  chronic = {
    version = "0.9.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0kspaxpfy7yvyk1lvpx31w852qfj8wb9z04mcj5bzi70ljb9awqk";
    };
  };
}
