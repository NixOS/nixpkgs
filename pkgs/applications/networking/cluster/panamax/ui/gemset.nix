{
  "actionmailer" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "0qjv5akjbpgd4cx518k522mssvc3y3nki65hi6fj5nbzi7a6rwq5";
    };
    dependencies = [
      "actionpack"
      "actionview"
      "mail"
    ];
  };
  "actionpack" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "07y1ny00h69xklq260smyl5md052f617gqrzkyw5sxafs5z25zax";
    };
    dependencies = [
      "actionview"
      "activesupport"
      "rack"
      "rack-test"
    ];
  };
  "actionview" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "06sp37gfpn2jn7j6vlpp1y6vfi5kig60vyvixrjhyz0g4vgm13ax";
    };
    dependencies = [
      "activesupport"
      "builder"
      "erubis"
    ];
  };
  "activemodel" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "0rlqzz25l7vsphgkilg80kmk20d9h357awi27ax6zzb9klkqh0jr";
    };
    dependencies = [
      "activesupport"
      "builder"
    ];
  };
  "activerecord" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "0j4r0m32mjbwmz9gs8brln35jzr1cn7h585ggj0w0f1ai4hjsby5";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "arel"
    ];
  };
  "activeresource" = {
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "0fc5igjijyjzsl9q5kybkdzhc92zv8wsv0ifb0y90i632jx6d4jq";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "rails-observers"
    ];
  };
  "activesupport" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "13i3mz66d5kp5y39gjwmcfqv0wb6mxm5k1nnz40wvd38dsf7n3bs";
    };
    dependencies = [
      "i18n"
      "json"
      "minitest"
      "thread_safe"
      "tzinfo"
    ];
  };
  "addressable" = {
    version = "2.3.6";
    source = {
      type = "gem";
      sha256 = "137fj0whmn1kvaq8wjalp8x4qbblwzvg3g4bfx8d8lfi6f0w48p8";
    };
  };
  "arel" = {
    version = "5.0.1.20140414130214";
    source = {
      type = "gem";
      sha256 = "0dhnc20h1v8ml3nmkxq92rr7qxxpk6ixhwvwhgl2dbw9mmxz0hf9";
    };
  };
  "binding_of_caller" = {
    version = "0.7.2";
    source = {
      type = "gem";
      sha256 = "15jg6dkaq2nzcd602d7ppqbdxw3aji961942w93crs6qw4n6h9yk";
    };
    dependencies = [
      "debug_inspector"
    ];
  };
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "byebug" = {
    version = "3.5.1";
    source = {
      type = "gem";
      sha256 = "0ldc2r0b316rrn2fgdgiznskj9gb0q9n60243laq7nqw9na8wdan";
    };
    dependencies = [
      "columnize"
      "debugger-linecache"
      "slop"
    ];
  };
  "capybara" = {
    version = "2.4.4";
    source = {
      type = "gem";
      sha256 = "114k4xi4nfbp3jfbxgwa3fksbwsyibx74gbdqpcgg3dxpmzkaa4f";
    };
    dependencies = [
      "mime-types"
      "nokogiri"
      "rack"
      "rack-test"
      "xpath"
    ];
  };
  "coderay" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "059wkzlap2jlkhg460pkwc1ay4v4clsmg1bp4vfzjzkgwdckr52s";
    };
  };
  "columnize" = {
    version = "0.8.9";
    source = {
      type = "gem";
      sha256 = "1f3azq8pvdaaclljanwhab78hdw40k908ma2cwk59qzj4hvf7mip";
    };
  };
  "coveralls" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "0sz30d7b83qqsj3i0fr691w05d62wj7x3afh0ryjkqkis3fq94j4";
    };
    dependencies = [
      "multi_json"
      "rest-client"
      "simplecov"
      "term-ansicolor"
      "thor"
    ];
  };
  "crack" = {
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "1il94m92sz32nw5i6hdq14f1a2c3s9hza9zn6l95fvqhabq38k7a";
    };
    dependencies = [
      "safe_yaml"
    ];
  };
  "ctl_base_ui" = {
    version = "0.0.5";
    source = {
      type = "gem";
      sha256 = "1pji85xmddgld5lqx52zxi5r2kx6rsjwkqlr26bp62xb29r10x57";
    };
    dependencies = [
      "haml"
      "jquery-rails"
      "jquery-ui-rails"
      "rails"
      "sass"
    ];
  };
  "debug_inspector" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "109761g00dbrw5q0dfnbqg8blfm699z4jj70l4zrgf9mzn7ii50m";
    };
  };
  "debugger-linecache" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0iwyx190fd5vfwj1gzr8pg3m374kqqix4g4fc4qw29sp54d3fpdz";
    };
  };
  "diff-lcs" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    };
  };
  "docile" = {
    version = "1.1.5";
    source = {
      type = "gem";
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
    };
  };
  "dotenv" = {
    version = "0.11.1";
    source = {
      type = "gem";
      sha256 = "09z0y0d6bks7i0sqvd8szfqj9i1kkj01anzly7shi83b3gxhrq9m";
    };
    dependencies = [
      "dotenv-deployment"
    ];
  };
  "dotenv-deployment" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "1ad66jq9a09qq1js8wsyil97018s7y6x0vzji0dy34gh65sbjz8c";
    };
  };
  "dotenv-rails" = {
    version = "0.11.1";
    source = {
      type = "gem";
      sha256 = "0r6hif0i1lipbi7mkxx7wa5clsn65n6wyd9jry262cx396lsfrqy";
    };
    dependencies = [
      "dotenv"
    ];
  };
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  "execjs" = {
    version = "2.2.2";
    source = {
      type = "gem";
      sha256 = "05m41mnxn4b2p133qzbz5cy9cc5rn57aa0pp2943hxmzbk379z1f";
    };
  };
  "haml" = {
    version = "4.0.5";
    source = {
      type = "gem";
      sha256 = "1xmzb0k5q271090crzmv7dbw8ss4289bzxklrc0fhw6pw3kcvc85";
    };
    dependencies = [
      "tilt"
    ];
  };
  "hike" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0i6c9hrszzg3gn2j41v3ijnwcm8cc2931fnjiv6mnpl4jcjjykhm";
    };
  };
  "i18n" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
    };
  };
  "its" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "0rxwds9ipqp48mzqcaxzmfcqhawazg0zlhc1avv3i2cmm3np1z8g";
    };
    dependencies = [
      "rspec-core"
    ];
  };
  "jquery-rails" = {
    version = "3.1.2";
    source = {
      type = "gem";
      sha256 = "0h5a565i3l2mbd221m6mz9d1nr53pz19i9qxv08qr1dv0yx2pr3y";
    };
    dependencies = [
      "railties"
      "thor"
    ];
  };
  "jquery-ui-rails" = {
    version = "4.2.1";
    source = {
      type = "gem";
      sha256 = "1garrnqwh35acj2pp4sp6fpm2g881h23y644lzbic2qmcrq9wd2v";
    };
    dependencies = [
      "railties"
    ];
  };
  "json" = {
    version = "1.8.2";
    source = {
      type = "gem";
      sha256 = "0zzvv25vjikavd3b1bp6lvbgj23vv9jvmnl4vpim8pv30z8p6vr5";
    };
  };
  "kramdown" = {
    version = "1.4.0";
    source = {
      type = "gem";
      sha256 = "001vy0ymiwbvkdbb9wpqmswv6imliv7xim00gq6rlk0chnbiaq80";
    };
  };
  libv8 = {
    version = "3.16.14.11";
    source = {
      type = "gem";
      sha256 = "000vbiy78wk5r1f6p7qncab8ldg7qw5pjz7bchn3lw700gpaacxp";
    };
  };
  "mail" = {
    version = "2.6.3";
    source = {
      type = "gem";
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
    };
    dependencies = [
      "mime-types"
    ];
  };
  "method_source" = {
    version = "0.8.2";
    source = {
      type = "gem";
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
    };
  };
  "mime-types" = {
    version = "2.4.3";
    source = {
      type = "gem";
      sha256 = "16nissnb31wj7kpcaynx4gr67i7pbkzccfg8k7xmplbkla4rmwiq";
    };
  };
  "mini_portile" = {
    version = "0.6.1";
    source = {
      type = "gem";
      sha256 = "07gah4k84sar9d850v9gip9b323pw74vwwndh3bbzxpw5iiwsd3l";
    };
  };
  "minitest" = {
    version = "5.5.1";
    source = {
      type = "gem";
      sha256 = "1h8jn0rgmwy37jnhfcg55iilw0n370vgp8xnh0g5laa8rhv32fyn";
    };
  };
  "multi_json" = {
    version = "1.10.1";
    source = {
      type = "gem";
      sha256 = "1ll21dz01jjiplr846n1c8yzb45kj5hcixgb72rz0zg8fyc9g61c";
    };
  };
  "netrc" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "1j4jbdvd19kq34xiqx1yqb4wmcywyrlaky8hrh09c1hz3c0v5dkb";
    };
  };
  "nokogiri" = {
    version = "1.6.5";
    source = {
      type = "gem";
      sha256 = "1xmxz6fa0m4p7c7ngpgz6gjgv65lzz63dsf0b6vh7gs2fkiw8j7l";
    };
    dependencies = [
      "mini_portile"
    ];
  };
  "phantomjs" = {
    version = "1.9.7.1";
    source = {
      type = "gem";
      sha256 = "14as0yzwbzvshbp1f8igjxcdxc5vbjgh0jhdvy393il084inlrl7";
    };
  };
  "pry" = {
    version = "0.10.1";
    source = {
      type = "gem";
      sha256 = "1j0r5fm0wvdwzbh6d6apnp7c0n150hpm9zxpm5xvcgfqr36jaj8z";
    };
    dependencies = [
      "coderay"
      "method_source"
      "slop"
    ];
  };
  "pry-byebug" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "17b6720ci9345wkzj369ydyj6hdlg2krd26zivpd4dvaijszzgzq";
    };
    dependencies = [
      "byebug"
      "pry"
    ];
  };
  "pry-stack_explorer" = {
    version = "0.4.9.1";
    source = {
      type = "gem";
      sha256 = "1828jqcfdr9nk86n15ky199vf33cfz51wkpv6kx230g0dsh9r85z";
    };
    dependencies = [
      "binding_of_caller"
      "pry"
    ];
  };
  "puma" = {
    version = "2.8.2";
    source = {
      type = "gem";
      sha256 = "1l57fmf8vyxfjv7ab5znq0k339cym5ghnm5xxfvd1simjp73db0k";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack" = {
    version = "1.5.2";
    source = {
      type = "gem";
      sha256 = "19szfw76cscrzjldvw30jp3461zl00w4xvw1x9lsmyp86h1g0jp6";
    };
  };
  "rack-protection" = {
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-test" = {
    version = "0.6.3";
    source = {
      type = "gem";
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
    };
    dependencies = [
      "rack"
    ];
  };
  "rails" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "059mpljplmhfz8rr4hk40q67fllcpsy809m4mwwbkm8qwif2z5r0";
    };
    dependencies = [
      "actionmailer"
      "actionpack"
      "actionview"
      "activemodel"
      "activerecord"
      "activesupport"
      "railties"
      "sprockets-rails"
    ];
  };
  "rails-observers" = {
    version = "0.1.2";
    source = {
      type = "gem";
      sha256 = "1lsw19jzmvipvrfy2z04hi7r29dvkfc43h43vs67x6lsj9rxwwcy";
    };
    dependencies = [
      "activemodel"
    ];
  };
  "railties" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "1n08h0rgj0aq5lvslnih6lvqz9wadpz6nnb25i4qhp37fhhyz9yz";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "rake"
      "thor"
    ];
  };
  "rake" = {
    version = "10.4.0";
    source = {
      type = "gem";
      sha256 = "0a10xzqc1lh6gjkajkslr0n40wjrniyiyzxkp9m5fc8wf7b74zw8";
    };
  };
  "ref" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "19qgpsfszwc2sfh6wixgky5agn831qq8ap854i1jqqhy1zsci3la";
    };
  };
  "rest-client" = {
    version = "1.7.2";
    source = {
      type = "gem";
      sha256 = "0h8c0prfi2v5p8iim3wm60xc4yripc13nqwq601bfl85k4gf25i0";
    };
    dependencies = [
      "mime-types"
      "netrc"
    ];
  };
  "rspec-core" = {
    version = "3.1.7";
    source = {
      type = "gem";
      sha256 = "01bawvln663gffljwzpq3mrpa061cghjbvfbq15jvhmip3csxqc9";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-expectations" = {
    version = "3.1.2";
    source = {
      type = "gem";
      sha256 = "0m8d36wng1lpbcs54zhg1rxh63rgj345k3p0h0c06lgknz339nzh";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-mocks" = {
    version = "3.1.3";
    source = {
      type = "gem";
      sha256 = "0gxk5w3klia4zsnp0svxck43xxwwfdqvhr3srv6p30f3m5q6rmzr";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-rails" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "1b1in3n1dc1bpf9wb3p3b2ynq05iacmr48jxzc73lj4g44ksh3wq";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
  };
  "rspec-support" = {
    version = "3.1.2";
    source = {
      type = "gem";
      sha256 = "14y6v9r9lrh91ry9r79h85v0f3y9ja25w42nv5z9n0bipfcwhprb";
    };
  };
  "safe_yaml" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
    };
  };
  "sass" = {
    version = "3.3.9";
    source = {
      type = "gem";
      sha256 = "0k19vj73283i907z4wfkc9qdska2b19z7ps6lcr5s4qzwis1zkmz";
    };
  };
  "simplecov" = {
    version = "0.9.1";
    source = {
      type = "gem";
      sha256 = "06hylxlalaxxldpbaqa54gc52wxdff0fixdvjyzr6i4ygxwzr7yf";
    };
    dependencies = [
      "docile"
      "multi_json"
      "simplecov-html"
    ];
  };
  "simplecov-html" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "0jhn3jql73x7hsr00wwv984iyrcg0xhf64s90zaqv2f26blkqfb9";
    };
  };
  "sinatra" = {
    version = "1.4.5";
    source = {
      type = "gem";
      sha256 = "0qyna3wzlnvsz69d21lxcm3ixq7db08mi08l0a88011qi4qq701s";
    };
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
  };
  "slop" = {
    version = "3.6.0";
    source = {
      type = "gem";
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
    };
  };
  "sprockets" = {
    version = "2.12.3";
    source = {
      type = "gem";
      sha256 = "1bn2drr8bc2af359dkfraq0nm0p1pib634kvhwn5lvj3r4vllnn2";
    };
    dependencies = [
      "hike"
      "multi_json"
      "rack"
      "tilt"
    ];
  };
  "sprockets-rails" = {
    version = "2.2.4";
    source = {
      type = "gem";
      sha256 = "172cdg38cqsfgvrncjzj0kziz7kv6b1lx8pccd0blyphs25qf4gc";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
  };
  "teaspoon" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "1j3brbm9cv5km9d9wzb6q2b3cvc6m254z48h7h77z1w6c5wr0p3z";
    };
    dependencies = [
      "railties"
    ];
  };
  "term-ansicolor" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1a2gw7gmpmx57sdpyhjwl0zn4bqp7jyjz7aslpvvphd075layp4b";
    };
    dependencies = [
      "tins"
    ];
  };
  "therubyracer" = {
    version = "0.12.1";
    source = {
      type = "gem";
      sha256 = "106fqimqyaalh7p6czbl5m2j69z8gv7cm10mjb8bbb2p2vlmqmi6";
    };
    dependencies = [
      "libv8"
      "ref"
    ];
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
  "thread_safe" = {
    version = "0.3.4";
    source = {
      type = "gem";
      sha256 = "1cil2zcdzqkyr8zrwhlg7gywryg36j4mxlxw0h0x0j0wjym5nc8n";
    };
  };
  "tilt" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "00sr3yy7sbqaq7cb2d2kpycajxqf1b1wr1yy33z4bnzmqii0b0ir";
    };
  };
  "tins" = {
    version = "1.3.3";
    source = {
      type = "gem";
      sha256 = "14jnsg15wakdk1ljh2iv9yvzk8nb7gpzd2zw4yvjikmffqjyqvna";
    };
  };
  "tzinfo" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
    };
    dependencies = [
      "thread_safe"
    ];
  };
  "uglifier" = {
    version = "2.5.1";
    source = {
      type = "gem";
      sha256 = "1vihq309mzv9a2i0s8v4imrn1g2kj8z0vr88q3i5b657c4kxzfp0";
    };
    dependencies = [
      "execjs"
      "json"
    ];
  };
  "webmock" = {
    version = "1.20.4";
    source = {
      type = "gem";
      sha256 = "01cz13ybxbbvkpl21bcfv0p9ir8m2zcplx93ps01ma54p25z4mxr";
    };
    dependencies = [
      "addressable"
      "crack"
    ];
  };
  "xpath" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "04kcr127l34p7221z13blyl0dvh0bmxwx326j72idayri36a394w";
    };
    dependencies = [
      "nokogiri"
    ];
  };
  "zeroclipboard-rails" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "00ixal0a0mxaqsyzp06c6zz4qdwqydy1qv4n7hbyqfhbmsdalcfc";
    };
    dependencies = [
      "railties"
    ];
  };
}
