{
  beta = {
    deps = {
      gn = {
        rev = "e9e83d9095d3234adf68f3e2866f25daf766d5c7";
        sha256 = "0y07c18xskq4mclqiz3a63fz8jicz2kqridnvdhqdf75lhp61f8a";
        url = "https://gn.googlesource.com/gn";
        version = "2023-05-19";
      };
    };
    sha256 = "1wbasmwdqkg5jcmzpidvzjsq2n2dr73bxz85pr8a5j4grw767gpz";
    sha256bin64 = "0xbizb3d539h1cw1kj9ahd8azmkcdfjdmqb5bpp8cr21bh2qbqp5";
    version = "115.0.5790.98";
  };
  dev = {
    deps = {
      gn = {
        rev = "4bd1a77e67958fb7f6739bd4542641646f264e5d";
        sha256 = "14h9jqspb86sl5lhh6q0kk2rwa9zcak63f8drp7kb3r4dx08vzsw";
        url = "https://gn.googlesource.com/gn";
        version = "2023-06-09";
      };
    };
    sha256 = "1fvhh8fvm0rkb41mhsh4p3bahf4fk3gixan2x1bappm3hdcixffb";
    sha256bin64 = "1zq4vyvm0vij03rc0zwzknm17108ka8bl1lsayp1133y2fgbl9f8";
    version = "116.0.5845.42";
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
        rev = "4bd1a77e67958fb7f6739bd4542641646f264e5d";
        sha256 = "14h9jqspb86sl5lhh6q0kk2rwa9zcak63f8drp7kb3r4dx08vzsw";
        url = "https://gn.googlesource.com/gn";
        version = "2023-06-09";
      };
    };
    sha256 = "152lyrw8k36gbmf4fmfny4ajqh0523y5d48yrshbgwn5klmbhaji";
    sha256bin64 = "118sk39939d52srws2vgs1mfizpikswxh5ihd9x053vzn0aj8cfa";
    version = "116.0.5845.187";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        rev = "4bd1a77e67958fb7f6739bd4542641646f264e5d";
        sha256 = "14h9jqspb86sl5lhh6q0kk2rwa9zcak63f8drp7kb3r4dx08vzsw";
        url = "https://gn.googlesource.com/gn";
        version = "2023-06-09";
      };
      ungoogled-patches = {
        rev = "116.0.5845.187-1";
        sha256 = "0br5lms6mxg2mg8ix5mkb79bg6wk5f2hn0xy1xc7gk9h3rl58is1";
      };
    };
    sha256 = "152lyrw8k36gbmf4fmfny4ajqh0523y5d48yrshbgwn5klmbhaji";
    sha256bin64 = "118sk39939d52srws2vgs1mfizpikswxh5ihd9x053vzn0aj8cfa";
    version = "116.0.5845.187";
  };
}
