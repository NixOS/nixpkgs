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
  version = "30.0";
  sources = [
    { locale = "ach"; arch = "linux-i686"; sha256 = "44d2fc9d491b6c001e35cff6e5f1c38c8561d24f8fe2dfb4d79365bcabe965ea"; }
    { locale = "ach"; arch = "linux-x86_64"; sha256 = "e9fb52a3b82a1434b7fa3bae606749819672c96ce8678c51f1fdbc68520e26bf"; }
    { locale = "af"; arch = "linux-i686"; sha256 = "bfce74c891ea370ce4e0fe43d578c3c0050d2655fff7372806ed6be338b2c438"; }
    { locale = "af"; arch = "linux-x86_64"; sha256 = "18408a9c3f3b8c4d9f8cfe067ac23ddcdd3d3a7a22892ba8d74de5679a064db6"; }
    { locale = "an"; arch = "linux-i686"; sha256 = "601efbf7944408ba1ac35831eaa92c4910cd904bfadc32895ff8d756c70ae934"; }
    { locale = "an"; arch = "linux-x86_64"; sha256 = "0ba4c272ebac9ecafe5dbfb7fbba1cd2790d126f5b1756ab9a323c94b644df0b"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "23ea3168aea75b044fa217b78b01a2dc8c9dd92171d726c4a78c23cffc474469"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "dae2c1634e17b8c3e276e4c758c4d4c3b1b0d6006adac8e420c13b6f09a6cf53"; }
    { locale = "as"; arch = "linux-i686"; sha256 = "7d36bd4589556374822f2ab5dd102d557257b5e0b529d1c963f96e9ab6a08850"; }
    { locale = "as"; arch = "linux-x86_64"; sha256 = "c13ccf3546bafcfeb41c33762e41af249306d4bcfd3ad7fc957db481372be0dc"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "853310674d7011956d760883af15b8e343250f8fc3acb3067e0f5a3d978c06ff"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "2b938081e8672ed5ae16c40c6300e585a26f54da278726f48b98f3ca3e065662"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "b9acce210f2adf188ba9a3d92774a846a263baa5e076bb9452b89ca5609d6ac8"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "dd2a33ee1ed8c848454b6e64a0c1527f193d070e4d867c4f13fa84f39c9bfecd"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "ee060cd395ef28bbad4be74aa42e2a51e7ad866183d139bffbcc7634dc94d738"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "11a5dd807083da8c3132d9d6518dc674642418eff1fccf68e451ac67b90f141a"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "339d286f7f8f469bb6f9f85a8b21a745ecc42717dc91c21c7db88822e9be661a"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "fc3f06743a84a7684e43cd4efedb02a126dd119f6141da49c6120f1bbcdf9392"; }
    { locale = "bn-IN"; arch = "linux-i686"; sha256 = "c585982368f258a8a728f782c37428311f0b6a6512231c077a439dd93645c3a2"; }
    { locale = "bn-IN"; arch = "linux-x86_64"; sha256 = "00b9af4425050ec42b4a45a3c4a16700edcc66297331b601950fb81421ef8eb4"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "b86d944592f16f5f0e558106e3464248e3d686f45527a40fb64aaa79d9f73422"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "b894c12508f0b0a892154ea61fb2bb01947929041a63518f7c405ed976cc4d3f"; }
    { locale = "bs"; arch = "linux-i686"; sha256 = "f7da0fead608f63c4a5be92fed9e0109fbe7288948d15dde05e10bba80b47743"; }
    { locale = "bs"; arch = "linux-x86_64"; sha256 = "1cb090f9b16bcae95055377bc14a531697c480ad50e3a098dbd572770924d558"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "0b36330715f8909e1515c535a06f4e3fdd7660de11b3424b4ce88f336561935f"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "c6e9e545d09e589fd5fbfd2c6482a5ef366c470e294823b3ba05c5e728bca2c2"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "ff1ca239be0e99b923c63c5bbc425dd2989bc40dbdc82dd731d7173fd539406a"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "fe8472d6a4bf9fcda3caef51449fc3e20e1fbadbb772b330a012ffa7219afae3"; }
    { locale = "csb"; arch = "linux-i686"; sha256 = "db1b7dbc7b0cd564a04b3a37827e8d77277cd7ba6a59403c45115d34e637f463"; }
    { locale = "csb"; arch = "linux-x86_64"; sha256 = "023dd75e02f41a2ce9991fb40a8a46767f1a10da876a390035a084c5b97bd9d2"; }
    { locale = "cy"; arch = "linux-i686"; sha256 = "9a6ac60099b03bdeb71c1a7739dafeff4b1682ffc43997191196e1f590421afa"; }
    { locale = "cy"; arch = "linux-x86_64"; sha256 = "a5f2030fb08c0dd6dff95310209ed7c6ee613680dd500f00e30e26c547f9c249"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "99a893ac19b0ca28177c8957d7296e6deef9ddb36a6b5b17823cb1e6fc9ec683"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "69f29e795f203fe47e22daf1259c2ecfb39c362babefbbccb31405f4632f236b"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "925aac0800ce63a88fadc945da40b00ed6dde327637821518a372d7affb6e450"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "d86c5d2102a95ff5a6e580a1ca7af25c2f470211182ef70e988b29b195be6dd4"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "af07fac82dea32d33bd6bc440e2a645eb160d196cf0d4883b878d3d2c584f81a"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "fcc96c25422837f19f9ff6cde02c81c4a5a3b7c8e6809b90c8761519571db1f6"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "758f7bb669743d6067e416c26f43806b16ddd16511a6818373e70960cbbd7151"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "d46ba3d642bf43fca46dfb29efb5d08a15f114eb9facc868e86c31f7c9c98014"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "4bca44a1ba94bf5616f7ea650e37cd3e5a719546def9e4a08ee88aedbc3a4db6"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "3303cc600153d0198dace9826b6883aa510d4e380aa985b092b1da67ad865625"; }
    { locale = "en-ZA"; arch = "linux-i686"; sha256 = "13736870573863aab644bf2be2219fe4b5c6bde4bd79b84f22e12d39e7cda6e0"; }
    { locale = "en-ZA"; arch = "linux-x86_64"; sha256 = "7e88fa9f355f6787d38e75d86d5b592a1a2cec208255f276887f53a12beb9e97"; }
    { locale = "eo"; arch = "linux-i686"; sha256 = "ae4446e223c0169dd0b56db58760fdb323a2bec8135e45c79d385d895b64cee8"; }
    { locale = "eo"; arch = "linux-x86_64"; sha256 = "202f61dd8e5506594ae70bbee9150d86c8037887f8345871dc5c1c9e498b1d66"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "8fb276ed26fd46fceb029fbade706cb6e55d2958f03400ec1290784c533888c4"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "78130525d30d7c592bb63d7cedf3ab5db804d457c4d127d90b93d94501ad7b3c"; }
    { locale = "es-CL"; arch = "linux-i686"; sha256 = "ef6bf393a681f4a08031eeda61bba3614ebfab222fed43f9f8b21cfa8eb3862e"; }
    { locale = "es-CL"; arch = "linux-x86_64"; sha256 = "e56224bca0ebfab9eedecafafd792e48cb67e3f8741c4d5a94c8f74f634cecf6"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "9e007e6aa0f8aa3d1fac5dc13e98f81c23e6ff1e574545c021f8f7feeff86ce2"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "d4ff94f46fd086300992a30a1c4a8aa97ad7164d6cd26e82b20b5d0680b38169"; }
    { locale = "es-MX"; arch = "linux-i686"; sha256 = "9db42a0557838b23ac4937adfec407804e624e679e9ffd6da739d17cdfbaab78"; }
    { locale = "es-MX"; arch = "linux-x86_64"; sha256 = "d42d619d6da78d0bbcb32b0a93a2eaa623eadb3a5af43e5b8b14400e6e969779"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "5947822f3f02bd4ba530ad978de1a9d237981e3abdf1598e44095c650794d1ff"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "7521a4db287bb928f50b64817f3631e96ea4cead81b1a84ab7c3b930b3450e86"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "44095e98e74205fa012a2c0c636de3fe9cfb79d5729abf15214c1e7734946014"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "2032dfbc82a9aca1a2f4cf67e6089400bf305d13906f048c5c9b906a7201a9fb"; }
    { locale = "fa"; arch = "linux-i686"; sha256 = "469b8008287c93e152e762e82fb61644384c1e2631a6c45033503652daed09b1"; }
    { locale = "fa"; arch = "linux-x86_64"; sha256 = "61ea0d8941d22083f918d014d56a613788d1f4f549e5a62d50a1f9071439a36f"; }
    { locale = "ff"; arch = "linux-i686"; sha256 = "81a0083e5e4136e3ab3e6db0e2adcedfae7572722655a9cb8b9ca388c6057342"; }
    { locale = "ff"; arch = "linux-x86_64"; sha256 = "0efe16da918288754a3af816d72448a73690eb71b110cf3ff0586ee7505b9735"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "a0ee069e7c3100b921aab7c54c5d32741df4e058f52cb7f42acb2643bd534b30"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "55c84d504603d648e7d72a2fb8badb0bc9148cb376bb0cc6054f091867cb2613"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "9c9abea13db23ef5ef8c9a3ccb5a0702b44a8db2402f43f01a478eb61e7ddf34"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "ce26fc67cbc2031880ffa3529a59ca4122016258ab1c023e23247c26308b6a3e"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "4a734880ed65a207d98630647a341644df4f68149c50ce5e683bb21b5c27f2c6"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "bace955c686456d7894ca7bc1cf854eb158d6183050318efc73768e232c9a413"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "4801f40ebd820b8f229cfcd04a04351fcee9f78268af1c9863089ef6c64d736a"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "c417c0182e6f706473bc4b7cf8c14aec96f96e21c17b8593b71ff38c97f7e9d2"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "15a9d316d472d2918eff0c6f02600e40a8f62d7ef53ab14c57537fdda0b5257a"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "8fcdcf093148222865a905586774dae5d805ef22c01afadeaabe3f0c7b315dba"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "83b0ccfe7cf7166899d17b2c9b1ea8effda9cf02024698f8db8f943a388bb3dc"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "550026595e6e59405b5869183af056ba5a60a303270f1a176ef25e3db1c70289"; }
    { locale = "gu-IN"; arch = "linux-i686"; sha256 = "7e7dc86fa805808931ba57455b99c9273a4b0aa60998affce3c4b06f0ae7fc70"; }
    { locale = "gu-IN"; arch = "linux-x86_64"; sha256 = "e0f35d7fe7875785e3749131cf86c5cbea5cbd7b3abd2c2c69f5f8376d3e53d7"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "5c200c8da3209c2120a8576c30ab609331b52807d0640daaa1a70f665c776969"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "6923a64d1ac5453453f148d38f116faca41be5b1d0a13d4f128bb73db67cb8e2"; }
    { locale = "hi-IN"; arch = "linux-i686"; sha256 = "6a7e5d06169d6dd87e505012604c93a28440156a3f81e6fe24d567f9c2b2a919"; }
    { locale = "hi-IN"; arch = "linux-x86_64"; sha256 = "56801593b9dd5ecefed8d7eaf438879dd23006ffff9a31c543861259dedf8263"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "4573cd0269639d122496bcaf842d8c741f4d54e8f57d0690b97d8e7e86ee7e74"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "753984384829229601fbe55d0b6615f3432fdf9babe908fb642f6ac79c749727"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "c330478e6e77eff117bce58e17661b83a30308f0a680f648fbf06d1c00f3883c"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "9d118ba236aa7a9b517278c375aa4e4fa65f85c71b8bea9c41702f6ae7b815cb"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "48c1691073b6ede77f5c5d5ae07af7372f17b9f52fd92950c2cca0a01b3b340e"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "beda26cefeeeeee59ea52fdd28e1e3025ca4cc3124541fc6825100a61eb398d8"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "8cf6d0bc2d4bcc68a5ddc935c3bd6ed19a63284dc3227e849be729645a6171d4"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "8be5900b83840871ffb6faba08fea9b35f9f396cae08b228c68e333719fb819f"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "7c167389105063b84d507b09c689fa18bf854fd695010c8273b9711b21a24034"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "c79321c83c9e654f6eaf96ddf5d24f279d517fbf35dfdf923acf026124919598"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "a3eb17e0eda3cbf8ffbbd1ecd1716929ac87a801f060dd8ed5291298667775a9"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "3742453f0748911b393fed804e5827f014cc595a9df4516438dfa163d5050411"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "fa030c64e04766ae5200370586c08b2f25627343586cd8a0486e583f345c466e"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "fddeae03ffdfef0f6cc999807e001ea931c15b1833da48655bcb5845f1e017a3"; }
    { locale = "kk"; arch = "linux-i686"; sha256 = "39d94b10fa751faf7423e5d43cd07ef4485ff26e21e47d106d2268058e2f33d9"; }
    { locale = "kk"; arch = "linux-x86_64"; sha256 = "1dc7138dd5c08088479c5e7e8054d7ed640504860a0043ecea2c8b0c9c1892f9"; }
    { locale = "km"; arch = "linux-i686"; sha256 = "0d12a305de4a63fc6c6394bd4044f44ca3626cbc41ca9ef1adad6d5041f6f1fd"; }
    { locale = "km"; arch = "linux-x86_64"; sha256 = "7710091695dd100b7f33585fce58c54fec462a96540a7d791f1935088f21fadf"; }
    { locale = "kn"; arch = "linux-i686"; sha256 = "b039e6a1114522ccae10b89ab794a222966fbf0914513b3c14f05c082a78b922"; }
    { locale = "kn"; arch = "linux-x86_64"; sha256 = "cf82965b25d3990a57d861d688f1bd69e5b069fe281937274060ebe36ddbb8a6"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "8b9378d39d7b42852c2bb537b0e85312760c343e6485826ed949ab4617293025"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "4b946a0cbedad2b8d0c3598c04eeb058cea05d6d7e6388e4cfa3146a40f7c449"; }
    { locale = "ku"; arch = "linux-i686"; sha256 = "11950c4a54c6a165e924fb6e68bcc46d63b5fddfcd2561c58a0ce401c0146d36"; }
    { locale = "ku"; arch = "linux-x86_64"; sha256 = "37a07a4e059580c31433b419bcd61d928ad1db7e607cf8443378472d54b61b78"; }
    { locale = "lij"; arch = "linux-i686"; sha256 = "c0efca49f31800a3773b0d05add56b195d1cbea287108803bb1ef5249a0dc94f"; }
    { locale = "lij"; arch = "linux-x86_64"; sha256 = "6e4b2d8c5e9942bc469f722110ba310b2ccdc4dda6e3baee93ae54012ae658a2"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "acde9010aa815f6645868b03f3d68d9a24c450ed830f063e2846ac1219ee628b"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "c2491cd3e5d11c302d7ec3191d646e2073c46f69966fc382901a93d16fb0c902"; }
    { locale = "lv"; arch = "linux-i686"; sha256 = "7411de62c4d8c01c8bb15b3f2dfc2e2ed17755e2f9856ead8e5e0fd05971ffd5"; }
    { locale = "lv"; arch = "linux-x86_64"; sha256 = "e8e57e629396eb180e0041a50ae98ecb2292f514d423423748e4d4cebc54fb59"; }
    { locale = "mai"; arch = "linux-i686"; sha256 = "26a053e48f4e6f04e4856a0dcb26e577a6ddb99afc883786d9c260d57e5e4a6d"; }
    { locale = "mai"; arch = "linux-x86_64"; sha256 = "86be2c736aa5ccf926d44f24afdb2d40c28444b5bd6cf090f9a847199b38b492"; }
    { locale = "mk"; arch = "linux-i686"; sha256 = "dcf7759bcde70158298ad9e2434e37d4e8240e00589a83dd8dbba53c35466a58"; }
    { locale = "mk"; arch = "linux-x86_64"; sha256 = "056297d6404794a8da78aeceb620b0ebbcb38a693ee1079cc02e4d0411e40ec3"; }
    { locale = "ml"; arch = "linux-i686"; sha256 = "2d632b3a5b60f18955906adca80b7ac7af3bfa39d03afd308efd1136cfc8971d"; }
    { locale = "ml"; arch = "linux-x86_64"; sha256 = "b54a9d47cadeae4f92d22a362ca887a18a16ef64500149ac8eb9355dbbe5971b"; }
    { locale = "mr"; arch = "linux-i686"; sha256 = "e66b22488bf2c772fa6d29cf43f3e9c1aa2a1a867620a1144af8cb92c2647651"; }
    { locale = "mr"; arch = "linux-x86_64"; sha256 = "da982205e9b659dd66ab05ca815324642bed2117e668e67ad620bb2d87c5d1c8"; }
    { locale = "ms"; arch = "linux-i686"; sha256 = "ad39ffa6d6d765c1e983d885f5d139a28e481d536068d517b4807137fa8d3036"; }
    { locale = "ms"; arch = "linux-x86_64"; sha256 = "fb1b6ed5e2e7247beb69f3d0ad937f76ce7c1107ccdad742ff5085d4b3a8da98"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "5220da4627863f9fa1c11886e9c19c315547afafa96c98b22a1a4359c75f1056"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "5f9d60faadc7b76b010cd9cf35922b1881377b535e8afc5d9b974651156df866"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "357b28841ea861b8297a4986460d1d265b27202c37bb296dcc69224f9b07fc51"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "9a8505da2fe045ab6c2a2277d2d043374a26f106a5966b00f42e22fb26cf929a"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "f115bb50d1e052584caf7363db875ae222ee37449fa151e2f313c157a6274d76"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "2e7829a8a20c946bddce13b7b3d1b3600f90d90d2438f3eb69188d47203b264d"; }
    { locale = "or"; arch = "linux-i686"; sha256 = "9ad48bdf2b7f1deedb05bdcc49740d5075ebf6ec228d82a7ed455c6bb36d7cb0"; }
    { locale = "or"; arch = "linux-x86_64"; sha256 = "a007bc73fb1ea7765016e9faebac2c4f5e0111a45b3d75d1e55f4de8931796a2"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "8a38d2b1516ed4b58e36d266cd25a5bd10548f9e412076c9b4f1f27256c98c2a"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "664fa562261532d0f6bad10b84e15d47b69073768c2d12986c8d776eb1af8ddd"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "3bb8963f1e3dcdb22cc55feebb2583fefd6f3760f4e6f2cc754174079d4ca07f"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "710f1d86d2974d6ad3c63ebc0873518fd59f218ba07b27d06fb75c83af2c632e"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "cd2fafbd2291bad8481c4086db3c2973a7869b28a5e68a5ff199079814c6b3fc"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "f0ba5dc2366757841afb9c9f7799c40667304c36efe7da284202e8e7a45aa1fc"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "051af14810ad0cee4487757833f1f5b4a6f6f903f3cecf00d00410c1324d9ce4"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "82102b33dc1989bc3aa49da3915baf7e4012afe6e4bd7f80a301dfe847f3dbbe"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "02051668e46d98f4e2e5becc3192f6173dfdf3a48cc82264c5821be06c5e12a0"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "9600c1d272785b946058ffac9e57a8b1701d065f24fa940ad22e4b5aec2efad9"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "7f17cbd3041396135eee08eac597c8c6a936e5a33d67d2b5de8ae157a56719ad"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "ba1de85abe53a7d66f6311d6a202d91f86e871bace168cf60a759ab0e17eccdb"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "9dcd0c2b5671fc5849b01f2932504a7217fca9a4b4eca8e9b6ff8f5a146517e2"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "725214900968e4e648d3d13635bf72d34910eb31a30b83a3e7ba9c5c4085c2d7"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "d22ed75aa727351efcdba1cffe8e24ff305943c9a3072cac08b004677cf6a028"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "89d60c682413949a6dad4b7fd49cc4508c4e067fe5847c5f21d5e25a953f195f"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "4ecbc58df00eaf4fafb1c33a93493bdd3e544562a67c60e2d4d93da90d369261"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "75baa2c5153e282e2671d6222b7fc8c3b9cfc2b9ee0a595a4451fd314a928fb4"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "53e2ae3525d0bd2005a86bf7ed3f27ca66906ddfceb85a738bd60e46ba2df773"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "2dcc5592a49767dc3f2a7d40387bb550fd36724419ff567f9d107e32b2cf2d6d"; }
    { locale = "son"; arch = "linux-i686"; sha256 = "d3b7372c59b21d0393768197517b3666ab78705b04a6e84a3345da031bad3776"; }
    { locale = "son"; arch = "linux-x86_64"; sha256 = "fc017e7a18701880c7a54c23a0f77a6521aae17880dbc562e2b37167ba918fa0"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "7f9c9100c559ebfbfff35adc694199079930f4bf9f1f6a820c0e17d80ea0e12b"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "0f3fcddabab8263eb4c238942c45c0b5efc20c169948da24c56ed401a85209dc"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "6281e2f849b3c530ff383cfd4cdc4ab06115362c3d57ba8133a9f799af08e815"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "368ca83faa5ef3640f71d977916614369ebac1622681e828b75e9abf6ebeb425"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "9f77f497fc3e8c585bd546c0bb95c92f9f37d683e092c0762b3fe0022b6d39b5"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "0aa21764f0ca58591e3cfebba75196edd51a8fdbadb738f036994178c9612a67"; }
    { locale = "ta"; arch = "linux-i686"; sha256 = "463ce70405d84945c201cca56c84171e097e6a0420d38cd453a0836fad82f09c"; }
    { locale = "ta"; arch = "linux-x86_64"; sha256 = "db7e78bc1f4bcb573474806d19324eca58f42008fb0b0fa856f701f1430aeefd"; }
    { locale = "te"; arch = "linux-i686"; sha256 = "18643daf675f8ef9785a0039d012c3a8ce96f4d228426651c5f09c292cbfb335"; }
    { locale = "te"; arch = "linux-x86_64"; sha256 = "d9f8a260fc47b608fd523c61e9c6981776997f4b7fc247e794be32d177abfbc0"; }
    { locale = "th"; arch = "linux-i686"; sha256 = "e03b80d55d2a545ab3219c5e88ed6b7d6974945e32321a2fc96039a6996638f6"; }
    { locale = "th"; arch = "linux-x86_64"; sha256 = "0416fd2b7e7ddde59a101fcba8258622a83b739effb327984fa8405e634c2121"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "75a49ce141c9a04254185b62af72c7e8c214e19e5257ff308b294aee6ac49a28"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "0845a554b299b848d35894144d3ba5c7e0b808bcc9b2732e904463258ca73cb7"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "a89f58c0f20a3ff7e609f572a4786f06b48886b7e2d303824417f42af49c8df2"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "b45768588aaf80917c8ad40d62835cc96c3dadf97715234e66542b96eeb8db8e"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "3fc35e59ecbbdf1b76b5b66e962a60eb724d9514d622879108725bcf7881fd1e"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "88116edeeecbfe1ac03af0da26aff84bc3aa5ba00574e899ec08e0d68243f509"; }
    { locale = "xh"; arch = "linux-i686"; sha256 = "a3afd3ac14049c72a9be28fb9a0849e4d3c5c2f13cb160c480988c4231679329"; }
    { locale = "xh"; arch = "linux-x86_64"; sha256 = "569587e9cc4cd99899d2939367d56f2e4e9ae333b583064a648f05a8b0b58e2c"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "358e44998142e56356b839a51dff97fe85e6293424bd0c148decf61f01b6125b"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "7b5a84dbbe361a775aaadad8fd328e24f6cf2e336297f1d5906f51ff5d3dfae7"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "cf2cb9bed37dffe178a524ef5fe983e0e8b18f17c999e98474ae13e012da54da"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "aa0f1c5fb96dc4585e70fbcc291c6842be25e5d59be8bf39e8dc0232e9f1a76c"; }
    { locale = "zu"; arch = "linux-i686"; sha256 = "775f6507ae8d6c2ef6e29e6b4d00453dcf9a0c9651eb9da482c78b5ebe64f2cd"; }
    { locale = "zu"; arch = "linux-x86_64"; sha256 = "603510372a52497a8e41468dbc193afa25b0615f504f4548201deb89f27bd354"; }
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
