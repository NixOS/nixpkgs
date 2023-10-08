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
      sha256_darwin = "06yhmapflj5m40952zcrq97qlj3crbbffaspiz87w0syxnw9avq1";
      sha256_darwin_aarch64 =
        "07dkpaqildzsrwbgjgxw5imbbz2pjvyq3n1wiw94lfjqbd9jrkbz";
      sha256_linux = "0lqng6g722apxa9k596f42f6bw323q4b29vrkcs1lh86skgikdgj";
      version = "117.0.5938.149";
    };
    deps = {
      gn = {
        rev = "811d332bd90551342c5cbd39e133aa276022d7f8";
        sha256 = "0jlg3d31p346na6a3yk0x29pm6b7q03ck423n5n6mi8nv4ybwajq";
        url = "https://gn.googlesource.com/gn";
        version = "2023-08-01";
      };
    };
    sha256 = "1pyrqxzxxibz0yp218kw6z186x8y6kd5a1l0mcbhj70rpm9cimyx";
    sha256bin64 = "1zly8dpxmhyqdsqd381r0yzjrf8nkfigfjhabm3dbf1ih7qma40z";
    version = "117.0.5938.149";
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
        rev = "117.0.5938.149-1";
        sha256 = "0kzbnymbp7snxmg3adpl16anyhs2rxk0iqy5dda8dx5rv9s8i0x0";
      };
    };
    sha256 = "1pyrqxzxxibz0yp218kw6z186x8y6kd5a1l0mcbhj70rpm9cimyx";
    sha256bin64 = "1zly8dpxmhyqdsqd381r0yzjrf8nkfigfjhabm3dbf1ih7qma40z";
    version = "117.0.5938.149";
  };
}
