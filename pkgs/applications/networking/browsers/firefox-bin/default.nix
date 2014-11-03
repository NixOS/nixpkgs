# This file is generated from generate_nix.rb. DO NOT EDIT.
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
  version = "32.0.3";
  sources = [
    { locale = "ach"; arch = "linux-i686"; sha256 = "fd22fab9da5ba843876e0daf7db5069e3898a8bd548f8b324169914c88c02a10"; }
    { locale = "ach"; arch = "linux-x86_64"; sha256 = "221028e98d8cb1cb330da4d2707c7cf98d2ae0066081f0b505d6cc4fa8fd4b30"; }
    { locale = "af"; arch = "linux-i686"; sha256 = "37c93da084d25bd47c6aaf5389846ba4ac1e68a8989c03890b69142a46a2dddc"; }
    { locale = "af"; arch = "linux-x86_64"; sha256 = "91dc95820faca47b031a8685a12e67d2f0b7f2cc9be5ff40f316bcf4c4110eee"; }
    { locale = "an"; arch = "linux-i686"; sha256 = "c1251a6eb097cfc2bfa1fb137bcfcfbea333d457d57de3dce40ca60b96b07a53"; }
    { locale = "an"; arch = "linux-x86_64"; sha256 = "fe010c04615c743f0500f9066bfab2e53d799074cbbd17c458b072ee741547f6"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "e3482b3f6629c3addba28f86496c6608823b0a462ebca259bc9acc9ccadd07f3"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "d2ba7625730d461d5f870ad4151991071ed36f141c65872d2e9493108d495603"; }
    { locale = "as"; arch = "linux-i686"; sha256 = "7f44156bd7087d5ddb46f8ecbcf2d7468b32cca7ed7ac88989e604b9853d603b"; }
    { locale = "as"; arch = "linux-x86_64"; sha256 = "a189cb96dedc9943362eaa70e851c64e0115c6c526d9d38a38ce2d79d80dea56"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "5d62d0d12f4cd678567b470a1b6d94ea5889a5c6530a5d3d0b4d07c04bae1f18"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "2e6f1caf2432ae2e6b6b3125449f7dcca1e2a3658ce267a0320aa449934260d8"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "d41d7abad29170d7d5df953bf9f3f22c56df8e85ddb4ba657cc0cbf357cdef0f"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "c899602dcf3ca72c657cc30ea54f986f44943ea9583da1dd6d48ebfe4489b7be"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "e4ed4c432b3f399a2f7aa93ae62ae1ffadd8e4758c44f359a0faa401c014a3da"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "138dc4afa256ca1a6f50ea250df5a032c69020f629e2b91843947e73f8e665c9"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "30f450b36b71431f87e016c09ab0e26f8ed72ee7a0cede0689be13d8b61a882c"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "ad320fef3271f5c6955404847552d11800ca8e8d7821cda53eb3311b6014281f"; }
    { locale = "bn-IN"; arch = "linux-i686"; sha256 = "1e4b1b3d06cbda0aacb1d971b9a70f5648f05e9ad225de87739baef602b3d58f"; }
    { locale = "bn-IN"; arch = "linux-x86_64"; sha256 = "51264d05eb58cec598a726b8e29e583355431c429a6f9eeddc16360ad0ef0dd5"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "e0e661d835297bb895ee3d2887fb4321b9c3c5af73edf5d36d365b254b0dc731"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "94c8e2b56ec784f3e2912a36bece9866c20e419069591517477b67156ad65f47"; }
    { locale = "bs"; arch = "linux-i686"; sha256 = "ea2950b6c81b6cb108b518320c0e53406c972b6d46944fec39f92c10722be7ca"; }
    { locale = "bs"; arch = "linux-x86_64"; sha256 = "4ceba96a76ec7631dc524d3e3b56c5994967b7ef227f38d3e3aa435c131f561a"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "eb68c1f8e99ab00ddb9861ece4f1d17ca07c7e77fd4c2d4f4ff233f6f0018ba4"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "17fe82eeeeb6c385010980984b04a8e71d3770a0d36d83e26786a5884aed7c05"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "69e2a0769284464a95db122fa97f1dfb268b02b754fe6a4842683fd4c94d9a13"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "bebaef3126c14b4d23c024176170aabb090463cae1a1b72b6b498ab3720bb9cf"; }
    { locale = "csb"; arch = "linux-i686"; sha256 = "9ac7be93d0c3a72460ee3fea75621008bee5b2e85b78796f02eded8239562d81"; }
    { locale = "csb"; arch = "linux-x86_64"; sha256 = "1af41e62a6c9ee47dad2d031fd7dcc0ff8b773ac7a912e6888f068e533972dd4"; }
    { locale = "cy"; arch = "linux-i686"; sha256 = "339ff34b6b6d79db48b83ec9cc34fcb853652795e648c82845bbccf910b4286f"; }
    { locale = "cy"; arch = "linux-x86_64"; sha256 = "686e466692bda17671d2ebf3683d03671c8d063c6a6008f3b27455656a584c95"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "67f0ee2e479c49853929cfb1b7fefe95d25d563d67f88f1560b21abf60cd67d6"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "d9f7cbbaa576e501edc9c03df922f708562ef1d3f84eefe010b8138b23399e40"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "a294f585d7f8247ecffd6c71beff75ea07f1ffb1af17830aa54904b6e9c4a71c"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "6dd118ebe633c66ebc7ef0bf71dcc4d5c2ce42552a4b981b74442e184fa8f3a9"; }
    { locale = "dsb"; arch = "linux-i686"; sha256 = "7b989e4a804e366b7dc4fcd500968851e0978b2cd0f9da95e6f6504b9ccff7de"; }
    { locale = "dsb"; arch = "linux-x86_64"; sha256 = "aa41149f4f2bc6020980920bdf85d57157ad3cee7dd7be0fa3328ecbb11007bf"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "f1b5bc91e4e34d6f17f3e4ed65fc3ab71e066b41df3ec0ff8c1156a4a51d7fb9"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "fb602fcc45c21c26aa7d15924182d9158064d43c14c44c62786427eaf51d4b1f"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "ad269f2192a1d635b8b930aa58a0303a544221e53b38aa8c464c81d807e28477"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "31ac6558c5a1deb512e937a52ca48d2183881de53685ca0dfaa63dc4495e0a73"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "265ae5df1a5f2edeae8d08bdcde45df0920f6fb0ad70385371d06ff890017982"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "1a917f88835d8796c52a52ed5c14a9ea71e595de8515ced1ca1356995f529bd6"; }
    { locale = "en-ZA"; arch = "linux-i686"; sha256 = "e345f37777a2d7fc763c24c7fb4fe3c6a99c2310066ad405c375b8af069eca84"; }
    { locale = "en-ZA"; arch = "linux-x86_64"; sha256 = "d86bf38fb667938852531f081caefe10baba79dc35ff737fa468744911f6968b"; }
    { locale = "eo"; arch = "linux-i686"; sha256 = "7b4069d26d4abfdd9878192fc7c5a54686687c401425205bce064d9720ae6f7c"; }
    { locale = "eo"; arch = "linux-x86_64"; sha256 = "b1a1b3b8c0c72856e5bb6058dd0ea2dabf2d9dee084f0355a248bee253838b29"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "5ef56bebe60802f449bcbd1e53ae6726c5109c559a8a9707269de2a31481764a"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "65f909b7f1e67cfcebbc8cab1377b967095b5a7f9650c7fa861544bbc874b59f"; }
    { locale = "es-CL"; arch = "linux-i686"; sha256 = "0b7499173c0f44ccc4cecb49e1801bb596d7a027c5ee39678252530672785906"; }
    { locale = "es-CL"; arch = "linux-x86_64"; sha256 = "69573ffa581de80f21c0201083febcc7de5549d9e567f02227f7d4567c1a97f8"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "640bc3111816383cb69e59039289737ca5d16ec2f5238b694348e9df1db794a0"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "fca7e225eac47f200c3cd01ee617a1fc6bbd728eddba30bb4583eb486155ab47"; }
    { locale = "es-MX"; arch = "linux-i686"; sha256 = "32342a144805a3c4e6bab5de0411116862d0b8276befa6f8689eca5d9da01860"; }
    { locale = "es-MX"; arch = "linux-x86_64"; sha256 = "cc189b4d4abdd9e90fd0dbfcc5b683e2a717f1f41a7930d9c0b6c405de97a9b3"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "b203934a8292393d84f389ca3a13d25e0c9602a10faf60804b435cf45f2fd691"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "4384025c813efa759c2dd62ed735d662f26d1037e95e892050987d4b2f602a45"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "179fb3acef15d262a9d2f7347a32f1d99bbcd5048c5cab5b69aaccb35afe82f2"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "cec3a33bc9950f97f14fc6493158e095e7a1660e4d104c2ff23ce655813d28cc"; }
    { locale = "fa"; arch = "linux-i686"; sha256 = "7ce8f6af63ad6d683e5e70e9b077c2452a7c0c040bad83efceab860e3d41d288"; }
    { locale = "fa"; arch = "linux-x86_64"; sha256 = "14f7b3f7c7eff44db26c3b55ae85b8625354f1962315fd40e3df4199b067d303"; }
    { locale = "ff"; arch = "linux-i686"; sha256 = "f4c9eb89160a5d4bf815715860fc4bc6bc7954e544182e60b204a031f83be5e0"; }
    { locale = "ff"; arch = "linux-x86_64"; sha256 = "b774f005bb5dee44eb0974834b42441b47a68f733ef22446b2547aef898b0c02"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "873cf1d866f5db419549a9c39fad9524599a737d80c6568d7a5c9c3739d36cd4"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "29f179920b198403f983b11bbd3f1b2d2cb83c65f5f8edcff63dd891d50c413a"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "ade608f8965144177d656d33ff4fa2f8fbd8f54861fca68ac74abab9ca085ad5"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "9bfade44971633bca8b12d6e2e05de6d20ec55e368d78da49e44a0131e9d94bb"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "6124308765f3456ac066dc734d245c455168d66ed59a8a65edc1b59ff1130169"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "9a60afeb858c1e48e21e112f772bc2efd3ef2891b51d0241384658905b140709"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "2de086f287e86d29579896e8fdd9a4d43ba5ed49b5042e4b5c71ff6380d21467"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "4f2cb11d743ac7d6fb5bc319c940729aa81d9ac97545cf5c6096fcd0d2e7de69"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "c18e5614d73f79df017b1cdedb6949e907ffcdc4152ddfbd56f79242a742f13a"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "4b64e007698b2433ead4b14b87c06fd1682ebe7e90ee881d310a8cdab2cd4d13"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "b319a40c4fa9c81533f431e95ad8f33d365aa799d3dccde5188beb3442c8422d"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "04a9103e56982e4529c361647ccef527cfbbbb4e88a96a708c0665ee04accd44"; }
    { locale = "gu-IN"; arch = "linux-i686"; sha256 = "a15bd410f9bdfde48438db95c44d91472f5567bd41c529b13a7b4d057f97a6b3"; }
    { locale = "gu-IN"; arch = "linux-x86_64"; sha256 = "8046ecbabf700872e4e8cf5d1a1d3df53f984a00415e49cb1d21bd507533f4c9"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "8369eeb403ef55e61263eafb61e8265f130d5fe4dc277b5e68f6efb65edf6702"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "a602a9944685ce688a002ea87178e1231170b78ba6ee911a3c7effa41768ecb1"; }
    { locale = "hi-IN"; arch = "linux-i686"; sha256 = "6eb2e8fa05bf7470f1be9756a5e529e5949f3e0796a0c663ee44c7264846fd3b"; }
    { locale = "hi-IN"; arch = "linux-x86_64"; sha256 = "7e39439801361ab9051941323987364678ef9b1fc8e765bfad2d39d836b7bf85"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "84cabd389757c61cea75ffc642a4b52e544e841a124066701eb071d2d88c15ed"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "0bc123e9a5190d155727971c2bed078a5e6b857daa22f2f4bcee4aee76e07bbc"; }
    { locale = "hsb"; arch = "linux-i686"; sha256 = "7a5d5a4a7a936defd6c3ea3b04550e39398428f90722d521490b700133964f82"; }
    { locale = "hsb"; arch = "linux-x86_64"; sha256 = "545ec5865ce941ca3bc635032cd65215111d56b3f0d68814efdd8ecacaab1d1d"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "b540eadbfa2bf5232049e30167ccf16249786f612ec152c14999e660eceb6497"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "4f64d672481bfe88f40fcf944d98fafceae18372c1e2373bba8172877d7555b8"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "f5ace133a64745ecf564996ebd6be55ce3ee0ee5be2ed8fe6c66414833d1e479"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "e949bffb9180b0ccdc6794b99b3897f9f30dbea84d9d218cd68477634eb58b25"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "73f2d64106a3404f6edcc66ab59091ffedb0fcd0c7f475becebebdfc4df41e1c"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "20d9193d9fc95a3e040220373c216913ca0099989d665b516b1e5de1cd7bf05b"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "d6bdeb739b5db8c8a25239963bf2f0d096b76f5914f8f4f4a4843e611beaad9f"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "300ccec13085aee1b011dd0058c279a31981b3e91280440672e09c71c4dd0eda"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "1e02459ec7e62ca3038018e6c88f410e53b0d7b3d1b6cb94d74ad0218a54a948"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "ba8e8a9ab5f391a5560b7bfd41dd853c6b52c2ff59ce8424f96236263985029d"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "681589c9748b0c7f78ba5c4afa0f254af6f92a0c0cfb504df6b29f94a917f8bb"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "7c6447f4dd823e1517ce12ad0b295b53a22d3a0855e1660fac9563a91f6999c2"; }
    { locale = "kk"; arch = "linux-i686"; sha256 = "0303c9b812115d3ada0d8fdfcf8e77143f4239440935bfaad5340d33a3270b8b"; }
    { locale = "kk"; arch = "linux-x86_64"; sha256 = "168b2ae2ac9168ae674d8649840fd7cc93d95325c7c0d60d7251239b776e5886"; }
    { locale = "km"; arch = "linux-i686"; sha256 = "04ba6e90f883e52809e51202356e4abda62ae40bb0ed225965ec8eeca333457d"; }
    { locale = "km"; arch = "linux-x86_64"; sha256 = "4903ca63d1ffdafbb7ae36eb7221992101a8a013928e25a820aac51022cdbade"; }
    { locale = "kn"; arch = "linux-i686"; sha256 = "2fc54219aa69f963c86e47fc2cafd78bfad2bbd2a11d2fb947786eaa30cfe255"; }
    { locale = "kn"; arch = "linux-x86_64"; sha256 = "8fd8e3de5ba9bf2f408da21bdedc1d2baf269fb33251d38fc84ec8b9c2fc86a8"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "eba2c630a59006bad5ff822409c18008e46a327e2903d88461dc88a54f573baa"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "baaafa60c8101ea2dfab30149e7ac6b953a63fb7c835e6aa1488349ce8a98384"; }
    { locale = "ku"; arch = "linux-i686"; sha256 = "b1333ed8afb9cd20b0e24d25e5747f466050acf1fc4ae2924df1bb345ce49f90"; }
    { locale = "ku"; arch = "linux-x86_64"; sha256 = "dd87578c93884388871680ef66f1d37e78f78939e7182a7d3a41fd8287afcdb8"; }
    { locale = "lij"; arch = "linux-i686"; sha256 = "6bdab68412b7d08da2023da4346eeac231bbda2de36d7225b7f7bdd23a36dbd6"; }
    { locale = "lij"; arch = "linux-x86_64"; sha256 = "d31d69421e74bf089e74f70e5c595284a8b60ce153c7c3ffd83e808adb1bf371"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "4e15475eed19edf5080695da8c9dc94d3bc28e064a30065a1adeb6ea11adcce9"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "f5b94a979a1863d068e4f35f71476677febe23de0de2dd803f44e57d2a196c55"; }
    { locale = "lv"; arch = "linux-i686"; sha256 = "177f771d821f7501d906fea0bec54d6064e36ce74dc5e17596cdbc460b7c0115"; }
    { locale = "lv"; arch = "linux-x86_64"; sha256 = "a958f13c3be77bdd1ea10edb5a453f54aaf6b2b7d00981762ea946abb2aa0a7c"; }
    { locale = "mai"; arch = "linux-i686"; sha256 = "32ee3fdb74c2023952071679cfc271ef548b0ba278619f0d2c2f19596c1b5fa1"; }
    { locale = "mai"; arch = "linux-x86_64"; sha256 = "c4bb89d5c9b16a4814a628ee31f8628cf287864db44d55ba11321d8203a1fd1c"; }
    { locale = "mk"; arch = "linux-i686"; sha256 = "b7ef5bee8ed38ba31ee2e2c1ab010e3a385b97096fff0120bb279e82b6220464"; }
    { locale = "mk"; arch = "linux-x86_64"; sha256 = "edf82adb52759c0d60f4bbf23ba1e0b2f7bb47475c80621a508e8a46c6221d06"; }
    { locale = "ml"; arch = "linux-i686"; sha256 = "265e68ed9ca02987ca9bc165b4fb69217e4e7aaf73d7ceb83eb0a3d472a3cbed"; }
    { locale = "ml"; arch = "linux-x86_64"; sha256 = "948eae17ae44b03c01124243f2246abe98fa6fdd17e9f174a8b1387f87994ff4"; }
    { locale = "mr"; arch = "linux-i686"; sha256 = "d3941188b754ec8219b0682eb8c3b531debbeccc0a5738a6304bb18075e473a6"; }
    { locale = "mr"; arch = "linux-x86_64"; sha256 = "b40f07132f883a703caefc275ad4a3a6d65f0e5535067595ddd9e7ff604ca315"; }
    { locale = "ms"; arch = "linux-i686"; sha256 = "217ae6fba0bb782e84bfc7d7658971c72a8922c4b8ae32abcacd8548c3b865ea"; }
    { locale = "ms"; arch = "linux-x86_64"; sha256 = "74d4a6123c40d92db7690e518d6943c916ee5a8ad266c94bdb8edc0e31f7e744"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "cc66fba1d389994b079962e78a7aeb2e4df8c3eea785ada286983a12329c2699"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "20161c2e0fdfdc65625d31d6ec1fbbdf2b88281e44b9dcbc9c4e5a07bf03d105"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "a8b86126c00e2fefe05a3783e03c7f3f6ca9575180b3b275b1dbb85c68cb126a"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "61fea91996c56b7279dc88714567b3e63f69d1b56a2922ea9886b74a69045d53"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "594e4c7393b6692bcbff4a732cb22687207cdbbfeb1d66bd10d7784fa60b1fd1"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "ae78c76d203532c34023f06a6c7a3f26e864a1b95aca358b7c680e275b250c8a"; }
    { locale = "or"; arch = "linux-i686"; sha256 = "b26642112413d3c53c6275a8b2bbaf162f4bdbaf9002ad4479b807e3447b2abe"; }
    { locale = "or"; arch = "linux-x86_64"; sha256 = "d212b39c68a7cf8619c946ff7e94c2081ba2a9fca3ed599870167477a887fe87"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "e28e4bec4e4f9d151bdc1e1ffbd42266052fbd81a479c70196a614f825e42f9f"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "4874f5407d8040a5e447d5a22a8d9e433a6bda273bc813654d95e0b9abb02af5"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "f738a7209e3da17fbc2c955148ef1e0ec08878acf374b9bff2ae6cb0b3b50138"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "b78325bc9ab80c176ba266cc6c46933f78ba69e0da44e6526e7b433336534d11"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "dc1564eeb496b1b8584338879d26cfbe4e2191eef204c80ee6a2f9c2d4722426"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "48c8bb9a52ae80c74f6fe379b28cf072d8275158326e752c776c27409578fcfe"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "0e74d57776d68d3d35e26b5fabdb66016a00d8bf22c6ec458ffea2e2e233227d"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "61d5fbc72f928e59cdf93ef08684e4d598b154638bf88cdace7d274874efa040"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "1baa7d0d61394c3108ff7d91798fa917e63a1a0943785f94697619cbb684148a"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "5cec6c5c013997f1ebade4d139d055b1df3fb5ed75dd41e335535dbfc6bc9359"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "78e4f327a928aed2342d845c9e8e4458eca8f77898aa2a7dd5f7ca55fc61a62b"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "320c3dbd605c650b378ed8e93e8b2518039c8efab27471012a498dbc51d1cac3"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "3fc9d98a86e63717dfeaa58ece0dbbb1a0523801c56c056ff74a60491a27fcb9"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "1d95e946fbb109380ad2e2fd5986f12211241113e218ae7ecb43e009b7aa5a37"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "12d8e83cc703c00da6054bd32bdf39993b588cbb5374880a3961d5ab476b6d29"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "4ce710ccda7b56a46a8fea2f42c499aa2296377a0979f76f19563caa85f4517e"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "86b726c25de378d53a8220681468fec88a7d525288b02eb9b700b12f87739ffc"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "bf8f6bb1b5fd7c82ca14f1802e7914e10b981c04d3ca89df983fe07d7df5b88c"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "39aaca3b7a559346aa418fd4abb1f2a44dc71901050a212178e3cbc7b870e6b1"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "85f5f097c7b9a07bbcb97caa9c8e5cfd16d3636ae17b41ec32e91d1238134db9"; }
    { locale = "son"; arch = "linux-i686"; sha256 = "2b5a33079e835afdf0246f8b4dec1db92fcc861636a75333c75f6d5d40c14201"; }
    { locale = "son"; arch = "linux-x86_64"; sha256 = "4d91324e9b7f88db822216440d5420b0c8b0898bdf77699a6b0fde1ab4db2f0c"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "e3e0194f5e72904b056be4b3e941c015d5af0d9f1a349fa39492a6cefaf5236d"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "45767fa6b57fb21399d4850fa88a3435e3fe0bb679de56fc1c28767eca235ba5"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "0f7addd1581d8552b874651bc8dde5b2fe4d4b814c694272674fb5f7732000be"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "7b68d38004216c86e3eb648fa78b06da88a703d68343f723f8e9d577d4c1224c"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "5f76d137052ff04da12e80f08a34a09c6ccd92d9ddf2f6efcf193940a948f86c"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "1aac59a70ac58bfe1926e87a850d7a5a2783332cfd49d9df1ad1fd3e276a9a29"; }
    { locale = "ta"; arch = "linux-i686"; sha256 = "2716d50134514693b5d6edafc7c127c708b9973c39d42823987061547e4c18be"; }
    { locale = "ta"; arch = "linux-x86_64"; sha256 = "9c9310ad313227cab38d8cd9ff6c4d9c15037bd39777a7fbd4b23ca71a1ac48e"; }
    { locale = "te"; arch = "linux-i686"; sha256 = "ac7d78ab767b13810ef7f313c2ba92067756082667db0e256e916f1f0be8c9fa"; }
    { locale = "te"; arch = "linux-x86_64"; sha256 = "cd6fc0d115fb67272f205a3595c82107dc8b20ce0696a2de8da6f82a7ae07112"; }
    { locale = "th"; arch = "linux-i686"; sha256 = "2d17b346aa296b79e880b83185d3608de4369de62e2e0ce2cfb8d2f3dd6ee97f"; }
    { locale = "th"; arch = "linux-x86_64"; sha256 = "331f2c59b2659c65c6899455e9ce55cd54b8debf4d17a60a8d6e76e2198080b6"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "491550857b3b2b3643f1798a9e871492177cdddfd17366057d147e1fbe1ca40e"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "aa8677def660eb8a3d258e7e7da05972e84be96807c8c7912f15bde05d749af7"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "9ebb7a0997353bc84b5d48ffae1631d30a70ecc3ed21010fc8499513e3404651"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "d686139d6622d6867cb9af95ec0c5e79866974d12468722d40c0ede104897034"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "e56c74b2f6752667f9448c081114065aa0d1c63979cc4bbbf1965a7acc62133e"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "41c79d4bcca7c28d02108129de1c8c93f5666bbaf651faef1eb9b424d4e8cb5d"; }
    { locale = "xh"; arch = "linux-i686"; sha256 = "89f30d4950fec07c9f1df426c1e5e9f72ab15efa5db93d243418909369d69f03"; }
    { locale = "xh"; arch = "linux-x86_64"; sha256 = "f97ea6169a6bdd4e48a0aee72ca709ebc1e2032a406d3dde6d8a6719b8429ee7"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "9ad1e75c6ca5f38bb565e747cec2901ad567efd69efa56328b912e37239f5b9e"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "400baea252b6f92051e7b054bdb4a4827571036ff7def10cbd841cfe2eaea60a"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "2e7bc62dd7c6c41c5feaf8cf9131bbbb0f0a3403870e57066a98147275b120fd"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "f2d620e5f4e8baac689557dc34ce582aaf36bcf4253c4f7cb00db52e1e1db98e"; }
    { locale = "zu"; arch = "linux-i686"; sha256 = "c9915d4f1b637934ba22dbb81aa2f711417fd5600c6efe25781f11bbd0c707cc"; }
    { locale = "zu"; arch = "linux-x86_64"; sha256 = "8fa84e20fb1e21947a8f727bb881d8249bf384944ee9693314cb39715547da5d"; }
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
