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
      sha256_darwin = "138mw5p6r0n0531fs6322yxsjgj9hia5plw4mj0b3mclykzy5l37";
      sha256_darwin_aarch64 =
        "1cym94av2gw2zwj3rdqbjcqkigpzf0zk2bam2hw9n2hiabb4rm0p";
      sha256_linux = "1q1vyhmcx6b5criz5bn1c3x3z2dzqdgsmwcvlb0rzqlzpla9q26m";
      version = "117.0.5938.92";
    };
    deps = {
      gn = {
        rev = "811d332bd90551342c5cbd39e133aa276022d7f8";
        sha256 = "0jlg3d31p346na6a3yk0x29pm6b7q03ck423n5n6mi8nv4ybwajq";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-01";
      };
    };
    sha256 = "1bdfvcywj6ggrn6fz6g7hqhikg0cjdj8llgcm4wji52i7897gw18";
    sha256bin64 = "05a2sggxm76kc6m5wcpb4gibnxa07j291m7292zdvyg32kffqxjr";
    version = "117.0.5938.132";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        rev = "811d332bd90551342c5cbd39e133aa276022d7f8";
        sha256 = "0jlg3d31p346na6a3yk0x29pm6b7q03ck423n5n6mi8nv4ybwajq";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-01";
      };
      ungoogled-patches = {
        rev = "117.0.5938.92-1";
        sha256 = "0ix0vaki9r305js61qraiah3vqjaj3dyycabi6grfavdgjpjkasb";
      };
    };
    sha256 = "0b1l8gjhqbsyqi30rsn8dyq2hdvwasdqfk1qzk55f9ch4wclkjk5";
    sha256bin64 = "047w7y4c8k076yzrjc50lvwncbk8b3lyqnd1si9nrsl7c66j2h0q";
    version = "117.0.5938.92";
  };
}
