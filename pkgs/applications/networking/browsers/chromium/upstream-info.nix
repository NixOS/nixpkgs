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
      sha256_darwin = "0y973bs4dbdrl152bfiq5avsp6h27j3v1kwgcgxk1d0g293322xs";
      sha256_darwin_aarch64 =
        "04qrhr52qc9rhmslgsh2yymsix9cv32g39xbpf8576scihfdngv8";
      sha256_linux = "1hy3s6j20h03ria033kfxd3rq259davvpjny4gpvznzklns71vi1";
      version = "118.0.5993.70";
    };
    deps = {
      gn = {
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        sha256 = "1ly7z48v147bfdb1kqkbc98myxpgqq3g6vgr8bjx1ikrk17l82ab";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
    };
    sha256 = "0gcrnvm3ar7x0fv38kjvdzgb8lflx1sckcqy89yawgfy6jkh1vj9";
    sha256bin64 = "1bq170l0g9yq17x6xlg6fjar6gv3hdi0zijwmx4s02pmw6727484";
    version = "118.0.5993.70";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        sha256 = "1ly7z48v147bfdb1kqkbc98myxpgqq3g6vgr8bjx1ikrk17l82ab";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
      ungoogled-patches = {
        rev = "118.0.5993.70-1";
        sha256 = "0k6684cy1ks6yba2bdz17g244f05qy9769cvis4h2jzhgbf5rysh";
      };
    };
    sha256 = "0gcrnvm3ar7x0fv38kjvdzgb8lflx1sckcqy89yawgfy6jkh1vj9";
    sha256bin64 = "1bq170l0g9yq17x6xlg6fjar6gv3hdi0zijwmx4s02pmw6727484";
    version = "118.0.5993.70";
  };
}
