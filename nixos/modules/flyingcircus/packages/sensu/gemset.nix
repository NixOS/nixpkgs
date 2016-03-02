{
  uuidtools = {
    source = {
      sha256 = "0zjvq1jrrnzj69ylmz1xcr30skf9ymmvjmdwbvscncd7zkr8av5g";
      type = "gem";
    };
    version = "2.1.5";
  };
  tilt = {
    source = {
      sha256 = "0lkd40xfdqkp333vdfhrfjmi2y7k2hjs4azawfb62mrkfp7ivj84";
      type = "gem";
    };
    version = "2.0.2";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    source = {
      sha256 = "1m56aygh5rh8ncp3s2gnn8ghn5ibkk0bg6s3clmh1vzaasw2lj4i";
      type = "gem";
    };
    version = "1.6.3";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      sha256 = "1hhmwqc81ram7lfwwziv0z70jh92sj1m7h7s9fr0cn2xq8mmn8l7";
      type = "gem";
    };
    version = "1.4.6";
  };
  sensu-transport = {
    version = "4.0.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "153r2wgqh2bxrgml2ag7iyw7w5r4jmcbqj96lcq5gr98761zzb8l";
    };
  };
  sensu-spawn = {
    version = "1.7.0";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "06krhrgdb1b83js185ljh32sd30r8irfb1rjs0wl2amn6w5nrdi6";
    };
  };
  sensu-settings = {
    dependencies = ["multi_json"];
    source = {
      sha256 = "0fk5chvzv946yg6cqpjlpjw5alwimg8rsxs3knhbgdanyrbh6m32";
      type = "gem";
    };
    version = "3.3.0";
  };
  sensu-logger = {
    dependencies = ["eventmachine" "multi_json"];
    source = {
      sha256 = "1pbzbr83df4awndr49f1z7z1bl9n73nkf1xcnlkjcnpnb3yy07pw";
      type = "gem";
    };
    version = "1.1.0";
  };
  sensu-extensions = {
    dependencies = ["multi_json" "sensu-extension" "sensu-logger" "sensu-settings"];
    source = {
      sha256 = "16npdf1hcpcn47wmznkwcikynxzb2jv2irqlvprjlapy2m6m4c62";
      type = "gem";
    };
    version = "1.4.0";
  };
  sensu-extension = {
    dependencies = ["eventmachine"];
    source = {
      sha256 = "1ms7g76vng0dzaq86g4s8mdszjribm6v6vkbmh4psf988xw95a2b";
      type = "gem";
    };
    version = "1.3.0";
  };
  sensu = {
    version = "0.22.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "0vyk8m4acjzn4i2q41gabpmrlqcl2x4ivf58m0hqn3x7l45ma605";
    };
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
      type = "gem";
    };
    version = "1.5.3";
  };
  rack = {
    source = {
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
      type = "gem";
    };
    version = "1.6.4";
  };
  multi_json = {
    source = {
      sha256 = "1rf3l4j3i11lybqzgq2jhszq7fh7gpmafjzd14ymp9cjfxqg596r";
      type = "gem";
    };
    version = "1.11.2";
  };
  ffi = {
    source = {
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
      type = "gem";
    };
    version = "1.9.10";
  };
  eventmachine = {
    version = "1.0.9.1";
    source = {
      type = "gem";
      remotes = ["https://rubygems.org"];
      sha256 = "17jr1caa3ggg696dd02g2zqzdjqj9x9q2nl7va82l36f7c5v6k4z";
    };
  };
  em-worker = {
    dependencies = ["eventmachine"];
    source = {
      sha256 = "0z4jx9z2q5hxvdvik4yp0ahwfk69qsmdnyp72ln22p3qlkq2z5wk";
      type = "gem";
    };
    version = "0.0.2";
  };
  em-redis-unified = {
    dependencies = ["eventmachine"];
    source = {
      sha256 = "0rzf2c2cbfc1k5jiahmgd3c4l9z5f74b6a549v44n5j1hyj03m9v";
      type = "gem";
    };
    version = "1.0.1";
  };
  daemons = {
    source = {
      sha256 = "0b839hryy9sg7x3knsa1d6vfiyvn0mlsnhsb6an8zsalyrz1zgqg";
      type = "gem";
    };
    version = "1.2.3";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      sha256 = "1lv7axi1fhascm9njxh3lx1rbrnsm8wgvib0g7j26v4h1fcphqg0";
      type = "gem";
    };
    version = "0.5.8";
  };
  async_sinatra = {
    dependencies = ["rack" "sinatra"];
    source = {
      sha256 = "0sjdvkchq5blvfdahhrlipsx5sr9kfmdx0zxssjlfkz54dbl14m0";
      type = "gem";
    };
    version = "1.2.0";
  };
  amqp = {
    dependencies = ["amq-protocol" "eventmachine"];
    source = {
      sha256 = "0jlcwyvjz0b28wxdabkyhdqyqp5ji56ckfywsy9mgp0m4wfbrh8c";
      type = "gem";
    };
    version = "1.5.0";
  };
  amq-protocol = {
    source = {
      sha256 = "1gl479j003vixfph5jmdskl20il8816y0flp4msrc8im3b5iiq3r";
      type = "gem";
    };
    version = "1.9.2";
  };
}