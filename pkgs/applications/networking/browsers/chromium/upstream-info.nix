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
      sha256_darwin = "020qzjy8aq7y4gxpn2vjw71k7p3bvqhsvqkja99n2wndw8w0l6sf";
      sha256_darwin_aarch64 =
        "1byi0k7kxg6x23j8161ndrm73j9v4wrpk3ydygnvk48biw54nl2i";
      sha256_linux = "1dvakqyn5s75k5hcjrydqgp003m5l7abvyd9b2whjbasa1my5ijz";
      version = "120.0.6099.71";
    };
    deps = {
      gn = {
        rev = "e4702d7409069c4f12d45ea7b7f0890717ca3f4b";
        sha256 = "1fbkpdsxbma41yja4s27j4i3f1pa38784f8knhq9plzawwc6w2bp";
        url = "https://gn.googlesource.com/gn";
        version = "2023-10-23";
      };
    };
    sha256 = "08rrkjd4xn8l8hbfc7jawjda85za9856i0fsimj9bg4zyg33rfk5";
    sha256bin64 = "0arwmfj9wnwray0gq0mmlcnq4azka1mg0kni3qb5fqsz3x04kha9";
    version = "120.0.6099.109";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        rev = "e4702d7409069c4f12d45ea7b7f0890717ca3f4b";
        sha256 = "1fbkpdsxbma41yja4s27j4i3f1pa38784f8knhq9plzawwc6w2bp";
        url = "https://gn.googlesource.com/gn";
        version = "2023-10-23";
      };
      ungoogled-patches = {
        rev = "120.0.6099.71-1";
        sha256 = "1wl8ykvpcww399xi8p3i8bp78fq44hpcnvijlg42ikxmrpsashjb";
      };
    };
    sha256 = "0jpmrp6cgm8xbsdrl219h5hr7yi0dan2qrhbwrkx3xxn2wi1v1nq";
    sha256bin64 = "15r1kx4jnbrcw7kfma528ks5ic17s4ydh1ncsb680himhln02z64";
    version = "120.0.6099.71";
  };
}
