# This file is generated from generate_nix.rb
# Execute the following command in a temporary directory to update the file.
#
# ruby generate_nix.rb > default.nix

{ stdenv, fetchurl, config
, alsaLib
, atk
, cairo
, cups
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gconf
, gdk_pixbuf
, glib
, glibc
, gst_plugins_base
, gstreamer
, gtk
, libX11
, libXScrnSaver
, libXext
, libXinerama
, libXrender
, libXt
, libcanberra
, libgnome
, libgnomeui
, mesa
, nspr
, nss
, pango
, heimdal
, pulseaudio
, systemd
}:

let
  version = "31.0";
  sources = [
    { locale = "ach"; arch = "linux-i686"; sha256 = "8372c1227b75486e297fd914bac530a45b22b789e627638e010d4c25337f350f"; }
    { locale = "ach"; arch = "linux-x86_64"; sha256 = "e01412aa570a462a3bb1ba851cd7133014b3299c0ad349c15534edc35c6d6397"; }
    { locale = "af"; arch = "linux-i686"; sha256 = "e75bd2d41de60483ed1eadcf03d9cd57146210ff9fdfe04e984404ce4bca29f7"; }
    { locale = "af"; arch = "linux-x86_64"; sha256 = "32697271215a0e63b7d0b25398d27772da5d53e88d020df24f170ebc341e5394"; }
    { locale = "an"; arch = "linux-i686"; sha256 = "3a590702183a86283e4de415eefdeed6f95f1e5d48c64456c4d6db8f84dcfb68"; }
    { locale = "an"; arch = "linux-x86_64"; sha256 = "98d35a6a2f0875a9723ed9511f3bea65f58da3196db3f75aaf7420d45bde33ad"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "e632f104442b725cf8e0e25c9a924b166289e1fab601a70aee0a81394632423c"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "603a054ceb36645881f52042e556572252e898bfa78cec04811e65f27b9db026"; }
    { locale = "as"; arch = "linux-i686"; sha256 = "05e64b9113f450bfbfa1b99c9580dbb2442af35d6cc20dec0c7af379dd5d37db"; }
    { locale = "as"; arch = "linux-x86_64"; sha256 = "85b57a101afd0c4aae040bb1f3523ddda3079d46ac8abe9cad826939fd274353"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "5df5eb0db623b42d9a2c9be58807ec66f43a26dd1365d44202d4b0db50d6a6f0"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "6faac3f3637bd68d6c20c73dd84c554afdaa136c4e142c26eb8142b7ab00895f"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "4a87051df26ddb3fd2cf7c2beabc2d403cbc4d2f2e7e0802fb11566722171b57"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "8194b851ed7f9559b78f63711df598ed094783eb2cc288fbd1e880d53118dde5"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "f6f903529d3276d1aa55968d4978fe5977d45076db0ee99d87199d59a9441ad5"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "bce34ee8ec314db0f7abfeddf491d15642dcedea125dc9bb7d7dda3915054940"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "9bd0e37ddf9a222263ca90308245e2078f45d754d8a2b0bc1e4dea13a5e7b581"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "debb3a9983e4219b6632cdfd09d04ab95314ba4e0bd7ff36fd89f0a748d25cdd"; }
    { locale = "bn-IN"; arch = "linux-i686"; sha256 = "ea2c9d29f4a3dfe8e0f146979c47ccba835b81cb1f1ed6e95124a837918590fa"; }
    { locale = "bn-IN"; arch = "linux-x86_64"; sha256 = "b2bf8e36ac1ca1afeae463bf95a289db7cf2d2fa303083ab405497cca2993b57"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "b4b9d2828e5387a65d0f63b2149400626cd47fc81b97b912eda11b3fe31d4604"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "c3af78f1215ffc1e9b6c193ba87d17e2f08e1a24856ee68aabf95b3ee7804ea9"; }
    { locale = "bs"; arch = "linux-i686"; sha256 = "7930f10d5d43e4504b9f347bcb2a2ef451be4418cee86c199b3e98c38587a20d"; }
    { locale = "bs"; arch = "linux-x86_64"; sha256 = "ee31279d2acf7286c9a59c99e68fdd1692b96247585230df20ea2bea5ee30ba2"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "f22f7964180ad27a122e56f070c6a2a0e3b044fe15ec5046b04db03877a3b7c7"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "84e8675f9613d1a8a49a760ee46d4625b88092cfc542e6b750384d0d5a0a465f"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "bed550a83c763a8147ef862cca7ca36106bfc5b34ea81f008c94886b86a3dde2"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "8bf76f388c6286a1b91cf460325b98c2dd08842031288617d9141b1368b5f62c"; }
    { locale = "csb"; arch = "linux-i686"; sha256 = "2420bf49ff3429b3f186b17555b8b3250d44579b5ff7ce616914af646b5996be"; }
    { locale = "csb"; arch = "linux-x86_64"; sha256 = "a0ee304a61b12ec1dd3caf5d876acbd9d2ad4443f9b96e73ecc1de8a1e16206f"; }
    { locale = "cy"; arch = "linux-i686"; sha256 = "603a66c237e95534d2dbd004e7fd77b69d5b99b73cba797c7825aaca6d849c61"; }
    { locale = "cy"; arch = "linux-x86_64"; sha256 = "69f68c024d6e9999b5a846d12c5a61ca63d962f6bd21737769d1fe5519916dad"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "da8ed391e8ae9729cf2af35700aff3f6900af208fee9eab6a6bd0fcb303abd09"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "7e3cc63eb61289e1006f683581345caaffe3ae39f7a636ff4f451b1e77a8ffb6"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "f191e74047cdddd43fa72242b1dce15a28160f62b4b8eae08ad117f4b27d6e0f"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "a81165d446cab525645ca2b18ef28cf253c6ee6267086d692a3904c79f7e5be0"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "eb0757aafd2a1c4bb9abeab01a3960d3ac21b92879f8dc7d24f485a43d305957"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "900f64bad286393f6d96f0ff00c6e78ae6cce998046cf506e2b3ec7a7b8e76c0"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "99284b229b7bfcc44cce3ebeee523e49bd5d9c7d860345ad3e242af4f9848683"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "9a4e003441556422375d4bede21da27a03d31b5ec452ff467abcfffdfe363f4a"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "13b4297db52ef851b38f292eba2b2136e4c2f1453e004012fe8b1fbcf000abce"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "ce87f081c4867b9968a2695341001854aa6c1f4f19073d13f54f333cfed236fc"; }
    { locale = "en-ZA"; arch = "linux-i686"; sha256 = "849584baf4c6dd330bf9c798e3e8923004a3a381642d4f684b5de3fb5b4fd895"; }
    { locale = "en-ZA"; arch = "linux-x86_64"; sha256 = "635d0cb43a2b5f7f0401f961fd88fc0d6735223ad421ec0ef92a4ee16b29727f"; }
    { locale = "eo"; arch = "linux-i686"; sha256 = "91da9571212dc82f5d7140e4de073189018f7f895a3b263a4f8840401b4b10bb"; }
    { locale = "eo"; arch = "linux-x86_64"; sha256 = "77f39ab0168efe9070ecd881dbd2884fe5f35eeea17a63ad8d957398f6eef40d"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "f4ec6f07e67195981c12b5cbc3a6289a6e9d29539014c034039bd498a40f9301"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "3f24135fd1a6fd2207bf1d80fc79cb34536b109e195e43a3a13eba0b68548c0e"; }
    { locale = "es-CL"; arch = "linux-i686"; sha256 = "de3672a512473cc6edc48bb775bc9a405d0c9effccdb0cd46af5ce2593d67613"; }
    { locale = "es-CL"; arch = "linux-x86_64"; sha256 = "770134c2bd8bc9f2e629e355b8e3b0949f67dd2ecd1b3a1d513bff364e53b734"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "4eeb5854427cde599468b90af70ae3e04eb9aff5132659f6e1ddb2f859f0be74"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "eb91e2e9b80cab85e6ab75e78a9b206a18bb647ffb247c0d5ed324ee219dccd9"; }
    { locale = "es-MX"; arch = "linux-i686"; sha256 = "0aa0c85a51a50adb9eca5e5a1eda0ca11ddc15ad12b2d930ebe769f10d535433"; }
    { locale = "es-MX"; arch = "linux-x86_64"; sha256 = "3f340072c80c95283b17e797bf4fdbde9d1de55b5f10f1c9e8193f8426c6157d"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "4719961e58e755ea2d9b94ff7439e1f9e858b0dacbd8631f98fadebca36c72a1"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "70aa1a76414c50b00fc85be87a07b936c7f60d83037f13716862e8491ec8d609"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "ea450d11b0cd3b4381797bf6ca48d74fb18d661864eccb365bc2d51b872b101a"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "d543e7fdd4c27875d30a1d527219e257296c6010e80dc0d5529722aa82cc666f"; }
    { locale = "fa"; arch = "linux-i686"; sha256 = "4b8aaf0d27f10474c6ec4eeec1418ffb08338475c5433199ac2db79aab5273b2"; }
    { locale = "fa"; arch = "linux-x86_64"; sha256 = "df10d71c7a762696ee682ca705052b15031dc7e84aa396f67fa26463e3dcd353"; }
    { locale = "ff"; arch = "linux-i686"; sha256 = "acdfec7656b48e5502692c408cd8c7543add80181130bdd2e0ec66ac44219a06"; }
    { locale = "ff"; arch = "linux-x86_64"; sha256 = "a9a0041cba2f80b09a2f22da6f1e9bfdfc1cbf0f5c324a427a1758174901fc27"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "304e90020134af5564d5c90c5d9fee6264aa871e82419408f5b0e9d97f8f8ff1"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "bfb86547ea4e0a5650a152070a7651a7f63b0df366fa4aed7f890033332e64a5"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "1ccef0f95df1571b9e378d97122303982f93251bd3ed70d0af93babc3459bad2"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "93ffcc3bbba8b7e0941fe674f6a67ed378e75b37c3e52debbef2434ea75f2b09"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "20ae7baa888fdcb467388313fa51104f8ba77ca31b2bcd731e2d65a46ff75c3f"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "33a028be0c63dc892efc93bd03375c8c4f9be38acb96a2bc516300c204086b3d"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "ddf134c692d321744bd787b7833ccc9b06ef130865c8f8ee816d35ff55c344a7"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "e76e18b18a7468ee6a550e837abf04b79833ae084210f723d0781f2b81e3077e"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "3c361e322be79ffaec9a382aacf3b9cc90f03fa664e35e283cd8572e66d3b8b0"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "5e95305321ff373d9cc6eee522dbd5ee948e6c298f2fb38d655965ec1de448e0"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "99b9dbf38f50f5385072d72d14684e980aead6125c4c91cfa8e69bd5c7f1aa0e"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "372bf1395f96be3b41d05630267354f7a6c0706e90f5e21320ab5ebd5d411d41"; }
    { locale = "gu-IN"; arch = "linux-i686"; sha256 = "0b8429553052c8e23d3aaf1210d53b51fac2250d1d526311a22757ebd85ca54f"; }
    { locale = "gu-IN"; arch = "linux-x86_64"; sha256 = "da6a7d7292965a0c1eaf58564d9bf85192719831208e8762d06c7082ee9824d7"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "78ac97da0515eb5a94455dcbf4cbd9a8d1ddbf03d4b8d29bad7b9e8fdbf5ef12"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "c0d853c639cfa7b14ce10ee50776f3aebf0c84807bb59d9ec6e0e20554ae8ed2"; }
    { locale = "hi-IN"; arch = "linux-i686"; sha256 = "82376fe3005c56d2e895e1ffa0e9233f3885700117a73d1c49d67d742e324752"; }
    { locale = "hi-IN"; arch = "linux-x86_64"; sha256 = "0ed6234fa9c5d449437d133c83f572ceca3dd82df6cbee8573c9f137c50bcf9c"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "10ff3539c27dc49763fe322e9540878d421bdf590d9a307fecc6c158472889c3"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "f97d7e3b290b0fc6a9116198da7fc7eb32895da74a3ad572d29577e14ab12f20"; }
    { locale = "hsb"; arch = "linux-i686"; sha256 = "bba1a949823e70d1b5f4a0bec27437b6fc11638fa67b2ca286a833a0d44f5ef8"; }
    { locale = "hsb"; arch = "linux-x86_64"; sha256 = "5efaf3ec7f7b5d94df17d2fe0d5877a35442d33ccbf141fcf30e11351f9b4000"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "88a86463f2a47e38886cd2e8b470702623c772086b71d55e61de80e1c1be4fb3"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "967ff3bb62c8dbc93a25f75bec73803428b3fe5024841d3e2d97e444c1d27304"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "4bac63a8b8fea36c3dab794dff933972f9adff7f91a7d3957d4edc3c60534016"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "9c26a2438462429f96b2d8bb8c4566b1b1f7d03200ed68aaca4eb6602342c33c"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "e36cd7195d5cd21afd97f31a5108af5999ade8a97f92db3e00067f3cfc31cd72"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "191e47625a6764670bfbab673989e5b2e6ad45ad1c3a0544a129afe8cb963171"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "c839d21d4e16b05bd9aa995ff2124b6b8418ca1405a8f3bfc70fb65b5710488b"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "16d8df9867e6a13a2be7408f459e2c67d449a47105cf9709e4a743abed8229a9"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "7f9c3909cda97d9a40f2630af4f11e6dd8e29f45ab949348123c4334f6aee8fe"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "52f95491dbf4ee9a1f2ee552feb8a30b8196b6747064e45d5a98d0fecfa11f67"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "6586fd1d792feea4e98442736f06eab15d7de526667db6a3ce7de1afac9fdaec"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "0ef883bdf3d415a5795bd613af05b16a406b3af3415ac1c1ebc646dd76f76467"; }
    { locale = "kk"; arch = "linux-i686"; sha256 = "39167c7ee9f0e9b62308fcaba0f061bda0eaac9d3bb707c6556f71085c7ddd54"; }
    { locale = "kk"; arch = "linux-x86_64"; sha256 = "ec2c9ae1f5daba1e3b0c8a4f24737b0968bc818748b682418f02983e25302703"; }
    { locale = "km"; arch = "linux-i686"; sha256 = "797747aa402ad42b6addd04d69995b0ea5c628da71f2cce15c8e612d15461189"; }
    { locale = "km"; arch = "linux-x86_64"; sha256 = "fd75e5fbba75dd8a6cdafdb1c4983bfd4336f300df559518d3fff0e6e7e482d6"; }
    { locale = "kn"; arch = "linux-i686"; sha256 = "fada07e5679bcf174078e0c596cd121301f72c307401922e5772c6fa79eeedbe"; }
    { locale = "kn"; arch = "linux-x86_64"; sha256 = "d9cbb3dc02e3db54ea691dc09c882fcd65fd99bb1d0250e29e3d0a37df72179b"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "22bd8b1dec10117579a267d5bb9b10f460c27c9419305aa1cc4456b09fcd7df5"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "0e9da5e79ebb149a62606e002202b70908d329a26c213df35480962fb05a9f7c"; }
    { locale = "ku"; arch = "linux-i686"; sha256 = "e5f55ab5112ca3a137c4df37460304ff7e33471e3e95e2709ace1cb32ef88084"; }
    { locale = "ku"; arch = "linux-x86_64"; sha256 = "224385ae3a9da1fbbbc0d309eba0de6f64e29da4de29299cb1c778cb5a57c968"; }
    { locale = "lij"; arch = "linux-i686"; sha256 = "e39f5edc61e25f490dcae7ea4fdc91033f5e868cbcaf848180c40bd920455f17"; }
    { locale = "lij"; arch = "linux-x86_64"; sha256 = "f6e9725f368ce4df3be078a1ad268a29cfeba01e5606de85fbe2e375b3a5e263"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "46b2c694c60540ded3d3f6cb504bc5b7a709cc0940ff6b3223f05d7b8e1f7309"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "51d10f5c63e377b0f9e46d7ee12ea8552b8df57d6e8d9334555b7fbab617c8a4"; }
    { locale = "lv"; arch = "linux-i686"; sha256 = "8e224c3efcca9864255332b7f7c089c0c04b0eb2dfe60cd04d7dd6a61d807852"; }
    { locale = "lv"; arch = "linux-x86_64"; sha256 = "e53090be92e7557be5d38aed25ac0a2fb1006d15bb38d61141473f4b38c6e26c"; }
    { locale = "mai"; arch = "linux-i686"; sha256 = "479795f542d17476bb721d3e7c7fef565617528016085976a63b9e5864b4dd31"; }
    { locale = "mai"; arch = "linux-x86_64"; sha256 = "8daa2882e27a19894ded43885e868dd7203f506cb1bd25ede1d36328fffbbe0d"; }
    { locale = "mk"; arch = "linux-i686"; sha256 = "78f6fa53d5fda46fbe54b9978acaa75faaf094d2d3b8e464539609253da07c52"; }
    { locale = "mk"; arch = "linux-x86_64"; sha256 = "47a147a93dc7d1e683a57f0d7ddd7fbe3d944145932e0773be8dab6a7a0b4b01"; }
    { locale = "ml"; arch = "linux-i686"; sha256 = "6ac6a36596db8bf675df76abc629fc99ff019455f8c08842668a08cb40b67e9a"; }
    { locale = "ml"; arch = "linux-x86_64"; sha256 = "c4d4bed760c429c5db1d5c42682127794f81e20182aed0fc37f4c9aaf7bc582c"; }
    { locale = "mr"; arch = "linux-i686"; sha256 = "a2fc483f2aca2cbb7bdff42e4b27b711fdf27f46bee707d1c6d664c391c95def"; }
    { locale = "mr"; arch = "linux-x86_64"; sha256 = "5209926b3130b8b75d933287872af62ac752fc9e3fc170b540a2f0bc49d97bdf"; }
    { locale = "ms"; arch = "linux-i686"; sha256 = "926944ef9a3807b3379bba4b2fff05d8c2776cc4e3239b0b2bd2e5424151e6ee"; }
    { locale = "ms"; arch = "linux-x86_64"; sha256 = "20cf8557fa41119febc99bbc6de10ea7e97d3c1abc2245241db862ca8a735db1"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "5a2778d9e93ae4371ad29737904aaecacf494855b45e5e79cfe773410f6600f6"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "8cfe4c778ee258dcd511990fd71eefcda46ab73c4448705e3815c5c371ee6ea1"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "350efbbaeb3ef9eee16a398ce482c2a3790f5b85dda6177857d7448de03af9e1"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "6d1310f7e2ebe5fc846f966bfa930a2bf3cd0877260de40b01496cb860630c37"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "6447690e509ec0d1306bbfa484df82e62dd5909603b43440443c28bf2f489f24"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "6e71ad4fe85b02f8745e6b3b39a6f69f13fff45fd555704747d1f59fcf64447a"; }
    { locale = "or"; arch = "linux-i686"; sha256 = "71866d15af41df9d98716544d25d8fc2069a9a8f92cdd8180731e3b3fb3c3492"; }
    { locale = "or"; arch = "linux-x86_64"; sha256 = "22ace7c20948526f1011e16581c870a919c4d8002bd0c3210ae8f702d1f8a03f"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "12eabc66d39bd767c129c1a1777a6a13812efa0bc3df430dd7940908f53094ec"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "54501bca85e231e9fab0aa894a6e566966fdbd172fc45888d97eb828e248d105"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "e16acf44c5ab2ee708ba0f74301106a5fc0c36cd65ebd302043af09803f30138"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "a1532684d5d0e9e2091a5d42202dc6b49ee8c21df14600f0772e1f0f53f6d638"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "9827bfda689b01e795d4ddf7ab1169e25cc1728175af74e8a08fa3e8ef40e40c"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "bfe02180011d564fe8deff4d3f3f8e3a6bfde05469738b5b2f8849a2ee485ba8"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "83fcda599d09946da8a968d903fa12b93502a23337f019d3217cc80f81607fe7"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "533050be56e6dbf06a5631a5b7a7db2da4f5514f224cb787600671c79c020379"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "62906af16b8e179be3015f6be9cf4b9481fcc506044c053373f9bc2e315729fa"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "f968ed9ba8ed43d0d52b02db23b2badf6e6a2544d105f23d6b09b80a07a28ee3"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "503fc4cf0de24ff5b1658d09264f8bb3b131c678f61c554ddf1006633ff2d336"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "514625ffbf4af4519a7671896f2f2797a1b17057dea356f7c17fa52a17736358"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "01521832ab38fd46751578691b82c0283d9c7a68459ab7225328afa285699b01"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "16b780ed767ff0537ec4619453d8cd3ebdcf124704d03d1741b5501007078dee"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "35ee6cded95ea13c8c480a46ffc9398f50d172aff2030611d6713b04ddc1c54d"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "c4ad9cec257bacffbcf3b4c84c63ec52e1ce830754b5be0b622a44ab223919ad"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "53a6bc5aebe5edf4bad34e163a54a3bed30a7c74ff883463caf057793ac3f58e"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "5110806bb3f02317b542bb79ce34c6bffeef68982807a5e53614958fb9adc779"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "3a58652b394fc2ffe1abcc1e89596f3e9357a2455cda8a0c76a44ff20331ada2"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "fb733f327080e5b4e2ae079a5cdbdb645fde1c9388368c13fcc6af4d3d91da7a"; }
    { locale = "son"; arch = "linux-i686"; sha256 = "56a262e4411404e94747312858ae1e7ca99ea48171361f03cdc660f8b0da0da2"; }
    { locale = "son"; arch = "linux-x86_64"; sha256 = "db77a5cab885f96efcbaae8e9f284ad30ab78aae1a405a5f1c2ac7d4d2e43498"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "fde7c85f09997ab3f7918072a9577f8d70947c5fafcc70782d684759146941bd"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "9865054be5d0a3913e4fa16aafdacd345607955b1d733d978033a2825d926c32"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "87f9f7d46a211b9205df5258f551b7c42264fdb81c70f836a37b3d5a821c4c03"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "ed03914c382efdec2f218e87e8efdd2b761e16ad0cc2a646b02050f27503161b"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "1e28e39ac45177607a2ff3c71d3317b8b777679bc9e8dad2236991f05c6823ca"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "81c2fdc5ec9f338b1dc3cd5d2e8dd62cf106c4cf759826be8eb7f3f3f550c49e"; }
    { locale = "ta"; arch = "linux-i686"; sha256 = "8e27ba1c8079745a93bebf6f7e4dbfa9ffc32b91d6dfa12975497466f3ec1550"; }
    { locale = "ta"; arch = "linux-x86_64"; sha256 = "c244aeff11608d6f1a8513045ab53d4909af02915761b15ff34ddbbc9995dcbe"; }
    { locale = "te"; arch = "linux-i686"; sha256 = "32e404eeeebeb521d909cc64fe1ba3c0b40130f7a4b4ae742a48ba61e8b668d4"; }
    { locale = "te"; arch = "linux-x86_64"; sha256 = "83b5cefddc6308050c24d9fb30818fa1fb3c1d4ba9a2de9d8fc99878b01855b4"; }
    { locale = "th"; arch = "linux-i686"; sha256 = "009cb39521635c1c89717b3d526a59c05e7ab82082ec31f0fd482800f01d3e8b"; }
    { locale = "th"; arch = "linux-x86_64"; sha256 = "1fe31902ef44e7049e9efa4774098c00d3ecad0a4c4f585716cb4bec158e3b88"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "e54ee04479b9891420af6fc1d639da121b677660a5bf1dfd8565792c9e1cdbdf"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "bdfae1142a7714a0be9bd24b02582a9ab9913c17d130cf0b2928deb657f8bebc"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "b2d6b518e86c3bae1068f7a6d7cdc975f3b0f99e514c5d3d18dbe5e62d15dbce"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "71bd0518b69c911dbb21297cd676ed66231a3b7bc59090a9f6a85d6882263277"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "390fb219da7169d69a7aca1df883750d56bf34f0f7b6b49781d6f3c6b8962962"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "1c5af9f646ced5533223bca6dd36f364c0ca9d3f02ba93797aa8b091144cf7e2"; }
    { locale = "xh"; arch = "linux-i686"; sha256 = "5d0d04c7c84ffc51b11f99205ae767954b78d98c3a2d18bfcceca1cb292fcd9a"; }
    { locale = "xh"; arch = "linux-x86_64"; sha256 = "5fafe2b375ee0935da52ec9037c4f515d1be5cf783548215d289a300e06bb9de"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "1361b7cfc08d4d000107a244ec2a163ab27616b1d1db13917f34acc4d4167d34"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "66aa04a7b5240df285afd37608c816b7c09cb365c6d0cd5aa4dbe8a7be61d824"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "c0e3d9b584ba10e2a67a904253b2d93ab3546465e69619f932b566ad6b04a003"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "6a24f9f3631bc0bcc15de6a124c0f7dbcee6d0099e2f0b0622a18e54c04620a9"; }
    { locale = "zu"; arch = "linux-i686"; sha256 = "7fa59f6ee26d48f992015b0bb667a0c230cea854eafa67d7c4e51d38e1a267d3"; }
    { locale = "zu"; arch = "linux-x86_64"; sha256 = "4af969f1e0d0703e83d903fc2a30739ae2ab42cc3a24219be8bfd152490970c5"; }
  ];

  arch = if stdenv.system == "i686-linux"
    then "linux-i686"
    else "linux-x86_64";

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  systemLocale = config.i18n.defaultLocale or "en-US";

  defaultSource = stdenv.lib.findFirst (sourceMatches "en-US") {} sources;

  source = stdenv.lib.findFirst (sourceMatches systemLocale) defaultSource sources;

