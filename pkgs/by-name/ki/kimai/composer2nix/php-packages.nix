{fetchFromGitHub, composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "azuyalabs/yasumi" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "azuyalabs-yasumi-37d1215d4f4012d3185bb9990c76ca17a4ff1c30";
        src = fetchurl {
          url = "https://api.github.com/repos/azuyalabs/yasumi/zipball/37d1215d4f4012d3185bb9990c76ca17a4ff1c30";
          sha256 = "191sfj0qx3n3n9m6189p11fhpjj5h6rzcfyvxr7sdjn3pydfrl5r";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-8674e51bb65af933a5ffaf1c308a660387c35c22";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/8674e51bb65af933a5ffaf1c308a660387c35c22";
          sha256 = "0hb0w6m5rwzghw2im3yqn6ly2kvb3jgrv8jwra1lwd0ik6ckrngl";
        };
      };
    };
    "behat/transliterator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "behat-transliterator-baac5873bac3749887d28ab68e2f74db3a4408af";
        src = fetchurl {
          url = "https://api.github.com/repos/Behat/Transliterator/zipball/baac5873bac3749887d28ab68e2f74db3a4408af";
          sha256 = "04dk371h448wjgdk9x9g2mpqwcnx71dfclvspkj23rn3znq964rh";
        };
      };
    };
    "composer/semver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-semver-35e8d0af4486141bc745f23a29cc2091eb624a32";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/semver/zipball/35e8d0af4486141bc745f23a29cc2091eb624a32";
          sha256 = "1sr3l0k87fi9z95j4jh9xqs4dz1315mj4bi95sij35d2ad3rcs19";
        };
      };
    };
    "dasprid/enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dasprid-enum-6faf451159fb8ba4126b925ed2d78acfce0dc016";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/6faf451159fb8ba4126b925ed2d78acfce0dc016";
          sha256 = "1c3c7zdmpd5j1pw9am0k3mj8n17vy6xjhsh2qa7c0azz0f21jk4j";
        };
      };
    };
    "doctrine/annotations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-annotations-e157ef3f3124bbf6fe7ce0ffd109e8a8ef284e7f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/annotations/zipball/e157ef3f3124bbf6fe7ce0ffd109e8a8ef284e7f";
          sha256 = "1lf9y10schsh11185xgfnwn91i77njymz3zv43xh4qcyjq5fjg32";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-1ca8f21980e770095a31456042471a57bc4c68fb";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/cache/zipball/1ca8f21980e770095a31456042471a57bc4c68fb";
          sha256 = "1p8ia9g3mqz71bv4x8q1ng1fgcidmyksbsli1fjbialpgjk9k1ss";
        };
      };
    };
    "doctrine/collections" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-collections-72328a11443a0de79967104ad36ba7b30bded134";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/collections/zipball/72328a11443a0de79967104ad36ba7b30bded134";
          sha256 = "03q652akal2ilqkmr2v8x6wqcd9i1qjnm2c3x5wf2ay267w9l22r";
        };
      };
    };
    "doctrine/common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-common-8b5e5650391f851ed58910b3e3d48a71062eeced";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/common/zipball/8b5e5650391f851ed58910b3e3d48a71062eeced";
          sha256 = "10p3q7q2aq5raka2p7hp988w8y8iqzh34mq6hb5zsykjbqxd88i7";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-0ac3c270590e54910715e9a1a044cc368df282b2";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/0ac3c270590e54910715e9a1a044cc368df282b2";
          sha256 = "1qf6nhrrn7hdxqvym9l3mxj1sb0fmx2h1s3yi4mjkkb4ri5hcmm8";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-4f2d4f2836e7ec4e7a8625e75c6aa916004db931";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/4f2d4f2836e7ec4e7a8625e75c6aa916004db931";
          sha256 = "1kxy6s4v9prkfvsnggm10kk0yyqsyd2vk238zhvv3c9il300h8sk";
        };
      };
    };
    "doctrine/doctrine-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-doctrine-bundle-4089f1424b724786c062aea50aae5f773449b94b";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/DoctrineBundle/zipball/4089f1424b724786c062aea50aae5f773449b94b";
          sha256 = "0qj6a4s6xlzcba7208f5z2m9711bbp0q7kh1ff3ab6j3sg5yip77";
        };
      };
    };
    "doctrine/doctrine-migrations-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-doctrine-migrations-bundle-1dd42906a5fb9c5960723e2ebb45c68006493835";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/DoctrineMigrationsBundle/zipball/1dd42906a5fb9c5960723e2ebb45c68006493835";
          sha256 = "07m6cj5c3xkcssmci1d7l29q91ddrvnngs1622g9h5fdgwf2yfis";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-750671534e0241a7c50ea5b43f67e23eb5c96f32";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/750671534e0241a7c50ea5b43f67e23eb5c96f32";
          sha256 = "1inhh3k8ai8d6rhx5xsbdx0ifc3yjjfrahi0cy1npz9nx3383cfh";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-2930cd5ef353871c821d5c43ed030d39ac8cfe65";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/2930cd5ef353871c821d5c43ed030d39ac8cfe65";
          sha256 = "04nckrk1kg89sprxby572vhxzl9sal47dc3hvrn9kbcgjxi51shs";
        };
      };
    };
    "doctrine/instantiator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-instantiator-c6222283fa3f4ac679f8b9ced9a4e23f163e80d0";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/instantiator/zipball/c6222283fa3f4ac679f8b9ced9a4e23f163e80d0";
          sha256 = "059ahw73z0m24cal4f805j6h1i53f90mrmjr7s4f45yfxgwcqvcn";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-39ab8fcf5a51ce4b85ca97c7a7d033eb12831124";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/39ab8fcf5a51ce4b85ca97c7a7d033eb12831124";
          sha256 = "19kak8fh8sf5bpmcn7a90sqikgx30mk2bmjf0jbzcvlbnsjyggah";
        };
      };
    };
    "doctrine/migrations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-migrations-47af29eef49f29ebee545947e8b2a4b3be318c8a";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/migrations/zipball/47af29eef49f29ebee545947e8b2a4b3be318c8a";
          sha256 = "0ix0x3d7lc1rkrbksk1sxlnl6sj733cs7fjg60jvd934f9y76m0c";
        };
      };
    };
    "doctrine/orm" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-orm-398ab0547aaf90bdb352b560a94c24f44ff00670";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/orm/zipball/398ab0547aaf90bdb352b560a94c24f44ff00670";
          sha256 = "1rzq1b6mkimn3ifymbzwc4s0i8gn84j2id8xyy6hp49izh9q4i6n";
        };
      };
    };
    "doctrine/persistence" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-persistence-63fee8c33bef740db6730eb2a750cd3da6495603";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/persistence/zipball/63fee8c33bef740db6730eb2a750cd3da6495603";
          sha256 = "0ijvlz6lwdjziry64bvcsh81mp4ik2lg36v5hprwsz6k7ryipiy7";
        };
      };
    };
    "doctrine/sql-formatter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-sql-formatter-25a06c7bf4c6b8218f47928654252863ffc890a5";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/sql-formatter/zipball/25a06c7bf4c6b8218f47928654252863ffc890a5";
          sha256 = "0vhvsrmsa1js8ba9nw5ss0kpv937py3pkvlvxd7zkz1yg038cpl3";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-ebaaf5be6c0286928352e054f2d5125608e5405e";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/ebaaf5be6c0286928352e054f2d5125608e5405e";
          sha256 = "02n4sh0gywqzsl46n9q8hqqgiyva2gj4lxdz9fw4pvhkm1s27wd6";
        };
      };
    };
    "endroid/qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "endroid-qr-code-0db25b506a8411a5e1644ebaa67123a6eb7b6a77";
        src = fetchurl {
          url = "https://api.github.com/repos/endroid/qr-code/zipball/0db25b506a8411a5e1644ebaa67123a6eb7b6a77";
          sha256 = "1xxh8nh6zay6az0cx69v13gkwgfr42a5k79p1cnqfnpqgij3jy3g";
        };
      };
    };
    "erusev/parsedown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "erusev-parsedown-cb17b6477dfff935958ba01325f2e8a2bfa6dab3";
        src = fetchurl {
          url = "https://api.github.com/repos/erusev/parsedown/zipball/cb17b6477dfff935958ba01325f2e8a2bfa6dab3";
          sha256 = "1iil9v8g03m5vpxxg3a5qb2sxd1cs5c4p5i0k00cqjnjsxfrazxd";
        };
      };
    };
    "ezyang/htmlpurifier" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ezyang-htmlpurifier-bbc513d79acf6691fa9cf10f192c90dd2957f18c";
        src = fetchurl {
          url = "https://api.github.com/repos/ezyang/htmlpurifier/zipball/bbc513d79acf6691fa9cf10f192c90dd2957f18c";
          sha256 = "0jg5aw2x872hlxnvz9ck8z322rfdxs86rhzj5lh0q9j7cm377v4a";
        };
      };
    };
    "friendsofsymfony/rest-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "friendsofsymfony-rest-bundle-e01be8113d4451adb3cbb29d7d2cc96bbc698179";
        src = fetchurl {
          url = "https://api.github.com/repos/FriendsOfSymfony/FOSRestBundle/zipball/e01be8113d4451adb3cbb29d7d2cc96bbc698179";
          sha256 = "1rswp88h5jbw8npyfln14jiznagjlnykxcxczc0w7crzzj4pxjxc";
        };
      };
    };
    "gedmo/doctrine-extensions" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "gedmo-doctrine-extensions-3b5b5cba476b4ae32a55ef69ef2e59d64d5893cf";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine-extensions/DoctrineExtensions/zipball/3b5b5cba476b4ae32a55ef69ef2e59d64d5893cf";
          sha256 = "1gpswmj8f3i8fc2n1wkcwq2nwyqb34fddghg4q9iq1sazsyc08q6";
        };
      };
    };
    "jms/metadata" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jms-metadata-7ca240dcac0c655eb15933ee55736ccd2ea0d7a6";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/metadata/zipball/7ca240dcac0c655eb15933ee55736ccd2ea0d7a6";
          sha256 = "1lwkv4f3vcba8p4r50a46572j1rhw2d60bgs3jd29xzsd292c4vd";
        };
      };
    };
    "jms/serializer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jms-serializer-111451f43abb448ce297361a8ab96a9591e848cd";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/serializer/zipball/111451f43abb448ce297361a8ab96a9591e848cd";
          sha256 = "03fwjg41l2xwf5lsxz4iagchq0g7m1dnj2z1ax44b30wiqvxpxv7";
        };
      };
    };
    "jms/serializer-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jms-serializer-bundle-6fa2dd0083e00fe21c5da171556d7ecabc14b437";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/JMSSerializerBundle/zipball/6fa2dd0083e00fe21c5da171556d7ecabc14b437";
          sha256 = "0vyza5vra9h9wlaa2rsbh19q1hmwcm4y6j21p1h9x8p8cck35pw5";
        };
      };
    };
    "kevinpapst/tabler-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "kevinpapst-tabler-bundle-c9a9dbf160094f2b2987f74cc15eade974793f14";
        src = fetchurl {
          url = "https://api.github.com/repos/kevinpapst/TablerBundle/zipball/c9a9dbf160094f2b2987f74cc15eade974793f14";
          sha256 = "012w8wa2dfpsf7cd5xj6p2pa8376bzi6hm8h299bwk21qhldp909";
        };
      };
    };
    "league/csv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-csv-34bf0df7340b60824b9449b5c526fcc3325070d5";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/csv/zipball/34bf0df7340b60824b9449b5c526fcc3325070d5";
          sha256 = "09v175w3b6nikijjrnm97733207frp2qd7m94iazyd6hm0g3vlnk";
        };
      };
    };
    "lorenzo/pinky" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "lorenzo-pinky-e1b1bdb2c132b8a7ba32bca64d2443f646ddbd17";
        src = fetchurl {
          url = "https://api.github.com/repos/lorenzo/pinky/zipball/e1b1bdb2c132b8a7ba32bca64d2443f646ddbd17";
          sha256 = "1hgbz01ziz5z2fghpn5ln1ci6p3qpklvnlc2mcrjfrzrls902ggs";
        };
      };
    };
    "maennchen/zipstream-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maennchen-zipstream-php-b8174494eda667f7d13876b4a7bfef0f62a7c0d1";
        src = fetchurl {
          url = "https://api.github.com/repos/maennchen/ZipStream-PHP/zipball/b8174494eda667f7d13876b4a7bfef0f62a7c0d1";
          sha256 = "1415m1x0x78hxga0saz9p7ar8s4znigl0297kwl0nn1hbklin68d";
        };
      };
    };
    "markbaker/complex" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "markbaker-complex-95c56caa1cf5c766ad6d65b6344b807c1e8405b9";
        src = fetchurl {
          url = "https://api.github.com/repos/MarkBaker/PHPComplex/zipball/95c56caa1cf5c766ad6d65b6344b807c1e8405b9";
          sha256 = "081lm0svcrs9m3dr2n6w688d6y3kq7axls4sqal462iq77wldjyj";
        };
      };
    };
    "markbaker/matrix" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "markbaker-matrix-728434227fe21be27ff6d86621a1b13107a2562c";
        src = fetchurl {
          url = "https://api.github.com/repos/MarkBaker/PHPMatrix/zipball/728434227fe21be27ff6d86621a1b13107a2562c";
          sha256 = "08cwxvb9j0amnqzg40rhgfvzhqa3bralnb3vc18syaw3yvd499p3";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-c915e2634718dbc8a4a15c61b0e62e7a44e14448";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/c915e2634718dbc8a4a15c61b0e62e7a44e14448";
          sha256 = "1sqqjdg75vc578zrm6xklmk9928l4dc7csjvlpln331b8rnai8hs";
        };
      };
    };
    "mpdf/mpdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mpdf-mpdf-596a87b876d7793be7be060a8ac13424de120dd5";
        src = fetchurl {
          url = "https://api.github.com/repos/mpdf/mpdf/zipball/596a87b876d7793be7be060a8ac13424de120dd5";
          sha256 = "1c6qvx8x6pjjyc4jrc9fy8i91b43aw0i9qvcrq79f4s2zz9r467z";
        };
      };
    };
    "mpdf/psr-http-message-shim" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mpdf-psr-http-message-shim-f25a0153d645e234f9db42e5433b16d9b113920f";
        src = fetchurl {
          url = "https://api.github.com/repos/mpdf/psr-http-message-shim/zipball/f25a0153d645e234f9db42e5433b16d9b113920f";
          sha256 = "17n8iwy9klac5fr8ri93ymzrgqzp1i9mvz40wwmxfngf4cl6c0d5";
        };
      };
    };
    "mpdf/psr-log-aware-trait" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mpdf-psr-log-aware-trait-a633da6065e946cc491e1c962850344bb0bf3e78";
        src = fetchurl {
          url = "https://api.github.com/repos/mpdf/psr-log-aware-trait/zipball/a633da6065e946cc491e1c962850344bb0bf3e78";
          sha256 = "1qdjzfwdnif6c8ry4halnzhdvg1b554f07rf6iz3szz7j10gp1gb";
        };
      };
    };
    "myclabs/deep-copy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myclabs-deep-copy-7284c22080590fb39f2ffa3e9057f10a4ddd0e0c";
        src = fetchurl {
          url = "https://api.github.com/repos/myclabs/DeepCopy/zipball/7284c22080590fb39f2ffa3e9057f10a4ddd0e0c";
          sha256 = "16k44y94bcr439bsxm5158xvmlyraph2c6n17qa5y29b04jqdw5j";
        };
      };
    };
    "nelmio/api-doc-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nelmio-api-doc-bundle-2360674a7bd8bbf5fb834b08e89662b6ad851618";
        src = fetchurl {
          url = "https://api.github.com/repos/nelmio/NelmioApiDocBundle/zipball/2360674a7bd8bbf5fb834b08e89662b6ad851618";
          sha256 = "1xbz551jxsr085pp7s32915hgrrlzk2gjgjxpvbb9a1x96i23afx";
        };
      };
    };
    "nelmio/cors-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nelmio-cors-bundle-78fcdb91f76b080a1008133def9c7f613833933d";
        src = fetchurl {
          url = "https://api.github.com/repos/nelmio/NelmioCorsBundle/zipball/78fcdb91f76b080a1008133def9c7f613833933d";
          sha256 = "1lymnkqs82q34qym9vr3677xzyzj0w4xly0ih5164siq4832mh3l";
        };
      };
    };
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-b22a57ebd13e838b90df5d3346090bc37056409d";
        src = fetchurl {
          url = "https://api.github.com/repos/onelogin/php-saml/zipball/b22a57ebd13e838b90df5d3346090bc37056409d";
          sha256 = "1bi65bi04a26zmaz7ms0qyg6i86k4cd9g8qs7dp1pphpvflgz461";
        };
      };
    };
    "pagerfanta/pagerfanta" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pagerfanta-pagerfanta-a07c84296e491add39d103b812129de77610c33b";
        src = fetchurl {
          url = "https://api.github.com/repos/BabDev/Pagerfanta/zipball/a07c84296e491add39d103b812129de77610c33b";
          sha256 = "02jjandfh01mbss7gspmmj4ianlf7zp8hsva76mwwchvm22jnpby";
        };
      };
    };
    "paragonie/constant_time_encoding" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-constant_time_encoding-58c3f47f650c94ec05a151692652a868995d2938";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/58c3f47f650c94ec05a151692652a868995d2938";
          sha256 = "0i9km0lzvc7df9758fm1p3y0679pzvr5m9x3mrz0d2hxlppsm764";
        };
      };
    };
    "paragonie/random_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-random_compat-996434e5492cb4c3edcb9168db6fbb1359ef965a";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/random_compat/zipball/996434e5492cb4c3edcb9168db6fbb1359ef965a";
          sha256 = "0ky7lal59dihf969r1k3pb96ql8zzdc5062jdbg69j6rj0scgkyx";
        };
      };
    };
    "phpdocumentor/reflection-common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-common-1d01c49d4ed62f25aa84a747ad35d5a16924662b";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/ReflectionCommon/zipball/1d01c49d4ed62f25aa84a747ad35d5a16924662b";
          sha256 = "1wx720a17i24471jf8z499dnkijzb4b8xra11kvw9g9hhzfadz1r";
        };
      };
    };
    "phpdocumentor/reflection-docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-docblock-622548b623e81ca6d78b721c5e029f4ce664f170";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/ReflectionDocBlock/zipball/622548b623e81ca6d78b721c5e029f4ce664f170";
          sha256 = "1vs0fhpqk8s9bc0sqyfhpbs63q14lfjg1f0c1dw4jz97145j6r1n";
        };
      };
    };
    "phpdocumentor/type-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-type-resolver-fad452781b3d774e3337b0c0b245dd8e5a4455fc";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/TypeResolver/zipball/fad452781b3d774e3337b0c0b245dd8e5a4455fc";
          sha256 = "1z75rvw5nmfb5f744b6x1acyhlams830agw10n33d222smbymchx";
        };
      };
    };
    "phpoffice/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoffice-math-f0f8cad98624459c540cdd61d2a174d834471773";
        src = fetchurl {
          url = "https://api.github.com/repos/PHPOffice/Math/zipball/f0f8cad98624459c540cdd61d2a174d834471773";
          sha256 = "0fkda40m017g9yc90zfq1n4hd53zxd4pcyq7ppxddl92hyma0sci";
        };
      };
    };
    "phpoffice/phpspreadsheet" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoffice-phpspreadsheet-fde2ccf55eaef7e86021ff1acce26479160a0fa0";
        src = fetchurl {
          url = "https://api.github.com/repos/PHPOffice/PhpSpreadsheet/zipball/fde2ccf55eaef7e86021ff1acce26479160a0fa0";
          sha256 = "1zba9gm4fzvkwddfbwjc7syq2m5jikjfjdpa5dbmyhxffbqhy589";
        };
      };
    };
    "phpoffice/phpword" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoffice-phpword-e76b701ef538cb749641514fcbc31a68078550fa";
        src = fetchurl {
          url = "https://api.github.com/repos/PHPOffice/PHPWord/zipball/e76b701ef538cb749641514fcbc31a68078550fa";
          sha256 = "1j9viqgb7nrgmj3q8nv622h0sfh28py8sa59x2gdsi0bjq12jwgy";
        };
      };
    };
    "phpstan/phpdoc-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpdoc-parser-bd84b629c8de41aa2ae82c067c955e06f1b00240";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpdoc-parser/zipball/bd84b629c8de41aa2ae82c067c955e06f1b00240";
          sha256 = "0zrq4hd5sg45szdksyb0vq7iz8ksksf2ladq75ri0smpxqjd4bp2";
        };
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-cache-aa5030cfa5405eccfdcb1083ce040c2cb8d253bf";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/cache/zipball/aa5030cfa5405eccfdcb1083ce040c2cb8d253bf";
          sha256 = "07rnyjwb445sfj30v5ny3gfsgc1m7j7cyvwjgs2cm9slns1k1ml8";
        };
      };
    };
    "psr/clock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-clock-e41a24703d4560fd0acb709162f73b8adfc3aa0d";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/clock/zipball/e41a24703d4560fd0acb709162f73b8adfc3aa0d";
          sha256 = "0wz5b8hgkxn3jg88cb3901hj71axsj0fil6pwl413igghch6i8kj";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-c71ecc56dfe541dbd90c5360474fbc405f8d5963";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/c71ecc56dfe541dbd90c5360474fbc405f8d5963";
          sha256 = "1mvan38yb65hwk68hl0p7jymwzr4zfnaxmwjbw7nj3rsknvga49i";
        };
      };
    };
    "psr/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-event-dispatcher-dbefd12671e8a14ec7f180cab83036ed26714bb0";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/event-dispatcher/zipball/dbefd12671e8a14ec7f180cab83036ed26714bb0";
          sha256 = "05nicsd9lwl467bsv4sn44fjnnvqvzj1xqw2mmz9bac9zm66fsjd";
        };
      };
    };
    "psr/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-client-bb5906edc1c324c9a05aa0873d40117941e5fa90";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/bb5906edc1c324c9a05aa0873d40117941e5fa90";
          sha256 = "1dfyjqj1bs2n2zddk8402v6rjq93fq26hwr0rjh53m11wy1wagsx";
        };
      };
    };
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-e616d01114759c4c489f93b099585439f795fe35";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/e616d01114759c4c489f93b099585439f795fe35";
          sha256 = "1vzimn3h01lfz0jx0lh3cy9whr3kdh103m1fw07qric4pnnz5kx8";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-402d35bcb92c70c026d1a6a9883f06b2ead23d71";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/402d35bcb92c70c026d1a6a9883f06b2ead23d71";
          sha256 = "13cnlzrh344n00sgkrp5cgbkr8dznd99c3jfnpl0wg1fdv1x4qfm";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-fe5ea303b0887d5caefd3d431c3e61ad47037001";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/fe5ea303b0887d5caefd3d431c3e61ad47037001";
          sha256 = "0a0rwg38vdkmal3nwsgx58z06qkfl85w2yvhbgwg45anr0b3bhmv";
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-simple-cache-764e0b3939f5ca87cb904f570ef9be2d78a07865";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/simple-cache/zipball/764e0b3939f5ca87cb904f570ef9be2d78a07865";
          sha256 = "0hgcanvd9gqwkaaaq41lh8fsfdraxmp2n611lvqv69jwm1iy76g8";
        };
      };
    };
    "robrichards/xmlseclibs" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "robrichards-xmlseclibs-f8f19e58f26cdb42c54b214ff8a820760292f8df";
        src = fetchurl {
          url = "https://api.github.com/repos/robrichards/xmlseclibs/zipball/f8f19e58f26cdb42c54b214ff8a820760292f8df";
          sha256 = "01zlpm36rrdj310cfmiz2fnabszxd3fq80fa8x8j3f9ki7dvhh5y";
        };
      };
    };
    "scheb/2fa-backup-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "scheb-2fa-backup-code-1ad84e7eb26eb425c609e03097cac99387dde44c";
        src = fetchurl {
          url = "https://api.github.com/repos/scheb/2fa-backup-code/zipball/1ad84e7eb26eb425c609e03097cac99387dde44c";
          sha256 = "1arw0vz19r5jg9s0hi1alw1lriz576yj27cyc4pvsjwcv7divrpa";
        };
      };
    };
    "scheb/2fa-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "scheb-2fa-bundle-6e51477c53070f27ac3e3d36be1a991870db415a";
        src = fetchurl {
          url = "https://api.github.com/repos/scheb/2fa-bundle/zipball/6e51477c53070f27ac3e3d36be1a991870db415a";
          sha256 = "0q8cqlrmjsx46m7irbxylsjn9a5h37fgjpmf31xj11nfn0by2q36";
        };
      };
    };
    "scheb/2fa-totp" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "scheb-2fa-totp-a233f4638b75941e97f089c4c917f6101f2983e3";
        src = fetchurl {
          url = "https://api.github.com/repos/scheb/2fa-totp/zipball/a233f4638b75941e97f089c4c917f6101f2983e3";
          sha256 = "0qqbmnir72i9zzlxmb96m9p971880ngkgjwx6ylhv40s9vkvi1g8";
        };
      };
    };
    "setasign/fpdi" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "setasign-fpdi-a6db878129ec6c7e141316ee71872923e7f1b7ad";
        src = fetchurl {
          url = "https://api.github.com/repos/Setasign/FPDI/zipball/a6db878129ec6c7e141316ee71872923e7f1b7ad";
          sha256 = "13wp8jrrrfkm8msnkfxbay8rhah4215gxslfrs8y8fm26gydbf54";
        };
      };
    };
    "spomky-labs/otphp" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spomky-labs-otphp-9a1569038bb1c8e98040b14b8bcbba54f25e7795";
        src = fetchurl {
          url = "https://api.github.com/repos/Spomky-Labs/otphp/zipball/9a1569038bb1c8e98040b14b8bcbba54f25e7795";
          sha256 = "1nm2qf4la9cgs5ghry5496ni536308gicg52fiy20z0lmlpryg15";
        };
      };
    };
    "symfony/asset" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-asset-c1108eb27a61ef4ac29504ef61c028648308036c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/asset/zipball/c1108eb27a61ef4ac29504ef61c028648308036c";
          sha256 = "0id5w1j1h3yr0myflxazfkx8wh056yx703y7gp4ykvwgydn4qhna";
        };
      };
    };
    "symfony/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-14a75869bbb41cb35bc5d9d322473928c6f3f978";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache/zipball/14a75869bbb41cb35bc5d9d322473928c6f3f978";
          sha256 = "176fa1hfnndiy7a49b7ms4gb6vdj25y7wajfa0mgaas3qd75zyxi";
        };
      };
    };
    "symfony/cache-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-contracts-1d74b127da04ffa87aa940abe15446fa89653778";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache-contracts/zipball/1d74b127da04ffa87aa940abe15446fa89653778";
          sha256 = "0n8zxm1qqlgzhk3f23s2bjll6il7qkszh1kr9p7hx895vp0rnk9c";
        };
      };
    };
    "symfony/clock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-clock-0639710e65f73cc504167958ea29be6de5c7177a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/clock/zipball/0639710e65f73cc504167958ea29be6de5c7177a";
          sha256 = "1cdjrvjzvxnvpvm71v74yqmm13ly5ilqmw819nz9gw30nkih8w48";
        };
      };
    };
    "symfony/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-config-5d33e0fb707d603330e0edfd4691803a1253572e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/config/zipball/5d33e0fb707d603330e0edfd4691803a1253572e";
          sha256 = "16bnyb06v7r9acplj8wqfw96wil9vk2flq21axjid3d0lml3mbx9";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-0254811a143e6bc6c8deea08b589a7e68a37f625";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/0254811a143e6bc6c8deea08b589a7e68a37f625";
          sha256 = "13j177gq2z3iq60lc7y052233aypflx87qarlpk3qr2slbcskqcs";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-d036c6c0d0b09e24a14a35f8292146a658f986e4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/d036c6c0d0b09e24a14a35f8292146a658f986e4";
          sha256 = "0pvgk0m2g8n6scwfwwmxj6dyqx2854zrkxizyfhpa8ikhh9a6kwj";
        };
      };
    };
    "symfony/dependency-injection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-dependency-injection-226ea431b1eda6f0d9f5a4b278757171960bb195";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/dependency-injection/zipball/226ea431b1eda6f0d9f5a4b278757171960bb195";
          sha256 = "15hjk8p120qhayyl4cgckdnchbcgk06k8xsg9vf9gy3vc39wx9jh";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-7c3aff79d10325257a001fcf92d991f24fc967cf";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/7c3aff79d10325257a001fcf92d991f24fc967cf";
          sha256 = "0p0c2942wjq1bb06y9i8gw6qqj7sin5v5xwsvl0zdgspbr7jk1m9";
        };
      };
    };
    "symfony/doctrine-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-doctrine-bridge-da33f27c1dd9946afecfd1585b867551df71bf53";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/doctrine-bridge/zipball/da33f27c1dd9946afecfd1585b867551df71bf53";
          sha256 = "0pcnr3yg01jjfhv5j3i06yd8fxan4a77jwzx9dyzf8y163fdx1bz";
        };
      };
    };
    "symfony/dotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-dotenv-835f8d2d1022934ac038519de40b88158798c96f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/dotenv/zipball/835f8d2d1022934ac038519de40b88158798c96f";
          sha256 = "1dcr57bdcpsj4i8fbx5s9p47pgcc788prxs789q8z3qxbj8g0p5m";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-c873490a1c97b3a0a4838afc36ff36c112d02788";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/c873490a1c97b3a0a4838afc36ff36c112d02788";
          sha256 = "0ac4a1zwi1fsisld4rq340y93pimzzlwja3ckx6r7yipb2yzkhib";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-e95216850555cd55e71b857eb9d6c2674124603a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/e95216850555cd55e71b857eb9d6c2674124603a";
          sha256 = "11gzz1hpjigsjs3q8pi9lpgimby1a38f3cyclq4sx0anpar8vpxp";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-a76aed96a42d2b521153fb382d418e30d18b59df";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/a76aed96a42d2b521153fb382d418e30d18b59df";
          sha256 = "1w49s1q6xhcmkgd3xkyjggiwys0wvyny0p3018anvdi0k86zg678";
        };
      };
    };
    "symfony/expression-language" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-expression-language-7d63ccd5331d4164961776eced5524e891e30ad3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/expression-language/zipball/7d63ccd5331d4164961776eced5524e891e30ad3";
          sha256 = "0dz5x5p4frkcdcnnar0akscakg3sm0xr121lqql35cbp2vsyap09";
        };
      };
    };
    "symfony/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-filesystem-952a8cb588c3bc6ce76f6023000fb932f16a6e59";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/filesystem/zipball/952a8cb588c3bc6ce76f6023000fb932f16a6e59";
          sha256 = "0fviv306dd0bhqf6kj5g2svr6i0alfj2gm0fqj5cfl1f35iq4zyw";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-11d736e97f116ac375a81f96e662911a34cd50ce";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/11d736e97f116ac375a81f96e662911a34cd50ce";
          sha256 = "0p0k05jilm3pfckzilfdpwjvmjppwb2dsg4ym9mxk7520qni8msj";
        };
      };
    };
    "symfony/flex" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-flex-6b44ac75c7f07f48159ec36c2d21ef8cf48a21b1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/flex/zipball/6b44ac75c7f07f48159ec36c2d21ef8cf48a21b1";
          sha256 = "0l8mzyb7wps5ss5l67y2z2r2m5zvvyrrzml1cf68i9bh8rq83dk7";
        };
      };
    };
    "symfony/form" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-form-10649ab710b58a04bcf1886f005ccab58d9cf0a4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/form/zipball/10649ab710b58a04bcf1886f005ccab58d9cf0a4";
          sha256 = "09bz7yw954401m3d4ww2vp4lf5mimkfff2hjmh6kj8bixj033zny";
        };
      };
    };
    "symfony/framework-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-framework-bundle-c26a221e0462027d1f9d4a802ed63f8ab07a43d0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/framework-bundle/zipball/c26a221e0462027d1f9d4a802ed63f8ab07a43d0";
          sha256 = "1qlhxkmw6fc998nc8zssjp12vspz78p0wzsb24d3m0z9sh3gh2dj";
        };
      };
    };
    "symfony/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-fc0944665bd932cf32a7b8a1d009466afc16528f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client/zipball/fc0944665bd932cf32a7b8a1d009466afc16528f";
          sha256 = "0c618kvlk4bj8fc1xygwmilbii6slqm9rdkm3cchscgxp4gx4zvm";
        };
      };
    };
    "symfony/http-client-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-contracts-1ee70e699b41909c209a0c930f11034b93578654";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client-contracts/zipball/1ee70e699b41909c209a0c930f11034b93578654";
          sha256 = "181m2alsmj9v8wkzn210g6v41nl2fx519f674p7r9q0m22ivk2ca";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-172d807f9ef3fc3fbed8377cc57c20d389269271";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/172d807f9ef3fc3fbed8377cc57c20d389269271";
          sha256 = "16y6f2h2bhq6k3f2f12clizswgn58b9vy99n4spgxrzaxhdv7k4w";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-13e8387320b5942d0dc408440c888e2d526efef4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/13e8387320b5942d0dc408440c888e2d526efef4";
          sha256 = "005p64hjs0z8p9n8b4wqs4q13xs4prfls0whnwm8c3x3mvawzdrl";
        };
      };
    };
    "symfony/intl" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-intl-4f45148f7eb984ef12b1f7e123205ab904828839";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/intl/zipball/4f45148f7eb984ef12b1f7e123205ab904828839";
          sha256 = "0r4nr5lzp4791nhrm0nyjdbvq4l8wmaf1k51f1k12aq00fhvc7vl";
        };
      };
    };
    "symfony/mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mailer-6da89e5c9202f129717a770a03183fb140720168";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mailer/zipball/6da89e5c9202f129717a770a03183fb140720168";
          sha256 = "06hw72i7chbpb7czyck88iwkrhi0vnhlgma6dvfp6b2z3qr57wc4";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-ca4f58b2ef4baa8f6cecbeca2573f88cd577d205";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/ca4f58b2ef4baa8f6cecbeca2573f88cd577d205";
          sha256 = "0lcq2avf9c8r35lhnbp8v5z5pypls4xxhz9pq5grn2x8n57h9fhk";
        };
      };
    };
    "symfony/monolog-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-monolog-bridge-c262c2f54ce7e160a231808817f306f880c32750";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/monolog-bridge/zipball/c262c2f54ce7e160a231808817f306f880c32750";
          sha256 = "02g9n6xvdg7ak85iys7kh4ri4ibf8vfmb6ibxwh036kmidy1c49i";
        };
      };
    };
    "symfony/monolog-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-monolog-bundle-414f951743f4aa1fd0f5bf6a0e9c16af3fe7f181";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/monolog-bundle/zipball/414f951743f4aa1fd0f5bf6a0e9c16af3fe7f181";
          sha256 = "0sni1jyqj79s4hxpyrdm086xz3dnmpb45zxlfgj29m549n3cahar";
        };
      };
    };
    "symfony/options-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-options-resolver-22301f0e7fdeaacc14318928612dee79be99860e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/options-resolver/zipball/22301f0e7fdeaacc14318928612dee79be99860e";
          sha256 = "1zl13p02d1zd3ndplwq30ql6j5x1pa3adghaqp84zwi4ivwzidnf";
        };
      };
    };
    "symfony/password-hasher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-password-hasher-e001f752338a49d644ee0523fd7891aabaccb7e2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/password-hasher/zipball/e001f752338a49d644ee0523fd7891aabaccb7e2";
          sha256 = "1053md8whnmcad1725jig3n07iabybs1gfhs863zhmvfkfsr0d42";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-875e90aeea2777b6f135677f618529449334a612";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/875e90aeea2777b6f135677f618529449334a612";
          sha256 = "19j8qcbp525q7i61c2lhj6z2diysz45q06d990fvjby15cn0id0i";
        };
      };
    };
    "symfony/polyfill-intl-icu" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-icu-e46b4da57951a16053cd751f63f4a24292788157";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-icu/zipball/e46b4da57951a16053cd751f63f4a24292788157";
          sha256 = "036a2r1p2a8kggldfcqps6azr7xf0wrl9hnp77gksxqlky84fc0c";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-ecaafce9f77234a6a449d29e49267ba10499116d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/ecaafce9f77234a6a449d29e49267ba10499116d";
          sha256 = "0f42w4975rakhysnmhsyw6n3rjg6rjg7b7x8gs1n0qfdb6wc8m3q";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8c4ad05dd0120b6a53c1ca374dca2ad0a1c4ed92";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8c4ad05dd0120b6a53c1ca374dca2ad0a1c4ed92";
          sha256 = "0msah2ii2174xh47v5x9vq1b1xn38yyx03sr3pa2rq3a849wi7nh";
        };
      };
    };
    "symfony/polyfill-php83" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php83-b0f46ebbeeeda3e9d2faebdfbf4b4eae9b59fa11";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php83/zipball/b0f46ebbeeeda3e9d2faebdfbf4b4eae9b59fa11";
          sha256 = "0z0xk1ghssa5qknp7cm3phdam77q4n46bkiwfpc5jkparkq958yb";
        };
      };
    };
    "symfony/property-access" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-property-access-75f6990ae8e8040dd587162f3f1863f755957129";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/property-access/zipball/75f6990ae8e8040dd587162f3f1863f755957129";
          sha256 = "1plbvslwcad8v04a20qb5ffajjj7pylc0q33scj9jrpqd31aiaj3";
        };
      };
    };
    "symfony/property-info" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-property-info-288be71bae2ebc88676f5d3a03d23f70b278fcc1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/property-info/zipball/288be71bae2ebc88676f5d3a03d23f70b278fcc1";
          sha256 = "0kl3a7i9gwmgav95wnakdalpb88kwb4y47h1y700v4al9ygcpvsv";
        };
      };
    };
    "symfony/rate-limiter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-rate-limiter-c32471a8ebe613f6856db4b0544fcf5429d12511";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/rate-limiter/zipball/c32471a8ebe613f6856db4b0544fcf5429d12511";
          sha256 = "1r2m3zwc852lyy2rcgxx5d46s5v42shbhrj52yhlwbg3ljgdncaa";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-98eab13a07fddc85766f1756129c69f207ffbc21";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/98eab13a07fddc85766f1756129c69f207ffbc21";
          sha256 = "0kbzjjwp5b6x03dky8pkz4k5p92rcvaya1px71ldc9llgwrdg5bs";
        };
      };
    };
    "symfony/runtime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-runtime-86539231fadfdc7f7e9911d6fa7ed84a606e7d34";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/runtime/zipball/86539231fadfdc7f7e9911d6fa7ed84a606e7d34";
          sha256 = "1bvl105m7fnamljmngkrmd1kfianhyj6ag4iwg09g9z5xql4l35w";
        };
      };
    };
    "symfony/security-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-security-bundle-97d4fb6dbee700937738036ec54b0fcb0641d7d6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/security-bundle/zipball/97d4fb6dbee700937738036ec54b0fcb0641d7d6";
          sha256 = "1cy4qjdl59xqj3l6iya4kyib8wvaaz7lq8rb9dxa44ar6dahmjcj";
        };
      };
    };
    "symfony/security-core" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-security-core-9e24a7199744d944c03fc1448276dc57f6237a33";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/security-core/zipball/9e24a7199744d944c03fc1448276dc57f6237a33";
          sha256 = "1j8cmdv7syh0g6sx3imlz815xqys42fpl0szsq89d9j084y61q9l";
        };
      };
    };
    "symfony/security-csrf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-security-csrf-b28413496ebfce2f98afbb990ad0ce0ba3586638";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/security-csrf/zipball/b28413496ebfce2f98afbb990ad0ce0ba3586638";
          sha256 = "02igfpbm4xc4kp5i2mzkc2s1pzaqbm016388rfc952x2xdp0m76i";
        };
      };
    };
    "symfony/security-http" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-security-http-1b49ad8e9f2c3ceec011d67ac09e774e4107416b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/security-http/zipball/1b49ad8e9f2c3ceec011d67ac09e774e4107416b";
          sha256 = "11ckpvs7a0vzyl1bdm2paq5607ahi398a0gl0nsiq6gvz6h5jac0";
        };
      };
    };
    "symfony/serializer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-serializer-f87ea9d7bfd4cf2f7b72be554607e6c96e6664af";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/serializer/zipball/f87ea9d7bfd4cf2f7b72be554607e6c96e6664af";
          sha256 = "0r37kyphv6p04jvfyrkglqqigg60j4ajp8h6f5k9x9g971hb1j7w";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-fe07cbc8d837f60caf7018068e350cc5163681a0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/fe07cbc8d837f60caf7018068e350cc5163681a0";
          sha256 = "0gyhi5xhchvhxnbnzjr9xjmbgvwz6s8cvjslbb1603cwgdy7npxh";
        };
      };
    };
    "symfony/stopwatch" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-stopwatch-fc47f1015ec80927ff64ba9094dfe8b9d48fe9f2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/stopwatch/zipball/fc47f1015ec80927ff64ba9094dfe8b9d48fe9f2";
          sha256 = "0gnpyw9bc4399ycqlqkdsp8nyg63y26629xbp26vh0xdvkfmgwrl";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-7cb80bc10bfcdf6b5492741c0b9357dac66940bc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/7cb80bc10bfcdf6b5492741c0b9357dac66940bc";
          sha256 = "1cmhv18d4wq1wb9v503hrflln89266c2hhi1f995sg4fjqhpwii3";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-a2ab2ec1a462e53016de8e8d5e8912bfd62ea681";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/a2ab2ec1a462e53016de8e8d5e8912bfd62ea681";
          sha256 = "1dky4f4n2wfv0pylqlsv6sqrn89hh1j7ixvxp7dn36c6y2l07533";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-06450585bf65e978026bda220cdebca3f867fde7";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/06450585bf65e978026bda220cdebca3f867fde7";
          sha256 = "1gd7ib8sdvi0byvc497i2d00nn8b0f9xsjgiyfwk0xzidq1dqwpy";
        };
      };
    };
    "symfony/twig-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-twig-bridge-97af829e4733125ee70e806694d56165c60b4ee1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/twig-bridge/zipball/97af829e4733125ee70e806694d56165c60b4ee1";
          sha256 = "0zwbhh1yss2m1fmh5hlym3jxw635s3p3d7j4ihicf8zr8sfqp922";
        };
      };
    };
    "symfony/twig-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-twig-bundle-35d84393e598dfb774e6a2bf49e5229a8a6dbe4c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/twig-bundle/zipball/35d84393e598dfb774e6a2bf49e5229a8a6dbe4c";
          sha256 = "0zfmra3lpqawnqkq0q8b6h3f9ldv9qb1hqhymp47mcarvlyin28l";
        };
      };
    };
    "symfony/validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-validator-15fe2c6ed815b06b6b8636d8ba3ef9807ee1a75c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/validator/zipball/15fe2c6ed815b06b6b8636d8ba3ef9807ee1a75c";
          sha256 = "1fcx1cjl2lvrd9fzvbj0kyqg7cknk8gam1arh47ihj1lw1fg6xgy";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-68d6573ec98715ddcae5a0a85bee3c1c27a4c33f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/68d6573ec98715ddcae5a0a85bee3c1c27a4c33f";
          sha256 = "1ywjv4qxh0a4a0b29cjmzimz2l05smbbxgcj8a3jpjsnjgfyx30y";
        };
      };
    };
    "symfony/var-exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-exporter-5fe9a0021b8d35e67d914716ec8de50716a68e7e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-exporter/zipball/5fe9a0021b8d35e67d914716ec8de50716a68e7e";
          sha256 = "1zzf63ji775j1bd3g57q0pb33j49m2a6sjd0cc0wxjcak0b47h3q";
        };
      };
    };
    "symfony/webpack-encore-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-webpack-encore-bundle-75cb918df3f65e28cf0d4bc03042bc45ccb19dd0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/webpack-encore-bundle/zipball/75cb918df3f65e28cf0d4bc03042bc45ccb19dd0";
          sha256 = "0d79a3r3zigixgql3kd9jw533al26rfpka3nyymjzakq79syvipn";
        };
      };
    };
    "symfony/yaml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-yaml-4f9237a1bb42455d609e6687d2613dde5b41a587";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/yaml/zipball/4f9237a1bb42455d609e6687d2613dde5b41a587";
          sha256 = "1vdk0s7xykg0hlri46d1csqc8im9wzmbcfdrqaypx9l09v8fdkdf";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-83ee6f38df0a63106a9e4536e3060458b74ccedb";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/83ee6f38df0a63106a9e4536e3060458b74ccedb";
          sha256 = "1ahj49c7qz6m3y65jd18cz2c8cg6zqhkmnsrqrw1bf3s8ly9a9bp";
        };
      };
    };
    "twig/cssinliner-extra" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-cssinliner-extra-259a4b861732545e0e1ecd43bf25b251494af45b";
        src = fetchurl {
          url = "https://api.github.com/repos/twigphp/cssinliner-extra/zipball/259a4b861732545e0e1ecd43bf25b251494af45b";
          sha256 = "1fmxjs0dwby4pjgx8dkvw6y4pq3ii4rxgvdhmdz030nn9r9c5rzf";
        };
      };
    };
    "twig/extra-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-extra-bundle-32807183753de0388c8e59f7ac2d13bb47311140";
        src = fetchurl {
          url = "https://api.github.com/repos/twigphp/twig-extra-bundle/zipball/32807183753de0388c8e59f7ac2d13bb47311140";
          sha256 = "0y1lynnviyf24ysh4bvpcjrxa88634hxp66snlfrwqaj0yfk41xn";
        };
      };
    };
    "twig/inky-extra" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-inky-extra-8c12463f6d66697347692b04b12c5c1789dc1a5c";
        src = fetchurl {
          url = "https://api.github.com/repos/twigphp/inky-extra/zipball/8c12463f6d66697347692b04b12c5c1789dc1a5c";
          sha256 = "1ld5q8m1hqcc54kp77rb4qf4nrn8l3xvwr5h3a5s9gw79826ladr";
        };
      };
    };
    "twig/intl-extra" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-intl-extra-7b3db67c700735f473a265a97e1adaeba3e6ca0c";
        src = fetchurl {
          url = "https://api.github.com/repos/twigphp/intl-extra/zipball/7b3db67c700735f473a265a97e1adaeba3e6ca0c";
          sha256 = "1m7an9srrygcp46lys20g2gs4fhpwrmpymkggd4xmaalqrp7wrv5";
        };
      };
    };
    "twig/string-extra" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-string-extra-b0c9037d96baff79abe368dc092a59b726517548";
        src = fetchurl {
          url = "https://api.github.com/repos/twigphp/string-extra/zipball/b0c9037d96baff79abe368dc092a59b726517548";
          sha256 = "0dvf7lnbp8vx081759cylz7w52896kvkdd5mcc489wgm2pg6830c";
        };
      };
    };
    "twig/twig" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-twig-9d15f0ac07f44dc4217883ec6ae02fd555c6f71d";
        src = fetchurl {
          url = "https://api.github.com/repos/twigphp/Twig/zipball/9d15f0ac07f44dc4217883ec6ae02fd555c6f71d";
          sha256 = "1vx01zb8ggccff3yvv3ng02l6k9w2yc38a07wd0n19qam6lis29z";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-11cb2199493b2f8a3b53e7f19068fc6aac760991";
        src = fetchurl {
          url = "https://api.github.com/repos/webmozarts/assert/zipball/11cb2199493b2f8a3b53e7f19068fc6aac760991";
          sha256 = "18qiza1ynwxpi6731jx1w5qsgw98prld1lgvfk54z92b1nc7psix";
        };
      };
    };
    "willdurand/jsonp-callback-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "willdurand-jsonp-callback-validator-738c36e91d4d7e0ff0cac145f77057e0fb88526e";
        src = fetchurl {
          url = "https://api.github.com/repos/willdurand/JsonpCallbackValidator/zipball/738c36e91d4d7e0ff0cac145f77057e0fb88526e";
          sha256 = "03nrx2kahvdrihksg6bb61d1r1vlddwbwk9ibx68c1w3kmv2grai";
        };
      };
    };
    "willdurand/negotiation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "willdurand-negotiation-68e9ea0553ef6e2ee8db5c1d98829f111e623ec2";
        src = fetchurl {
          url = "https://api.github.com/repos/willdurand/Negotiation/zipball/68e9ea0553ef6e2ee8db5c1d98829f111e623ec2";
          sha256 = "03d8jpwkv3bfj2sqdxrfxfj5qimw2na8ndvn8aqqzjixrhl3skb2";
        };
      };
    };
    "zircote/swagger-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "zircote-swagger-php-598958d8a83cfbd44ba36388b2f9ed69e8b86ed4";
        src = fetchurl {
          url = "https://api.github.com/repos/zircote/swagger-php/zipball/598958d8a83cfbd44ba36388b2f9ed69e8b86ed4";
          sha256 = "090563d2s9p5r46nvz9lldi44fv1ri0g58lr69df4yv6y265b697";
        };
      };
    };
  };
  devPackages = {
    "composer/pcre" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-pcre-00104306927c7a0919b4ced2aaa6782c1e61a3c9";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/pcre/zipball/00104306927c7a0919b4ced2aaa6782c1e61a3c9";
          sha256 = "0y7adswd7hq9fsnwqdkrjwimnpzyklw71myypybm65xk43wf3ck8";
        };
      };
    };
    "composer/xdebug-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-xdebug-handler-ced299686f41dce890debac69273b47ffe98a40c";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/xdebug-handler/zipball/ced299686f41dce890debac69273b47ffe98a40c";
          sha256 = "1hnhrp26mk3zjsp6cl351b12bcbbbdglc677vjz9n8l7qj466b0h";
        };
      };
    };
    "dama/doctrine-test-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dama-doctrine-test-bundle-688eea6529ea894b83deada10c83662d7804f34b";
        src = fetchurl {
          url = "https://api.github.com/repos/dmaicher/doctrine-test-bundle/zipball/688eea6529ea894b83deada10c83662d7804f34b";
          sha256 = "13fwy9rvlkkgszw7a84f4r9y47qldyhf25sc8nwjcp59mh6x905s";
        };
      };
    };
    "doctrine/data-fixtures" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-data-fixtures-bbcb74f2ac6dbe81a14b3c3687d7623490a0448f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/data-fixtures/zipball/bbcb74f2ac6dbe81a14b3c3687d7623490a0448f";
          sha256 = "02vissj2gvqhh3mqgfzp7yi7h6g1h2pg9lvxqqw2vfiz8k8dgcsc";
        };
      };
    };
    "doctrine/doctrine-fixtures-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-doctrine-fixtures-bundle-c808a0c85c38c8ee265cc8405b456c1d2b38567d";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/DoctrineFixturesBundle/zipball/c808a0c85c38c8ee265cc8405b456c1d2b38567d";
          sha256 = "0hkdq75zzx3sfpi72k7hpkdimyzs3rskn1xzfc9b650fx97anmh5";
        };
      };
    };
    "fakerphp/faker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fakerphp-faker-bfb4fe148adbf78eff521199619b93a52ae3554b";
        src = fetchurl {
          url = "https://api.github.com/repos/FakerPHP/Faker/zipball/bfb4fe148adbf78eff521199619b93a52ae3554b";
          sha256 = "0iv7a1r7n2js07dl9xvc9v3x3nvln4z7i6pmlgyvz1lj3czyfmqm";
        };
      };
    };
    "friendsofphp/php-cs-fixer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "friendsofphp-php-cs-fixer-a92472c6fb66349de25211f31c77eceae3df024e";
        src = fetchurl {
          url = "https://api.github.com/repos/PHP-CS-Fixer/PHP-CS-Fixer/zipball/a92472c6fb66349de25211f31c77eceae3df024e";
          sha256 = "0khrg7mp744kgk640cw8sw9x5ndvqj1jawwvkbkgznfp04rp8swk";
        };
      };
    };
    "masterminds/html5" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "masterminds-html5-f47dcf3c70c584de14f21143c55d9939631bc6cf";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/f47dcf3c70c584de14f21143c55d9939631bc6cf";
          sha256 = "1n2xiyxqmxk9g34wn1lg2yyivwg2ry8iqk8m7g2432gm97rmyb20";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-4a21235f7e56e713259a6f76bf4b5ea08502b9dc";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/4a21235f7e56e713259a6f76bf4b5ea08502b9dc";
          sha256 = "18ziyx7825wkrgvyc79mql7lv9vly72rmjyhckjkpswq8vg9a71y";
        };
      };
    };
    "phar-io/manifest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-manifest-97803eca37d319dfa7826cc2437fc020857acb53";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/manifest/zipball/97803eca37d319dfa7826cc2437fc020857acb53";
          sha256 = "107dsj04ckswywc84dvw42kdrqd4y6yvb2qwacigyrn05p075c1w";
        };
      };
    };
    "phar-io/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-version-4f7fd7836c6f332bb2933569e566a0d6c4cbed74";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/version/zipball/4f7fd7836c6f332bb2933569e566a0d6c4cbed74";
          sha256 = "0mdbzh1y0m2vvpf54vw7ckcbcf1yfhivwxgc9j9rbb7yifmlyvsg";
        };
      };
    };
    "phpstan/phpstan" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpstan-27816a01aea996191ee14d010f325434c0ee76fa";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpstan/zipball/27816a01aea996191ee14d010f325434c0ee76fa";
          sha256 = "1yrfqlsp5hxmc94lpv456nmbyq8zcnc672dqflwbvpf2q1n4637w";
        };
      };
    };
    "phpstan/phpstan-doctrine" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpstan-doctrine-9534fcd0b6906c62594146b506acadeabd3a99b3";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpstan-doctrine/zipball/9534fcd0b6906c62594146b506acadeabd3a99b3";
          sha256 = "143wi4ah5mc4pdsgxrnzzzfdar8d5rl5hb648phl9dclfxs7y07h";
        };
      };
    };
    "phpstan/phpstan-phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpstan-phpunit-70ecacc64fe8090d8d2a33db5a51fe8e88acd93a";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpstan-phpunit/zipball/70ecacc64fe8090d8d2a33db5a51fe8e88acd93a";
          sha256 = "1bbqlvz1ppn1vfzfn72lj1qqxmr6khnjczxjb4djry58qma19x34";
        };
      };
    };
    "phpstan/phpstan-strict-rules" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpstan-strict-rules-7a50e9662ee9f3942e4aaaf3d603653f60282542";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpstan-strict-rules/zipball/7a50e9662ee9f3942e4aaaf3d603653f60282542";
          sha256 = "05xn7jmw3yz3s2wr4svnjfbvqz834frr0w61dzdvf341q0a3p7r6";
        };
      };
    };
    "phpstan/phpstan-symfony" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpstan-phpstan-symfony-ef7db637be9b85fa00278fc3477ac66abe8eb7d1";
        src = fetchurl {
          url = "https://api.github.com/repos/phpstan/phpstan-symfony/zipball/ef7db637be9b85fa00278fc3477ac66abe8eb7d1";
          sha256 = "184i8w0shb91b9cyfjifm7xg8i967wdbvbbbnxj42i7m96lqag57";
        };
      };
    };
    "phpunit/php-code-coverage" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-code-coverage-ca2bd87d2f9215904682a9cb9bb37dda98e76089";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-code-coverage/zipball/ca2bd87d2f9215904682a9cb9bb37dda98e76089";
          sha256 = "1q6nmraphj50rn9xqm9qh2xpgkb9yc45ahi39qa6a8nizqp3k3dk";
        };
      };
    };
    "phpunit/php-file-iterator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-file-iterator-cf1c2e7c203ac650e352f4cc675a7021e7d1b3cf";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-file-iterator/zipball/cf1c2e7c203ac650e352f4cc675a7021e7d1b3cf";
          sha256 = "1407d8f1h35w4sdikq2n6cz726css2xjvlyr1m4l9a53544zxcnr";
        };
      };
    };
    "phpunit/php-invoker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-invoker-5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-invoker/zipball/5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
          sha256 = "1vqnnjnw94mzm30n9n5p2bfgd3wd5jah92q6cj3gz1nf0qigr4fh";
        };
      };
    };
    "phpunit/php-text-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-text-template-5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-text-template/zipball/5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
          sha256 = "0ff87yzywizi6j2ps3w0nalpx16mfyw3imzn6gj9jjsfwc2bb8lq";
        };
      };
    };
    "phpunit/php-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-timer-5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-timer/zipball/5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
          sha256 = "0g1g7yy4zk1bidyh165fsbqx5y8f1c8pxikvcahzlfsr9p2qxk6a";
        };
      };
    };
    "phpunit/phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-phpunit-954ca3113a03bf780d22f07bf055d883ee04b65e";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/phpunit/zipball/954ca3113a03bf780d22f07bf055d883ee04b65e";
          sha256 = "16k48778pl6jsdaqkd5k5mfc65d1vhjp04qjpx70xnsw9f6gdsbk";
        };
      };
    };
    "sebastian/cli-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-cli-parser-442e7c7e687e42adc03470c7b668bc4b2402c0b2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/cli-parser/zipball/442e7c7e687e42adc03470c7b668bc4b2402c0b2";
          sha256 = "074qzdq19k9x4svhq3nak5h348xska56v1sqnhk1aj0jnrx02h37";
        };
      };
    };
    "sebastian/code-unit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-1fc9f64c0927627ef78ba436c9b17d967e68e120";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit/zipball/1fc9f64c0927627ef78ba436c9b17d967e68e120";
          sha256 = "04vlx050rrd54mxal7d93pz4119pas17w3gg5h532anfxjw8j7pm";
        };
      };
    };
    "sebastian/code-unit-reverse-lookup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-reverse-lookup-ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit-reverse-lookup/zipball/ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
          sha256 = "1h1jbzz3zak19qi4mab2yd0ddblpz7p000jfyxfwd2ds0gmrnsja";
        };
      };
    };
    "sebastian/comparator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-comparator-fa0f136dd2334583309d32b62544682ee972b51a";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/comparator/zipball/fa0f136dd2334583309d32b62544682ee972b51a";
          sha256 = "0m8ibkwaxw2q5v84rlvy7ylpkddscsa8hng0cjczy4bqpqavr83w";
        };
      };
    };
    "sebastian/complexity" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-complexity-25f207c40d62b8b7aa32f5ab026c53561964053a";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/complexity/zipball/25f207c40d62b8b7aa32f5ab026c53561964053a";
          sha256 = "1k8w6z8zcym3y5s0riami9667s0gd206jr3za6pkbb90zzj6b76g";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-74be17022044ebaaecfdf0c5cd504fc9cd5a7131";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/diff/zipball/74be17022044ebaaecfdf0c5cd504fc9cd5a7131";
          sha256 = "0f90471bi8lkmffms3bc2dnggqv8a81y1f4gi7p3r5120328mjm0";
        };
      };
    };
    "sebastian/environment" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-environment-830c43a844f1f8d5b7a1f6d6076b784454d8b7ed";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/environment/zipball/830c43a844f1f8d5b7a1f6d6076b784454d8b7ed";
          sha256 = "02045n3in01zk571v1phyhj0b2mvnvx8qnlqvw4j33r7qdd4clzn";
        };
      };
    };
    "sebastian/exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-exporter-ac230ed27f0f98f597c8a2b6eb7ac563af5e5b9d";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/exporter/zipball/ac230ed27f0f98f597c8a2b6eb7ac563af5e5b9d";
          sha256 = "1a6yj8v8rwj3igip8xysdifvbd7gkzmwrj9whdx951pdq7add46j";
        };
      };
    };
    "sebastian/global-state" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-global-state-bde739e7565280bda77be70044ac1047bc007e34";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/global-state/zipball/bde739e7565280bda77be70044ac1047bc007e34";
          sha256 = "0lk9hbvrma0jm4z2nm8dr94w0pinlnp6wzcczcm1cjkm4zx0yabw";
        };
      };
    };
    "sebastian/lines-of-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-lines-of-code-e1e4a170560925c26d424b6a03aed157e7dcc5c5";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/lines-of-code/zipball/e1e4a170560925c26d424b6a03aed157e7dcc5c5";
          sha256 = "1ycasbrcsmyqszihx730l9krh2inj72xkpvb2fqd5y5xn4r8va2g";
        };
      };
    };
    "sebastian/object-enumerator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-enumerator-5c9eeac41b290a3712d88851518825ad78f45c71";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-enumerator/zipball/5c9eeac41b290a3712d88851518825ad78f45c71";
          sha256 = "11853z07w8h1a67wsjy3a6ir5x7khgx6iw5bmrkhjkiyvandqcn1";
        };
      };
    };
    "sebastian/object-reflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-reflector-b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-reflector/zipball/b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
          sha256 = "0g5m1fswy6wlf300x1vcipjdljmd3vh05hjqhqfc91byrjbk4rsg";
        };
      };
    };
    "sebastian/recursion-context" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-recursion-context-e75bd0f07204fec2a0af9b0f3cfe97d05f92efc1";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/recursion-context/zipball/e75bd0f07204fec2a0af9b0f3cfe97d05f92efc1";
          sha256 = "1ag6ysxffhxyg7g4rj9xjjlwq853r4x92mmin4f09hn5mqn9f0l1";
        };
      };
    };
    "sebastian/resource-operations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-resource-operations-0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/resource-operations/zipball/0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
          sha256 = "0p5s8rp7mrhw20yz5wx1i4k8ywf0h0ximcqan39n9qnma1dlnbyr";
        };
      };
    };
    "sebastian/type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-type-75e2c2a32f5e0b3aef905b9ed0b179b953b3d7c7";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/type/zipball/75e2c2a32f5e0b3aef905b9ed0b179b953b3d7c7";
          sha256 = "0bvfvb62qbpy2hzxs4bjzb0xhks6h3cp6qx96z4qlyz6wl2fa1w5";
        };
      };
    };
    "sebastian/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-version-c6c1022351a901512170118436c764e473f6de8c";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/version/zipball/c6c1022351a901512170118436c764e473f6de8c";
          sha256 = "1bs7bwa9m0fin1zdk7vqy5lxzlfa9la90lkl27sn0wr00m745ig1";
        };
      };
    };
    "symfony/browser-kit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-browser-kit-a3bb210e001580ec75e1d02b27fae3452e6bf502";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/browser-kit/zipball/a3bb210e001580ec75e1d02b27fae3452e6bf502";
          sha256 = "0lqcjv3jaf6f8lkrq0b3nzdz2l7b71qyz3hp61gfcdln6jmacwcg";
        };
      };
    };
    "symfony/debug-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-bundle-1e07027423d1d37125b60a50997ada26a9d9d202";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/debug-bundle/zipball/1e07027423d1d37125b60a50997ada26a9d9d202";
          sha256 = "0rwkpdh1y2dw62970na5qr2nf3pq86s7ylsz8x6aqp1hxxxizxsb";
        };
      };
    };
    "symfony/dom-crawler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-dom-crawler-14ff4fd2a5c8969d6158dbe7ef5b17d6a9c6ba33";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/dom-crawler/zipball/14ff4fd2a5c8969d6158dbe7ef5b17d6a9c6ba33";
          sha256 = "1ic6k9pabn6f23h3rahvq481ks5fmczqa6j9z0il98hbc6cmvwc9";
        };
      };
    };
    "symfony/phpunit-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-phpunit-bridge-bd0455b7888e4adac29cf175d819c51f88fed942";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/phpunit-bridge/zipball/bd0455b7888e4adac29cf175d819c51f88fed942";
          sha256 = "1pyhd9gflliqqpjw698k4nszx8vd6k5xw3xznv55vfdzy6dkwas7";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-c4b1ef0bc80533d87a2e969806172f1c2a980241";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/c4b1ef0bc80533d87a2e969806172f1c2a980241";
          sha256 = "1p8p6lyh20flscy0rmpdfyjzir5qhik6h2nz3h95qxrw27aimbj0";
        };
      };
    };
    "symfony/web-profiler-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-web-profiler-bundle-38462d16856740ec0d1ba2cb902eebf09100dde2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/web-profiler-bundle/zipball/38462d16856740ec0d1ba2cb902eebf09100dde2";
          sha256 = "1alfwcv74bwdfsps0q5kw5yi0ykz2961gbg8fj9qsj6r2pgnlcx8";
        };
      };
    };
    "theseer/tokenizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "theseer-tokenizer-b2ad5003ca10d4ee50a12da31de12a5774ba6b96";
        src = fetchurl {
          url = "https://api.github.com/repos/theseer/tokenizer/zipball/b2ad5003ca10d4ee50a12da31de12a5774ba6b96";
          sha256 = "03yw81yj8m9dzbifx0zj455jw59fwbiqidaqq2vyh56a6k5sdkgb";
        };
      };
    };
  };
  gitSrc = fetchFromGitHub {
    owner = "kimai";
    repo = "kimai";
    rev = "refs/tags/2.10.0";
    hash = "sha256-VFUBtaT5zEM0ttJDBHHs+OYGg7WDKxA2YAaGYXUu98Q=";
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "kimai";
  src = gitSrc;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "AGPL-3.0-or-later";
    description = "Kimai is a web-based multi-user time-tracking application. Works great for everyone: freelancers, companies, organizations - everyone can track their times, generate reports, create invoices and do so much more. SaaS version available at https://www.kimai.cloud";
  };
}
