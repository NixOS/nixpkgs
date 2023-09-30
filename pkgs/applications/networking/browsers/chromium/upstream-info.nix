{
  beta = {
    deps = {
      gn = {
        rev = "811d332bd90551342c5cbd39e133aa276022d7f8";
        sha256 = "0jlg3d31p346na6a3yk0x29pm6b7q03ck423n5n6mi8nv4ybwajq";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-01";
      };
    };
    sha256 = "1wf0j189cxpayy6ffmj5j6h5yg3amivryilimjc2ap0jkyj4xrbi";
    sha256bin64 = "11w1di146mjb9ql30df9yk9x4b9amc6514jzyfbf09mqsrw88dvr";
    version = "117.0.5938.22";
  };
  dev = {
    deps = {
      gn = {
        rev = "cc56a0f98bb34accd5323316e0292575ff17a5d4";
        sha256 = "1ly7z48v147bfdb1kqkbc98myxpgqq3g6vgr8bjx1ikrk17l82ab";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-10";
      };
    };
    sha256 = "1z01b6w4sgndrlcd26jgimk3rhv3wzpn67nv1fd5ln7dwfwkyq20";
    sha256bin64 = "11y09hsy7y1vg65xfilq44ffsmn15dqy80fa57psj1kin4a52v2x";
    version = "118.0.5966.0";
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
        rev = "117.0.5938.132-1";
        sha256 = "11bg7j5838nhkwpv7blvpijjhqrisvx032bjmkng1cpy2d0kmfcx";
      };
    };
    sha256 = "1bdfvcywj6ggrn6fz6g7hqhikg0cjdj8llgcm4wji52i7897gw18";
    sha256bin64 = "05a2sggxm76kc6m5wcpb4gibnxa07j291m7292zdvyg32kffqxjr";
    version = "117.0.5938.132";
  };
}
