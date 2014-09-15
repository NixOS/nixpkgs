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
  version = "32.0";
  sources = [
    { locale = "ach"; arch = "linux-i686"; sha256 = "cef5938e567e6dc4d0460c1eb3f770d2acfa045d98186f6a490ad53b3c69d302"; }
    { locale = "ach"; arch = "linux-x86_64"; sha256 = "bd5427dfd1d11f8a9a8d4803608453fdb11a7d304aed618f26b3fd6667a0d131"; }
    { locale = "af"; arch = "linux-i686"; sha256 = "48e97eb3c65b381b8fe579d9a3cb4e4f28f06137043be1a54288f3e85c1f8312"; }
    { locale = "af"; arch = "linux-x86_64"; sha256 = "fea64b289b3ee69ec0efa55b0d57998485125bf000c78e1c4567be5b40e1ac34"; }
    { locale = "an"; arch = "linux-i686"; sha256 = "022110d1b31f51f5e9aedb2eac01159fd7c14e9c787530c246ba907e68317d0d"; }
    { locale = "an"; arch = "linux-x86_64"; sha256 = "418f9b1061950b93ff8a2889a47ebd65c792a221510eb15ec6e0d67c73fa4da0"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "228739f558428aa97364da3869ab28e68499e103bac0af7c391f1ee66be97754"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "44255bbfed7a804a205846a2c634a0ec4868a05f58a9ce0350ac3d2ce147f500"; }
    { locale = "as"; arch = "linux-i686"; sha256 = "0a40d888a10b2be8b76ddab70e32a534a3e95a029aac4c8945bb71b4a6e63d3d"; }
    { locale = "as"; arch = "linux-x86_64"; sha256 = "a55a81da699c51b3bb422ba0942d548373d2a207c6e8eb0d7abde50dca6dc57f"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "61826f0098f2535a1019eb1c7e21fb8971f66fa1d39bf773a130e96cfa99897a"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "4b84870ecb220189ab59e837f74a2195a38265226dce5542841187d35dbd18dd"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "40029f2cdcb4964a43193456f436c3a9428face17ed3ef4b655e3f1bc47c217c"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "7490f9815dac528c32d0254c9f5e7834e4af6b4e61d6618d235481b0e086906a"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "320e9f8c338d180cd90390b3dbf38b2ed17ab9606ac13c79d64ae114e72653a1"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "921ef8a9beb4469d5faba09e6786415dce37030a4c24f6057ec5fbe301113dd4"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "69833779015e09952825d0fdc6fb9283379c9b9a26d7bad4a12bb29bb74c277c"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "de3f0efafc6b838e90d550287d574f9fa26c9b2690fa1fc48b766b9d478fc1b9"; }
    { locale = "bn-IN"; arch = "linux-i686"; sha256 = "aff667e3277bf61f3b117ebd13a3ce469e9bf6ba58b7dd736d8913b234c4a4a4"; }
    { locale = "bn-IN"; arch = "linux-x86_64"; sha256 = "c446d8a57a1542eb2aefd4a0b5304917dde8446c94c11d8f80110ff881878bb2"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "5f05c4bb347f5150c5685e7308aee338b6d92b8cac204e7afb326d2c44ff8dd8"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "6dfa3436ddcf6f47e7d40846b09ad4c7555aae40f25f5380b30a0776d0368d37"; }
    { locale = "bs"; arch = "linux-i686"; sha256 = "7df19221c455bfe29e9a8eb6f48088e37be5a493319c46e45b48a72ebbac1df2"; }
    { locale = "bs"; arch = "linux-x86_64"; sha256 = "aaa2c0f3eb430337e865732c0bbf3d5efe72869954607f5560c8925bd736cfba"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "9c725ba77e778144e31b907b2b4cdd4f045dc6ce12bedd9bbb92a98224a44327"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "30a27b9558bcc7f7c03f4a204e20aabc9b1d4fd5240a93fe14e02f95ba4f34e8"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "491b7114f686235233e3ceb2c7db47d8bef426bd1578545f5d1cd001b15afb71"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "098596de29865bac4dcb642d8da801b7707fafbc60f25e5c1803ed8aaaa77d50"; }
    { locale = "csb"; arch = "linux-i686"; sha256 = "a53579fc73f5bf4811ab608320b0d889406be9b655574fbaef2aa8db7478e023"; }
    { locale = "csb"; arch = "linux-x86_64"; sha256 = "903bb549115252d2850ab7cbca9d46890cb8ee5f40ac7b8740fc3d81a1225c68"; }
    { locale = "cy"; arch = "linux-i686"; sha256 = "0f3db887046a8f5b597eca5d943a9eed295f8ca7b8831f8c27ec6c833c63b2b4"; }
    { locale = "cy"; arch = "linux-x86_64"; sha256 = "ab680b6ef58106766de8aeae909ffd313abc03f2400a06e2b3f8371e211a0a0d"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "47280c825f065cfbfccbef0077032f3c04a75f860eb5a31861515295b6a85050"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "25a93f49d789d3d5d6d3fa82cbfc5f5c195a8da4d1dfb12c113d29b125e71e79"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "2922c1a06f37322c05b6ad66a95fd7cdc2ad10a86ee082739810060a932bea55"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "5dadafb7e44eb174c717101a336b00a03b8f7fefb606f356c0ae4b00209d5723"; }
    { locale = "dsb"; arch = "linux-i686"; sha256 = "047f3c1b05ac28e1e566451e6b93fbb88e300afb0f264faf17e72ac5f9aae201"; }
    { locale = "dsb"; arch = "linux-x86_64"; sha256 = "f0de9a6713f197a4664183b4fe80179543588cbaf83d4f174f360177e0149a6d"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "5343cc2302d49a57c3fabb7b03ca4f11a0eb979bbab7442262bc34186b3bd596"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "91ab977a9089fc68ed54062cee6d0a71caa2591ec5d4994181d8939605baa114"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "1d4c0d24b2558bd311f9f6cf44186596f9634d7a5c69b4b7648b59a2443272bd"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "7c13ae7155b92b7aaec599fffdbc8c02fde8b6575f892fd3e5edf67c3102790b"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "1a6d8fe7cf0df7ccee2047c2031da4b8f0ef8271d6413e0c7bc87bf208c8af90"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "3b9793fe7957031f88f240254326697e685de3690aac1fa13d447cb2a23a2738"; }
    { locale = "en-ZA"; arch = "linux-i686"; sha256 = "63fd411e37656bfe56fec468f47dca7a61ffe5f9be3ab1c23ad252b8199f39d5"; }
    { locale = "en-ZA"; arch = "linux-x86_64"; sha256 = "3a5510c7a996a50e94e68c05cff1fbf31a7cc787d2bd173828d867d4b8d22243"; }
    { locale = "eo"; arch = "linux-i686"; sha256 = "cf2004a5134c6240bfb05f499cee09f425295ce0bd8d170b0832a845b4d255c3"; }
    { locale = "eo"; arch = "linux-x86_64"; sha256 = "186753142ed4c28eded8861e399ff33bc7738ba75c112507b4acb53ccd11b13c"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "57cf456aed64517f69801d6c19a143aa9a90f85de015be22b8a2e2d4a6b33d23"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "09c833d17aa31e99fa0aae3eb5f296c643c34ea22d94f8b5ff64e2b871e70dbe"; }
    { locale = "es-CL"; arch = "linux-i686"; sha256 = "5b2fca43e84335e8b0cdb5d341402d5b1b57016881e7112a0ae8f5c5374f8857"; }
    { locale = "es-CL"; arch = "linux-x86_64"; sha256 = "f1a03f0e4c69d796d5fd4b26aed1d356dfdcdd5ce7f180bf045a97ce308f13c2"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "0167a7dcc31364818981372dce640c408a4bfd2983b5bc3d2726b5525873361e"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "92dac800255e1ba12c48b8078b8098ae1b3980401c6da54c3798d853c6685c13"; }
    { locale = "es-MX"; arch = "linux-i686"; sha256 = "e0f7c028869ac2d1edf582622fa2dfe5c6c6dfe042f8d74bc3ec9080dc70a36c"; }
    { locale = "es-MX"; arch = "linux-x86_64"; sha256 = "02669ae0b19e3b1cb8589b583b6de0b0b62f2987ef126c7fcc2efa2cd63e714f"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "855f6c7bf2bb01e08b8e20e7c8d633000c70e64fd37405695be7cf3cee515be1"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "348dc193a4bfc6fc53d203cae7e5b5af68c56bcb01ffec0f7c427017f5d3b98f"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "7a79a9967b0522199c62ea03edc27cd2752c80eeba816a9334e9624f48c7525d"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "5cc04f7915a31d54d858d0e532e49829ab45ccd250416aed1612774c960d0cb9"; }
    { locale = "fa"; arch = "linux-i686"; sha256 = "59ff7d6cd90eb7a4f2e34adacec95ef728e4fe1739a098a22da8843c5a2da1c0"; }
    { locale = "fa"; arch = "linux-x86_64"; sha256 = "529a65d93b5da907cc8f2389996e783d261fcd03711c92aab7be0ee05e92aba5"; }
    { locale = "ff"; arch = "linux-i686"; sha256 = "62c8c769fc847b2fd564e85748e0b8b1249555d86e09d38212566e4dbbb9526c"; }
    { locale = "ff"; arch = "linux-x86_64"; sha256 = "fbc42b7aaf60f83da91b76905ddca103cbdfa660824343348c7b5325977b9e70"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "7377752db6d01993cde0ac9d73234bf8538cee217e3d11089a50c4c2be447751"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "5909ddaa88ad8408b8590518ea4b738d7f581ee827ecd679bd8ebd2208287c5e"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "7c9de38b184ca8d10b0d7035c0b31cde79103a25efc516b98f6a2d91e054d7e8"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "8668f081a5c976cde7bcea6727d1885d77711c11bbb4a0023c9759d6f0bfb619"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "dff7ae0b0a4b18eaae1501a03ad754e71794cef3981334bbc77cd55f15b42fa2"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "3b20b9fe8eee700192296d70b93ff5f21d6667093cbff16303679a3491c78fd7"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "fb4c5e7689668af719f2ed2c16d7605298e61003b6d9490a67742b6146b0f98b"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "f3d379924e56b8296004be9c3dbf381cf3535bf1790e44ee2bb1f6477829def1"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "1768c0e05770c502fe3122dd1c37dbd1e51b9b5c5aaa7cf57a5590e9217393d4"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "95d77215bd1332cefba9dac1f55eaf3f479927526ca6ed38281837b3c8fbac39"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "0af5c23d8e11ec797537c9710b179c7f6ae182bb4831f535848aba0b229ea89f"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "1befe0623ee71fdc3f7508b532a411fb5f8438ca06963f79cd9c3d20c3fdaa7f"; }
    { locale = "gu-IN"; arch = "linux-i686"; sha256 = "d61a8bc5eb6b78a4a9d36078ce5946487e0bb9f89ceaba0feb7c449d486feacb"; }
    { locale = "gu-IN"; arch = "linux-x86_64"; sha256 = "bcfdfe861bfd7447cab99a03826013e77e004ef9b01927b5dbeb0afd40f46f67"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "0b4c596542e65af735a2f66a61743492c146c51373acf7026274378033a6431d"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "96cd11044613c0a924eee6272313f21e01b987982732d6bcc362935d799fa6ff"; }
    { locale = "hi-IN"; arch = "linux-i686"; sha256 = "8640aae3dc8d965ac3c0aa65e3579e7613d0c78dfabb06d23840d39df8881ec0"; }
    { locale = "hi-IN"; arch = "linux-x86_64"; sha256 = "b1b84b405b4d0f5c87ab750ed5942d29018e46b73e298296dc9931f8b3981998"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "006e932d4b7474b5f24628d08ec5e28d45b9a23dfb144599fda2b0969f57863e"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "b70aa31702ea42b85e6ed678cc20bff94267a746cb81ac70dec0d84a244b489f"; }
    { locale = "hsb"; arch = "linux-i686"; sha256 = "c33442ce4cb0d9355c915fa1ea3407f67c0470e8711055bb2fb275e612a64fa4"; }
    { locale = "hsb"; arch = "linux-x86_64"; sha256 = "19d6b48b415d48c278f5ec203ee03136a5f80a8ee566e336de187694ab9862a9"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "eddcf8119a9680c2676720f33d0fbe750e015d7d21f07325bd47dea0b7cc5bd9"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "703e8e9da4bd1adb2e1ca77b221c4ce80d9e2b63be7b27eb34c0fed29a2d76b6"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "3c2fe1bb3bc7d9d0bf1006962e635262b7ab23017ea703746d436e25b68d7ec6"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "602942788ce157b3d2d6a02d0105e1da632a055bf657282131a0946f87a4431d"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "de47061063986cff65ae50537a2dbc0abb3d5ec7f1fc5b2a3c8aa66dc4ca4a6e"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "2d3c4a294c1dc8ece94de489dbef9ce3b4222b0883c5f61f1f90fa881329cd53"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "0ae9ae73771c7429e7f6ec457e656bef034d211a191e5125dc09006a4157b57a"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "8618faa41d021e98d5d010efbead4440828f9f2cc485068fef3f3fef39713bdf"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "e91bbb7a5bc1052b2f8558598fc9c4cb610314bf026c5eae97a7e85badcc096f"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "1b2c610711bfa05aa0ecbd4ddd81724d29f3f162798cdb35b2c15b1a07cc5743"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "c4495bdfc92b1089a3c812d863df20856d585ad9601f41a8c99a522df216736a"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "55a5fc7eef3d8a4bb2ea7b19eff6dbeddf9fe9f239f645b996aba44477cb4bf3"; }
    { locale = "kk"; arch = "linux-i686"; sha256 = "ca09ceaf455f7fdc93e871617f73200eedd9cff32e8704ead4fd68b86190a8ac"; }
    { locale = "kk"; arch = "linux-x86_64"; sha256 = "b6f09b29afe73ab3a25a8cfa2b88ef7f51b83f501990fc80fa886da75916a257"; }
    { locale = "km"; arch = "linux-i686"; sha256 = "920de5e59f13894e0f2b008cbecf4089b1b36087744ee4bc050b32e1887f8e7b"; }
    { locale = "km"; arch = "linux-x86_64"; sha256 = "fee6df7cce32d81675c91116ed89996ceaf5de1cc3fde028b04d6012338527b0"; }
    { locale = "kn"; arch = "linux-i686"; sha256 = "d6587c2a00e4c1a9c38a75f64085bd66e100482a7977dfbb3434bc6a902be313"; }
    { locale = "kn"; arch = "linux-x86_64"; sha256 = "b6066271412a7d4faa2fa028b03f88061477bd5a0ea5e7d5ec8e3e81c52ce166"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "c0de3fcf13a0947239a1310d862deaf5d37836f82f4d618f9aaf09ed69fcfcfc"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "b929dffdf57cb08087e2ec4054ba58368cc5535579d336872b4016d5bddc9ceb"; }
    { locale = "ku"; arch = "linux-i686"; sha256 = "4926a59d15eda575ec3a0b32f8ebecd12a354b80746efc61d0630a91720c5e9b"; }
    { locale = "ku"; arch = "linux-x86_64"; sha256 = "04083b8b57ab3e5693637ca424daa18ab678594b37a56ba4ba9e70c369782002"; }
    { locale = "lij"; arch = "linux-i686"; sha256 = "730ef2c9920b0eb6e511d5725780ce3d6c2b341d03049e6cb8e83ceeeaf191d7"; }
    { locale = "lij"; arch = "linux-x86_64"; sha256 = "b068b0e242ff84055665eb9688d392d98e433ed0c44793734f264b340c2efdf5"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "885ad622f8a36bb5385187995423e811be28a169c8f33d8eec064f04f45e85cc"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "d289b593c8c6ccef5d0ee339de674385b08ee28da7b851230da20469aeba7558"; }
    { locale = "lv"; arch = "linux-i686"; sha256 = "e5558f1cd93264f7f30a9259c28cc50131782d1941388b71f80b1672a29c597f"; }
    { locale = "lv"; arch = "linux-x86_64"; sha256 = "61788b9ef4f13369114abe4a16e7ee89e16d791cf5d3e1eb74eedb88c3a90e9b"; }
    { locale = "mai"; arch = "linux-i686"; sha256 = "a9991d23913da8fe6dcf47aacc23b92055c7019265d6c7a01d9d6b3c7ffa4c4d"; }
    { locale = "mai"; arch = "linux-x86_64"; sha256 = "946420fd821b3ec97bfa1fab52b22111428da0ed919e86c0d33be53b30f5d476"; }
    { locale = "mk"; arch = "linux-i686"; sha256 = "bf10e053684e5e71eb1886f4127743937a560eee15e7c85c9849bc4b15a60123"; }
    { locale = "mk"; arch = "linux-x86_64"; sha256 = "b5d1d9d3eaff11f230c864799c77c8169415ee5dd2e1dab944d91ce1c8e8c054"; }
    { locale = "ml"; arch = "linux-i686"; sha256 = "c899ba567d847933fa40e3bf1be26e8a5fd3bdf4af45db60cb9198b1a6c98ee8"; }
    { locale = "ml"; arch = "linux-x86_64"; sha256 = "fb069df12d603c808c798e43d3ef92868c239a130e078e7492456d1f54cac882"; }
    { locale = "mr"; arch = "linux-i686"; sha256 = "14027be4ec9f060b3ac69975dfa1da7aa0b58531383bd335fe3dca98f06597a8"; }
    { locale = "mr"; arch = "linux-x86_64"; sha256 = "a18dc57bd2b73bf733a0ad61b7ac9b8b4bd149260a4c59fed171b76e52eaed41"; }
    { locale = "ms"; arch = "linux-i686"; sha256 = "3fbd39a0c2def17862e266ef295a38f93400135898348e6321fd37829461660c"; }
    { locale = "ms"; arch = "linux-x86_64"; sha256 = "0fb3bab95d1aa501304069aad3c4a8ec38088f3b86ebbd0ef58f29c9d837602d"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "1c36cae02772a2e7465f1b6a67e91d169120724c0f13aaa06ff66a095084d71f"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "7a64797441cc03f947c98c5ebdfb7c36caa2daf0597374904a25e6d499501de5"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "32b93da5068e6cd76c4bde1833592d89d0c2ebf3d9b4ac636e7b00e7007edb6d"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "6dfa7bd9edfe177e03a4f3244760c7d75db1c6edb291bf05df2db31156235743"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "d9fa7e708e90c20ebb1c2b2df9bf866817f87cc8638b886c6d69ba5033e6482d"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "fd431fe5784dd4d5b42b53bea56439db95f5bebc4b8f47517e2cdd4ff5ebaa7c"; }
    { locale = "or"; arch = "linux-i686"; sha256 = "83f358e0e8e545ee4bdb01da4795f4609edd5c504150260241274b205f4df5ae"; }
    { locale = "or"; arch = "linux-x86_64"; sha256 = "128c80cc0c6e2ff558960b8f4d191239b92a38ed4537dc58b77c7c464254992b"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "87af71809038e38b00bbefc8795aa8fdba6bbe6fae0a7a6c82e9e752044b8573"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "263c8f80b2e7f4cb86f829cea41c92ec876fa77c945cfb46452e456a55f72685"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "32dad8cb30e70394b118d305135d86ffc4ad1fc345cafb063712a7d288e04209"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "97231cd5c4fc5e5c125d6ead400ea941c60bcadecaa46200a485e2df79e6ccc6"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "9f5fcbc0c9f70c02e997483888dd69c5a510cdf07f4d6d6447c04c258ad60681"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "2921da4f0d1018201c2db7e65823f36fc307d46759cd0cf94d3667f8c1ae719f"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "6aebbc3a93961d2baeeb2e07f00b57c4abd73d1ffe4ff21f9bc4812c98b0025d"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "59cf5be7d0a3390ac0094a436b7b498bf26a42c178082f2ba2a79273f4ba8a44"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "b57ca3477f1869cdbe474b875640a0516d6dac660aeb2b16f1902f776131aeec"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "0cdad1a4bc9af986bdab8cafd0efc0d96c0010d8c86797e0cd58de9b90fad5cd"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "1cf86aa09a145bd190ee815a2dc66129f0f05fb4c30802c9f85d977ec370dbe8"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "6e10324605e7b50adee8597ce9694c318125131e301c7c5608e15206784d2475"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "30d902defb08ab7661c369118729e78046fd0bb17ae9ac080587d105c44c7e04"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "a3ad52e02e346f5c51ea58b92ebda1f5d98234583dbd1627e002ee95db150837"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "367ba16e7505ac93908443861ef76f7bcb9444a65add1155a3e80bbc97564c72"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "018c013809857c5bda53b931080c40e8152a229f3d2b079975d381cb106059a7"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "471da0ef940666ed3442a576b085ed065a6da4de102f59aacaf2168c84d127de"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "4cb690b5c1b8a97f83eeb8d26870f19492ed61463765eae29294946f3fb173fd"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "863a1866b30700a6b22775b8b7c01ad27502ee3bd73ed20a874a9cac0a889638"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "1c2c815b9fbf5cef9bd0b732bf47d56c1ecfc554ca4573d3fb67be3351a35bf9"; }
    { locale = "son"; arch = "linux-i686"; sha256 = "aaa955cb028036b3f70e0284eedfcfb2b655dd6b7bd6f717ec0609323ad6a897"; }
    { locale = "son"; arch = "linux-x86_64"; sha256 = "84751dbf1e16f8912bd71f24a9c80805ac3a7aa32f30eeb2f3f945113ff4c1ee"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "50ef1fe3d72312a78d951bda1892b7548d46669ddcb60f0af5a22fdd1b8f23aa"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "05b24a18a637a730804dc485f86e3b3d4ce3046ff81689984c0e14d6e55c9ade"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "3388ec26ca4c9ac2ed327037bc73eddcd7fd390765107e47fa3953c53e0ab1f2"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "d81f19076ce990256fdd4c5e7bdf39f8f70d24f3057a1383aa100d259844ada9"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "3ae73ff229c1280ab7b271c29096804839c5d92ef0c15f7a8a8366946ba24720"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "77f723f41ec258309a66e8c808ff4ebc5705ba115bf2417f87943d381d6b57e8"; }
    { locale = "ta"; arch = "linux-i686"; sha256 = "6897b368738eed28e6b2b17529d6e6656d22f228ecaae04c4f8c539a1dfc3d6c"; }
    { locale = "ta"; arch = "linux-x86_64"; sha256 = "831bdc86dd2023f273c55276c81181027a0e701520aba397308ad662076a6ee4"; }
    { locale = "te"; arch = "linux-i686"; sha256 = "3a33e92dc25ea10c55b5ca56345e5b8659c99ca335112e049ba9edb9017c09b4"; }
    { locale = "te"; arch = "linux-x86_64"; sha256 = "3c071efaef763ea731caa1c6cb97357c13e07b112d923b3c3ef7ee22badbeca9"; }
    { locale = "th"; arch = "linux-i686"; sha256 = "7982fa0407ff8f3a955c7a74b70fb9fd10cc06f7f06d429ce06cc60fe4b7b635"; }
    { locale = "th"; arch = "linux-x86_64"; sha256 = "06f54c193ba9bbf19774e8d507c9e15414a9859584de806900ccb0bcb546178e"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "c1565d373b951065a1c6ac827590f944e1524d5a91748bd42740ea25210ece31"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "6d49988225ae1a662e1fd721910f445bf1c111bef6894153b2092a4117391bdb"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "f03049ea0b8bd86d95e386bb79a90513087691b725a90e01fec4f7a54803ba0b"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "5bac7c50bb2a850c208c8410a2deab0b37e03a02f33d52e3d4097ce2c8718d37"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "ee6b3f27f68c3d37e8170c7222249c1459e4530f61438a0f1553fe36213c5ce7"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "1cb80cac3b942d588e133ccad7ac8c77d3af31cf6ddd9676ffa7be130434788c"; }
    { locale = "xh"; arch = "linux-i686"; sha256 = "86f7bab77885e5cf391d9dca758f8c1112bea9dd249dc7d2f184845da9df6316"; }
    { locale = "xh"; arch = "linux-x86_64"; sha256 = "07d874163ace6a820dfca49829032efd1b1a612e76c14a012287db39841280b7"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "27a7039cdd5be498d2de89e2993264c432e36309bb5c40bd519212de6f8b3469"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "f65d8334d5fb6b7bdcb6b212c232e2bad3d8d2718d96dba7c149a6bb2add81c8"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "1aab3b3aad0adbb72edc3db1780838bb2fdf80554eb9eb00fe7b50918bef843c"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "b322ec6027b6760855520dbc40b6e934f931b64c0a859682e4014ee1bdb2b321"; }
    { locale = "zu"; arch = "linux-i686"; sha256 = "f29d8c82b595edb03a42b0c8896e1880efe2fd14e87802501c4007088bf3ad9c"; }
    { locale = "zu"; arch = "linux-x86_64"; sha256 = "bed6ddb23da87c4d7f469d92a1cec9817a41b51012bb30145227633b3265e998"; }
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
