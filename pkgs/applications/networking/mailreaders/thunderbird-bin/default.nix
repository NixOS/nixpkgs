# This file is generated from generate_nix.rb. DO NOT EDIT.
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

assert stdenv.isLinux;

let
  version = "31.1.2";
  sources = [
    { locale = "id"; arch = "linux-i686"; sha256 = "210f0037279ec373d5d189a8724962fec3237900c343ca93d2421ca93a35f201"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "7436275f73a1292567cc587bd41439ecb724fac5e092f0b0f2af932bf39805f7"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "14b878d70f96e60e3a73134c3cbb35cc6d468446b588510ae5f2e8934d8fbb3b"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "6edabe4a5bf81274cb117bdf7ec7d0b89f3759b9f31e1b9e03c0c603cda2e91f"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "9f65b45570f83d41b856f99b3077e6e112fa65b3762eb51277269fdbf07cfdb2"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "6a500164772c004d851f13d77a7a9b84428b5c372fdba6f0936c1ddd398d9087"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "fb5f9ab606101cfebe86f64f64b9e46ecd73a704c1a2a993e4b4d68129d84484"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "54517217aa8cf4d715dd2c7d5cf7c4b96bd5f0add2dda9d9d9412ea10b4210a4"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "2ff66a151f4003b5dc0432b43e1038e0c69645c58fc5d6015cab3e493a8ed9a7"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "e34c892ff3fe761c2707036c5ea3453fe411dca2ad2e474ead7ef0c209558e06"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "46154b1fab58e9040e4e67b01ae2c5865b644ccf8f2239c396725bf063eae640"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "271f169763271582698b8ec23d9ca463b41a7d2b373b56d9c170179e15f0fc34"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "2b3f2e9933bcda04abc5785b77630cedcba2d85a73a9d535d895ed7910c97d54"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "e4878b6ec24d75cba9e991f6b852ec280992b205bca0e82a2aecfd9a607cdbb4"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "b2ff2e8b6c9b7ee81d0965380d15e080c204ffac35b687ca29ca41b51804b491"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "7afd4c4618f4e7758875ae58295e340289eb994723d3eea13c388751878e0b4e"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "41f07408eaec108a28f03917820329c801a386ad3628ebdeb7abd852e579ae72"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "ea667afbfeba6901a56cc44751d6bf202ef978ce7e39719e56c1fe31a622922b"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "cea91b552b14e4a417d288d93b4db10b787a1a15316ed7de0b3016be359ddcc5"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "8d72d7cca4885f527a8e8d2b8e2950d0ea0e5d1a840bcde38c08a77e3b6a69a7"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "92a28502463e92e6bb9cf7854358c13757222433f9931703a2df4d1ef93bdcbb"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "6b61650491252bb441a13b2fa550d9bdd76e6f23a0e5da641fde4372637c451c"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "4d35dfe5c9d66ea8f81fa0e5957152296f9af31968b8ed4975563c480abf2da8"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "3647b5345ac4fa5cc6cd301fefbe538d2442110f93cccb5e8eca4227bcbcd661"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "b06afea38900f268b95787c257d960de8c0174f582e51434aa97a9535fac43a4"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "c4ae2aebdd91543cf3c64ea25931327f6e8d2113b59d0b2fbb19561b4f935134"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "854d4c53fd22c5c1f4635ed41e7dadc6f0603439380e3d3f15ea7a5db5721941"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "64842c6606e2102434ed0b33bcb53d0cdef08e4b55e67e85b3c1244a7dab32d5"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "6632eec0a8bf14a77590fae44113d417589634a97cd0b57ef4ede7623cd5b632"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "727c25136106eca05d4c0bbddbe01672decc4a9f55b3246290c1c6e41cbef946"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "986ae49f92e2bab52cc3a4da4f9ca9bce34c01e96126d4fd9fe41d39d16a8ee3"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "c208dc5adb8bbe39535ec28836425d66d557d4ebb111aca9c0d025750ad0d3c4"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "ee8b101070f820849ec2bde48b76e102cf750bbcee106f47238259bb3cb791bb"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "19471d5e13856f85fc395b825fb297f88805bba5d1d6c2999c49c4947cc6ed43"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "b21ec0c7e2ee24b971828ae02419f06e3d9447c5e30b1c8257a1d8e1b5ac383e"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "6f8eda76fe19bd590e4f8e23e491edc93b870b72064814eb0d6352c99513397f"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "217a6b195255c841ff42f181aa4fa54bd76a91de61662098d96c4fb9e7d6b79a"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "f11ce6f7ef22cb99674668bfcd0f3614a4a9e162f9608fa1290ae26c6c199560"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "85f32820095ee3b50716731b2b369378cf530fd1f3ef3522a5cd55e00fb4ce5e"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "d67b98991de46de52f84627ccb7f2888551343eef94a5d7562e587fcd8d968ec"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "14914642dc540c6a0fa0df5816eb35b39b822dac4da58a79d9cfe1c3bf7ed1c0"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "c0421803b2be6704151177c0d13557a9d828e3b3333cd214734e2ed4aafce105"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "9226cd799114fcec9c1b53b403708e62ca9f151d43bb53167b822cd3ca779171"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "05e13ad7c9a53a123c3a50e858285f730a4a5ec95e93074cfda990f4466a1c4f"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "ed9b4f3bfd457d00792795584bf17bebf4b42967c111cf4f778aa7e88b437407"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "301dbc22a9af014aeb6f151ac1f6ff67ef667dabe31c5e487681f682bf8d567b"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "9894e91593b3d825d2572af8c520c8be5dd791a267bb056180dc4415d55f4dc1"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "0531f815bc4325f150465c753ffe849577931e47eb9528df3b58e666155856f0"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "4633afa9f32f6aa1bc91c1ca2e6d1b5622192c9a82fd4c591e0f6a3095ab0baf"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "2121bd74ce76a0ec1734e3171c8da8ac4d935c99f6c16344639ff7e60de9a860"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "d10a856d94c790281500cf1c41683255a858eecc43afaa74819ef2d3559216e9"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "964343e1ee3209dea0a90dcb1f5371cb0f949b68e059aa23fe80d53747a4699c"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "f28ce0029dc5fb3212bd020065c2d453d36db53c98df1806f0e4192ef3d8c5da"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "fb532732406c8338bfb947e20ee6a95ff1bb18b1d6eadcd7525153393894bdf9"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "5e05b156179978920c4c7ed995ef018ddaa6332c5fe1898d94314412d11567b0"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "acba5a042588731e8b1af0dcc7e075577551969d7c1081c23df6feae7f4d107d"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "92c6f00a0e014617b5fb53167c821f17f550e8307fcd4af831cde04891f00b40"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "191c531621e961b25bf8f16c2aad2ac57357d3456f84fc5efb4f7b7e9becc202"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "2f061035a0b6b07bb81d9f84f1bad9a7fd50b0546417fc047102e684683241c5"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "ee7b57cfbc15104568e12d0cc81a14118c7b0f2708963fbe2ba8ca7a2ce30a0b"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "a493b0d327f608a815654a74b22f0ab3237b139998b8720c197468fc624754b6"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "2b9e87e794e6ac423fd7e6c5500b8a63dc2f8a6a4bdf39de2bbfa5c06a2a8f67"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "d272ea7a87f15a649c8d6089b6a5eac91ca732b760163e36ee6634ac2a186313"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "2b71cab0bfd437a6c79125cbe0ccb82bc1fe257c6aa24b0b63c1a8456334e6e0"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "56a04b6a6a27d9eea98bb5539c927870a3a43aaace14d31faf54dd56b8ef128b"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "99e33539eff6a48d944f47fc86a98e07ab4395e90e509c050403e70820b11db4"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "4c7a67b83db3c15cb8385ec057eff849e59841d2c6e82f6839f76c747c09fd02"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "5e54ad0316c905a2fc137365e34ba24391ec3a12c638f1947d8048b9747b2a21"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "735d14680ba5108d9d422fda161d0cd1cf31ffb2d29d66b33671c58504436290"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "031b6f8a2f9a14689e91d887754221a972d4c9aa02807209126aa0d26be18b04"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "604db8cb078699262bf01f81a97bb745bda26efdb7e81bdae66ae5fe9f546c48"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "62a3ed654691720ff2cb2402efb450dcbe395baecd6c20dcba3d45455bfb68d1"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "81b2a2eab496824d109faf49b6df93adc9dce838058f3f70c9e9c99ad251baf3"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "6cdf95dd941475554630709d89fb802e8744bae7645ad9164dc2e8af701d195e"; }
    { locale = "ta-LK"; arch = "linux-i686"; sha256 = "422f2173eae85a95611ba14a9945aac7b44076764b7c67d2c4198b3e6fe2fad7"; }
    { locale = "ta-LK"; arch = "linux-x86_64"; sha256 = "d3d3dfc439bcb26cdb8d8f1ef0a9a24e804a6928aa6ac4f9ea2c0994c3e6e2c4"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "6d0e3db5748fa2bce8ebc3b51098241ba80971afea629836a37e4f84feeb0c85"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "4dd79725f91c163cd5a2073d52f3f599c2e0e95281e8235df0a20c9f8717fa07"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "7b1fb8c036729ee18507e0c3529cbaf93e8776801fba9bd8c93fa7b56dcf460e"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "926b0ad5e817af337b2f2f7416f98e935b5a6b90171816207275413c04dffb2c"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "a0c9e3abe9f3835166237a9ee12dffdc1e3255b59a47e3ed0f19ecf5a6f41ba8"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "173c030e3bba69c1634587a4032e4d0b49f37e0a94ba75c4deda7f23d25b21cc"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "25f3ca3328c99421db81e4d88b8fe51e913b01430e0db412699b11fef0c81240"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "df9f7737dddd56fb233d029c83c46a18470f992bc2b0222b54e1c4c36bde135b"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "181bbb3808b28a5dc170db90db69a99137ce5d49c559c59c4a185b1ee48bea3d"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "8b06fb2d2e4027aaa3ca5032823b203f5e2628c7673dd956103636916cf28a32"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "e7679ef7d467aeaa796af37e62a48fb08e60299cdeb6cea07fcbd8253cda7288"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "83a4b3a22de8be841be0967cda71dcc05958dddb690b7f90d80f1f6235555a49"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "b7db83686a2e9bf5e501ae32b608189af09eca9f4996b975960fcab3a97a10d2"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "aa081115593e5225f5fb47a9ba5bcd983da1c9e088f1a9f5cea3710afda75cd9"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "99698f7259b1c3fa21600c43aa2a946376547a852e04f5a20478282bdbbb99d8"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "bb2958eea731689b4fa48e98604233ef03b4de89107d801f72b12843cbc6fc70"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "988e95cda1b412663bcbf1c1b552ad24b889fdfc30e7228bc47ac7f14aa43b31"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "ac1f417ddc5b62f674f86f25a248d1434d996453892b4825ffb38852436d2df5"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "9209fa7bdada6245717dbfaf517d68cef04719812504bc0c988def6adc7baab5"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "6e2f046dae0a6fa80de190b95667340abcb0ddaddf1ecee813099a89142c56e1"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "f4acc2f18f55d7578555ac0b189aeb834adb6c3911ee665790fe4799774c8fe4"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "2dc24f408fc801df266f2b890109c2e7d4a0d47bc2db7f541d371037ffad8ff8"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "b9e89373d2d1b0123095cd45867014f87bc2696093127448e7b7b9cf72d294e6"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "191f8f5327e8a7607497b990dce09e6219c444cbe9261fdbf709cdd07d6cd57f"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "80cb0818fce6c8130c9344d3259a7bbc1722c1e7896853d365ad06cc4ccddd82"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "347027a7c82330f5bc1989a19afb6dde415c260ad4de6c312bd1bda30d4f7651"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "94f2742fd3a88826eab8712e77a503fb340437ed0a2c1657b64f13b8522c0ad6"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "8319f02f751d0683e5d015d32da3e12c94cb8a8fd27f8cdf5cd583e6e594bdfd"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "076ed4c9c2ed99769e278ed0965ca5da7efd00bc9fb225e36cffb712b7cedca5"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "e37bf18f4e32f050ac97b1a20cfa44832d4438524e2ef9c4ca82e7ed8c1307cb"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "afc9aef58f08bf8f4b300308a5a4e527ba93e1bae024983063efd82e96c36703"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "d46257893e5e1f17757f0b53c9201b12bc4e5b27bde1eecb007a858f61c49fab"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "8a1cbc00e4e6cffb3a225d9334e9c2372050203a0cba3b31c6537e02404efedb"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "ae17a6fb60f27bb95a11501a061c7ab9deb0a6ba89b17e6cf01394e18710a831"; }
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
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = platforms.linux;
  };
}
