{
  "amq-protocol" = {
    version = "1.9.2";
    source = {
      type = "gem";
      sha256 = "1gl479j003vixfph5jmdskl20il8816y0flp4msrc8im3b5iiq3r";
    };
  };
  "amqp" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "0jlcwyvjz0b28wxdabkyhdqyqp5ji56ckfywsy9mgp0m4wfbrh8c";
    };
    dependencies = [
      "amq-protocol"
      "eventmachine"
    ];
  };
  "async_sinatra" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0sjdvkchq5blvfdahhrlipsx5sr9kfmdx0zxssjlfkz54dbl14m0";
    };
    dependencies = [
      "rack"
      "sinatra"
    ];
  };
  "childprocess" = {
    version = "0.5.8";
    source = {
      type = "gem";
      sha256 = "1lv7axi1fhascm9njxh3lx1rbrnsm8wgvib0g7j26v4h1fcphqg0";
    };
    dependencies = [
      "ffi"
    ];
  };
  "daemons" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0b839hryy9sg7x3knsa1d6vfiyvn0mlsnhsb6an8zsalyrz1zgqg";
    };
  };
  "em-redis-unified" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "0rzf2c2cbfc1k5jiahmgd3c4l9z5f74b6a549v44n5j1hyj03m9v";
    };
    dependencies = [
      "eventmachine"
    ];
  };
  "em-worker" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "0z4jx9z2q5hxvdvik4yp0ahwfk69qsmdnyp72ln22p3qlkq2z5wk";
    };
    dependencies = [
      "eventmachine"
    ];
  };
  "eventmachine" = {
    version = "1.0.8";
    source = {
      type = "gem";
      sha256 = "1frvpk3p73xc64qkn0ymll3flvn4xcycq5yx8a43zd3gyzc1ifjp";
    };
  };
  "ffi" = {
    version = "1.9.10";
    source = {
      type = "gem";
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
    };
  };
  "multi_json" = {
    version = "1.11.2";
    source = {
      type = "gem";
      sha256 = "1rf3l4j3i11lybqzgq2jhszq7fh7gpmafjzd14ymp9cjfxqg596r";
    };
  };
  "rack" = {
    version = "1.6.4";
    source = {
      type = "gem";
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
    };
  };
  "rack-protection" = {
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
    };
    dependencies = [
      "rack"
    ];
  };
  "sensu" = {
    version = "0.22.0";
    source = {
      type = "gem";
      sha256 = "05yrljlgqyr98ck9302m8igck38m2rk0n8sq3v58f78hv9yi3whw";
    };
    dependencies = [
      "async_sinatra"
      "em-redis-unified"
      "eventmachine"
      "multi_json"
      "sensu-extension"
      "sensu-extensions"
      "sensu-logger"
      "sensu-settings"
      "sensu-spawn"
      "sensu-transport"
      "sinatra"
      "thin"
      "uuidtools"
    ];
  };
  "sensu-extension" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1ms7g76vng0dzaq86g4s8mdszjribm6v6vkbmh4psf988xw95a2b";
    };
    dependencies = [
      "eventmachine"
    ];
  };
  "sensu-extensions" = {
    version = "1.4.0";
    source = {
      type = "gem";
      sha256 = "16npdf1hcpcn47wmznkwcikynxzb2jv2irqlvprjlapy2m6m4c62";
    };
    dependencies = [
      "multi_json"
      "sensu-extension"
      "sensu-logger"
      "sensu-settings"
    ];
  };
  "sensu-logger" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "1pbzbr83df4awndr49f1z7z1bl9n73nkf1xcnlkjcnpnb3yy07pw";
    };
    dependencies = [
      "eventmachine"
      "multi_json"
    ];
  };
  "sensu-settings" = {
    version = "3.3.0";
    source = {
      type = "gem";
      sha256 = "0fk5chvzv946yg6cqpjlpjw5alwimg8rsxs3knhbgdanyrbh6m32";
    };
    dependencies = [
      "multi_json"
    ];
  };
  "sensu-spawn" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "1gdfnc4jzdfp5g3gwr5izwlsrfnhpb4g61ikkj9kjpqi180n234y";
    };
    dependencies = [
      "childprocess"
      "em-worker"
      "eventmachine"
    ];
  };
  "sensu-transport" = {
    version = "3.3.0";
    source = {
      type = "gem";
      sha256 = "16j8bz39p0cbvlq0k4pijl11i0gxw28p87f3bgpxaqdh1wdga1f2";
    };
    dependencies = [
      "amq-protocol"
      "amqp"
      "em-redis-unified"
      "eventmachine"
    ];
  };
  "sinatra" = {
    version = "1.4.6";
    source = {
      type = "gem";
      sha256 = "1hhmwqc81ram7lfwwziv0z70jh92sj1m7h7s9fr0cn2xq8mmn8l7";
    };
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
  };
  "thin" = {
    version = "1.6.3";
    source = {
      type = "gem";
      sha256 = "1m56aygh5rh8ncp3s2gnn8ghn5ibkk0bg6s3clmh1vzaasw2lj4i";
    };
    dependencies = [
      "daemons"
      "eventmachine"
      "rack"
    ];
  };
  "tilt" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "0lkd40xfdqkp333vdfhrfjmi2y7k2hjs4azawfb62mrkfp7ivj84";
    };
  };
  "uuidtools" = {
    version = "2.1.5";
    source = {
      type = "gem";
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
    };
  };
}