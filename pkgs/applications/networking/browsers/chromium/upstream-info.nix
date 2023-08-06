{
  beta = {
    deps = {
      gn = {
        rev = "4bd1a77e67958fb7f6739bd4542641646f264e5d";
        sha256 = "14h9jqspb86sl5lhh6q0kk2rwa9zcak63f8drp7kb3r4dx08vzsw";
        url = "https://gn.googlesource.com/gn";
        version = "2023-06-09";
      };
    };
    sha256 = "0r5m2bcrh2zpl2m8wnzyl4afh8s0dh2m2fnfjf50li94694vy4jz";
    sha256bin64 = "047wsszg4c23vxq93a335iymiqpy7lw5izzz4f0zk1a4sijafd59";
    version = "116.0.5845.50";
  };
  dev = {
    deps = {
      gn = {
        rev = "fae280eabe5d31accc53100137459ece19a7a295";
        sha256 = "02javy4jsllwl4mxl2zmg964jvzw800w6gbmr5z6jdkip24fw0kj";
        url = "https://gn.googlesource.com/gn";
        version = "2023-07-12";
      };
    };
    sha256 = "0pyf3k58m26lkc6v6mqpwvhyaj6bbyywl4c17cxb5zmzc1zmc5ia";
    sha256bin64 = "10w5dm68aaffgdq0xqi4ans2w7byisqqld09pz5vpk350gy16fjh";
    version = "117.0.5897.3";
  };
  stable = {
    chromedriver = {
      sha256_darwin = "1c41cb7zh13ny4xvpwy7703cnjrkmqxd3n8zpja7n6a38mi8mgsk";
      sha256_darwin_aarch64 =
        "1kliszw10jnnlhzi8jrdzjq0r7vfn6ksk1spsh2rfn2hmghccv2d";
      sha256_linux = "1797qmb213anvp9lmrkj6wmfdwkdfswmshmk1816zankw5dl883j";
      version = "115.0.5790.98";
    };
    deps = {
      gn = {
        rev = "e9e83d9095d3234adf68f3e2866f25daf766d5c7";
        sha256 = "0y07c18xskq4mclqiz3a63fz8jicz2kqridnvdhqdf75lhp61f8a";
        url = "https://gn.googlesource.com/gn";
        version = "2023-05-19";
      };
    };
    sha256 = "1h3j24ihn76qkvckzg703pm1jsh6nbkc48n2zx06kia8wz96567z";
    sha256bin64 = "04jklk2zwkyy8i70v9nk7nw35w2g9pyxdw9w3sn9mddgbjjph5z9";
    version = "115.0.5790.170";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        rev = "e9e83d9095d3234adf68f3e2866f25daf766d5c7";
        sha256 = "0y07c18xskq4mclqiz3a63fz8jicz2kqridnvdhqdf75lhp61f8a";
        url = "https://gn.googlesource.com/gn";
        version = "2023-05-19";
      };
      ungoogled-patches = {
        rev = "115.0.5790.170-1";
        sha256 = "0vk82jacadb4id16596s4751j4idq6903w6sl2s7cj4ppxd6pyf1";
      };
    };
    sha256 = "1h3j24ihn76qkvckzg703pm1jsh6nbkc48n2zx06kia8wz96567z";
    sha256bin64 = "04jklk2zwkyy8i70v9nk7nw35w2g9pyxdw9w3sn9mddgbjjph5z9";
    version = "115.0.5790.170";
  };
}
