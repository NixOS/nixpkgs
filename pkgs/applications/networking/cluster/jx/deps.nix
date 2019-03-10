# file generated from go.mod using vgo2nix (https://github.com/adisbladis/vgo2nix)
# file was patched manually to account for the `replace` statements in the
# upstream go.mod that's not yet supported by vgo2nix.
[
  {
    goPackagePath = "cloud.google.com/go";
    fetch = {
      type = "git";
      url = "https://code.googlesource.com/gocloud";
      rev = "v0.34.0";
      sha256 = "1kclgclwar3r37zbvb9gg3qxbgzkb50zk3s9778zlh2773qikmai";
    };
  }
  {
    goPackagePath = "code.gitea.io/sdk";
    fetch = {
      type = "git";
      url = "https://github.com/go-gitea/go-sdk";
      rev = "79a281c4e34a";
      sha256 = "1bkcsmjagsyaynyi562rsi3xvypnb2z38inq6ni5k9mxk9q5r8h0";
    };
  }
  {
    goPackagePath = "contrib.go.opencensus.io/exporter/aws";
    fetch = {
      type = "git";
      url = "https://github.com/census-ecosystem/opencensus-go-exporter-aws";
      rev = "dd54a7ef511e";
      sha256 = "05xs00w0miw7ci329dmfhxdav3wfjcn3z63px7s8cqd78k18a4sn";
    };
  }
  {
    goPackagePath = "contrib.go.opencensus.io/exporter/stackdriver";
    fetch = {
      type = "git";
      url = "https://github.com/census-ecosystem/opencensus-go-exporter-stackdriver";
      rev = "v0.6.0";
      sha256 = "0qhxpfmzn5jsh1qrq7w2zkg87xvalqam2ciq65qfq38mfkssda3v";
    };
  }
  {
    goPackagePath = "contrib.go.opencensus.io/integrations/ocsql";
    fetch = {
      type = "git";
      url = "https://github.com/opencensus-integrations/ocsql";
      rev = "v0.1.2";
      sha256 = "0rs8dyr8jp4907h8f6ih3bgqbqjhq9q7m8b3pfvargmr7kq5si70";
    };
  }
  {
    goPackagePath = "git.apache.org/thrift.git";
    fetch = {
      type = "git";
      url = "https://github.com/apache/thrift.git";
      rev = "2566ecd5d999";
      sha256 = "14gl0j85x3hj3gncf417f8zf92phrpvkj4clxmvbcq1dcgjdn6mc";
    };
  }
  {
    goPackagePath = "github.com/Azure/azure-pipeline-go";
    fetch = {
      type = "git";
      url = "https://github.com/Azure/azure-pipeline-go";
      rev = "v0.1.8";
      sha256 = "0p2m31l893377na7dmsjfpjd5swqnb7p0vhsng3vyn237i8f1336";
    };
  }
  {
    goPackagePath = "github.com/Azure/azure-sdk-for-go";
    fetch = {
      type = "git";
      url = "https://github.com/Azure/azure-sdk-for-go";
      rev = "v21.1.0";
      sha256 = "1rway7ksn6c98pxs036hl8nvljs3vxspgsjj9y1ncc0vzavg29d1";
    };
  }
  {
    goPackagePath = "github.com/Azure/azure-storage-blob-go";
    fetch = {
      type = "git";
      url = "https://github.com/Azure/azure-storage-blob-go";
      rev = "cf01652132cc";
      sha256 = "0pcb59nsn094flpqwl7yz7cqvvwki0wam9r8gjbzqbsjn7ib3gac";
    };
  }
  {
    goPackagePath = "github.com/Azure/draft";
    fetch = {
      type = "git";
      url = "https://github.com/Azure/draft";
      rev = "v0.15.0";
      sha256 = "03396zlalfsdxaiqpb97m8x9r060yyydvh0dkg7506pz5zrfm4pn";
    };
  }
  {
    goPackagePath = "github.com/Azure/go-ansiterm";
    fetch = {
      type = "git";
      url = "https://github.com/Azure/go-ansiterm";
      rev = "d6e3b3328b78";
      sha256 = "010khrkhkf9cxlvvb6ncqv4c1qcdmpbz9jn38g4fxf4xsma8xx1q";
    };
  }
  {
    goPackagePath = "github.com/Azure/go-autorest";
    fetch = {
      type = "git";
      url = "https://github.com/Azure/go-autorest";
      rev = "v10.15.5";
      sha256 = "158xbd8wn1bna1k1ichlirz6a1zvlh3rg7klr9cnp72l2q8jwvcl";
    };
  }
  {
    goPackagePath = "github.com/BurntSushi/toml";
    fetch = {
      type = "git";
      url = "https://github.com/BurntSushi/toml";
      rev = "v0.3.0";
      sha256 = "0k7v2i1d2d6si8gswn83qb84czhhia53v2wdy33yz9ppdidxk0ry";
    };
  }
  {
    goPackagePath = "github.com/DataDog/datadog-go";
    fetch = {
      type = "git";
      url = "https://github.com/DataDog/datadog-go";
      rev = "281ae9f2d895";
      sha256 = "1n82vl636zcpfrhh7yhmszvdxdba5hn2fjl39dvnk0a8pm2afmkx";
    };
  }
  {
    goPackagePath = "github.com/GoogleCloudPlatform/cloudsql-proxy";
    fetch = {
      type = "git";
      url = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
      rev = "ac834ce67862";
      sha256 = "07n2hfhqa9hinabmx79aqqwxzzkky76x3jvpd89kch14fijbh532";
    };
  }
  {
    goPackagePath = "github.com/IBM-Cloud/bluemix-go";
    fetch = {
      type = "git";
      url = "https://github.com/IBM-Cloud/bluemix-go";
      rev = "d718d474c7c2";
      sha256 = "1div1yrr7lbamh469hkd41acbjsln7jyaf0kzjxbjgb4rwmnh2jk";
    };
  }
  {
    goPackagePath = "github.com/Jeffail/gabs";
    fetch = {
      type = "git";
      url = "https://github.com/Jeffail/gabs";
      rev = "v1.1.1";
      sha256 = "1lk6cn7fnnfyq8xb0xlv8zv3gvdd0vb2g8ikc9rfcppl7hwy51n8";
    };
  }
  {
    goPackagePath = "github.com/MakeNowJust/heredoc";
    fetch = {
      type = "git";
      url = "https://github.com/MakeNowJust/heredoc";
      rev = "e9091a26100e";
      sha256 = "04lh2vm6d6s1vikzh9xb4ya744snr5c4v5797y2b8ri4pyfgd9h2";
    };
  }
  {
    goPackagePath = "github.com/Masterminds/semver";
    fetch = {
      type = "git";
      url = "https://github.com/Masterminds/semver";
      rev = "v1.4.2";
      sha256 = "0k2fpk2x8jbvqkqxx5hkx1ygrsppzmzypqb90i1r33yq7ac7zlxj";
    };
  }
  {
    goPackagePath = "github.com/Masterminds/sprig";
    fetch = {
      type = "git";
      url = "https://github.com/Masterminds/sprig";
      rev = "6b2a58267f6a";
      sha256 = "10vzhx710vaxqzh45vrkw4vc3fgcbycpn04shcylzcmlxmfnpjv1";
    };
  }
  {
    goPackagePath = "github.com/Microsoft/go-winio";
    fetch = {
      type = "git";
      url = "https://github.com/Microsoft/go-winio";
      rev = "v0.4.6";
      sha256 = "0i3z8yrxlldq0n70ic30517437jzzxmvbglhbxrz75qnlzrglhlp";
    };
  }
  {
    goPackagePath = "github.com/NYTimes/gziphandler";
    fetch = {
      type = "git";
      url = "https://github.com/NYTimes/gziphandler";
      rev = "63027b26b87e";
      sha256 = "1px0rlhxpap7rk37w0qlq66zzxwfvbpdc2sps2i2rqxgd3w5n31g";
    };
  }
  {
    goPackagePath = "github.com/Netflix/go-expect";
    fetch = {
      type = "git";
      url = "https://github.com/Netflix/go-expect";
      rev = "124a37274874";
      sha256 = "1cq3d7d4cpwgyzb0syka4a4dspcymq5582qzvbdkbkc4s81kjr4c";
    };
  }
  {
    goPackagePath = "github.com/Nvveen/Gotty";
    fetch = {
      type = "git";
      url = "https://github.com/Nvveen/Gotty";
      rev = "cd527374f1e5";
      sha256 = "1ylvr1p6p036ns3g3wdz8f92f69symshkc8j54fa6gpg4hyk0k6q";
    };
  }
  {
    goPackagePath = "github.com/Pallinder/go-randomdata";
    fetch = {
      type = "git";
      url = "https://github.com/Pallinder/go-randomdata";
      rev = "15df0648130a";
      sha256 = "1kdrchnhp71spz6amcbxr5m0pdksbqx8jjydvxb82pw43rrbx6s7";
    };
  }
  {
    goPackagePath = "github.com/PuerkitoBio/purell";
    fetch = {
      type = "git";
      url = "https://github.com/PuerkitoBio/purell";
      rev = "v1.1.0";
      sha256 = "0vsxyn1fbm7g873b8kf3hcsgqgncb5nmfq3zfsc35a9yhzarka91";
    };
  }
  {
    goPackagePath = "github.com/PuerkitoBio/urlesc";
    fetch = {
      type = "git";
      url = "https://github.com/PuerkitoBio/urlesc";
      rev = "de5bf2ad4578";
      sha256 = "0n0srpqwbaan1wrhh2b7ysz543pjs1xw2rghvqyffg9l0g8kzgcw";
    };
  }
  {
    goPackagePath = "github.com/SAP/go-hdb";
    fetch = {
      type = "git";
      url = "https://github.com/SAP/go-hdb";
      rev = "v0.13.2";
      sha256 = "0gzw594y039chx22a3zn9y3j2y6bqsgi9zq7lzpf7schzl52ii7h";
    };
  }
  {
    goPackagePath = "github.com/SermoDigital/jose";
    fetch = {
      type = "git";
      url = "https://github.com/SermoDigital/jose";
      rev = "v0.9.1";
      sha256 = "0fc6w0hl9n39ixpayg1j3b4nvnr06bgvhqx5mxgxcydjci5pqi8m";
    };
  }
  {
    goPackagePath = "github.com/StackExchange/wmi";
    fetch = {
      type = "git";
      url = "https://github.com/StackExchange/wmi";
      rev = "5d049714c4a6";
      sha256 = "1slw6v1fl8i0hz4db9lph55pbhnrxhqyndq6vm27dgvpj22k29fk";
    };
  }
  {
    goPackagePath = "github.com/acarl005/stripansi";
    fetch = {
      type = "git";
      url = "https://github.com/acarl005/stripansi";
      rev = "5a71ef0e047d";
      sha256 = "02sxiishdixm791jqbkmhdcvc712l0fb8rqmibxzgc61h0qs6rs3";
    };
  }
  {
    goPackagePath = "github.com/alcortesm/tgz";
    fetch = {
      type = "git";
      url = "https://github.com/alcortesm/tgz";
      rev = "9c5fe88206d7";
      sha256 = "04dcwnz2c2i4wbq2vx3g2wrdgqpncr2r1h6p1k08rdwk4bq1h8c5";
    };
  }
  {
    goPackagePath = "github.com/alecthomas/template";
    fetch = {
      type = "git";
      url = "https://github.com/alecthomas/template";
      rev = "a0175ee3bccc";
      sha256 = "0qjgvvh26vk1cyfq9fadyhfgdj36f1iapbmr5xp6zqipldz8ffxj";
    };
  }
  {
    goPackagePath = "github.com/alecthomas/units";
    fetch = {
      type = "git";
      url = "https://github.com/alecthomas/units";
      rev = "2efee857e7cf";
      sha256 = "1j65b91qb9sbrml9cpabfrcf07wmgzzghrl7809hjjhrmbzri5bl";
    };
  }
  {
    goPackagePath = "github.com/alexflint/go-filemutex";
    fetch = {
      type = "git";
      url = "https://github.com/alexflint/go-filemutex";
      rev = "d358565f3c3f";
      sha256 = "19fzbm0x8821awsmqj9ig49dxxkd72p1yfqbijmdwwszvw2r0ggz";
    };
  }
  {
    goPackagePath = "github.com/andygrunwald/go-gerrit";
    fetch = {
      type = "git";
      url = "https://github.com/andygrunwald/go-gerrit";
      rev = "43cfd7a94eb4";
      sha256 = "1350r7pvvgl26kiiz4x96ac5gym2xc9968ddx18z8wlv776azidr";
    };
  }
  {
    goPackagePath = "github.com/andygrunwald/go-jira";
    fetch = {
      type = "git";
      url = "https://github.com/andygrunwald/go-jira";
      rev = "v1.5.0";
      sha256 = "13fp8qim22znvlqclsg2sdlpvbnmgh549rrsa9cxk04klgaapdqy";
    };
  }
  {
    goPackagePath = "github.com/anmitsu/go-shlex";
    fetch = {
      type = "git";
      url = "https://github.com/anmitsu/go-shlex";
      rev = "648efa622239";
      sha256 = "10rgdp5d106iisgz25ic8k6f44s9adh4sjh6fyxq9ccm21gw49b7";
    };
  }
  {
    goPackagePath = "github.com/antham/chyle";
    fetch = {
      type = "git";
      url = "https://github.com/antham/chyle";
      rev = "v1.4.0";
      sha256 = "144ja4g7b238dm3hwgqbl71skxp5mx7438w78hjpbfn5zq2cbrs2";
    };
  }
  {
    goPackagePath = "github.com/antham/envh";
    fetch = {
      type = "git";
      url = "https://github.com/antham/envh";
      rev = "v1.2.0";
      sha256 = "0l0mn4vwns9b6faxvx464a38mjgk5rhn58sxai1g7l8c3qqr3g0h";
    };
  }
  {
    goPackagePath = "github.com/antham/strumt";
    fetch = {
      type = "git";
      url = "https://github.com/antham/strumt";
      rev = "6776189777d3";
      sha256 = "0m7xhjnfpxvhx3a59k46k33i0zmy427vxmx67smndjxgxgmpqzd0";
    };
  }
  {
    goPackagePath = "github.com/aokoli/goutils";
    fetch = {
      type = "git";
      url = "https://github.com/aokoli/goutils";
      rev = "v1.0.1";
      sha256 = "1yj4yjfwylica31sgj69ygb04p9xxi22kgfxd0j5f58zr8vwww2n";
    };
  }
  {
    goPackagePath = "github.com/armon/circbuf";
    fetch = {
      type = "git";
      url = "https://github.com/armon/circbuf";
      rev = "bbbad097214e";
      sha256 = "1idpr0lzb2px2p3wgfq2276yl7jpaz43df6n91kf790404s4zmk3";
    };
  }
  {
    goPackagePath = "github.com/armon/go-metrics";
    fetch = {
      type = "git";
      url = "https://github.com/armon/go-metrics";
      rev = "f0300d1749da";
      sha256 = "13l7c35ps0r27vxfil2w0xhhc7w5rh00awvlmn4cz0a937b9ffpv";
    };
  }
  {
    goPackagePath = "github.com/armon/go-radix";
    fetch = {
      type = "git";
      url = "https://github.com/armon/go-radix";
      rev = "v1.0.0";
      sha256 = "1m1k0jz9gjfrk4m7hjm7p03qmviamfgxwm2ghakqxw3hdds8v503";
    };
  }
  {
    goPackagePath = "github.com/asaskevich/govalidator";
    fetch = {
      type = "git";
      url = "https://github.com/asaskevich/govalidator";
      rev = "f9ffefc3facf";
      sha256 = "02rsz7v49in9bmgsjciqcyik9xmy3yfz0znw739ssgy6px00cg04";
    };
  }
  {
    goPackagePath = "github.com/aws/aws-k8s-tester";
    fetch = {
      type = "git";
      url = "https://github.com/aws/aws-k8s-tester";
      rev = "b411acf57dfe";
      sha256 = "1yhgmkdd003v99w9kdl96phfmg3f3a5ahmn49srdbakc3p1wwxh8";
    };
  }
  {
    goPackagePath = "github.com/aws/aws-sdk-go";
    fetch = {
      type = "git";
      url = "https://github.com/aws/aws-sdk-go";
      rev = "v1.16.20";
      sha256 = "0a5wwmjmlbdgmsv1myxr9vmr9k9cic5d31kc30qbasm7p15ljxr1";
    };
  }
  {
    goPackagePath = "github.com/banzaicloud/bank-vaults";
    fetch = {
      type = "git";
      url = "https://github.com/banzaicloud/bank-vaults";
      rev = "e31657d7c4fe";
      sha256 = "0f642k5prrvq7wcm96hk7vw8ma86x7k1bvkr8mrcvabnvvp5jcfk";
    };
  }
  {
    goPackagePath = "github.com/bazelbuild/buildtools";
    fetch = {
      type = "git";
      url = "https://github.com/bazelbuild/buildtools";
      rev = "80c7f0d45d7e";
      sha256 = "1r2590m283k2449ikjmvrifz1ik8gn4wyq563r4v03ssylf3rv40";
    };
  }
  {
    goPackagePath = "github.com/beevik/etree";
    fetch = {
      type = "git";
      url = "https://github.com/beevik/etree";
      rev = "v1.0.1";
      sha256 = "0f3lj7azxd5qq29hqd32211ds7n56i3rgmfll6c1f4css1f3srxg";
    };
  }
  {
    goPackagePath = "github.com/beorn7/perks";
    fetch = {
      type = "git";
      url = "https://github.com/beorn7/perks";
      rev = "3a771d992973";
      sha256 = "1l2lns4f5jabp61201sh88zf3b0q793w4zdgp9nll7mmfcxxjif3";
    };
  }
  {
    goPackagePath = "github.com/bgentry/speakeasy";
    fetch = {
      type = "git";
      url = "https://github.com/bgentry/speakeasy";
      rev = "v0.1.0";
      sha256 = "02dfrj0wyphd3db9zn2mixqxwiz1ivnyc5xc7gkz58l5l27nzp8s";
    };
  }
  {
    goPackagePath = "github.com/bitly/go-hostpool";
    fetch = {
      type = "git";
      url = "https://github.com/bitly/go-hostpool";
      rev = "a3a6125de932";
      sha256 = "1m82mvnfw6k2ylpn598bcsg8mdgbq4fnsk7yc23hpvps9glsrbb6";
    };
  }
  {
    goPackagePath = "github.com/blang/semver";
    fetch = {
      type = "git";
      url = "https://github.com/blang/semver";
      rev = "v3.5.1";
      sha256 = "13ws259bwcibkclbr82ilhk6zadm63kxklxhk12wayklj8ghhsmy";
    };
  }
  {
    goPackagePath = "github.com/bmizerany/assert";
    fetch = {
      type = "git";
      url = "https://github.com/bmizerany/assert";
      rev = "b7ed37b82869";
      sha256 = "18hy1wyl9zdi7sgxafrn3m7fadh6in0rhhb8l0cvkxqzdl0jcw2s";
    };
  }
  {
    goPackagePath = "github.com/bouk/monkey";
    fetch = {
      type = "git";
      url = "https://github.com/bouk/monkey";
      rev = "v1.0.0";
      sha256 = "1ngcjmn6bys10zd22x8fh5lf0iyqkjqmbx47b0inw9ddh56sdzph";
    };
  }
  {
    goPackagePath = "github.com/bwmarrin/snowflake";
    fetch = {
      type = "git";
      url = "https://github.com/bwmarrin/snowflake";
      rev = "68117e6bbede";
      sha256 = "1zpjxm82d55map8bvvpa1l9xjxg03005dza3rd7a6bapm31f3107";
    };
  }
  {
    goPackagePath = "github.com/c2h5oh/datasize";
    fetch = {
      type = "git";
      url = "https://github.com/c2h5oh/datasize";
      rev = "4eba002a5eae";
      sha256 = "02sxd659q7m7axfywiqfxk5rh6djh2m5240bin1makldj1nj16j3";
    };
  }
  {
    goPackagePath = "github.com/cenkalti/backoff";
    fetch = {
      type = "git";
      url = "https://github.com/cenkalti/backoff";
      rev = "v2.0.0";
      sha256 = "0k4899ifpir6kmfxli8a2xfj5zdh0xb2jd0fq2r38wzd4pk25ipr";
    };
  }
  {
    goPackagePath = "github.com/chai2010/gettext-go";
    fetch = {
      type = "git";
      url = "https://github.com/chai2010/gettext-go";
      rev = "bf70f2a70fb1";
      sha256 = "0bwjwvjl7zqm7kxram1rzz0ri3h897kiin13ljy9hx3fzz1i9lml";
    };
  }
  {
    goPackagePath = "github.com/chromedp/cdproto";
    fetch = {
      type = "git";
      url = "https://github.com/chromedp/cdproto";
      rev = "57cf4773008d";
      sha256 = "1m9qq4nvdj5rbpq123s88agiv3604lvg0q2af7fhr1m16rs4xg1k";
    };
  }
  {
    goPackagePath = "github.com/chromedp/chromedp";
    fetch = {
      type = "git";
      url = "https://github.com/chromedp/chromedp";
      rev = "v0.1.1";
      sha256 = "1wcj54ff3qa6sypl8bdaabwlhf3v9b7br3nr9rq0ls64jfdw1sla";
    };
  }
  {
    goPackagePath = "github.com/circonus-labs/circonus-gometrics";
    fetch = {
      type = "git";
      url = "https://github.com/circonus-labs/circonus-gometrics";
      rev = "v2.2.6";
      sha256 = "11j6bm05baskaavjzjkf48jkxis5sk621wkvi3j2315abkyhsf6f";
    };
  }
  {
    goPackagePath = "github.com/client9/misspell";
    fetch = {
      type = "git";
      url = "https://github.com/client9/misspell";
      rev = "v0.3.4";
      sha256 = "1vwf33wsc4la25zk9nylpbp9px3svlmldkm0bha4hp56jws4q9cs";
    };
  }
  {
    goPackagePath = "github.com/codeship/codeship-go";
    fetch = {
      type = "git";
      url = "https://github.com/codeship/codeship-go";
      rev = "7793ca823354";
      sha256 = "1jr93ddbb1v27vd4w8wx2dcha8g32gc6rl0chyz75rmypi6888h7";
    };
  }
  {
    goPackagePath = "github.com/containerd/continuity";
    fetch = {
      type = "git";
      url = "https://github.com/containerd/continuity";
      rev = "004b46473808";
      sha256 = "0js7wjap44db6vvdpz4dvblqx6j36r1kb09ggvlwx4inkwg2ds2d";
    };
  }
  {
    goPackagePath = "github.com/coreos/bbolt";
    fetch = {
      type = "git";
      url = "https://github.com/coreos/bbolt";
      rev = "v1.3.1-coreos.6";
      sha256 = "0r39wj5fv6d7nkkirjnnrnhikcp6sqa5dgmr6cimz5s0smvfm8vw";
    };
  }
  {
    goPackagePath = "github.com/coreos/etcd";
    fetch = {
      type = "git";
      url = "https://github.com/coreos/etcd";
      rev = "v3.3.10";
      sha256 = "1x2ii1hj8jraba8rbxz6dmc03y3sjxdnzipdvg6fywnlq1f3l3wl";
    };
  }
  {
    goPackagePath = "github.com/coreos/go-semver";
    fetch = {
      type = "git";
      url = "https://github.com/coreos/go-semver";
      rev = "v0.2.0";
      sha256 = "1gghi5bnqj50hfxhqc1cxmynqmh2yk9ii7ab9gsm75y5cp94ymk0";
    };
  }
  {
    goPackagePath = "github.com/coreos/go-systemd";
    fetch = {
      type = "git";
      url = "https://github.com/coreos/go-systemd";
      rev = "c6f51f82210d";
      sha256 = "1vnccmnkjl6n539l4cliz6sznpqn6igf5v7mbmsgahb838742clb";
    };
  }
  {
    goPackagePath = "github.com/coreos/pkg";
    fetch = {
      type = "git";
      url = "https://github.com/coreos/pkg";
      rev = "399ea9e2e55f";
      sha256 = "0nxbn0m7lr4dg0yrwnvlkfiyg3ndv8vdpssjx7b714nivpc6ar0y";
    };
  }
  {
    goPackagePath = "github.com/cpuguy83/go-md2man";
    fetch = {
      type = "git";
      url = "https://github.com/cpuguy83/go-md2man";
      rev = "v1.0.8";
      sha256 = "1w22dfdamsq63b5rvalh9k2y7rbwfkkjs7vm9vd4a13h2ql70lg2";
    };
  }
  {
    goPackagePath = "github.com/danwakefield/fnmatch";
    fetch = {
      type = "git";
      url = "https://github.com/danwakefield/fnmatch";
      rev = "cbb64ac3d964";
      sha256 = "0cbf511ppsa6hf59mdl7nbyn2b2n71y0bpkzbmfkdqjhanqh1lqz";
    };
  }
  {
    goPackagePath = "github.com/davecgh/go-spew";
    fetch = {
      type = "git";
      url = "https://github.com/davecgh/go-spew";
      rev = "v1.1.1";
      sha256 = "0hka6hmyvp701adzag2g26cxdj47g21x6jz4sc6jjz1mn59d474y";
    };
  }
  {
    goPackagePath = "github.com/deckarep/golang-set";
    fetch = {
      type = "git";
      url = "https://github.com/deckarep/golang-set";
      rev = "1d4478f51bed";
      sha256 = "01kaqrc5ywbwa46b6lz3db7kkg8q6v383h4lnxds4z3kjglkqaff";
    };
  }
  {
    goPackagePath = "github.com/denisenkom/go-mssqldb";
    fetch = {
      type = "git";
      url = "https://github.com/denisenkom/go-mssqldb";
      rev = "2fea367d496d";
      sha256 = "0qq3b68ziqhfy8j9xrzpq2czsbacakbraicm7gp7l6mdbifi06zr";
    };
  }
  {
    goPackagePath = "github.com/denormal/go-gitignore";
    fetch = {
      type = "git";
      url = "https://github.com/denormal/go-gitignore";
      rev = "75ce8f3e513c";
      sha256 = "0yqicwkrw7plrc6zybv025ssaqzhy01s0c7x8ifp0x3vmxrzy57k";
    };
  }
  {
    goPackagePath = "github.com/dgrijalva/jwt-go";
    fetch = {
      type = "git";
      url = "https://github.com/dgrijalva/jwt-go";
      rev = "v3.2.0";
      sha256 = "08m27vlms74pfy5z79w67f9lk9zkx6a9jd68k3c4msxy75ry36mp";
    };
  }
  {
    goPackagePath = "github.com/disintegration/imaging";
    fetch = {
      type = "git";
      url = "https://github.com/disintegration/imaging";
      rev = "v1.4.2";
      sha256 = "0dzwqy1xcm0d481z1fa2r60frdlf5fzjligpiqh5g8lhqskk2lx8";
    };
  }
  {
    goPackagePath = "github.com/djherbis/atime";
    fetch = {
      type = "git";
      url = "https://github.com/djherbis/atime";
      rev = "v1.0.0";
      sha256 = "1zwxsk2r2p53qpgsxkky4x1gvxca4fx6qy9y10jvgpn4wf57m4ja";
    };
  }
  {
    goPackagePath = "github.com/dnaeon/go-vcr";
    fetch = {
      type = "git";
      url = "https://github.com/dnaeon/go-vcr";
      rev = "v1.0.1";
      sha256 = "1d0kpqr12qrqlamz5a47bp05mx49za2v6l1k7c6z71xahfmb7v2d";
    };
  }
  {
    goPackagePath = "github.com/docker/distribution";
    fetch = {
      type = "git";
      url = "https://github.com/docker/distribution";
      rev = "edc3ab29cdff";
      sha256 = "1nqjaq1q6fs3c0avpb02sib0a906xfbk3m74hk2mqjdbyx9y8b4m";
    };
  }
  {
    goPackagePath = "github.com/docker/docker";
    fetch = {
      type = "git";
      url = "https://github.com/docker/docker";
      rev = "5e5fadb3c020";
      sha256 = "14rbpynz304xh0aqphjspld3955wcis1d1gcg4dicw0q1klhhw8v";
    };
  }
  {
    goPackagePath = "github.com/docker/go-connections";
    fetch = {
      type = "git";
      url = "https://github.com/docker/go-connections";
      rev = "v0.3.0";
      sha256 = "0v1pkr8apwmhyzbjfriwdrs1ihlk6pw7izm57r24mf9jdmg3fyb0";
    };
  }
  {
    goPackagePath = "github.com/docker/go-units";
    fetch = {
      type = "git";
      url = "https://github.com/docker/go-units";
      rev = "v0.3.2";
      sha256 = "1sqwvcszxqpv77xf2d8fxvryxphdwj9v8f93231wpnk9kpilhyii";
    };
  }
  {
    goPackagePath = "github.com/docker/spdystream";
    fetch = {
      type = "git";
      url = "https://github.com/docker/spdystream";
      rev = "bc6354cbbc29";
      sha256 = "08746a15snvmax6cnzn2qy7cvsspxbsx97vdbjpdadir3pypjxya";
    };
  }
  {
    goPackagePath = "github.com/dsnet/compress";
    fetch = {
      type = "git";
      url = "https://github.com/dsnet/compress";
      rev = "cc9eb1d7ad76";
      sha256 = "159liclywmyb6zx88ga5gn42hfl4cpk1660zss87fkx31hdq9fgx";
    };
  }
  {
    goPackagePath = "github.com/duosecurity/duo_api_golang";
    fetch = {
      type = "git";
      url = "https://github.com/duosecurity/duo_api_golang";
      rev = "539434bf0d45";
      sha256 = "1dzf280gin51gww2hkcc5r5dmrjfjirsmkmksjw2ipkgy8kp40nz";
    };
  }
  {
    goPackagePath = "github.com/dustin/go-humanize";
    fetch = {
      type = "git";
      url = "https://github.com/dustin/go-humanize";
      rev = "v1.0.0";
      sha256 = "1kqf1kavdyvjk7f8kx62pnm7fbypn9z1vbf8v2qdh3y7z7a0cbl3";
    };
  }
  {
    goPackagePath = "github.com/elazarl/go-bindata-assetfs";
    fetch = {
      type = "git";
      url = "https://github.com/elazarl/go-bindata-assetfs";
      rev = "v1.0.0";
      sha256 = "1swfb37g6sga3awvcmxf49ngbpvjv7ih5an9f8ixjqcfcwnb7nzp";
    };
  }
  {
    goPackagePath = "github.com/elazarl/goproxy";
    fetch = {
      type = "git";
      url = "https://github.com/elazarl/goproxy";
      rev = "2ce16c963a8a";
      sha256 = "1jdgwbma4zs77w66y6hf7677hwpww1wzw27qdk1dr0pms0y7zlzp";
    };
  }
  {
    goPackagePath = "github.com/emicklei/go-restful";
    fetch = {
      type = "git";
      url = "https://github.com/emicklei/go-restful";
      rev = "v2.8.0";
      sha256 = "1zqcjhg4q7788hyrkhwg4b6r1vc4qnzbw8c5j994mr18x42brxzg";
    };
  }
  {
    goPackagePath = "github.com/emirpasic/gods";
    fetch = {
      type = "git";
      url = "https://github.com/emirpasic/gods";
      rev = "v1.9.0";
      sha256 = "1zhkppqzy149fp561pif8d5d92jd9chl3l9z4yi5f8n60ibdmmjf";
    };
  }
  {
    goPackagePath = "github.com/erikstmartin/go-testdb";
    fetch = {
      type = "git";
      url = "https://github.com/erikstmartin/go-testdb";
      rev = "8d10e4a1bae5";
      sha256 = "1fhrqcpv8x74qwxx9gpnhgqbz5wkp2bnsq92w418l1fnrgh4ppmq";
    };
  }
  {
    goPackagePath = "github.com/evanphx/json-patch";
    fetch = {
      type = "git";
      url = "https://github.com/evanphx/json-patch";
      rev = "v4.1.0";
      sha256 = "1yqakqyqspdwpq2dzvrd9rb79z24zmrafscj284dnrl421ns3zvh";
    };
  }
  {
    goPackagePath = "github.com/fatih/color";
    fetch = {
      type = "git";
      url = "https://github.com/fatih/color";
      rev = "v1.7.0";
      sha256 = "0v8msvg38r8d1iiq2i5r4xyfx0invhc941kjrsg5gzwvagv55inv";
    };
  }
  {
    goPackagePath = "github.com/fatih/structs";
    fetch = {
      type = "git";
      url = "https://github.com/fatih/structs";
      rev = "v1.0.0";
      sha256 = "040grl40gcqd1y852lnf0l1l5wi73g0crnaihzl0nfsas9ydk3h4";
    };
  }
  {
    goPackagePath = "github.com/flynn/go-shlex";
    fetch = {
      type = "git";
      url = "https://github.com/flynn/go-shlex";
      rev = "3f9db97f8568";
      sha256 = "1j743lysygkpa2s2gii2xr32j7bxgc15zv4113b0q9jhn676ysia";
    };
  }
  {
    goPackagePath = "github.com/fsnotify/fsnotify";
    fetch = {
      type = "git";
      url = "https://github.com/fsnotify/fsnotify";
      rev = "v1.4.7";
      sha256 = "07va9crci0ijlivbb7q57d2rz9h27zgn2fsm60spjsqpdbvyrx4g";
    };
  }
  {
    goPackagePath = "github.com/fsouza/fake-gcs-server";
    fetch = {
      type = "git";
      url = "https://github.com/fsouza/fake-gcs-server";
      rev = "e85be23bdaa8";
      sha256 = "185kw9cap458s9ldlb2nm0vlwx82rd6jnx13600p8hnb5y36fjw7";
    };
  }
  {
    goPackagePath = "github.com/gfleury/go-bitbucket-v1";
    fetch = {
      type = "git";
      url = "https://github.com/gfleury/go-bitbucket-v1";
      rev = "3a732135aa4d";
      sha256 = "0bnzxd1p6kbv3cym38l0kry1jbxhyz905lkbkhmiswmjg7mmlq1k";
    };
  }
  {
    goPackagePath = "github.com/ghodss/yaml";
    fetch = {
      type = "git";
      url = "https://github.com/ghodss/yaml";
      rev = "v1.0.0";
      sha256 = "0skwmimpy7hlh7pva2slpcplnm912rp3igs98xnqmn859kwa5v8g";
    };
  }
  {
    goPackagePath = "github.com/gliderlabs/ssh";
    fetch = {
      type = "git";
      url = "https://github.com/gliderlabs/ssh";
      rev = "v0.1.1";
      sha256 = "0bylkc7yg8bxxffhchikcnzwli5n95cfmbji6v2a4mn1h5n36mdm";
    };
  }
  {
    goPackagePath = "github.com/go-ini/ini";
    fetch = {
      type = "git";
      url = "https://github.com/go-ini/ini";
      rev = "v1.39.0";
      sha256 = "0j7pyl5v7xfzkhsyz193iq56ilan69pp11g2n5jw1k4h4g8s4k9b";
    };
  }
  {
    goPackagePath = "github.com/go-kit/kit";
    fetch = {
      type = "git";
      url = "https://github.com/go-kit/kit";
      rev = "v0.8.0";
      sha256 = "1rcywbc2pvab06qyf8pc2rdfjv7r6kxdv2v4wnpqnjhz225wqvc0";
    };
  }
  {
    goPackagePath = "github.com/go-ldap/ldap";
    fetch = {
      type = "git";
      url = "https://github.com/go-ldap/ldap";
      rev = "v3.0.1";
      sha256 = "0dn4v340wdrfhah5kp2pyi69a1kwwllrz84whsiiwbial8fac483";
    };
  }
  {
    goPackagePath = "github.com/go-logfmt/logfmt";
    fetch = {
      type = "git";
      url = "https://github.com/go-logfmt/logfmt";
      rev = "v0.3.0";
      sha256 = "1gkgh3k5w1xwb2qbjq52p6azq3h1c1rr6pfwjlwj1zrijpzn2xb9";
    };
  }
  {
    goPackagePath = "github.com/go-ole/go-ole";
    fetch = {
      type = "git";
      url = "https://github.com/go-ole/go-ole";
      rev = "v1.2.1";
      sha256 = "114h8x7dh4jp7w7k678fm98lr9icavsf74v6jfipyq7q35bsfr1p";
    };
  }
  {
    goPackagePath = "github.com/go-openapi/jsonpointer";
    fetch = {
      type = "git";
      url = "https://github.com/go-openapi/jsonpointer";
      rev = "v0.17.0";
      sha256 = "0sv2k1fwj6rsigc9489c19ap0jib1d0widm040h0sjdw2nadh3i2";
    };
  }
  {
    goPackagePath = "github.com/go-openapi/jsonreference";
    fetch = {
      type = "git";
      url = "https://github.com/go-openapi/jsonreference";
      rev = "v0.17.0";
      sha256 = "1d0rk17wn755xsfi9pxifdpgs2p23bc0rkf95kjwxczyy6jbqdaj";
    };
  }
  {
    goPackagePath = "github.com/go-openapi/spec";
    fetch = {
      type = "git";
      url = "https://github.com/go-openapi/spec";
      rev = "v0.17.1";
      sha256 = "14n5x2nxlj2x62v3km96yw7rncxk2b9v94k3j0c22r43c60m38mx";
    };
  }
  {
    goPackagePath = "github.com/go-openapi/swag";
    fetch = {
      type = "git";
      url = "https://github.com/go-openapi/swag";
      rev = "v0.17.0";
      sha256 = "1hhgbx59f7lcsqiza2is8q9walhf8mxfkwj7xql1scrn6ms2jmlv";
    };
  }
  {
    goPackagePath = "github.com/go-sql-driver/mysql";
    fetch = {
      type = "git";
      url = "https://github.com/go-sql-driver/mysql";
      rev = "v1.4.0";
      sha256 = "1jwz2j3vd5hlzmnkh20d4276yd8cxy7pac3x3dfi52jkm82ms99n";
    };
  }
  {
    goPackagePath = "github.com/go-stack/stack";
    fetch = {
      type = "git";
      url = "https://github.com/go-stack/stack";
      rev = "v1.8.0";
      sha256 = "0wk25751ryyvxclyp8jdk5c3ar0cmfr8lrjb66qbg4808x66b96v";
    };
  }
  {
    goPackagePath = "github.com/go-test/deep";
    fetch = {
      type = "git";
      url = "https://github.com/go-test/deep";
      rev = "v1.0.1";
      sha256 = "0f4rbdl6qmlq4bzh0443i634bm675bbrkyzwp8wkc1yhdl9qsij7";
    };
  }
  {
    goPackagePath = "github.com/go-yaml/yaml";
    fetch = {
      type = "git";
      url = "https://github.com/go-yaml/yaml";
      rev = "v2.1.0";
      sha256 = "0k7afgp9gkx6pmilijx1wf1sgl3vfbnlfjj05qhnw3whhy4yyyqs";
    };
  }
  {
    goPackagePath = "github.com/gobuffalo/envy";
    fetch = {
      type = "git";
      url = "https://github.com/gobuffalo/envy";
      rev = "v1.6.5";
      sha256 = "14ak10gap2xmy0vxwl0kplck8dhg6xyqcvra5wfana9w1520a622";
    };
  }
  {
    goPackagePath = "github.com/gobwas/glob";
    fetch = {
      type = "git";
      url = "https://github.com/gobwas/glob";
      rev = "v0.2.3";
      sha256 = "0jxk1x806zn5x86342s72dq2qy64ksb3zrvrlgir2avjhwb18n6z";
    };
  }
  {
    goPackagePath = "github.com/gocql/gocql";
    fetch = {
      type = "git";
      url = "https://github.com/gocql/gocql";
      rev = "8516aabb0f99";
      sha256 = "0b68630xizfzndl368l7inda8q8py69wxh967y9knvx33yfs7bzp";
    };
  }
  {
    goPackagePath = "github.com/gogo/protobuf";
    fetch = {
      type = "git";
      url = "https://github.com/gogo/protobuf";
      rev = "v1.1.1";
      sha256 = "1525pq7r6h3s8dncvq8gxi893p2nq8dxpzvq0nfl5b4p6mq0v1c2";
    };
  }
  {
    goPackagePath = "github.com/golang/glog";
    fetch = {
      type = "git";
      url = "https://github.com/golang/glog";
      rev = "23def4e6c14b";
      sha256 = "0jb2834rw5sykfr937fxi8hxi2zy80sj2bdn9b3jb4b26ksqng30";
    };
  }
  {
    goPackagePath = "github.com/golang/groupcache";
    fetch = {
      type = "git";
      url = "https://github.com/golang/groupcache";
      rev = "6f2cf27854a4";
      sha256 = "01wzacrqyqz10g29s88yjcm6w2wisffbadfppas51pfqmijhc11k";
    };
  }
  {
    goPackagePath = "github.com/golang/lint";
    fetch = {
      type = "git";
      url = "https://github.com/golang/lint";
      rev = "06c8688daad7";
      sha256 = "0xi94dwvz50a66bq1hp9fyqkym5mcpdxdb1hrfvicldgjf37lc47";
    };
  }
  {
    goPackagePath = "github.com/golang/mock";
    fetch = {
      type = "git";
      url = "https://github.com/golang/mock";
      rev = "v1.1.1";
      sha256 = "0ap8wb6pdl6ccmdb43advjll2ly4sz26wsc3axw0hbrjrybybzgy";
    };
  }
  {
    goPackagePath = "github.com/golang/protobuf";
    fetch = {
      type = "git";
      url = "https://github.com/golang/protobuf";
      rev = "v1.2.0";
      sha256 = "0kf4b59rcbb1cchfny2dm9jyznp8ri2hsb14n8iak1q8986xa0ab";
    };
  }
  {
    goPackagePath = "github.com/golang/snappy";
    fetch = {
      type = "git";
      url = "https://github.com/golang/snappy";
      rev = "2e65f85255db";
      sha256 = "05w6mpc4qcy0pv8a2bzng8nf4s5rf5phfang4jwy9rgf808q0nxf";
    };
  }
  {
    goPackagePath = "github.com/google/btree";
    fetch = {
      type = "git";
      url = "https://github.com/google/btree";
      rev = "4030bb1f1f0c";
      sha256 = "0ba430m9fbnagacp57krgidsyrgp3ycw5r7dj71brgp5r52g82p6";
    };
  }
  {
    goPackagePath = "github.com/google/go-cmp";
    fetch = {
      type = "git";
      url = "https://github.com/google/go-cmp";
      rev = "v0.2.0";
      sha256 = "1fbv0x27k9sn8svafc0hjwsnckk864lv4yi7bvzrxvmd3d5hskds";
    };
  }
  {
    goPackagePath = "github.com/google/go-github";
    fetch = {
      type = "git";
      url = "https://github.com/google/go-github";
      rev = "v17.0.0";
      sha256 = "1kvw95l77a5n5rgal9n1xjh58zxb3a40ij1j722b1h4z8yg9jhg4";
    };
  }
  {
    goPackagePath = "github.com/google/go-querystring";
    fetch = {
      type = "git";
      url = "https://github.com/google/go-querystring";
      rev = "53e6ce116135";
      sha256 = "0lkbm067nhmxk66pyjx59d77dbjjzwyi43gdvzyx2f8m1942rq7f";
    };
  }
  {
    goPackagePath = "github.com/google/gofuzz";
    fetch = {
      type = "git";
      url = "https://github.com/google/gofuzz";
      rev = "24818f796faf";
      sha256 = "0cq90m2lgalrdfrwwyycrrmn785rgnxa3l3vp9yxkvnv88bymmlm";
    };
  }
  {
    goPackagePath = "github.com/google/martian";
    fetch = {
      type = "git";
      url = "https://github.com/google/martian";
      rev = "v2.1.0";
      sha256 = "197hil6vrjk50b9wvwyzf61csid83whsjj6ik8mc9r2lryxlyyrp";
    };
  }
  {
    goPackagePath = "github.com/google/subcommands";
    fetch = {
      type = "git";
      url = "https://github.com/google/subcommands";
      rev = "46f0354f6315";
      sha256 = "043j9y17kp73972vblkzmr222143hja3gg6cnry4wsiri9lslc2l";
    };
  }
  {
    goPackagePath = "github.com/google/uuid";
    fetch = {
      type = "git";
      url = "https://github.com/google/uuid";
      rev = "v1.1.0";
      sha256 = "0yx4kiafyshdshrmrqcf2say5mzsviz7r94a0y1l6xfbkkyvnc86";
    };
  }
  {
    goPackagePath = "github.com/google/wire";
    fetch = {
      type = "git";
      url = "https://github.com/google/wire";
      rev = "v0.2.0";
      sha256 = "07arvzwyari18dz1lq4kzysm2dnph93wsbbdzq58hzcmar9snm8g";
    };
  }
  {
    goPackagePath = "github.com/googleapis/gax-go";
    fetch = {
      type = "git";
      url = "https://github.com/googleapis/gax-go";
      rev = "v2.0.0";
      sha256 = "0h92x579vbrv2fka8q2ddy1kq6a63qbqa8zc09ygl6skzn9gw1dh";
    };
  }
  {
    goPackagePath = "github.com/googleapis/gnostic";
    fetch = {
      type = "git";
      url = "https://github.com/googleapis/gnostic";
      rev = "v0.2.0";
      sha256 = "0yh3ckd7m0r9h50wmxxvba837d0wb1k5yd439zq4p1kpp4390z12";
    };
  }
  {
    goPackagePath = "github.com/gophercloud/gophercloud";
    fetch = {
      type = "git";
      url = "https://github.com/gophercloud/gophercloud";
      rev = "bdd8b1ecd793";
      sha256 = "0q9rss8yl11v9l10nb2203crsqzqpfxwnwfckaaszjx37rnd98cg";
    };
  }
  {
    goPackagePath = "github.com/gopherjs/gopherjs";
    fetch = {
      type = "git";
      url = "https://github.com/gopherjs/gopherjs";
      rev = "0766667cb4d1";
      sha256 = "13pfc9sxiwjky2lm1xb3i3lcisn8p6mgjk2d927l7r92ysph8dmw";
    };
  }
  {
    goPackagePath = "github.com/gorilla/context";
    fetch = {
      type = "git";
      url = "https://github.com/gorilla/context";
      rev = "v1.1.1";
      sha256 = "03p4hn87vcmfih0p9w663qbx9lpsf7i7j3lc7yl7n84la3yz63m4";
    };
  }
  {
    goPackagePath = "github.com/gorilla/mux";
    fetch = {
      type = "git";
      url = "https://github.com/gorilla/mux";
      rev = "v1.6.2";
      sha256 = "0pvzm23hklxysspnz52mih6h1q74vfrdhjfm1l3sa9r8hhqmmld2";
    };
  }
  {
    goPackagePath = "github.com/gorilla/securecookie";
    fetch = {
      type = "git";
      url = "https://github.com/gorilla/securecookie";
      rev = "v1.1.1";
      sha256 = "16bqimpxs9vj5n59vm04y04v665l7jh0sddxn787pfafyxcmh410";
    };
  }
  {
    goPackagePath = "github.com/gorilla/sessions";
    fetch = {
      type = "git";
      url = "https://github.com/gorilla/sessions";
      rev = "v1.1.3";
      sha256 = "0a99mlw5gvqbghnc1nx76gaanpxzjqfd74klp3s3sgbss69clayi";
    };
  }
  {
    goPackagePath = "github.com/gorilla/websocket";
    fetch = {
      type = "git";
      url = "https://github.com/gorilla/websocket";
      rev = "v1.4.0";
      sha256 = "00i4vb31nsfkzzk7swvx3i75r2d960js3dri1875vypk3v2s0pzk";
    };
  }
  {
    goPackagePath = "github.com/gotestyourself/gotestyourself";
    fetch = {
      type = "git";
      url = "https://github.com/gotestyourself/gotestyourself";
      rev = "v2.2.0";
      sha256 = "0yif3gdyckmf8i54jq0xn00kflla5rhib9sarw66ngnbl7bn9kyl";
    };
  }
  {
    goPackagePath = "github.com/gregjones/httpcache";
    fetch = {
      type = "git";
      url = "https://github.com/gregjones/httpcache";
      rev = "9cad4c3443a7";
      sha256 = "0wjdwcwqqcx2d5y68qvhg6qyj977il5ijmnn9h9cd6wjbdy0ay6s";
    };
  }
  {
    goPackagePath = "github.com/grpc-ecosystem/go-grpc-middleware";
    fetch = {
      type = "git";
      url = "https://github.com/grpc-ecosystem/go-grpc-middleware";
      rev = "v1.0.0";
      sha256 = "0lwgxih021xfhfb1xb9la5f98bpgpaiz63sbllx77qwwl2rmhrsp";
    };
  }
  {
    goPackagePath = "github.com/grpc-ecosystem/go-grpc-prometheus";
    fetch = {
      type = "git";
      url = "https://github.com/grpc-ecosystem/go-grpc-prometheus";
      rev = "v1.2.0";
      sha256 = "1lzk54h7np32b3acidg1ggbn8ppbnns0m71gcg9d1qkkdh8zrijl";
    };
  }
  {
    goPackagePath = "github.com/grpc-ecosystem/grpc-gateway";
    fetch = {
      type = "git";
      url = "https://github.com/grpc-ecosystem/grpc-gateway";
      rev = "v1.5.1";
      sha256 = "1q3l6ydf37lm6hdm9df8y385bacycj4pin1b06w7dpm6m045l3sp";
    };
  }
  {
    goPackagePath = "github.com/hailocab/go-hostpool";
    fetch = {
      type = "git";
      url = "https://github.com/hailocab/go-hostpool";
      rev = "e80d13ce29ed";
      sha256 = "05ld4wp3illkbgl043yf8jq9y1ld0zzvrcg8jdij129j50xgfxny";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/consul";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/consul";
      rev = "v1.4.2";
      sha256 = "1nprl9kcb98ikcmk7safji3hl4kfacx0gnh05k8m4ysfz6mr7zri";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/errwrap";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/errwrap";
      rev = "v1.0.0";
      sha256 = "0slfb6w3b61xz04r32bi0a1bygc82rjzhqkxj2si2074wynqnr1c";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-cleanhttp";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-cleanhttp";
      rev = "v0.5.0";
      sha256 = "1mwl96a815x1843pnqn7lk38s05bgn5rdjw57xd46jzr62izcnsq";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-hclog";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-hclog";
      rev = "4783caec6f2e";
      sha256 = "1sjhmsysr5vp5y6y9s0l49hjgqb14s0m9p7wwc2m4cga4qps299s";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-immutable-radix";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-immutable-radix";
      rev = "v1.0.0";
      sha256 = "1v3nmsnk1s8bzpclrhirz7iq0g5xxbw9q5gvrg9ss6w9crs72qr6";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-memdb";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-memdb";
      rev = "032f93b25bec";
      sha256 = "1bkbvx93a7li9myy2vs27wh6yyxn67gyvlmb6ywidr4lf50azi5v";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-msgpack";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-msgpack";
      rev = "v0.5.3";
      sha256 = "00jv0ajqd58pkb2yyhlrjp0rv1mvb1ijx3yqjyikcmzvk9jb4h5m";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-multierror";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-multierror";
      rev = "v1.0.0";
      sha256 = "00nyn8llqzbfm8aflr9kwsvpzi4kv8v45c141v88xskxp5xf6z49";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-plugin";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-plugin";
      rev = "362c99b11937";
      sha256 = "0q23ri3s5r2w7z20bpk76vlb79mdwz0xbk7ppdlcbrkbylrpw9ai";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-retryablehttp";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-retryablehttp";
      rev = "e651d75abec6";
      sha256 = "1bw09c1q3hlgmp954w9y0xqzb1m82im28z2yfc85hanm3v71f76y";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-rootcerts";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-rootcerts";
      rev = "6bb64b370b90";
      sha256 = "1a81fcm1i0ji2iva0dcimiichgwpbcb7lx0vyaks87zj5wf04qy9";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-sockaddr";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-sockaddr";
      rev = "v1.0.0";
      sha256 = "1yn1xq8ysn0lszmkygz3a9lgpswbz1p91jv7q8l20s4749a22xgi";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-syslog";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-syslog";
      rev = "v1.0.0";
      sha256 = "09vccqggz212cg0jir6vv708d6mx0f9w5bxrcdah3h6chgmal6v1";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-uuid";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-uuid";
      rev = "v1.0.1";
      sha256 = "0jvb88m0rq41bwgirsadgw7mnayl27av3gd2vqa3xvxp3fy0hp5k";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-version";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go-version";
      rev = "270f2f71b1ee";
      sha256 = "1d43wlp932nqbwkca4bhw8l4x6cg25jyh8l1s3814vddscfpfz2v";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go.net";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/go.net";
      rev = "v0.0.1";
      sha256 = "06arwi95xp5rxyz7rndvhc3wlwg0jn9a5z6djf3yyg5h9zfab9i4";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/golang-lru";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/golang-lru";
      rev = "v0.5.0";
      sha256 = "12k2cp2k615fjvfa5hyb9k2alian77wivds8s65diwshwv41939f";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/hcl";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/hcl";
      rev = "ef8a98b0bbce";
      sha256 = "1qalfsc31fra7hcw2lc3s20aj7al62fq3j5fn5kga3mg99b82nyr";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/logutils";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/logutils";
      rev = "v1.0.0";
      sha256 = "076wf4sh5p3f953ndqk1cc0x7jhmlqrxak9953rz79rcdw77rjvv";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/mdns";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/mdns";
      rev = "v1.0.0";
      sha256 = "0qr4l91hhi97s8a1isnrw3s4q8pjzacqiks870vnwh15v7ig3axd";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/memberlist";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/memberlist";
      rev = "v0.1.3";
      sha256 = "0k1spq7dagvqj3baqw2dhxx1zxrb02y6m3apzr3a7gyirii890g3";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/serf";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/serf";
      rev = "v0.8.2";
      sha256 = "0nrslghvdjhaczr2xp9mn8xgcx1dxl4jgpbk0l61ssmxahpx4iyc";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/vault";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/vault";
      rev = "v0.11.4";
      sha256 = "0snqa3kar40mygcacdv55k60k9blq2zqx9hfcv42v7p0x3zqh0z0";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/vault-plugin-secrets-kv";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/vault-plugin-secrets-kv";
      rev = "edbfe287c5d9";
      sha256 = "0rg7k3azsmk2kiwjvylfryhadxly7x2yj0gb4wkaacvka728kxrz";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/yamux";
    fetch = {
      type = "git";
      url = "https://github.com/hashicorp/yamux";
      rev = "3520598351bb";
      sha256 = "15r8yzj7a7bki9d0k3da5pab6byhyc63kvmi0by92x61mz7svqa5";
    };
  }
  {
    goPackagePath = "github.com/heptio/sonobuoy";
    fetch = {
      type = "git";
      url = "https://github.com/jenkins-x/sonobuoy";
      rev = "dad27c12bf17";
      sha256 = "1xs8h3rx4s9yvv0klxwjb2qw05qh65hllxhz688wrw7ynyrwcmr1";
    };
  }
  {
    goPackagePath = "github.com/hinshun/vt10x";
    fetch = {
      type = "git";
      url = "https://github.com/hinshun/vt10x";
      rev = "d55458df857c";
      sha256 = "0vwsp5iii7pf4na8pkd7cn3bawkwnsimkv1sysy7bslclg5jm370";
    };
  }
  {
    goPackagePath = "github.com/hpcloud/tail";
    fetch = {
      type = "git";
      url = "https://github.com/hpcloud/tail";
      rev = "v1.0.0";
      sha256 = "1njpzc0pi1acg5zx9y6vj9xi6ksbsc5d387rd6904hy6rh2m6kn0";
    };
  }
  {
    goPackagePath = "github.com/huandu/xstrings";
    fetch = {
      type = "git";
      url = "https://github.com/huandu/xstrings";
      rev = "v1.0.0";
      sha256 = "0bnyh4awmr9aagqhhi19xdadzksrkl01d987ycqx86dwlvqqxnxf";
    };
  }
  {
    goPackagePath = "github.com/iancoleman/orderedmap";
    fetch = {
      type = "git";
      url = "https://github.com/iancoleman/orderedmap";
      rev = "22c6ecc9fe13";
      sha256 = "0k8axkkg84ik5v5b4m398c7lbaygb815y1wsj7fn5y2d1mqndd4q";
    };
  }
  {
    goPackagePath = "github.com/imdario/mergo";
    fetch = {
      type = "git";
      url = "https://github.com/imdario/mergo";
      rev = "v0.3.6";
      sha256 = "1lbzy8p8wv439sqgf0n21q52flf2wbamp6qa1jkyv6an0nc952q7";
    };
  }
  {
    goPackagePath = "github.com/inconshreveable/mousetrap";
    fetch = {
      type = "git";
      url = "https://github.com/inconshreveable/mousetrap";
      rev = "v1.0.0";
      sha256 = "1mn0kg48xkd74brf48qf5hzp0bc6g8cf5a77w895rl3qnlpfw152";
    };
  }
  {
    goPackagePath = "github.com/influxdata/influxdb";
    fetch = {
      type = "git";
      url = "https://github.com/influxdata/influxdb";
      rev = "049f9b42e9a5";
      sha256 = "1m9p7zwwwk3fb9z3xxzv86avpnknvc1nya8l6q8maylyb89rk6ir";
    };
  }
  {
    goPackagePath = "github.com/jbenet/go-context";
    fetch = {
      type = "git";
      url = "https://github.com/jbenet/go-context";
      rev = "d14ea06fba99";
      sha256 = "0q91f5549n81w3z5927n4a1mdh220bdmgl42zi3h992dcc4ls0sl";
    };
  }
  {
    goPackagePath = "github.com/jbrukh/bayesian";
    fetch = {
      type = "git";
      url = "https://github.com/jbrukh/bayesian";
      rev = "bf3f261f9a9c";
      sha256 = "12xylsachg2br784909nf0n2c4bk1k7qwabfy4nccbvadyqscg82";
    };
  }
  {
    goPackagePath = "github.com/jefferai/jsonx";
    fetch = {
      type = "git";
      url = "https://github.com/jefferai/jsonx";
      rev = "v1.0.0";
      sha256 = "15j4lch1k2bdrkcc2wnqbdcsf8avair0b7fn9ymhjqkz1zcqvpby";
    };
  }
  {
    goPackagePath = "github.com/jenkins-x/draft-repo";
    fetch = {
      type = "git";
      url = "https://github.com/jenkins-x/draft-repo";
      rev = "2f66cc518135";
      sha256 = "1rwyyzakij8c13wvphksdf903dq9kw1k32lwsjwg3pxcr3rw9nr6";
    };
  }
  {
    goPackagePath = "github.com/jenkins-x/golang-jenkins";
    fetch = {
      type = "git";
      url = "https://github.com/jenkins-x/golang-jenkins";
      rev = "65b83ad42314";
      sha256 = "1mvvwklcp0cwg4vrsycamly7k9zck185bma3j9rr7pga12cwdsid";
    };
  }
  {
    goPackagePath = "github.com/jetstack/cert-manager";
    fetch = {
      type = "git";
      url = "https://github.com/jetstack/cert-manager";
      rev = "v0.5.2";
      sha256 = "0xic07v4fzvhn14sri6dlwklilq1966pc0l6vv664p4msgqldc9a";
    };
  }
  {
    goPackagePath = "github.com/jinzhu/gorm";
    fetch = {
      type = "git";
      url = "https://github.com/jinzhu/gorm";
      rev = "572d0a0ab1eb";
      sha256 = "1fzxbq89gdi57ql1pd9hf5q6jqzinz54v84lwp1bkv0mpipxqydr";
    };
  }
  {
    goPackagePath = "github.com/jinzhu/inflection";
    fetch = {
      type = "git";
      url = "https://github.com/jinzhu/inflection";
      rev = "3272df6c21d0";
      sha256 = "129xn1lm768ikbvwy5cap20d3p38hw4d631za34zapfxyy2p96c0";
    };
  }
  {
    goPackagePath = "github.com/jinzhu/now";
    fetch = {
      type = "git";
      url = "https://github.com/jinzhu/now";
      rev = "8ec929ed50c3";
      sha256 = "0ydl9cx17zkx21b5cqhrl8x4j7yhmyl3ki4kn1c0ql38jw4pww7y";
    };
  }
  {
    goPackagePath = "github.com/jmespath/go-jmespath";
    fetch = {
      type = "git";
      url = "https://github.com/jmespath/go-jmespath";
      rev = "c2b33e8439af";
      sha256 = "1r6w7ydx8ydryxk3sfhzsk8m6f1nsik9jg3i1zhi69v4kfl4d5cz";
    };
  }
  {
    goPackagePath = "github.com/joho/godotenv";
    fetch = {
      type = "git";
      url = "https://github.com/joho/godotenv";
      rev = "v1.3.0";
      sha256 = "0ri8if0pc3x6jg4c3i8wr58xyfpxkwmcjk3rp8gb398a1aa3gpjm";
    };
  }
  {
    goPackagePath = "github.com/jonboulle/clockwork";
    fetch = {
      type = "git";
      url = "https://github.com/jonboulle/clockwork";
      rev = "v0.1.0";
      sha256 = "1pqxhsdavbp1n5grgyx2j6ylvql2fzn2cvpsgkc8li69dil7sibl";
    };
  }
  {
    goPackagePath = "github.com/json-iterator/go";
    fetch = {
      type = "git";
      url = "https://github.com/json-iterator/go";
      rev = "v1.1.5";
      sha256 = "11wn4hpmrs8bmpvd93wqk49jfbbgylakhi35f9k5qd7jd479ci4s";
    };
  }
  {
    goPackagePath = "github.com/jtolds/gls";
    fetch = {
      type = "git";
      url = "https://github.com/jtolds/gls";
      rev = "v4.2.1";
      sha256 = "1vm37pvn0k4r6d3m620swwgama63laz8hhj3pyisdhxwam4m2g1h";
    };
  }
  {
    goPackagePath = "github.com/julienschmidt/httprouter";
    fetch = {
      type = "git";
      url = "https://github.com/julienschmidt/httprouter";
      rev = "v1.2.0";
      sha256 = "1k8bylc9s4vpvf5xhqh9h246dl1snxrzzz0614zz88cdh8yzs666";
    };
  }
  {
    goPackagePath = "github.com/kballard/go-shellquote";
    fetch = {
      type = "git";
      url = "https://github.com/kballard/go-shellquote";
      rev = "95032a82bc51";
      sha256 = "1rspvmnsikdq95jmx3dykxd4k1rmgl98ryjrysvl0cf18hl1vq80";
    };
  }
  {
    goPackagePath = "github.com/kevinburke/ssh_config";
    fetch = {
      type = "git";
      url = "https://github.com/kevinburke/ssh_config";
      rev = "9fc7bb800b55";
      sha256 = "102icrla92zmr5zngipc8c9yfbqhf73zs2w2jq6s7p0gdjifigc8";
    };
  }
  {
    goPackagePath = "github.com/keybase/go-crypto";
    fetch = {
      type = "git";
      url = "https://github.com/keybase/go-crypto";
      rev = "255a5089e85a";
      sha256 = "0c2n05lpkpq7ii8c2x3p228x3sm6msn33532zyfk2k9dk7zigzy9";
    };
  }
  {
    goPackagePath = "github.com/kisielk/gotool";
    fetch = {
      type = "git";
      url = "https://github.com/kisielk/gotool";
      rev = "v1.0.0";
      sha256 = "14af2pa0ssyp8bp2mvdw184s5wcysk6akil3wzxmr05wwy951iwn";
    };
  }
  {
    goPackagePath = "github.com/knative/build";
    fetch = {
      type = "git";
      url = "https://github.com/knative/build";
      rev = "v0.3.0";
      sha256 = "1zn9ngl3wr8mgg31m8dw1w5jfjdiq0gkrdv0936vabazxjgsyb5q";
    };
  }
  {
    goPackagePath = "github.com/knative/build-pipeline";
    fetch = {
      type = "git";
      url = "https://github.com/knative/build-pipeline";
      rev = "7c289d8aedf7";
      sha256 = "132flxjg6aj12xmz5px6dyljj630q0icdmxr9dz7l6j01ll4yagk";
    };
  }
  {
    goPackagePath = "github.com/knative/pkg";
    fetch = {
      type = "git";
      url = "https://github.com/knative/pkg";
      rev = "994b801b03ef";
      sha256 = "15xpdk9zmsljdd3rwcxmk1nml9nync9yj71pqih69bgxfqpbyrx1";
    };
  }
  {
    goPackagePath = "github.com/knq/snaker";
    fetch = {
      type = "git";
      url = "https://github.com/knq/snaker";
      rev = "d9ad1e7f342a";
      sha256 = "1020q2faxm12lshmyd6qh1dnhls145nyrmisw4gy3zlk3ccy5jif";
    };
  }
  {
    goPackagePath = "github.com/knq/sysutil";
    fetch = {
      type = "git";
      url = "https://github.com/knq/sysutil";
      rev = "0218e141a794";
      sha256 = "11nsjv7bm370gbiwv7l4kp573gv5zj1xajxjf4x57wynzxhij5lq";
    };
  }
  {
    goPackagePath = "github.com/konsorten/go-windows-terminal-sequences";
    fetch = {
      type = "git";
      url = "https://github.com/konsorten/go-windows-terminal-sequences";
      rev = "v1.0.1";
      sha256 = "1lchgf27n276vma6iyxa0v1xds68n2g8lih5lavqnx5x6q5pw2ip";
    };
  }
  {
    goPackagePath = "github.com/kr/logfmt";
    fetch = {
      type = "git";
      url = "https://github.com/kr/logfmt";
      rev = "b84e30acd515";
      sha256 = "02ldzxgznrfdzvghfraslhgp19la1fczcbzh7wm2zdc6lmpd1qq9";
    };
  }
  {
    goPackagePath = "github.com/kr/pretty";
    fetch = {
      type = "git";
      url = "https://github.com/kr/pretty";
      rev = "v0.1.0";
      sha256 = "18m4pwg2abd0j9cn5v3k2ksk9ig4vlwxmlw9rrglanziv9l967qp";
    };
  }
  {
    goPackagePath = "github.com/kr/pty";
    fetch = {
      type = "git";
      url = "https://github.com/kr/pty";
      rev = "v1.1.2";
      sha256 = "1jhi5g23xsrqkfjg9a7l7rqzgx2mlf2w11892nng9p9f7xp55k6h";
    };
  }
  {
    goPackagePath = "github.com/kr/text";
    fetch = {
      type = "git";
      url = "https://github.com/kr/text";
      rev = "v0.1.0";
      sha256 = "1gm5bsl01apvc84bw06hasawyqm4q84vx1pm32wr9jnd7a8vjgj1";
    };
  }
  {
    goPackagePath = "github.com/lib/pq";
    fetch = {
      type = "git";
      url = "https://github.com/lib/pq";
      rev = "v1.0.0";
      sha256 = "1zqnnyczaf00xi6xh53vq758v5bdlf0iz7kf22l02cal4i6px47i";
    };
  }
  {
    goPackagePath = "github.com/lusis/go-slackbot";
    fetch = {
      type = "git";
      url = "https://github.com/lusis/go-slackbot";
      rev = "401027ccfef5";
      sha256 = "125rraz8nwid7vw7x8xj4cz7i74xycx3jddvzn0r3sqajnq94s0l";
    };
  }
  {
    goPackagePath = "github.com/lusis/slack-test";
    fetch = {
      type = "git";
      url = "https://github.com/lusis/slack-test";
      rev = "3c758769bfa6";
      sha256 = "110gs02k9bqrch248jycb7a3yzx2i3yh02k9s16fhdw612ag2sak";
    };
  }
  {
    goPackagePath = "github.com/magiconair/properties";
    fetch = {
      type = "git";
      url = "https://github.com/magiconair/properties";
      rev = "v1.8.0";
      sha256 = "1a10362wv8a8qwb818wygn2z48lgzch940hvpv81hv8gc747ajxn";
    };
  }
  {
    goPackagePath = "github.com/mailru/easyjson";
    fetch = {
      type = "git";
      url = "https://github.com/mailru/easyjson";
      rev = "60711f1a8329";
      sha256 = "0234jp6134wkihdpdwq1hvzqblgl5khc1wp6dyi2h0hgh88bhdk1";
    };
  }
  {
    goPackagePath = "github.com/markbates/inflect";
    fetch = {
      type = "git";
      url = "https://github.com/markbates/inflect";
      rev = "v1.0.4";
      sha256 = "0pd50b8q6bib84yab14csd6nc08hfdapzbh1nnw6qrmc1zxi7r7m";
    };
  }
  {
    goPackagePath = "github.com/mattbaird/jsonpatch";
    fetch = {
      type = "git";
      url = "https://github.com/mattbaird/jsonpatch";
      rev = "81af80346b1a";
      sha256 = "0ll22kpf75m72r7i5ddg3r87gdlagbj2x24bppgbi8jp018pdq95";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-colorable";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-colorable";
      rev = "v0.0.9";
      sha256 = "1nwjmsppsjicr7anq8na6md7b1z84l9ppnlr045hhxjvbkqwalvx";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-isatty";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-isatty";
      rev = "v0.0.4";
      sha256 = "0zs92j2cqaw9j8qx1sdxpv3ap0rgbs0vrvi72m40mg8aa36gd39w";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-runewidth";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-runewidth";
      rev = "v0.0.2";
      sha256 = "0vkrfrz3fzn5n6ix4k8s0cg0b448459sldq8bp4riavsxm932jzb";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-sqlite3";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-sqlite3";
      rev = "38ee283dabf1";
      sha256 = "18xyi0n1dhspvy6z982k7v545w7k0idpmvlqmrn6nkd6dkw7pfdw";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-zglob";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-zglob";
      rev = "49693fbb3fe3";
      sha256 = "1j7li9jbqfakm3glj1hf0bl062y25jmaqw3d6v973c1vcgmdxvgw";
    };
  }
  {
    goPackagePath = "github.com/matttproud/golang_protobuf_extensions";
    fetch = {
      type = "git";
      url = "https://github.com/matttproud/golang_protobuf_extensions";
      rev = "v1.0.1";
      sha256 = "1d0c1isd2lk9pnfq2nk0aih356j30k3h1gi2w0ixsivi5csl7jya";
    };
  }
  {
    goPackagePath = "github.com/mgutz/ansi";
    fetch = {
      type = "git";
      url = "https://github.com/mgutz/ansi";
      rev = "9520e82c474b";
      sha256 = "00bz22314j26736w1f0q4jy9d9dfaml17vn890n5zqy3cmvmww1j";
    };
  }
  {
    goPackagePath = "github.com/mholt/archiver";
    fetch = {
      type = "git";
      url = "https://github.com/mholt/archiver";
      rev = "v3.1.1";
      sha256 = "1v18xzzwi836rdxnr5dssllc083rdiry9baqaqnz6x3f1xvfnqp9";
    };
  }
  {
    goPackagePath = "github.com/miekg/dns";
    fetch = {
      type = "git";
      url = "https://github.com/miekg/dns";
      rev = "v1.0.14";
      sha256 = "1qgli6yp59bv6vc6zag84cwxmcxgnyxm1q2f301yyijk3wy5b2ak";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/cli";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/cli";
      rev = "v1.0.0";
      sha256 = "1i9kmr7rcf10d2hji8h4247hmc0nbairv7a0q51393aw2h1bnwg2";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/copystructure";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/copystructure";
      rev = "v1.0.0";
      sha256 = "05njg92w1088v4yl0js0zdrpfq6k37i9j14mxkr3p90p5yd9rrrr";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/go-homedir";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/go-homedir";
      rev = "3864e76763d9";
      sha256 = "1n8vya16l60i5jms43yb8fzdgwvqa2q926p5wkg3lbrk8pxy1nv0";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/go-testing-interface";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/go-testing-interface";
      rev = "v1.0.0";
      sha256 = "1dl2js8di858bawg7dadlf1qjpkl2g3apziihjyf5imri3znyfpw";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/gox";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/gox";
      rev = "v0.4.0";
      sha256 = "1q4fdkw904mrmh1q5z8pfd3r0gcn5dm776kldqawddy93iiwnp8r";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/iochan";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/iochan";
      rev = "v1.0.0";
      sha256 = "058n9bbf536f2nw3pbs7pysrg9cqvgkb28z2zf5wjyrzrknyk53g";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/ioprogress";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/ioprogress";
      rev = "6a23b12fa88e";
      sha256 = "1fcfwi5fzv17iahif42y7dhjfnjwkslk03zb9cniw42wyiwhj3jk";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/mapstructure";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/mapstructure";
      rev = "f15292f7a699";
      sha256 = "0zm3nhdvmj3f8q0vg2sjfw1sm3pwsw0ggz501awz95w99664a8al";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/reflectwalk";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/reflectwalk";
      rev = "v1.0.0";
      sha256 = "0wzkp0fdx22n8f7y9y37dgmnlrlfsv9zjdb48cbx7rsqsbnny7l0";
    };
  }
  {
    goPackagePath = "github.com/modern-go/concurrent";
    fetch = {
      type = "git";
      url = "https://github.com/modern-go/concurrent";
      rev = "bacd9c7ef1dd";
      sha256 = "0s0fxccsyb8icjmiym5k7prcqx36hvgdwl588y0491gi18k5i4zs";
    };
  }
  {
    goPackagePath = "github.com/modern-go/reflect2";
    fetch = {
      type = "git";
      url = "https://github.com/modern-go/reflect2";
      rev = "v1.0.1";
      sha256 = "06a3sablw53n1dqqbr2f53jyksbxdmmk8axaas4yvnhyfi55k4lf";
    };
  }
  {
    goPackagePath = "github.com/mwitkow/go-conntrack";
    fetch = {
      type = "git";
      url = "https://github.com/mwitkow/go-conntrack";
      rev = "cc309e4a2223";
      sha256 = "0nbrnpk7bkmqg9mzwsxlm0y8m7s9qd9phr1q30qlx2qmdmz7c1mf";
    };
  }
  {
    goPackagePath = "github.com/nbio/st";
    fetch = {
      type = "git";
      url = "https://github.com/nbio/st";
      rev = "e9e8d9816f32";
      sha256 = "14r4acm82gp9ikqnp41a06bm4mrdlbskakhibbxsc5ljav7bni27";
    };
  }
  {
    goPackagePath = "github.com/nlopes/slack";
    fetch = {
      type = "git";
      url = "https://github.com/nlopes/slack";
      rev = "347a74b1ea30";
      sha256 = "0wkj2kvvg2jl01bajkjavcpn1c98yhxd96cadpm522ag3gqdlw81";
    };
  }
  {
    goPackagePath = "github.com/nwaples/rardecode";
    fetch = {
      type = "git";
      url = "https://github.com/nwaples/rardecode";
      rev = "v1.0.0";
      sha256 = "1dsq1wcddl7r1y0d94px368biiy1dgzl3nab47f0rb0fp1b24l1x";
    };
  }
  {
    goPackagePath = "github.com/oklog/run";
    fetch = {
      type = "git";
      url = "https://github.com/oklog/run";
      rev = "v1.0.0";
      sha256 = "1pbjza4claaj95fpqvvfrysvs10y7dm0pl6qr5lzh6qy1vnhmcgw";
    };
  }
  {
    goPackagePath = "github.com/olekukonko/tablewriter";
    fetch = {
      type = "git";
      url = "https://github.com/olekukonko/tablewriter";
      rev = "a0225b3f23b5";
      sha256 = "0bp9r6xzy6d3p7l2hjmvr25y3rp3p8c9xv1agkllkksm45ng6681";
    };
  }
  {
    goPackagePath = "github.com/onsi/ginkgo";
    fetch = {
      type = "git";
      url = "https://github.com/onsi/ginkgo";
      rev = "v1.6.0";
      sha256 = "0x0gc89vgq38xhgmi2h22bhr73cf2gmk42g89nz89k8dgg9hhr25";
    };
  }
  {
    goPackagePath = "github.com/onsi/gomega";
    fetch = {
      type = "git";
      url = "https://github.com/onsi/gomega";
      rev = "v1.4.2";
      sha256 = "0f1lpgdcfan3bj545xjrlkdkmi7g0l8gn82gsxay1x6rsqv6nl0b";
    };
  }
  {
    goPackagePath = "github.com/opencontainers/go-digest";
    fetch = {
      type = "git";
      url = "https://github.com/opencontainers/go-digest";
      rev = "v1.0.0-rc1";
      sha256 = "01gc7fpn8ax429024p2fcx3yb18axwz5bjf2hqxlii1jbsgw4bh9";
    };
  }
  {
    goPackagePath = "github.com/opencontainers/image-spec";
    fetch = {
      type = "git";
      url = "https://github.com/opencontainers/image-spec";
      rev = "v1.0.1";
      sha256 = "03dvbj3dln8c55v9gp79mgmz2yi2ws3r08iyz2fk41y3i22iaw1q";
    };
  }
  {
    goPackagePath = "github.com/opencontainers/runc";
    fetch = {
      type = "git";
      url = "https://github.com/opencontainers/runc";
      rev = "v0.1.1";
      sha256 = "09fm7f1k4lvx8v3crqb0cli1x2brlz8ka7f7qa8d2sb6ln58h7w7";
    };
  }
  {
    goPackagePath = "github.com/openzipkin/zipkin-go";
    fetch = {
      type = "git";
      url = "https://github.com/openzipkin/zipkin-go";
      rev = "v0.1.1";
      sha256 = "0kd5yc4117dlqc80v0f29kb2l8nrx2da9c03ljns5n8hynnjgb27";
    };
  }
  {
    goPackagePath = "github.com/operator-framework/operator-sdk";
    fetch = {
      type = "git";
      url = "https://github.com/operator-framework/operator-sdk";
      rev = "913cbf711929";
      sha256 = "1fq6g8q11qx842zsj8k16ng6p2xpmp52v91m24vz35rh9pl4kdg0";
    };
  }
  {
    goPackagePath = "github.com/ory/dockertest";
    fetch = {
      type = "git";
      url = "https://github.com/ory/dockertest";
      rev = "v3.3.4";
      sha256 = "0gwdbxszjzv3cr42kmwjvqab1y8y8g9j0p3yl1n0rzmsfxcz1mmb";
    };
  }
  {
    goPackagePath = "github.com/pascaldekloe/goe";
    fetch = {
      type = "git";
      url = "https://github.com/pascaldekloe/goe";
      rev = "57f6aae5913c";
      sha256 = "1dqd3mfb4z2vmv6pg6fhgvfc53vhndk24wcl9lj1rz02n6m279fq";
    };
  }
  {
    goPackagePath = "github.com/patrickmn/go-cache";
    fetch = {
      type = "git";
      url = "https://github.com/patrickmn/go-cache";
      rev = "v2.1.0";
      sha256 = "10020inkzrm931r4bixf8wqr9n39wcrb78vfyxmbvjavvw4zybgs";
    };
  }
  {
    goPackagePath = "github.com/pborman/uuid";
    fetch = {
      type = "git";
      url = "https://github.com/pborman/uuid";
      rev = "e790cca94e6c";
      sha256 = "0y1crv4wkly2naki2f68ln9sc8l9skswkc696vr8vc43p4p67wam";
    };
  }
  {
    goPackagePath = "github.com/pelletier/go-buffruneio";
    fetch = {
      type = "git";
      url = "https://github.com/pelletier/go-buffruneio";
      rev = "v0.2.0";
      sha256 = "0l83p1gg6g5mmhmxjisrhfimhbm71lwn1r2w7d6siwwqm9q08sd2";
    };
  }
  {
    goPackagePath = "github.com/pelletier/go-toml";
    fetch = {
      type = "git";
      url = "https://github.com/pelletier/go-toml";
      rev = "v1.2.0";
      sha256 = "1fjzpcjng60mc3a4b2ql5a00d5gah84wj740dabv9kq67mpg8fxy";
    };
  }
  {
    goPackagePath = "github.com/petar/GoLLRB";
    fetch = {
      type = "git";
      url = "https://github.com/petar/GoLLRB";
      rev = "53be0d36a84c";
      sha256 = "01xp3lcamqkvl91jg6ly202gdsgf64j39rkrcqxi6v4pbrcv7hz0";
    };
  }
  {
    goPackagePath = "github.com/peterbourgon/diskv";
    fetch = {
      type = "git";
      url = "https://github.com/peterbourgon/diskv";
      rev = "v2.0.1";
      sha256 = "1mxpa5aad08x30qcbffzk80g9540wvbca4blc1r2qyzl65b8929b";
    };
  }
  {
    goPackagePath = "github.com/petergtz/pegomock";
    fetch = {
      type = "git";
      url = "https://github.com/petergtz/pegomock";
      rev = "b113d17a7e81";
      sha256 = "1si2dxz6wvx7px8g1455gz1vvlfwsm014wdbvyr69c3m2ad86wm0";
    };
  }
  {
    goPackagePath = "github.com/pierrec/lz4";
    fetch = {
      type = "git";
      url = "https://github.com/pierrec/lz4";
      rev = "v2.0.5";
      sha256 = "0y5rh7z01zycd59nnjpkqq0ydyjmcg9j1xw15q1i600l9j9g617p";
    };
  }
  {
    goPackagePath = "github.com/pkg/browser";
    fetch = {
      type = "git";
      url = "https://github.com/pkg/browser";
      rev = "c90ca0c84f15";
      sha256 = "05xpqsns08blmwdh8aw5kpq2d9x4fl91535j6np1ylw1q2b67b8i";
    };
  }
  {
    goPackagePath = "github.com/pkg/errors";
    fetch = {
      type = "git";
      url = "https://github.com/pkg/errors";
      rev = "v0.8.0";
      sha256 = "001i6n71ghp2l6kdl3qq1v2vmghcz3kicv9a5wgcihrzigm75pp5";
    };
  }
  {
    goPackagePath = "github.com/pmezard/go-difflib";
    fetch = {
      type = "git";
      url = "https://github.com/pmezard/go-difflib";
      rev = "v1.0.0";
      sha256 = "0c1cn55m4rypmscgf0rrb88pn58j3ysvc2d0432dp3c6fqg6cnzw";
    };
  }
  {
    goPackagePath = "github.com/posener/complete";
    fetch = {
      type = "git";
      url = "https://github.com/posener/complete";
      rev = "v1.1.1";
      sha256 = "1nbdiybjizbaxbf5q0xwbq0cjqw4bl6jggvsjzrpif0w86fcjda2";
    };
  }
  {
    goPackagePath = "github.com/prometheus/client_golang";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/client_golang";
      rev = "v0.9.1";
      sha256 = "01gnylazia30pcp069xcng482gwmm3xcx5zgrlwdkhic1lyb6i9l";
    };
  }
  {
    goPackagePath = "github.com/prometheus/client_model";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/client_model";
      rev = "5c3871d89910";
      sha256 = "04psf81l9fjcwascsys428v03fx4fi894h7fhrj2vvcz723q57k0";
    };
  }
  {
    goPackagePath = "github.com/prometheus/common";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/common";
      rev = "v0.2.0";
      sha256 = "02kym6lcfnlq23qbv277jr0q1n7jj0r14gqg93c7wn7gc44jv3vp";
    };
  }
  {
    goPackagePath = "github.com/prometheus/procfs";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/procfs";
      rev = "185b4288413d";
      sha256 = "0d85429kdw5dgj5zhyiz1sq3i5691vj2gjnda93nnxxzx9acg8cv";
    };
  }
  {
    goPackagePath = "github.com/qor/inflection";
    fetch = {
      type = "git";
      url = "https://github.com/qor/inflection";
      rev = "04140366298a";
      sha256 = "1s4qcnwaajp3c5ykwx4dfy32hykwsm0ki7kx8lcw8b0z0grkz6qh";
    };
  }
  {
    goPackagePath = "github.com/rifflock/lfshook";
    fetch = {
      type = "git";
      url = "https://github.com/rifflock/lfshook";
      rev = "bf539943797a";
      sha256 = "0hns4zidw8g3s5l9dyl894fnyjr0a5xgdvx26rnal9jrn4n6z835";
    };
  }
  {
    goPackagePath = "github.com/rodaine/hclencoder";
    fetch = {
      type = "git";
      url = "https://github.com/rodaine/hclencoder";
      rev = "0680c4321930";
      sha256 = "0xyzmbhg0qnaybbd4sxly8932kswx2gplcw788gh811ylhjj2liy";
    };
  }
  {
    goPackagePath = "github.com/russross/blackfriday";
    fetch = {
      type = "git";
      url = "https://github.com/russross/blackfriday";
      rev = "v1.5.1";
      sha256 = "0qmavm5d14kj6im6sqzpqnlhpy524428vkn4hnfwknndr9rycmn0";
    };
  }
  {
    goPackagePath = "github.com/ryanuber/columnize";
    fetch = {
      type = "git";
      url = "https://github.com/ryanuber/columnize";
      rev = "9b3edd62028f";
      sha256 = "1ya1idkbb0a9fjlhkcnh5a9yvpwzwfmbyg7d56lpplwr9rqi1da4";
    };
  }
  {
    goPackagePath = "github.com/ryanuber/go-glob";
    fetch = {
      type = "git";
      url = "https://github.com/ryanuber/go-glob";
      rev = "256dc444b735";
      sha256 = "07rsd7hranghwc68ib0r2zxd9d5djanzjvd84j9dgj3wqsyg5mi2";
    };
  }
  {
    goPackagePath = "github.com/satori/go.uuid";
    fetch = {
      type = "git";
      url = "https://github.com/satori/go.uuid";
      rev = "v1.2.0";
      sha256 = "1j4s5pfg2ldm35y8ls8jah4dya2grfnx2drb4jcbjsyrp4cm5yfb";
    };
  }
  {
    goPackagePath = "github.com/sean-/seed";
    fetch = {
      type = "git";
      url = "https://github.com/sean-/seed";
      rev = "e2103e2c3529";
      sha256 = "0glir8jxi1w7aga2jwdb63pp1h8q4whknili7xixsqzwyy716125";
    };
  }
  {
    goPackagePath = "github.com/sergi/go-diff";
    fetch = {
      type = "git";
      url = "https://github.com/sergi/go-diff";
      rev = "v1.0.0";
      sha256 = "0swiazj8wphs2zmk1qgq75xza6m19snif94h2m6fi8dqkwqdl7c7";
    };
  }
  {
    goPackagePath = "github.com/sethgrid/pester";
    fetch = {
      type = "git";
      url = "https://github.com/sethgrid/pester";
      rev = "03e26c9abbbf";
      sha256 = "0xhzs8xjaxr00n0sc0hjhlp78l01jwqqv9r6yfcxqy86cfyrdfgw";
    };
  }
  {
    goPackagePath = "github.com/sethvargo/go-password";
    fetch = {
      type = "git";
      url = "https://github.com/sethvargo/go-password";
      rev = "v0.1.2";
      sha256 = "0z6jz4b7cfdwiqrzhcyvraq2s1rw4fpw4fbna9r7xi1vvj26gyrf";
    };
  }
  {
    goPackagePath = "github.com/shirou/gopsutil";
    fetch = {
      type = "git";
      url = "https://github.com/shirou/gopsutil";
      rev = "eb1f1ab16f2e";
      sha256 = "0qn5nn4kcqcw5wkcg82s9jbjh6wvrfq88zinm35xlpwhpdklznjw";
    };
  }
  {
    goPackagePath = "github.com/shirou/w32";
    fetch = {
      type = "git";
      url = "https://github.com/shirou/w32";
      rev = "bb4de0191aa4";
      sha256 = "0xh5vqblhr2c3mlaswawx6nipi4rc2x73rbdvlkakmgi0nnl50m4";
    };
  }
  {
    goPackagePath = "github.com/shurcooL/githubv4";
    fetch = {
      type = "git";
      url = "https://github.com/shurcooL/githubv4";
      rev = "51d7b505e2e9";
      sha256 = "0zy2aci0gr9x08fl8bicknc2v9nqnxhqr3y05dzvmr0b5av9q24f";
    };
  }
  {
    goPackagePath = "github.com/shurcooL/go";
    fetch = {
      type = "git";
      url = "https://github.com/shurcooL/go";
      rev = "9e1955d9fb6e";
      sha256 = "1lad9bvs75jsn61cfza19739c2c057k0bqxg2b4xz3z3l4w1mkqj";
    };
  }
  {
    goPackagePath = "github.com/shurcooL/graphql";
    fetch = {
      type = "git";
      url = "https://github.com/shurcooL/graphql";
      rev = "e4a3a37e6d42";
      sha256 = "0d4a6njigzis6hgac5dpxaw6nzrm4cqmfyj53icr3isa38c2isrf";
    };
  }
  {
    goPackagePath = "github.com/sirupsen/logrus";
    fetch = {
      type = "git";
      url = "https://github.com/sirupsen/logrus";
      rev = "v1.2.0";
      sha256 = "0r6334x2bls8ddznvzaldx4g88msjjns4mlks95rqrrg7h0ijigg";
    };
  }
  {
    goPackagePath = "github.com/smartystreets/assertions";
    fetch = {
      type = "git";
      url = "https://github.com/smartystreets/assertions";
      rev = "b2de0cb4f26d";
      sha256 = "1i7ldgavgl35c7gk25p7bvdr282ckng090zr4ch9mk1705akx09y";
    };
  }
  {
    goPackagePath = "github.com/smartystreets/goconvey";
    fetch = {
      type = "git";
      url = "https://github.com/smartystreets/goconvey";
      rev = "ef6db91d284a";
      sha256 = "16znlpsms8z2qc3airawyhzvrzcp70p9bx375i19bg489hgchxb7";
    };
  }
  {
    goPackagePath = "github.com/soheilhy/cmux";
    fetch = {
      type = "git";
      url = "https://github.com/soheilhy/cmux";
      rev = "v0.1.4";
      sha256 = "1f736g68d9vwlyfb6g0fxkr0r875369xafk30cz8kaq5niaqwv0h";
    };
  }
  {
    goPackagePath = "github.com/spf13/afero";
    fetch = {
      type = "git";
      url = "https://github.com/spf13/afero";
      rev = "v1.1.1";
      sha256 = "0138rjiacl71h7kvhzinviwvy6qa2m6rflpv9lgqv15hnjvhwvg1";
    };
  }
  {
    goPackagePath = "github.com/spf13/cast";
    fetch = {
      type = "git";
      url = "https://github.com/spf13/cast";
      rev = "v1.2.0";
      sha256 = "177bk7lq40jbgv9p9r80aydpaccfk8ja3a7jjhfwiwk9r1pa4rr2";
    };
  }
  {
    goPackagePath = "github.com/spf13/cobra";
    fetch = {
      type = "git";
      url = "https://github.com/spf13/cobra";
      rev = "v0.0.3";
      sha256 = "1q1nsx05svyv9fv3fy6xv6gs9ffimkyzsfm49flvl3wnvf1ncrkd";
    };
  }
  {
    goPackagePath = "github.com/spf13/jwalterweatherman";
    fetch = {
      type = "git";
      url = "https://github.com/spf13/jwalterweatherman";
      rev = "7c0cea34c8ec";
      sha256 = "132p84i20b9s5r6fs597lsa6648vd415ch7c0d018vm8smzqpd0h";
    };
  }
  {
    goPackagePath = "github.com/spf13/pflag";
    fetch = {
      type = "git";
      url = "https://github.com/spf13/pflag";
      rev = "v1.0.3";
      sha256 = "1cj3cjm7d3zk0mf1xdybh0jywkbbw7a6yr3y22x9sis31scprswd";
    };
  }
  {
    goPackagePath = "github.com/spf13/viper";
    fetch = {
      type = "git";
      url = "https://github.com/spf13/viper";
      rev = "v1.0.2";
      sha256 = "0y3r6ysi5vn0yq5c7pbl62yg2i64fkv54xgj2jf1hn3v6zzyimis";
    };
  }
  {
    goPackagePath = "github.com/src-d/gcfg";
    fetch = {
      type = "git";
      url = "https://github.com/src-d/gcfg";
      rev = "v1.3.0";
      sha256 = "1hrdxlha4kkcpyydmjqd929rmwn5a9xq7arvwhryxppxq7502axk";
    };
  }
  {
    goPackagePath = "github.com/stoewer/go-strcase";
    fetch = {
      type = "git";
      url = "https://github.com/stoewer/go-strcase";
      rev = "v1.0.1";
      sha256 = "0axc5sq5n9gkhy7npn9w12ycxddngmbphdywhfrsskm44kvd8rpx";
    };
  }
  {
    goPackagePath = "github.com/streadway/amqp";
    fetch = {
      type = "git";
      url = "https://github.com/streadway/amqp";
      rev = "27835f1a64e9";
      sha256 = "1py7lsrk0a4r0fx91jq6nn0vdv8phzw5wlnjbl38gmlq32hsff7k";
    };
  }
  {
    goPackagePath = "github.com/stretchr/objx";
    fetch = {
      type = "git";
      url = "https://github.com/stretchr/objx";
      rev = "v0.1.1";
      sha256 = "0iph0qmpyqg4kwv8jsx6a56a7hhqq8swrazv40ycxk9rzr0s8yls";
    };
  }
  {
    goPackagePath = "github.com/stretchr/testify";
    fetch = {
      type = "git";
      url = "https://github.com/stretchr/testify";
      rev = "v1.3.0";
      sha256 = "0wjchp2c8xbgcbbq32w3kvblk6q6yn533g78nxl6iskq6y95lxsy";
    };
  }
  {
    goPackagePath = "github.com/tidwall/gjson";
    fetch = {
      type = "git";
      url = "https://github.com/tidwall/gjson";
      rev = "v1.1.0";
      sha256 = "0m19fh7djlwl188ddw4myspck92hq0pck4xwmvx6msq7pz2mhds9";
    };
  }
  {
    goPackagePath = "github.com/tidwall/match";
    fetch = {
      type = "git";
      url = "https://github.com/tidwall/match";
      rev = "1731857f09b1";
      sha256 = "14nv96h0mjki5q685qx8y331h4yga6hlfh3z9nz6acvnv284q578";
    };
  }
  {
    goPackagePath = "github.com/tmc/grpc-websocket-proxy";
    fetch = {
      type = "git";
      url = "https://github.com/tmc/grpc-websocket-proxy";
      rev = "830351dc03c6";
      sha256 = "0d1b7jydlwfx9m78fbmfdva2yf1cd8x4j0bq5wxj5n7ihwyf07jg";
    };
  }
  {
    goPackagePath = "github.com/trivago/tgo";
    fetch = {
      type = "git";
      url = "https://github.com/trivago/tgo";
      rev = "v1.0.1";
      sha256 = "10243ai91r57fkh8jpyxg9dz503cb5nkmlsj10p3g8a38v808mrl";
    };
  }
  {
    goPackagePath = "github.com/ugorji/go";
    fetch = {
      type = "git";
      url = "https://github.com/ugorji/go";
      rev = "8333dd449516";
      sha256 = "16bix8957bgszzm176jn12q1dzi6flha4bif5h8j8lqbxc6pab3q";
    };
  }
  {
    goPackagePath = "github.com/ulikunitz/xz";
    fetch = {
      type = "git";
      url = "https://github.com/ulikunitz/xz";
      rev = "v0.5.6";
      sha256 = "1qpk02c0nfgfyg110nmbaiy5x12fpn0pm8gy7h1s8pwns133n831";
    };
  }
  {
    goPackagePath = "github.com/urfave/cli";
    fetch = {
      type = "git";
      url = "https://github.com/urfave/cli";
      rev = "v1.18.0";
      sha256 = "0al7w7yjyijx9dldndnj1bws5w1li0a7wjbwbkxa5kd0z7l39x81";
    };
  }
  {
    goPackagePath = "github.com/viniciuschiele/tarx";
    fetch = {
      type = "git";
      url = "https://github.com/viniciuschiele/tarx";
      rev = "6e3da540444d";
      sha256 = "0r7d6s5znbr69xm9334c8b404yk1jqg0h8n6bjs8zwgwk20cwxjf";
    };
  }
  {
    goPackagePath = "github.com/wbrefvem/go-bitbucket";
    fetch = {
      type = "git";
      url = "https://github.com/wbrefvem/go-bitbucket";
      rev = "fc08fd046abb";
      sha256 = "1h7wpl442cl4qfhm2115rwnch8bs2314qi09kwgy2zjrv5gq969n";
    };
  }
  {
    goPackagePath = "github.com/xanzy/go-gitlab";
    fetch = {
      type = "git";
      url = "https://github.com/xanzy/go-gitlab";
      rev = "f3bc634ab936";
      sha256 = "1lznkdlhm1jvka745qkynlyci4svw38s9chrz0lvwpl680kazv1q";
    };
  }
  {
    goPackagePath = "github.com/xanzy/ssh-agent";
    fetch = {
      type = "git";
      url = "https://github.com/xanzy/ssh-agent";
      rev = "v0.2.0";
      sha256 = "069nlriymqswg52ggiwi60qhwrin9nzhd2g65a7h59z2qbcvk2hy";
    };
  }
  {
    goPackagePath = "github.com/xi2/xz";
    fetch = {
      type = "git";
      url = "https://github.com/xi2/xz";
      rev = "48954b6210f8";
      sha256 = "178r0fa2dpzxf0sabs7dn0c8fa7vs87zlxk6spkn374ls9pir7nq";
    };
  }
  {
    goPackagePath = "github.com/xiang90/probing";
    fetch = {
      type = "git";
      url = "https://github.com/xiang90/probing";
      rev = "07dd2e8dfe18";
      sha256 = "0r8rq27yigz72mk8z7p61yjfan8id021dnp1v421ln9byzpvabn2";
    };
  }
  {
    goPackagePath = "github.com/xlab/handysort";
    fetch = {
      type = "git";
      url = "https://github.com/xlab/handysort";
      rev = "fb3537ed64a1";
      sha256 = "0g1q7qx259xhywkiqmcf0siwvyqbwdyc4ng0hz5z8r9zc68ic647";
    };
  }
  {
    goPackagePath = "go.etcd.io/bbolt";
    fetch = {
      type = "git";
      url = "https://github.com/etcd-io/bbolt";
      rev = "v1.3.1-etcd.7";
      sha256 = "0f2brc4zyc1z3s1bw9krgj7gijdrdz9sw2w8i7s0xvidd54qr32l";
    };
  }
  {
    goPackagePath = "go.etcd.io/etcd";
    fetch = {
      type = "git";
      url = "https://github.com/etcd-io/etcd";
      rev = "83304cfc808c";
      sha256 = "1jfiv4a6n6ik5l1sscgmvll9yyic5ax0a03vis8n3b5g5qycws34";
    };
  }
  {
    goPackagePath = "go.opencensus.io";
    fetch = {
      type = "git";
      url = "https://github.com/census-instrumentation/opencensus-go";
      rev = "v0.18.0";
      sha256 = "0flvv47h3988k1sg56qyh3hfskn563kblp4bs7mi6kzjc9jqz817";
    };
  }
  {
    goPackagePath = "go.uber.org/atomic";
    fetch = {
      type = "git";
      url = "https://github.com/uber-go/atomic";
      rev = "v1.3.2";
      sha256 = "11pzvjys5ddjjgrv94pgk9pnip9yyb54z7idf33zk7p7xylpnsv6";
    };
  }
  {
    goPackagePath = "go.uber.org/multierr";
    fetch = {
      type = "git";
      url = "https://github.com/uber-go/multierr";
      rev = "v1.1.0";
      sha256 = "1slfc6syvw8cvr6rbrjsy6ja5w8gsx0f8aq8qm16rp2x5c2pj07w";
    };
  }
  {
    goPackagePath = "go.uber.org/zap";
    fetch = {
      type = "git";
      url = "https://github.com/uber-go/zap";
      rev = "v1.9.1";
      sha256 = "19a1i6fipqj8w7h6qjmg1sfbg18yzzqsgfn0vmr55hkgc0y6nmny";
    };
  }
  {
    goPackagePath = "gocloud.dev";
    fetch = {
      type = "git";
      url = "https://github.com/google/go-cloud";
      rev = "v0.9.0";
      sha256 = "0rk0k2iy4rk0vqjyq98l89zkhq194bgdr95542ks5jbwinc82h36";
    };
  }
  {
    goPackagePath = "golang.org/x/crypto";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/crypto";
      rev = "505ab145d0a9";
      sha256 = "1vbsvcvmjz6c00p5vf8ls533p52fx2y3gy6v4k5qrdlzl4wf0i5s";
    };
  }
  {
    goPackagePath = "golang.org/x/exp";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/exp";
      rev = "509febef88a4";
      sha256 = "02isrh39z8znrp5znplzy0dip2gnrl3jm1355raliyvhnhg04j6q";
    };
  }
  {
    goPackagePath = "golang.org/x/image";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/image";
      rev = "c73c2afc3b81";
      sha256 = "1kkafy29vz5xf6r29ghbvvbwrgjxwxvzk6dsa2qhyp1ddk6l2vkz";
    };
  }
  {
    goPackagePath = "golang.org/x/lint";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/lint";
      rev = "c67002cb31c3";
      sha256 = "0gymbggskjmphqxqcx4s0vnlcz7mygbix0vhwcwv5r67c0bf6765";
    };
  }
  {
    goPackagePath = "golang.org/x/net";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/net";
      rev = "351d144fa1fc";
      sha256 = "1c5x25qjyz83y92bq0lll5kmznyi3m02wd4c54scgf0866gy938k";
    };
  }
  {
    goPackagePath = "golang.org/x/oauth2";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/oauth2";
      rev = "d668ce993890";
      sha256 = "17m8d02fazil0dwvk33vpwvsb91asgbmmpqy05751csrfqhhdqna";
    };
  }
  {
    goPackagePath = "golang.org/x/sync";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/sync";
      rev = "37e7f081c4d4";
      sha256 = "1bb0mw6ckb1k7z8v3iil2qlqwfj408fvvp8m1cik2b46p7snyjhm";
    };
  }
  {
    goPackagePath = "golang.org/x/sys";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/sys";
      rev = "aca44879d564";
      sha256 = "106vs2md02h16rwnk9mq2h4ix7iyv2n6bfm7v9zp0kknswlag1x0";
    };
  }
  {
    goPackagePath = "golang.org/x/text";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/text";
      rev = "v0.3.0";
      sha256 = "0r6x6zjzhr8ksqlpiwm5gdd7s209kwk5p4lw54xjvz10cs3qlq19";
    };
  }
  {
    goPackagePath = "golang.org/x/time";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/time";
      rev = "fbb02b2291d2";
      sha256 = "0jjqcv6rzihlgg4i797q80g1f6ch5diz2kxqh6488gwkb6nds4h4";
    };
  }
  {
    goPackagePath = "golang.org/x/tools";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/tools";
      rev = "06f26fdaaa28";
      sha256 = "07qj9wfjygy64krr8rgbxf43v007y7hmbimh8j95qfrq5fh7bp21";
    };
  }
  {
    goPackagePath = "google.golang.org/api";
    fetch = {
      type = "git";
      url = "https://code.googlesource.com/google-api-go-client";
      rev = "v0.1.0";
      sha256 = "1az6n10i35ls13wry20nnm5afzr3j3s391nia8ghgx5vfskgzn56";
    };
  }
  {
    goPackagePath = "google.golang.org/appengine";
    fetch = {
      type = "git";
      url = "https://github.com/golang/appengine";
      rev = "v1.3.0";
      sha256 = "13cyhqwmvc2nia4ssdwwdzscq52aj3z9zjikx17wk4kb0j8vr370";
    };
  }
  {
    goPackagePath = "google.golang.org/genproto";
    fetch = {
      type = "git";
      url = "https://github.com/google/go-genproto";
      rev = "082222b4a5c5";
      sha256 = "1q57b7c01wwcgd488fdkipizaxnwm4pkl0bzs2p7wbdagsbvv1g9";
    };
  }
  {
    goPackagePath = "google.golang.org/grpc";
    fetch = {
      type = "git";
      url = "https://github.com/grpc/grpc-go";
      rev = "v1.17.0";
      sha256 = "0ibwav7p5cqng8yslarix521i1s11r7w9y2rjliahm75cj5crrb8";
    };
  }
  {
    goPackagePath = "gopkg.in/AlecAivazis/survey.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/AlecAivazis/survey.v1";
      rev = "v1.6.2";
      sha256 = "1w8pfgnnr0wz13fcnfhjkc20yh42in3ia7v6nczzyn38r2fdr43g";
    };
  }
  {
    goPackagePath = "gopkg.in/airbrake/gobrake.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/airbrake/gobrake.v2";
      rev = "v2.0.9";
      sha256 = "1x06f7n7qlyzqgyz0sdfcidf3w4ldn6zs6qx2mhibggk2z4whcjw";
    };
  }
  {
    goPackagePath = "gopkg.in/alecthomas/kingpin.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/alecthomas/kingpin.v2";
      rev = "v2.2.6";
      sha256 = "0mndnv3hdngr3bxp7yxfd47cas4prv98sqw534mx7vp38gd88n5r";
    };
  }
  {
    goPackagePath = "gopkg.in/asn1-ber.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/asn1-ber.v1";
      rev = "f715ec2f112d";
      sha256 = "00ixms8x3lrhywbvq5v2sagcqsxa1pcnlk17dp5lnwckv3xg4psb";
    };
  }
  {
    goPackagePath = "gopkg.in/check.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/check.v1";
      rev = "788fd7840127";
      sha256 = "0v3bim0j375z81zrpr5qv42knqs0y2qv2vkjiqi5axvb78slki1a";
    };
  }
  {
    goPackagePath = "gopkg.in/cheggaaa/pb.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/cheggaaa/pb.v1";
      rev = "v1.0.25";
      sha256 = "0vxqiw6f3xyv0zy3g4lksf8za0z8i0hvfpw92hqimsy84f79j3dp";
    };
  }
  {
    goPackagePath = "gopkg.in/fsnotify.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/fsnotify.v1";
      rev = "v1.4.7";
      sha256 = "07va9crci0ijlivbb7q57d2rz9h27zgn2fsm60spjsqpdbvyrx4g";
    };
  }
  {
    goPackagePath = "gopkg.in/gemnasium/logrus-airbrake-hook.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/gemnasium/logrus-airbrake-hook.v2";
      rev = "v2.1.2";
      sha256 = "0sbg0dn6cysmf8f2bi209jwl4jnpiwp4rdghnxlzirw3c32ms5y5";
    };
  }
  {
    goPackagePath = "gopkg.in/h2non/gock.v0";
    fetch = {
      type = "git";
      url = "https://gopkg.in/h2non/gock.v0";
      rev = "1baf36abac00";
      sha256 = "1gddy7cl8d84r3s2kkzm25bm19n8ml8iznch94q6wnsrz3g6bsqq";
    };
  }
  {
    goPackagePath = "gopkg.in/inf.v0";
    fetch = {
      type = "git";
      url = "https://gopkg.in/inf.v0";
      rev = "v0.9.1";
      sha256 = "00k5iqjcp371fllqxncv7jkf80hn1zww92zm78cclbcn4ybigkng";
    };
  }
  {
    goPackagePath = "gopkg.in/ini.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/ini.v1";
      rev = "v1.39.0";
      sha256 = "0j7pyl5v7xfzkhsyz193iq56ilan69pp11g2n5jw1k4h4g8s4k9b";
    };
  }
  {
    goPackagePath = "gopkg.in/mgo.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/mgo.v2";
      rev = "9856a29383ce";
      sha256 = "1gfbcmvpwwf1lydxj3g42wv2g9w3pf0y02igqk4f4f21h02sazkw";
    };
  }
  {
    goPackagePath = "gopkg.in/pipe.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/pipe.v2";
      rev = "3c2ca4d52544";
      sha256 = "090wrj4n6a6pzdlakcxy9qnkngc8hp6m49ipbnlszs0hyj2hnngv";
    };
  }
  {
    goPackagePath = "gopkg.in/robfig/cron.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/robfig/cron.v2";
      rev = "be2e0b0deed5";
      sha256 = "1cmm6dc4cl8269wlknxmicyn1s63irg66lj76b9ncjjfrvijpf0y";
    };
  }
  {
    goPackagePath = "gopkg.in/src-d/go-billy.v4";
    fetch = {
      type = "git";
      url = "https://gopkg.in/src-d/go-billy.v4";
      rev = "v4.2.0";
      sha256 = "18fghcyk69g460px8rvmhmqldkbhw17dpnhg45qwdvaq90b0bkx9";
    };
  }
  {
    goPackagePath = "gopkg.in/src-d/go-git-fixtures.v3";
    fetch = {
      type = "git";
      url = "https://gopkg.in/src-d/go-git-fixtures.v3";
      rev = "v3.3.0";
      sha256 = "1xbnd2ln95xgr6385ahl1y7108ifr3fh0zhy7fmb7cjasq8zlvw9";
    };
  }
  {
    goPackagePath = "gopkg.in/src-d/go-git.v4";
    fetch = {
      type = "git";
      url = "https://gopkg.in/src-d/go-git.v4";
      rev = "v4.5.0";
      sha256 = "1krg24ncckwalmhzs2vlp8rwyk4rfnhfydwg8iw7gaywww2c1wfc";
    };
  }
  {
    goPackagePath = "gopkg.in/tomb.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/tomb.v1";
      rev = "dd632973f1e7";
      sha256 = "1lqmq1ag7s4b3gc3ddvr792c5xb5k6sfn0cchr3i2s7f1c231zjv";
    };
  }
  {
    goPackagePath = "gopkg.in/warnings.v0";
    fetch = {
      type = "git";
      url = "https://gopkg.in/warnings.v0";
      rev = "v0.1.2";
      sha256 = "1kzj50jn708cingn7a13c2wdlzs6qv89dr2h4zj8d09647vlnd81";
    };
  }
  {
    goPackagePath = "gopkg.in/yaml.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/yaml.v2";
      rev = "v2.2.1";
      sha256 = "0dwjrs2lp2gdlscs7bsrmyc5yf6mm4fvgw71bzr9mv2qrd2q73s1";
    };
  }
  {
    goPackagePath = "gotest.tools";
    fetch = {
      type = "git";
      url = "https://github.com/gotestyourself/gotest.tools";
      rev = "v2.2.0";
      sha256 = "0yif3gdyckmf8i54jq0xn00kflla5rhib9sarw66ngnbl7bn9kyl";
    };
  }
  {
    goPackagePath = "honnef.co/go/tools";
    fetch = {
      type = "git";
      url = "https://github.com/dominikh/go-tools";
      rev = "88497007e858";
      sha256 = "0rinkyx3r2bq45mgcasnn5jb07cwbv3p3s2wwcrzxsarsj6wa5lc";
    };
  }
  {
    goPackagePath = "k8s.io/api";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/api";
      rev = "6db15a15d2d3";
      sha256 = "0jqb0c57yzaajrl17hbziw19x5n14q46dg73y0gmv0blpa6laxcy";
    };
  }
  {
    goPackagePath = "k8s.io/apiextensions-apiserver";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/apiextensions-apiserver";
      rev = "1f84094d7e8e";
      sha256 = "1b73cwjgsxjr00jbygmgs13bgyz6593kqqx2xksn9rir42qb3zil";
    };
  }
  {
    goPackagePath = "k8s.io/apimachinery";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/apimachinery";
      rev = "bebe27e40fb7";
      sha256 = "1g1q2f77b320z0v9b1gmal056dz189wf069400a44c0v5y61ak8l";
    };
  }
  {
    goPackagePath = "k8s.io/cli-runtime";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/cli-runtime";
      rev = "1ee5ba10d7e3";
      sha256 = "1nr5s217sy9s23xkhn2fpa6ck473wxq3a8m3vrmxq6xd0c60fkyy";
    };
  }
  {
    goPackagePath = "k8s.io/client-go";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/client-go";
      rev = "701b91367003";
      sha256 = "1qmz3s7yfa1l07lpyn3g7x9wnc9bxc0lk0p893vana96xj177zih";
    };
  }
  {
    goPackagePath = "k8s.io/code-generator";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/code-generator";
      rev = "8c97d6ab64da";
      sha256 = "137ih44qiaaidjw5xk7giqngi0x01awvknb0vrnf60ajq2dy9sdh";
    };
  }
  {
    goPackagePath = "k8s.io/gengo";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/gengo";
      rev = "906d99f89cd6";
      sha256 = "08hcvmn6n02a5yjl9yby1n6ybqf7b4jwzppj0v6rr73hh6w3kfi4";
    };
  }
  {
    goPackagePath = "k8s.io/helm";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/helm";
      rev = "v2.7.2";
      sha256 = "087f8wnf0kcbkh6flxlv07knrb964zyszi2k4i1ihaajg3bkbpq6";
    };
  }
  {
    goPackagePath = "k8s.io/kube-openapi";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/kube-openapi";
      rev = "d8ea2fe547a4";
      sha256 = "1m64xrp2vz7il2b3nikdjxf8l4yw2b2yp8997mwkj4rldznfxlxb";
    };
  }
  {
    goPackagePath = "k8s.io/kubernetes";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/kubernetes";
      rev = "v1.11.3";
      sha256 = "123qk5y9cwsj1cyswbpbdha84ynraam1xmqd5cpr4w29kw7nsjr8";
    };
  }
  {
    goPackagePath = "k8s.io/metrics";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/metrics";
      rev = "3954d62a524d";
      sha256 = "0y3ywkbhc9kdzp1dl4crphijx0ajd7apqpq3gvrmq4v224078hic";
    };
  }
  {
    goPackagePath = "k8s.io/test-infra";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/test-infra";
      rev = "a22cef183a8f";
      sha256 = "17cjbbadx2qsr1si5v6pb1ma59j9162mzk62zdimr8jr8q2pc402";
    };
  }
  {
    goPackagePath = "k8s.io/utils";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes/utils";
      rev = "5e321f9a457c";
      sha256 = "0bgmjzjhxjldbd2n046fywk8351xnp8acf3nh8si0f0s5saniy7i";
    };
  }
  {
    goPackagePath = "sigs.k8s.io/yaml";
    fetch = {
      type = "git";
      url = "https://github.com/kubernetes-sigs/yaml";
      rev = "v1.1.0";
      sha256 = "1p7hvjdr5jsyk7nys1g1pmgnf3ys6n320i6hds85afppk81k01kb";
    };
  }
  {
    goPackagePath = "vbom.ml/util";
    fetch = {
      type = "git";
      url = "https://github.com/fvbommel/util";
      rev = "256737ac55c4";
      sha256 = "0pvsbh23fpa8w1gx2hv2rcw6nlb7r4nalfhfy3385sj0pc0b62lc";
    };
  }
]
