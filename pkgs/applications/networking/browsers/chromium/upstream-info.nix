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
      sha256_darwin = "08jlxh2xngd8dn1r88d6ryl1mjmhba36ma7yla93yds02bsi845i";
      sha256_darwin_aarch64 =
        "137nzad2h2hqpzwqk7jimb23sw2rwz9j2iz7c5cz7v2wzaqw3qsk";
      sha256_linux = "1xkzqc7cja56b4rdbqv1b2996k9jqicvykzcsnic04m9il18p3ns";
      version = "119.0.6045.105";
    };
    deps = {
      gn = {
        rev = "e4702d7409069c4f12d45ea7b7f0890717ca3f4b";
        sha256 = "1fbkpdsxbma41yja4s27j4i3f1pa38784f8knhq9plzawwc6w2bp";
        url = "https://gn.googlesource.com/gn";
        version = "2023-10-23";
      };
    };
    sha256 = "0jpmrp6cgm8xbsdrl219h5hr7yi0dan2qrhbwrkx3xxn2wi1v1nq";
    sha256bin64 = "15r1kx4jnbrcw7kfma528ks5ic17s4ydh1ncsb680himhln02z64";
    version = "120.0.6099.71";
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
        rev = "119.0.6045.199-1";
        sha256 = "1j64sah88j7q86cjqf0cqa85mc8ka59nm37vz0bxwpnydap3khb5";
      };
    };
    sha256 = "0f11p5gf98islrp6w10ji8lw9jpnc8jzl54d9902zjai0r3hx81f";
    sha256bin64 = "1if5zzjsnzjnl917hnkb569mi4cgdikxx6lpi6sy7g6pk7466xpn";
    version = "119.0.6045.199";
  };
}
