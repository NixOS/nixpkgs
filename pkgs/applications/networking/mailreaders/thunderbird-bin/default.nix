# This file is generated from generate_nix.rb
# Execute the following command in a temporary directory to update the file.
#
# ruby generate_nix.rb > default.nix

{ stdenv, fetchurl, config
, gconf
, alsaLib
, at_spi2_atk
, atk
, cairo
, cups
, curl
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gdk_pixbuf
, glib
, glibc
, gst_plugins_base
, gstreamer
, gtk
, kerberos
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
}:

let
  version = "31.0";
  sources = [
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "a1e9954236de1d0581342fbb894b721528bc51a208d3bbedd4d8defbcc1cb50f"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "0fe9c22ad8cf575813ae8e476d985a3b951174df5beda67fd98e261f831252aa"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "35fb5c44bc3ed25beec4f6172c44f75426579f27bd2302361870615bb1f62194"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "3b04ffd5e1640c0138e5dab63a1059bd0342fff9f44547c6b34fbe6da810f911"; }
    { locale = "ta-LK"; arch = "linux-i686"; sha256 = "2e8a1b96820216fda11c234d80a74d7326b49d7ac3f595f646aa10dccde61940"; }
    { locale = "ta-LK"; arch = "linux-x86_64"; sha256 = "006f25951b4ac90b8d8d32491d260900dfcfb24c10cd4a10dbadf3840b4bcd4e"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "839e95de15a4e0287cfe36d70e07d1d40a1708016f615244a84553794ac76b4c"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "592a353df70c368c3c9855ead6d3b68433e7ebaaf42169108b9e74a83517230b"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "890bc1ee046ebf67079bd39ecb761a78fbf8cee8f72b32958ad18a0c3184b23b"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "7b52dfc2cea5bedae2ccfe11b0ec2d66edb81b76c2272c60f4bb247970384c9f"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "6ab1e46650ff296719e498a1b9e5dad5c2f32e6be9d6fec12d1ab917a5f76872"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "fdb170e3f546de759ef8a8aa85f6c3bf5152e121739cc27797c3065f4f85c183"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "208be79ce95d45f4f69d8bf53d4e2f457410653a81117b4bd4d42bf14a1485dc"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "2e562f9f59457d484ccfb1beb0129e2ca3ba4e5cbf5c955a65480836dc2e6567"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "07c7836bac31fa835c244dbe5eff19bad5dc5a9339cb8a94bd07d88f8590c867"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "7124de1e3cff7a5c17506f8e175aab1aaf96d4c9fd57824d6c0af110f47b1fbc"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "5d4e7f1f82b53161e84abf45f4a7210f0304399efed2df621c2e24cd5f1e1db0"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "814798f7dd066228ae73ce6bfdf430db4f0c4e905ce8a6670c73f894865dbf4e"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "35727d874cdeca69e18cedc109b6c3540c8dbb7450b2158cb1209cf00272cc38"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "0aa2232adc0e06c0a841a11155c2cd8f317b2f12b0e02c239ebe6150ad3bc278"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "b45871e531b18a35f60240dc0417e5a9f08f8c9e3ea762a36e938425505df8b0"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "a32dd96a41ed33a81c240c60c3538db45c1c4357ceaf37c8482a378a526c5454"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "3162753876da622895175afb60cd89be1ee343a10a45f9ac3feb3b306e161838"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "7c8d26a07d239f18f94f14696036974317ac1186072ba4482c315d02dcb97e5f"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "8cfaf98f3702b418bfd7692373b9f6e99a4b06e47a75a2df602e98d8f6acf761"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "6bd9ab36402f3391abc2e96f8786e16407736cf04d524e562736ac47279e2a26"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "0a3e7c130197d4abcbf4d37eef51a946c11cf72707686f8c7a0caa9cc21e75c8"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "8d4003960a8a7a496662b59834118c8712443761b867e5f54f3bf4a683715d22"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "5db77f9d117071feeddb5eadf74ea6332ccf9abaa441ba4d7b0a5f0f3781452d"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "46995a9f269f0385fc9ac9d31ee65d84e79ac81bd61892adaeb1afff991bcc82"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "73071beb9caa24aaac8eec9cfb01f7e333dc6ac438ab36e7f5afa7d850dbeb8e"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "a17cc26a51bbcff44837d74bdb35ba0ae10def6f4b536c4a67e9169221bd0afb"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "4782b1f56c1f5fb1f802385d693a96b5013503e97e4d73e43fb90c3331aec839"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "dbba59d0c697e6dc05bc2b554eed2c6040642cb1246a4119cd7c37b0451c6d4e"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "b37a5eaf187d1c026990f55a3e993594a49bb689f1643d2f944c7f3c7cfd6819"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "629132c5cc5f937fb504542662bb8aa7570eee1ae648087dbfb0c6dedadfa53c"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "89e818736957569f91f7f329118b09a27b072c6d7c89f601eb02cd1d870c4088"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "6a3a358227972a0eb60b1b531f322ebb2e604805bfb50b55d88cb8447b443105"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "794b1e0be4bd6f8facebe3aa44f66a139a660d4fe75891f463adb5d7da7b32cb"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "81b51a607844b229d026d9acec4ea1739c365a890857871260b6eca92a176e04"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "924c5c47c76fc09f5a46176ef1a6e3466d783b8a4c08a5e660a03e0e84459116"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "c46c2285a6f1c825e52ea6cd7dda31d6f67be15668ecf71883c55c9fa21a3fd5"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "58a53bf3ad217b36beb9795f34349cfa3f10b7a39044f024c547be31b033ee28"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "21d1f89810a284818c0a73e8abd5b51a9ea58b7db2b9bf6dd5e0119f4bfc13a3"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "67cb3d38230d24c2a7615468ae2465e6f768904e3735ce31833dcba7b98023c5"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "9e6b5351e96b9b2c57ce04fddaf9656adf84bc2a961a8ca614cec2f830d4e2a7"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "80d0a09d93362f7eff9c7a20025080207a14c43e56b132c3962dd1d795d2a85c"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "07d92405612e1000bc0b401481e94548877511ce224f19b23aa4fa192f21d489"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "0d70e52c8dc5bf6f13c8ea2a5762cb94534ec54548c792ae181febc3d23c01cb"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "2962de1886753b81684360ffbf97afa4d4371662a6f467ebc369e225d335745d"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "6eacb202078be4de4a86c3fc957dbf482e32ab28805d719aa5d0d7f4fd832f48"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "83ed10b7d9d74a28f9982a9d11840522f214ccb53ed599f9fce6ae26bd9d2298"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "227140594d1e12f2edf4e942327a8c64ab922796f7bda324eead8a299a6082ab"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "bc219c6795389fbdf20c4a84a61c350f376374285eff9aaedbc4893fdcbbdc24"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "4ac7de0edc1d2b084f38058f8c55e8c2fad0782a1f7f7ac69af5c6f28e2a71f9"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "cf026ebca03f6eb59b81073f754b9989f2023bb61d8dfaacbb28da3372abf43b"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "001f67664b02736aa757fa99ec00c8df023ead8f94113d1040092057031c4557"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "39fdd81738e0cea77c0f860f0e5253416daa6bd13f1e9feab4c6a52c6dd981f9"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "0a5a830078e0774e81154f07055613d4b6dd6875be4ac976ac70883cfa0ed9cc"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "a33890be6ac154862b7b80f864990b3bbad2db8adbf1d26bf2cd61b175db673e"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "6f837f1c640c46dd99c4ab691ec6964e40b6d931830d4da604d4329c6d1ecde2"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "a37294fbf0b358e5b9619aa36a20f92fc637a6b0697b8d607b958d256ce81225"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "2bbb5800b9a6d03545ca3dfc8f99f9f30c11e474ea360481f1f7e9610b0a87b0"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "e2a68f359f48a19437605b581bf9a8cf911feabfb2b15ec3724c60d1cbfe15ec"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "976fbb88b1c75dc402b9eea76aef4d8a0886ee76bcf65d798a6ae8234b2b297a"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "190679f7638b3697b236d971014f0da938aa2d664afb93e7f4d1c0fb51bfb46e"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "530b19e48b0e49047746b2f5dd486cfb19930b1064478c465ce2acb21eac66ba"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "0fe30abe10b4c97aef9ee40550205e0f269c5cfe76c08a36c8cf886a5af78558"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "3f2d2784e3aa75cbd3ca0579d660b50b31e488253e52fedbfefc7c5448803967"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "83e64293ed8d1ecf509e2617a71fed9583e4d4c3de3ae5b50175ad8c0f8322ae"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "aa282b17eeeb185734f33d2ed9f287958d8a48ed82653d197426e3e3091ecba3"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "c17db84f0cfd5525e4b8a08e300cabbbcd2bc45f59eb886e180eef0f8c4e45ef"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "909ae64789280db1a07b3b57dfa1a5d337fecd3bd59bacd3bab2eb72dbecb04f"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "9021a15bda3d4947e1ed6ee6666a252e3541b020d8d7eb58e854e426719f8d6d"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "a3536d7e8bb429d562e7731fea8675dc9d442ca8e59cc72eb1b404da12d1d53a"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "99cb049415e4837e615e1946409d1fd62966ae8eb843d89dfb61a6675b5b363f"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "06a17ca2ee8f44098252f24dae17589f32c80bd35e127a093c18161751a581fc"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "b8537b39f3e1242e3ed705ff919b01eb89ac72cf7c15ef0c44d258069c8ea317"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "f2f1e9babb37f79121034f9b8cbc90fbf9f0fa1c152a7f0d7162aff6f6e33f1a"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "60bc6bd468c820066e00f8108e0912df57a941b4150c06797a7958ec684c4969"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "a88591a1850b56c68dd75b4ecff79a32d46dcb42f788d66bb46d45cd0f0d5672"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "2bb7656dde363f3c3d3c8c8b4dbdb306f7e618491c917bc7c1b6e6f41d30fbf0"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "b396c752f7652e5ee31d6bec4bfb70b2d86438d966051f91e4d7a77ce5a924dc"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "1f0595e6953b0b6aa09577f180897760f8f85ba15e00e6ae3b12105c705cdac4"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "4d3a4d283705889759dcb321e4b700896b132634005590e546bf6744e6187260"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "456252e7bb5f29ef3c76afb2df0f406fcf93ef1c6df56d0f209bb85e91c8acce"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "ee93df33057576bd55bc80b71aeec7c6f487028f0fe52f679614811be5c71bae"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "7f7189250d76f970bfc1879b2ac6fe2d42bdcf3a652614fa4e080dcc636bbd4c"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "cb389bd9712def87c06ffab3fc50b8fa58c773c6725fd0e0befec3e2ac957ef5"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "8f9bf916357e7385dec5de9e4d58f6dfbe3c7fc6d2b66298304c3630189833e6"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "f89251f74b85c22a9f7b97b844a118e498698e205f733f1fb0d7a98787f973ee"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "019a15e1e83b6810de6a4d64deb3eba1a9c2a0c6f1c382582e356445e40d5bda"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "ae1d03ddf4b424edc59e08c65a9fb20107311289e4faf8f06f14bc471b00d35f"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "a19dce910ba5be35c0fd51be50bd96be3b3db84587f749ed9a108a14a3b732b7"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "8cb4cb6a99955209026224a4cbbcab7b37b0b9fc38147eeaa439631be7750c08"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "4520a3ae24cc7056eb87d48280999c2c3da6aa76b9182c291512dc80363efb27"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "8803a9477f6ac963bdacfd82f6e6b8aabb217fa6c39b311645e461f38cda3757"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "c8eae521293986be6d626302d91abbb88a12855565fd41c3614f7a5d7534f0cd"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "9ea7f173533757c99a9c2dfdceab5cc58e583f929a2e7db95184823a00319a0a"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "6b9775f8142273d118870887da2728da4732609395897513739df7b352a4989c"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "bcaeea579405f015fcdb78e16cfd92e4c0895614c5966a1a7049a4fe310b1c46"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "7de3a89ece968819fcd7f438aaa2f5762f9d936b20fb3c364467ac123b24182e"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "af7f04ef648264f56dcb62e7e473586f3c5b13d3ecd2918278962f335dda7966"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "8477854792552b471e4eb11f71c79b14544cf438e795feae3082c0f3a31e0c8a"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "21db7e27557670796db9282174e7da04afe3a0c89b31e042f7bbd3992e4e08be"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "8f05b160d346b45308ba0c7dbe531bce043f22abffd2a4d1200628669a3b4aa0"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "5e77c23bdb52dba7b663b574520972e2b78588e5143922c1e1837c0e0bd71a86"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "35e663dad586cce929baa1ec501b149ff586df15a687eb41a8cc619c542a625c"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "211322939ab3b4bfc3e6f0548356c9479db5deb687e1e2232f527462017dcd2d"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "0d50802a6fd7d9256591076c267759d39af91f680025b03ec6925e21c20494e4"; }
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
  name = "thunderbird-bin-${version}";

  src = fetchurl {
    url = "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${version}/${source.arch}/${source.locale}/thunderbird-${version}.tar.bz2";
    inherit (source) sha256;
  };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc
      gconf
      alsaLib
      at_spi2_atk
      atk
      cairo
      cups
      curl
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gdk_pixbuf
      glib
      glibc
      gst_plugins_base
      gstreamer
      gtk
      kerberos
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
    ] + ":" + stdenv.lib.makeSearchPath "lib64" [
      stdenv.gcc.gcc
    ];

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/thunderbird-bin-${version}"
      cp -r * "$prefix/usr/lib/thunderbird-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/thunderbird-bin-${version}/thunderbird" "$out/bin/"

      for executable in \
        thunderbird mozilla-xremote-client thunderbird-bin plugin-container \
        updater
      do
        patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          "$out/usr/lib/thunderbird-bin-${version}/$executable"
      done

      for executable in \
        thunderbird mozilla-xremote-client thunderbird-bin plugin-container \
        updater libxul.so
      do
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/thunderbird-bin-${version}/$executable"
      done

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/thunderbird.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/thunderbird
      Icon=$out/lib/thunderbird-bin-${version}/chrome/icons/default/default256.png
      Name=Thunderbird
      GenericName=Mail Reader
      Categories=Application;Network;
      EOF
    '';

  meta = with stdenv.lib; {
    description = "Mozilla Thunderbird, a full-featured email client";
    homepage = http://www.mozilla.org/thunderbird/;
    license = {
      shortName = "unfree"; # not sure
      fullName = "unfree";
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.linux;
  };
}
