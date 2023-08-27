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
      sha256_darwin = "0gzx3zka8i2ngsdiqp8sr0v6ir978vywa1pj7j08vsf8kmb93iiy";
      sha256_darwin_aarch64 =
        "18iyapwjg0yha8qgbw7f605n0j54nd36shv3497bd84lc9k74b14";
      sha256_linux = "0d8mqzjc11g1bvxvffk0xyhxfls2ycl7ym4ssyjq752g2apjblhp";
      version = "116.0.5845.96";
    };
    deps = {
      gn = {
        rev = "4bd1a77e67958fb7f6739bd4542641646f264e5d";
        sha256 = "14h9jqspb86sl5lhh6q0kk2rwa9zcak63f8drp7kb3r4dx08vzsw";
        url = "https://gn.googlesource.com/gn";
        version = "2023-06-09";
      };
    };
    sha256 = "1afr0shzsxfi72xypr33r9y4rps1yfx9qf1f9pyjz5x4l5wz8pp8";
    sha256bin64 = "08hqymyzah1wiyag56iivvydy1zph4jzicjjjyh6br07lpfps7nk";
    version = "116.0.5845.110";
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
        rev = "116.0.5845.110-1";
        sha256 = "1dj8zjnd105lmrfb033hgcvw3a2jaxlp97aqnj0wzx6jw7q9y4p1";
      };
    };
    sha256 = "1afr0shzsxfi72xypr33r9y4rps1yfx9qf1f9pyjz5x4l5wz8pp8";
    sha256bin64 = "08hqymyzah1wiyag56iivvydy1zph4jzicjjjyh6br07lpfps7nk";
    version = "116.0.5845.110";
  };
}
