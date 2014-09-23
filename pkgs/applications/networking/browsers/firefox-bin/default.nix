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

assert stdenv.isLinux;

let
  version = "32.0.2";
  sources = [
    { locale = "ach"; arch = "linux-i686"; sha256 = "e1402164b85e1713e176e604182cc35d0e7f916f1889d410161830b836f797e6"; }
    { locale = "ach"; arch = "linux-x86_64"; sha256 = "0740678eef6a5fcdc9f2c3b54c8933eeb1685383e470338a23eeae79f0eda8f8"; }
    { locale = "af"; arch = "linux-i686"; sha256 = "9fb1d38e3b5fd6a7b33bd6c5a0a29603ac2b633f75ce42d84c357e545d8a2e86"; }
    { locale = "af"; arch = "linux-x86_64"; sha256 = "a661208cca850129d166d449d28ee1dba68a907e472082d9b9aeae2aa3931850"; }
    { locale = "an"; arch = "linux-i686"; sha256 = "eabde5cfb85b30bcc41e59d790d12bec3cee5ff1e09ec7d95158a42dd8832d3b"; }
    { locale = "an"; arch = "linux-x86_64"; sha256 = "94bfab099b217111172b1b60d3f27d9574af0113bd3c0d94a1500714fed328ae"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "93a9fbd7a578467031445e657669ae736921b046221c240a99643d8a3461292e"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "25aadd414acbe9ed52c652ac92bc06f81f26da57a701ae295e86e591829193e5"; }
    { locale = "as"; arch = "linux-i686"; sha256 = "240df4ad7909f9496344af53b13d0f8c0e32d9d8a1a9e42d41d1becf53e47ae0"; }
    { locale = "as"; arch = "linux-x86_64"; sha256 = "b1411b274f4ebd103ee64aadf7a0c5e5fa4911bbcf31a7a420e05242dedf7bc9"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "a015e7f12a5b3ed5f6ce108f6307f016c6e93c1bb3bb82426ed53d6a7e3548b1"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "dafb6843def24d24f86030a43a113678a21eb07938583a6aa6af34521e7dc060"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "c7dc7809d38ab7b3f351a958c1f81bdd7f1de6a5e098df2c7c5c38cf12a58ee0"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "189d4cb2a9ed4424b47ce9372b99a3a7568e4f5e4bc0fa4f015971c17919c608"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "a10a4a62d212a2d1da75b0f0c57956b9801249c48e55d8c65e517263d66c80ff"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "d15aaceec28e330d6ffbc6c28bbd7a87d7857787e9421e37f7f812f11938d1e3"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "a536a86d2c385ae81c4684ecc2ec3febf523232a4b60b3ab053ca30b35685456"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "f9ca18b46c7d29ac66f58ac5df1c1489f60bfaf3cac8f0e09606aa059578d99f"; }
    { locale = "bn-IN"; arch = "linux-i686"; sha256 = "371a45e07f05c89f237d25a14016ee188f18a2a856dd0933ef966cc0ac0eb3ef"; }
    { locale = "bn-IN"; arch = "linux-x86_64"; sha256 = "6931ff46d40ff3a37c9ff280ad8cf6e9ee449ec5dbde07408b3fd5f306091eda"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "ccd24a7e3d0e6c2e88d0760b024c6daf14dc3b43bc05c426a9b015a9d2e4fff6"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "a71a82b9695ca2c811d9ee5c706b43189237c631c7b7f30f3bdea791cffbb285"; }
    { locale = "bs"; arch = "linux-i686"; sha256 = "1cc8c8d4fa84e34ff7d0c259ad14b36c625cc7eec279931ae7f27d60a42ee052"; }
    { locale = "bs"; arch = "linux-x86_64"; sha256 = "38a483a645c79dc933e4924d6b4227c3319f99f4211c7838f1d2037e2d682ce6"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "5b69a67a7345e25f587da803121d2af752dc935e0f2ca5b944d41693d9644d61"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "d7d491be229d77451ab8678c48d550f93c77622dc0e1b7dfc90ab5f442fcc9c8"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "65338cda64b4434f4f0070c3176bb29f6a0220fd5b831eb5b9275229e62f547d"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "913b83a18a1d0bb72aba0aaefd930d0aa4322aef9721eff1700ea59b5be7267f"; }
    { locale = "csb"; arch = "linux-i686"; sha256 = "5166ba256b5fbb7a0847fac22bfbce80193c64f112e70bd9b3c98419159094c0"; }
    { locale = "csb"; arch = "linux-x86_64"; sha256 = "6e5f611403d9f471115acefe673923aff11c23d1f55a48d3c4a72f369b3a1426"; }
    { locale = "cy"; arch = "linux-i686"; sha256 = "fa25fb3118ee8708adbf7f971a90e7435efa6cc27bd00128fc47a5a7cff932f3"; }
    { locale = "cy"; arch = "linux-x86_64"; sha256 = "3f7cef085317cd1687409de61a1fec1b1f25e3ab6fd45ec22d7c8b9765721055"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "b94781c7053e8cea3905b2dcc35679c885077c70ed6d30eba733f086972e5bb1"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "61a81ef0149ce7b80df72c8f6c9cc50bb69f333be535cfb5e82bed2fe908f395"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "ab473d7d1bdf7b19b361c8c6d32d3688027e2f85bf9454445366ec91e0190635"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "d86ca3135ab81930bce65b1abca41a23702d5ba98b5cd18a07a5aba362bdc767"; }
    { locale = "dsb"; arch = "linux-i686"; sha256 = "8ac96e548e16c07c67f07845b2b24888a20b816912e32f523512b1327c925f27"; }
    { locale = "dsb"; arch = "linux-x86_64"; sha256 = "5ba36e4e552fbee1c4200a72d9314d49c770a066aee4d5b7338674f9ba68008d"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "bc4a39f92999271335b8e5059ff23d25c07317fbb314cf3eb3b9a30a883820b7"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "916cb5f4532132eb03801daadd991bd0cb64dc0d3790832d7dc38a49bcafa039"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "9a90fc5fa3ae660045b2cd881cd7091ac8f5f3c7cb3791b51c883831cd9ed5c3"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "c102127532a6890038d5993fd0c3576c442e8f28a4b7950a5c4f5fb7f03fa5e4"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "1467b34e93c2906f5642848b5e78e59340dcecf1b9cb16a202a88e892993d463"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "6eb3771f53a05f9e9e37f0cf209f3c1ace266b1e0a8a4dada82e13aee0668172"; }
    { locale = "en-ZA"; arch = "linux-i686"; sha256 = "e8c8aeaa16ae398e8bd8ce323c0ed439f4028fce327208ab5a7ae9f47e9a9ff0"; }
    { locale = "en-ZA"; arch = "linux-x86_64"; sha256 = "e477014e018fcd1c0d66bb7ddec29c4da6b8c8481315c49d103cc5f7679ee22e"; }
    { locale = "eo"; arch = "linux-i686"; sha256 = "5ab2bcc2d7fd8328b6066bd8d7d2b8ef2424e316f12f520fec3d8e1c3b2d0827"; }
    { locale = "eo"; arch = "linux-x86_64"; sha256 = "4b5ba84b808948e20aa0718cdf6b0979a28acce997410fafcaea548dfdd75225"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "8e64cb96de16ab5f01d640b56f28a2823663d6d201470cfbacb578c38f5996b4"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "9824cd86daea925a4c6ced16a303eed53a0d2018eafe92ae36096c455d5a5163"; }
    { locale = "es-CL"; arch = "linux-i686"; sha256 = "63f6816ab1522766f7ab3a22d3095ca4f41accfa4d87099b6c49be1c2b7d7f88"; }
    { locale = "es-CL"; arch = "linux-x86_64"; sha256 = "86a9738d9e2d4fa5420833bfb78e7b85b93b4166e15f6f881b0693ec58ebb186"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "af0b9f96020946c7b0ad7ba87b42ae1d57b8c94be303480545da7161984db2d7"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "2ffe7b605f0ad4461f44a97c1ca811bfefacefeec44b4aad2d1a0a2a574c634b"; }
    { locale = "es-MX"; arch = "linux-i686"; sha256 = "882bcd706056c362691130a52b6aae8ea776e2f35045b0cd3bf4265324e09547"; }
    { locale = "es-MX"; arch = "linux-x86_64"; sha256 = "eef4352e74b20f7f44f59e7d426317575f94c5dbd03da2108a5cef4f6f1e1d85"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "b475680ef5bd692c559320619bf682970b9731bffe7cf27fd11171d96e14ebb2"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "046ef98993262d9b310d942eb788bb3620837a3f25fb5ff8c65e48881333215e"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "733a9c0bacec0908d83c212d9b7988fc88bc39bdb9c8a9cea03a1bd673cd70f5"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "f37c2b3c27dfb07cd3ae97877349ae188dbb2312a08f6acd7211ada8d37e2d26"; }
    { locale = "fa"; arch = "linux-i686"; sha256 = "c299f3829ba0036bdf8a6f3182fe3cc10467322ce1ece70beb488867dd5e6b95"; }
    { locale = "fa"; arch = "linux-x86_64"; sha256 = "6be5d41183ffab60d8235bd4d25676ebb356c132e5dad1c868e321e067327aab"; }
    { locale = "ff"; arch = "linux-i686"; sha256 = "5ff3733e9eeec2bf391cef5377129413d389cf519ac74ff1c2ca8851a480636b"; }
    { locale = "ff"; arch = "linux-x86_64"; sha256 = "d748d447925406363e221e533e4c38941f78406be82409d725a95d65f7cb2a16"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "2faa8305a370967bc87f15ebb96d4e47b98964e1fc2be91d65d582a020623507"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "bd9995fba22f250f53a896d97df35234c0361afe32406f6662aee656daa68503"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "21876667e25ac7a6c8bdceebe68f9781add1382a5d70b1d4533a8ff9c15eca2c"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "32646ccf21c16e3ddb9db7ff7afee2b4781b2843afd0681b88082180d21824ef"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "da0fb0a2dfc247c620cb7cefe2998500c1d92838f975385fdd7fe936bc4be60a"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "8b5a2a232706e2843efb14e8ab7fd797df32ea8299c0def48d7982ddcb9f496d"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "0ec928a220106871febbc0b892b8a8313e1809156c39ce9eb490dd91bdfa21cd"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "5e1e50c233c5abe7a231492f8a103787ff89fdad0a6a9a7b7826afd3fe4abf26"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "17b1ee67a0d3cb4fef4dc274b40f44e26e9bfb16d09ea99e18b99f1c1387c536"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "8a1adab344aef2067b6a1ae96e793e60aad08ae189eb0ec78583655d985cfaf7"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "a1bfcd973f6e9e9f2c1ac29b28fa8a360265871f914bfc7a9f7d25ed3049463c"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "643fe1ff872bbc6a5813efdd136050492dc4877467829bb078f1d0f496c364f5"; }
    { locale = "gu-IN"; arch = "linux-i686"; sha256 = "e5aff0e8e6dd48417ab1ecf1a6e1e8de45f1a3c74450ad14dcfcf51e5462f955"; }
    { locale = "gu-IN"; arch = "linux-x86_64"; sha256 = "396f646a2e0dcef9a6cf2b6939548582a73a76968c8868b66b3422997dbcfc61"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "8f9fdc2e2539d86e45a6c8c39c03c359d1f084bc928ad2f880f30531f0dc667a"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "4a856e9f89003044e986aa52efe30a59802db06055bf230405ded11dfdf1d016"; }
    { locale = "hi-IN"; arch = "linux-i686"; sha256 = "086df0acb1e6681eac12169d3d5773d331ec31aca10c890aa8e8861cf8509038"; }
    { locale = "hi-IN"; arch = "linux-x86_64"; sha256 = "3cf7dd5a4bb9d307fda375c5edd1ea8e265e5bcd1c8d2c7ca3a97c9bcb8f25d6"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "cb2074a2da52bc1a20b6e98cf34e15d4a1080f5f83472778a4627c166dbc8acc"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "208cc24a8db68f995c73ecbfdd1c115a97acd86d62bde50e22f02f02ce4d3584"; }
    { locale = "hsb"; arch = "linux-i686"; sha256 = "2576fe729c7ae811d925888638efac2696aaf4eb3cc6f12e63364c2fffbd1b78"; }
    { locale = "hsb"; arch = "linux-x86_64"; sha256 = "9cd011bf1e21946f8903df58697ee0b24778ebf4d53618faf9c64671980e462f"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "bbebe50cfe5e4a99e3aef33df956fdb2835f32b37762e64dd3b3bc7a36a2b818"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "8b2fb0579abeba18a140f2f68486ced879d446e8c972108774ebcc1880d786f2"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "91496635ec9f64c59f249934a264a229359a2169a006e8fcab9e63b28511acf4"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "a4027f89009075dca8f7cb0b5a5425383762b99cbf06ac051b682485c55883e6"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "74804bbf17634c8d9b68f8d71a2c1b4bf0d6ef009f38293214955f196699662a"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "f587863795f891211d336e01da82b91bc16fd13acc2539b29a323586198db451"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "869f5acc7b1b0490bc53d49723efcacfa519f8016360c0b07d77782ccc8b1057"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "fddeb3125a15c3789dfe40b81fc980405250a47fa76da8f8d46fd90d45feb991"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "a2cc9f8a5dd5cf7c920e502591f4961133f43733adc25a95dc9329cb717c76ff"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "dce3e98ae165fe6ff6722c137fc3a4e99c2d94027382cd5cd64cedc44d403417"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "e459a84d83eb5e2ee149657ec130515b57fe9eee1c14e3d6de42e5bcd3b3b467"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "9f29f8a5ddb5939690ab595a1c17b56b2eb1c4ee2a22c02b1fa200975bb7b9fd"; }
    { locale = "kk"; arch = "linux-i686"; sha256 = "c03147a02e9dcf5431740d31e4574b63eb4842ef6e238a7b693855cef4915023"; }
    { locale = "kk"; arch = "linux-x86_64"; sha256 = "0a06e4db35a9d216c4185c5b4655c902a1c1845ed9fd6e208dcae4be5663ff90"; }
    { locale = "km"; arch = "linux-i686"; sha256 = "69c3992c6951b1f074c4bca6fc48796adfb47ecec1cb97d94e0a1b7fa49ccf1a"; }
    { locale = "km"; arch = "linux-x86_64"; sha256 = "88b354a7251caafb1fb62df886847da5bf0d8fc2a98b8567488d6901d5a08d85"; }
    { locale = "kn"; arch = "linux-i686"; sha256 = "5711ee9de7821c86fd53fb7570e0d0f40b5706619341a6f29e18ed3562842382"; }
    { locale = "kn"; arch = "linux-x86_64"; sha256 = "ddd88c50eeeb5f1fc59a0693b9fa3f73eab2e7183642583b02cb5c147551a20a"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "4b450a4d549108587e450a42a2401f30ac693acc3739814bce8d44a29189b1cd"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "24b07ae89994c7d8cc3cda2501ca9be5ae9cd60c0874ed720caffe0819bc93f8"; }
    { locale = "ku"; arch = "linux-i686"; sha256 = "b9d810736780a346d109c054abcde641ffecb5fb3a0b088c924bfde62cc8c171"; }
    { locale = "ku"; arch = "linux-x86_64"; sha256 = "eafeaf06a8d70d2364ac22e7a3200808908fbeadd86b0cba4b6a681442b3d7af"; }
    { locale = "lij"; arch = "linux-i686"; sha256 = "dd33c64be05c53ff04bb9819ac96e0ec4d4c97bb0e1634779100e1e21fc35f7c"; }
    { locale = "lij"; arch = "linux-x86_64"; sha256 = "84ef3095d53c053d5f2740be3b4135db1f909d4f568e86b642ae646006adc85d"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "02cc32c98464354f272fe72a4d672aea284c33fb63077e12420647d26b9307c7"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "38ac40dafc34d521883fda94b403351599f4d0208b35d6f2367d31d3ae64d0cf"; }
    { locale = "lv"; arch = "linux-i686"; sha256 = "aeb5f114a9228f1624a328fdbe713b99e26b3f013d0f31fadaaf95e053541ec8"; }
    { locale = "lv"; arch = "linux-x86_64"; sha256 = "9d815cd3d084fbab4cf6952fc3e8ec8213db6808ec2458a2825aa5799caf28a8"; }
    { locale = "mai"; arch = "linux-i686"; sha256 = "de84b9b7418113dfe89fdbf9fccfa2a15843a06859671c47d55add711ff3581d"; }
    { locale = "mai"; arch = "linux-x86_64"; sha256 = "0bf86a468953ce65b9eeaf96a9ad54538c2919a50663416375250de1a4380ebd"; }
    { locale = "mk"; arch = "linux-i686"; sha256 = "1c013c18f760480f36684f4338c454444cd9e11177e1d2b577a3949d3a98f3c9"; }
    { locale = "mk"; arch = "linux-x86_64"; sha256 = "c1850414ddf7cf0bab4b59e920b68afb7568fcc4c50ba34d1a7ac44352ae9656"; }
    { locale = "ml"; arch = "linux-i686"; sha256 = "5978cf858cc808421f1987243edf8b9844506398ef5ea5465b4521aebd59112e"; }
    { locale = "ml"; arch = "linux-x86_64"; sha256 = "2322ea3eb12883aa10c003d84bb7a514bd9dd851b59d60b2aab6934054f5b0d5"; }
    { locale = "mr"; arch = "linux-i686"; sha256 = "13dbf297a7a59a4391d1e471720f8f8359c662322b30b8aba76cff68287d4c20"; }
    { locale = "mr"; arch = "linux-x86_64"; sha256 = "77a6b1e058e0e19cd90e55aa9ed054bf32e576ffefc6f91bd647d04324af08b4"; }
    { locale = "ms"; arch = "linux-i686"; sha256 = "c50e4f07ead64d5838378cc0f4e20812dfbd0578f3a14c944fbf6c2ff2ab5abe"; }
    { locale = "ms"; arch = "linux-x86_64"; sha256 = "b1a3b92c19f16e51dd57e714d90c2959858c3c0b61d07a0871e55c5dc115e5c9"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "be0db6345efd43eee3226ecd75a5d27fc0dfc6dd1258465bfc28657656ed6086"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "5d108f17ad9130bcfb1257ad1ab3c0b2bc0b74d38aaef8b6ab2b853e27f9002a"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "84c119b1475ee36761bfae63116209292eb75b72e8fc632e23abc337688d5d7b"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "e679c46d4014fc228e6da20ed7d758045eab361527e6645547f248de88f77d3f"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "68cba2208e5d8e6fe2f9e6c239b78c580418c131ecc64d34e6332759e986c5b2"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "c53d2c7d0d1862a8b8b5ad4f62d882f1b5dd40301f314f1769eba3200aab3efb"; }
    { locale = "or"; arch = "linux-i686"; sha256 = "bbc9fab1d49f1451fc9676f757033cf86e63cb19af59f5804a856c29a4d3fab1"; }
    { locale = "or"; arch = "linux-x86_64"; sha256 = "cd5a235dbe69943d9cef9d6a536137e7f050a1ef72e0d69019e88032f7c9d49f"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "fa13b8803a79f18b4d776a40a7974aa1dd248daa0edea22a82519d0881948fed"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "844b89ec583682ef1d4168a6f009bbebaacbed853290e559c75253c86aa42aac"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "895ca79004c0acfd35dc7eb93a614f8704aa99b08e4984379ca8555df080768c"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "88eb5b5a81bb764711193574f67247792416760e09092401b38161ff50530d82"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "05ba46807e59febf0f1c38754b89e57bd5296247dc974961ca725b8ef470c7d5"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "94c65166fea890750df97f55950a459f11916858a4d4a66f8d40bf20ba01106e"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "7add1c4da4e7d909f8811ffe3208baec235c024a5c4a0e74475e59d94671761f"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "e18bb758ea708fe009e84d0566c5cc083bb570754ddd425fdade7b2137551eed"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "bd4095434e8ce2a5794e3442a9acb682277e83aa3ab0b549e8ca9c48b21f05da"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "f1775dc522487b47d8d8ad6868e4d97fab64e120c029b63a7a8e3d66f1e00c3e"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "33caa73fa433c3ad0b9c96bd5f41f1e1661b8eb8d49c6e6b5ca87f1b5df9d9b7"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "fe455ad13b472dd3f974aabc7d10faf088ddec2e4b0175516a63b3031a2b0c3e"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "16c4cac0766dd36ff6d395ee577f2a868479e30671bcccebf4b51189b549d538"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "1cae6839091cbed377f9ba13e814209419684f5cd64761de7fcb58c593f1079f"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "97449c9f1baf401da22b9b393931611fa89c51173d257641b557bf52da5f01f0"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "190f873f08f117b4ed5c310615b6339f6fe8db4082693dd42bce09f2e5910da0"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "30d0f24f9317ec351c8f78befc72f5f3c263bd51bf01f3deb7c80201fae32832"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "06a595608d666ead0a5a8ed05336e8440f23edc9aa701d50ffed736b8eed5ffb"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "7010c4ecefd983be4ed81770222f199d2cddb20bc32e30b53a8e191e364af087"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "6ca3834abb5bf3f798f2960672a76e5d015a967f63fbc29ea01acdef0f1c788a"; }
    { locale = "son"; arch = "linux-i686"; sha256 = "9756b08e055ab638212e79e3974b7ce887fb9163932670d002f3dc40223b9b31"; }
    { locale = "son"; arch = "linux-x86_64"; sha256 = "46f8bd307239998d9c00da8fcc62515549d6d538d637b247b146d767cc37c7f1"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "72283566511c103d822d50414d7eca83818210bd2502a5d59981d0631d7ba2b5"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "04fa235113d13812d1829cf34440053eab0be118885e49bfa72d276b80ee7896"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "906864452eeda1dba33ea5a8c34b1450f53b3818790fd1ecc022af8e08753ead"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "f94d3b0bfcfe8ef7495019f766d36253b9e3ccdf1d2e64254b5551261dfb50cd"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "6c30a67676bcb7f9cec41abf801af69887ac2ed452505e7924d43ed6b98f7129"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "2c97de1a96456f4007bebfd1e654da7c10272f8e354f42e3f6e91b869b67eb29"; }
    { locale = "ta"; arch = "linux-i686"; sha256 = "de46730e8802a7921a2a5c55459afc4d1f9163797c46e5375937ae730e0813e9"; }
    { locale = "ta"; arch = "linux-x86_64"; sha256 = "106cf9849addeaf7f85c1543e55fa684af5f2c513244037f41de67d2b5f7ab5b"; }
    { locale = "te"; arch = "linux-i686"; sha256 = "6d6cb9b2f8bb1070c85069b79b7637b7a9e2210cc6553c3516852fdb2a9ad5df"; }
    { locale = "te"; arch = "linux-x86_64"; sha256 = "79af44fdfd537735d904ef082c8e1576693805d6f9a39fa1c42e483cb9ed0351"; }
    { locale = "th"; arch = "linux-i686"; sha256 = "50c463576bd2f7865d09762bc7b54dd5956b97652516d514e0bf555e7a215d84"; }
    { locale = "th"; arch = "linux-x86_64"; sha256 = "a95b126f46d9637b4eb71d58a72eba480b2f9d4d696b354795dc25ceae649f26"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "b4ce3e19f7d25f7363869f3ed203e1acc148a36c29a60cb01a088d4aac5f2fee"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "98b6a3ffeb538454337210d089caefea8a34d5ce4a11eb146f74e520b9840d65"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "414a818aaa59b2793e62ac0458ce07a58750357f18a4d85c4b4e892e85029408"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "a1e5138c820280158433ce90138a4d6c575f96d9422b411a6fe3d3891893fea9"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "df93f0da0ec657a19c8539a1c198ddf1166b925a828296c53083377700469725"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "d6cf0ec7c44ef21024e8e1a89cf7fd2b52192ca2def53474d3e8abc135bf8cda"; }
    { locale = "xh"; arch = "linux-i686"; sha256 = "4c33f824946528eba44af4da80670336fa570b1a0f1d9f3c5f1fefd47edf0c33"; }
    { locale = "xh"; arch = "linux-x86_64"; sha256 = "c377148074b83a928c641b3ef47bd1ea219326dd572aceb42bf094d858401fbe"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "b8637087ce843c3e4375d6b0b469dd0fbfa62a4dc72b9d2939ab3093c9531867"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "0c77c172ae90639b6d28d5991f7e540f0fc437a85d8d67cab6835755c3a96d6e"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "52988cf1f92155818665d7c2dc7012ea474db7ae42e05d88a34780c6b2d8172e"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "d3d7e93158675ab98d5b1935f9668759a227b2d248b0f503c224f264ae421699"; }
    { locale = "zu"; arch = "linux-i686"; sha256 = "76bf3f0743d3dd826e9f21b0b651628d85784b63ab29155918d0196e1b6dc17e"; }
    { locale = "zu"; arch = "linux-x86_64"; sha256 = "2568d74f9fc3871434e75e594446eed9b192e9635f14e1bed14707566830cf2c"; }
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
