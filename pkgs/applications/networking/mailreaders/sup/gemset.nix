{
  "chronic" = {
    version = "0.9.1";
    source = {
      type = "gem";
      sha256 = "0kspaxpfy7yvyk1lvpx31w852qfj8wb9z04mcj5bzi70ljb9awqk";
    };
  };
  "gpgme" = {
    version = "2.0.7";
    source = {
      type = "gem";
      sha256 = "1p84zhiri2ihcld7py9mwc2kg5xs5da8fk11zhndrhmw05yvf5mr";
    };
    dependencies = [
      "mini_portile"
    ];
  };
  "highline" = {
    version = "1.6.21";
    source = {
      type = "gem";
      sha256 = "06bml1fjsnrhd956wqq5k3w8cyd09rv1vixdpa3zzkl6xs72jdn1";
    };
  };
  "locale" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "18bb0g24flq9dr8qv4j7pm7w9i2vmvmqrbmry95ibf1r1c4s60yj";
    };
  };
  "lockfile" = {
    version = "2.1.3";
    source = {
      type = "gem";
      sha256 = "0dij3ijywylvfgrpi2i0k17f6w0wjhnjjw0k9030f54z56cz7jrr";
    };
  };
  "mime-types" = {
    version = "1.25.1";
    source = {
      type = "gem";
      sha256 = "0mhzsanmnzdshaba7gmsjwnv168r1yj8y0flzw88frw1cickrvw8";
    };
  };
  "mini_portile" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "09kcn4g63xrdirgwxgjikqg976rr723bkc9bxfr29pk22cj3wavn";
    };
  };
  "ncursesw" = {
    version = "1.4.9";
    source = {
      type = "gem";
      sha256 = "154cls3b237imdbhih7rni5p85nw6mpbpkzdw08jxzvqaml7q093";
    };
  };
  "rmail-sup" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1xswk101s560lxqaax3plqh8vjx7jjspnggdwb3q80m358f92q9g";
    };
  };
  "sup" = {
    version = "0.20.0";
    source = {
      type = "gem";
      sha256 = "1lpqgrqkv29xr1h1142qsbmknlshpgys7fc3w1nkyhib8s3ikamg";
    };
    dependencies = [
      "chronic"
      "highline"
      "locale"
      "lockfile"
      "mime-types"
      "ncursesw"
      "rmail-sup"
      "trollop"
      "unicode"
    ];
  };
  "trollop" = {
    version = "2.1.1";
    source = {
      type = "gem";
      sha256 = "0z5dvh7glwqjprlihsjx67hfzy4whsjfhqj9akyyrby9q5va1i4k";
    };
  };
  "unicode" = {
    version = "0.4.4.2";
    source = {
      type = "gem";
      sha256 = "15fggljzan8zvmr8h12b5m7pcj1gvskmmnx367xs4p0rrpnpil8g";
    };
  };
  "xapian-ruby" = {
    version = "1.2.19.1";
    source = {
      type = "gem";
      sha256 = "1crfrmc8kf6qq1xcfcmgf213zg66badpg4d86n7y9x3i1f5lxlbv";
    };
  };
}