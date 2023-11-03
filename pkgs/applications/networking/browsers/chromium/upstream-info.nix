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
    sha256 = "0c3adrrgpnhm8g1546ask9pf17qj1sjgb950mj0rv4snxvddi75j";
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
    sha256 = "16dq27lsywrn2xlgr5g46gdv15p30sihfamli4vkv3zxzfxdjisv";
    sha256bin64 = "11y09hsy7y1vg65xfilq44ffsmn15dqy80fa57psj1kin4a52v2x";
    version = "118.0.5966.0";
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
        rev = "991530ce394efb58fcd848195469022fa17ae126";
        sha256 = "1zpbaspb2mncbsabps8n1iwzc67nhr79ndc9dnqxx1w1qfvaldg2";
        url = "https://gn.googlesource.com/gn";
        version = "2023-09-12";
      };
    };
    sha256 = "0w41yj5zpnwshvdhgklgyj21xksa9kfz15xdym7hs9nsb785jl5i";
    sha256bin64 = "0frxc3w880bim6d5gjjc5gsnsj7cgsb1c0z8pppi3d1gqlad7d2q";
    version = "119.0.6045.105";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        rev = "991530ce394efb58fcd848195469022fa17ae126";
        sha256 = "1zpbaspb2mncbsabps8n1iwzc67nhr79ndc9dnqxx1w1qfvaldg2";
        url = "https://gn.googlesource.com/gn";
        version = "2023-09-12";
      };
      ungoogled-patches = {
        rev = "119.0.6045.105-1";
        sha256 = "0iy6lw3f8phhvfds56z72sd9ilvqjxsaxf7yz50hhmzy23knfngv";
      };
    };
    sha256 = "0w41yj5zpnwshvdhgklgyj21xksa9kfz15xdym7hs9nsb785jl5i";
    sha256bin64 = "0frxc3w880bim6d5gjjc5gsnsj7cgsb1c0z8pppi3d1gqlad7d2q";
    version = "119.0.6045.105";
  };
}