in

stdenv.mkDerivation {
  name = "firefox-bin-${version}";

  src = fetchurl {
    url = "http://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/${source.arch}/${source.locale}/firefox-${version}.tar.bz2";
    inherit (source) sha256;
  };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc
      alsaLib
      atk
      cairo
      cups
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gconf
      gdk_pixbuf
      glib
      glibc
      gst_plugins_base
      gstreamer
      gtk
      libX11
      libXScrnSaver
      libXext
      libXinerama
      libXrender
      libXt
      libcanberra
      libgnome
      libgnomeui
      mesa
      nspr
      nss
      pango
      heimdal
      pulseaudio
      systemd
    ] + ":" + stdenv.lib.makeSearchPath "lib64" [
      stdenv.gcc.gcc
    ];

  # "strip" after "patchelf" may break binaries.
  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/firefox-bin-${version}"
      cp -r * "$prefix/usr/lib/firefox-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/firefox-bin-${version}/firefox" "$out/bin/"

      for executable in \
        firefox mozilla-xremote-client firefox-bin plugin-container \
        updater crashreporter webapprt-stub
      do
        patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          "$out/usr/lib/firefox-bin-${version}/$executable"
      done

      for executable in \
        firefox mozilla-xremote-client firefox-bin plugin-container \
        updater crashreporter webapprt-stub libxul.so
      do
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/firefox-bin-${version}/$executable"
      done

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/firefox.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/firefox
      Icon=$out/lib/firefox-bin-${version}/chrome/icons/default/default256.png
      Name=Firefox
      GenericName=Web Browser
      Categories=Application;Network;
      EOF
    '';

  meta = with stdenv.lib; {
    description = "Mozilla Firefox, free web browser";
    homepage = http://www.mozilla.org/firefox/;
    license = {
      shortName = "unfree"; # not sure
      fullName = "unfree";
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.linux;
  };
}
