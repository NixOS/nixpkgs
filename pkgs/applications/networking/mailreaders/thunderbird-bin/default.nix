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

assert stdenv.isLinux;

let
  version = "31.1.1";
  sources = [
    { locale = "tr"; arch = "linux-i686"; sha256 = "9e651a41fec262a7dc198c2833631ebd6f3665cc9ffe7bfacdbe86512e5c3fae"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "5d7d4162b8eaaacb49d859c092b1f31894f2e1e1d6a59c2d025bbbb94ba5f275"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "6c7978decea10d942ddacce387f2c4aa10188921010d0063836718bfacc9373e"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "e3b43a14be66fec19b445507e1e057d0f25f3e637e3a122cc032437588231543"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "e2c75ccc5778507602f0dfec0f4c94a6626764d4b9b08ed899400a96e60b558a"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "a534f2e40d6c066f11074bc2d34a0e1e73302dff1b74fe2c17087e234f4bd306"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "8413bc0ed4ccd586aedf1232434d169ded0e2144ba1534f8117db5aeedb3dcc8"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "3c0eaf6656ffe5fa8844d75bd979ff5ac3d4f02fa6688decd29ee148d5fd86e0"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "0f6ddc392213b83ebb2dd705f70c54d43d0efc6492bacf7b1ee8871abf4ce833"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "d5234d9b7e4c7f6329c0a55c66c8d49e6aa63369310bec8ef2b77bd19185195e"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "795d2f21944179f75b18d826e91ea2225d2793e77a0d27d3dc8aa6380d43f591"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "1062a401ed829b961232aa5a727b713427f5de86637c23382b9cb72ef58010bb"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "2467d6c417fcd5e7157e87c9a683fcb735c75b6bca34bdf8bb22a9b8ecfee1ce"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "91b2abf765ac12f7e4f65723ec8c927ed9ade049a266c01ae69b0bdda352c37c"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "467887abffaf00ea0c791ead711d55aa6688c24cdabcdaaa6e76e12a5f526049"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "078bbf8ab3ddc7e1aeef0c0178d30194b3a5aa492272a88d82f4263dd2c451cd"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "1c05f4f0c68fad29f171a70454af7c863aec54199dcdb4e442c8339c5a3a94b6"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "0c57250af517664113983bf8b3da1ecb8bade0dc440954829165ad1c7d78e501"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "bd7547419ee8bdb82993e58210108440e5714b20f7e8368b4f8d72a8accf3882"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "3d46fe755cb1706adf383f08f8d988e9eed9b568f0e34d34d5eee8b267b7aa38"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "8c955cfa9542504ccc06f1abbcbb3f22aacd6139c5cb0519a926c0470d07664f"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "c15599a9aa7eea15acc25b65790c29c8335e4b5919cac51c3f792cbc5e732c39"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "ba0acbaecd61cc15186f61c4c51770ea920e515f7465cf9ce9a7f40f8cc6aac4"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "2dc61c90113ff25d4bf04d52d69ad7450a5bf5ff6e3054306bf52e866af69b52"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "30b7efd9bba9509934069a98b8c1900ba31698417daa7b6ecd969bc8fa48ccd4"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "2721ee45dae5ee5954bd813769a1ded4bb69667122c95be15f4dbd435d7ee1b9"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "e307a39b37fffc19bdfb538a72bb53065c2cb0547515464bc7034998d867ceb1"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "a7cfe778883dcf326373980b8e3816f061e805cb09ee566742d2f2810ffe85b3"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "f72b4b809364e0b1a74fc7e01765637546b16e6b80910cb50926c5b3e8836d03"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "64cfd71d0fe9b325a06ede8aa485956073968e014c16d8a2abe2ec4e8393be48"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "d3d0600636ffc981e8878668f188e00fe038f3a64361b82a88a23b456c10b290"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "d4c83d61282ce2b38f822421e18810519e57c85cf3f8ee70daacd27591741fa6"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "3e75b4e3b51ed9523945f121f9330196f34c2249b53c291cd17400df4a814f32"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "2e707228e9ab88f3df58b951d7c52b8080ae25567bfef23c4b9844f5f6205b6f"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "3c1912bb2a197fa06c1284627aafad8bb133176c26f1affa588d34ec5e490582"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "2de9caa23c327cae9671b95224119d7984af0e344dd2a623ca4f99ce44880228"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "410e2fa951875d9dabc39ee711ffd43d8d89bda5899ba545512829d58853bb7e"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "4f30f574c9b108007fa8663848c40b2db17688574e1af2c67fa47823b1d84763"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "85236d8b6b9a7e95fcd544129d5021a5677d2dc659bc06189bababd34d141436"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "d6854eeb822c78f3a93ca29df889d5aa41ee6fbaa1984ad53914782d5f69c4de"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "d2402bf28b07557f3cec5325f947cf4aacbef00a4a213c12f7e4bfba5e859f94"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "43f51ae219661ab11647e9d1887eb804810ea6b0b4d10adaaba8757934bf5742"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "65de5cf2d768fd5b37cd1d0f54a57c0d1f8bbec83ba78bed31dbdc100f2c3699"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "45006694ff627109969922410dacadebd6752c8b509f56434b47bfc5d2815dcd"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "fdd8ba113eed364873296d3c9eb46177e10c6ad4cb40322c931adee8a62af26c"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "60be4b795ff66025d35aef1d4bc0b61e9224caced60f411b1200b3e302ac538a"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "3371dae9618e78afa0edd528011fd2907cfcb7da999c9bc998431b9ba3873f06"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "40b10af4e5bca14b9b823721f231b30fcfc8ca56302d3acc388f7ba6b6ebe642"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "8ba14dbfe5cbdaebf613ff6b4bec223fc725071f1251f11e7f925caa003db291"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "e02085114e1074fe28d0fdd9eac147db0a94f1c0da36fccf509ede12f32f6ea2"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "ce71e045c070c0fb420b75f8d6bdc01885d754de45373b9e7614900a849d7c5f"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "28670d0cc63cc82582062169519a218d2a75c8609f6e839980944fed4a3bf820"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "b3edd79b25c1616fd95915071f60d830a486e538a990240da8c28218b3ed8c23"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "9f616e96d3ccaf3576325006eca3b134d46879e1581d20e628040f054fc95c63"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "4652f28a1dbc60548397a1f67a93bcec381a8a477a3fc19765d844ab5564c03e"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "eaf07fd1176bdbdc41bdff3bfca075ad40f3c0cbde6b813ff93177807067f304"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "4a4a8c213fac98676878874d876db364fb8afa07d56293871b101b897e2339dc"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "3d756e21fbdce575f69152c2942aaadff6cddc672e44d135910483022a5b0da8"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "b32966b9faf0441ec4defadd1ce581a5ebeec187f1f09602d72e77988c47484e"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "232672be1a2d38d5fe0f0baf32cfcf137a177c52e41a68b0cd92464b7cdd13da"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "a0658816bc8b97083e69c87c493e35149b6f4681ec3b7bf25332c2889d28e17b"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "b92fe39a090ca55bd4780f98782d39243814737bb0f1a5ac56f4d2f46ced0e47"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "54b41d2faa2d87dbb74009597bcb6f31c07564afa14bcd914b6a71283681dbb7"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "74863219716dd4f2254e43e61e9e7388cbde55568b1667a49099e148ccc802dd"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "e45ff62dceb1417b0eb46048907b789d75cf9d522ac5b9628dc0ef3ff87d558b"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "8b1f17da7fde17be475a7007badff67091a48f80f7bd6c4637032cb40a58356b"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "e903e133fa7bf017c82bd22608cd060e4bf75eb220ec3c5a7c8ba6ccd299d2ac"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "f250fef4fcb751b1c65c0f61af359a526f517594392a32b32fc81ef483fcf3d0"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "d54f9f616ae6ca3febcd38e046e5f2caa8d289fe237445434a2a883a5abcff03"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "d7f1ee3ac47ffeece149e68f895748e266509f15d663a8a145f33783d8df5095"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "1989da79cd9d1cb5dcec4bbc8ff5efdc454fc7384cf191a4fc754a177e59b9ab"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "023ab9ce689858115f9ff2f8837ad1f9c518f09e896ddc4a2c74c76baf69a2c9"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "e9ba25649edc96a7dcd0870cad17941ba3b621124f07ea4d9b60088b4c8b5b75"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "d3ce9cedd6a791adbf3a28d4253a125acbd5f77505190aff34aba0aab43dd33e"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "ec72bbec1bc0ca99637532e861a9206a7059b8e0a1862cc3530f59311307aad2"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "a4af27cab605792e01ca9c1d31e8b553810aa10882b92c74a3c00b9f517c8bb5"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "06f99130b79fdf85023de18bd620d8bff82b31c4f0b4f2842e332d370a18a851"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "d3e76cea7395462d443352e410fc526cc0b879c23a4c1e3e31d45667d11e96ca"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "7220f944194959bb0d2fdbdd56754ba37fc0bf72832ca83f352be09c8b072d27"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "fce0ad1f14fe3d0e03272d898628c3253c078752fd738cdc34db32ebe34f5c08"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "79b20fc2a45947cfd60afecea1186451919bfcecc53d06394c51438b95053785"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "1ba226bd991812289c97c69b52c1772dcae2e415373de2f0a59257567c4d6a2f"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "ffb27db273a97e61e2f479e94ad77a4cdc65bf977189793fc25925e9c9bf35eb"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "6bd9814c351a990ca755c7fcd2fa6d8683df950d807ddc9cec3fbb4214529757"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "6c56805008b187e94d178ceed0dea011f0fd35f58e5773fefec2c2e3eb91124f"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "6b9575a3932c3aac78e6ebe304405e98b26f27bbd7c519a536cd8cf5621b6849"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "8117705e9b435413fb60218968b3b8adc0e8e79032328f880967303162b48ea9"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "19dfd0d5a4ccdc87b1ae344309c1ddfac4cee2deac50ce6fc4b3a5921ae3b136"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "9b80082461c6c352a08e2dccab3844a5164f6922a629ce6f717524e3ac713a93"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "dd831e552567d85bc909253102a9c8bca3e1ca7ba31d76f36cb176d04287bdeb"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "7f44745b4a4fedcd994da4f678393aa325b8b1dc6277cb89772c37509ee38d8d"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "986c4297ab9e1f64d8296682586b1c087e4f6709b8ee180cbb8ee9e29014022e"; }
    { locale = "ta-LK"; arch = "linux-i686"; sha256 = "6d1bace303e1f8770793c10295d59d27919ac2e4f3306128df07fc66583abb9a"; }
    { locale = "ta-LK"; arch = "linux-x86_64"; sha256 = "ee8eaa5411625f452364db7fd98e2cd61390568b381cbde45ebf2be1d31f11ea"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "0506d357bd67de478cc4672afcf40cd0ed0eed29969ee08e992996aa0681ba4d"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "5d5c24ee4efef2dc6af982b380a0ce369f7a9f6bddcb039f257669cd0c7a3e6f"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "2e24203dfb7f3433fff9c3239128fa305ba17b050faf7db6a5b9a4a6cdbd7855"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "f17efe65ac5731ead20b6479ea15655f4ae44c0aac908e7183abb20a279e787f"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "c44f459c0c6ab10f2c9a4b4ae7e283adba61e2b27b4602a06078ed40d81a1bb6"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "5660daaa21612990adb7e1d04d111c5d1d293aead5cf48829c93405c0e7441a7"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "0e81f161a8cc4af53ca1b658466344354dd84030cbf635b9eb9f8e3901f6e263"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "7782326c86f92e58303873078930d3a5056d38aac7d7e0afb55bbc656869af72"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "c805a072e440b709ccf53fa6db477eeecbcc0317e03458e5326c6a845561d6a4"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "27af6a52b0b96234c7b6da6147d2051f378f7581e5027e4997db10daeffd8547"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "6fdba82e322a21315de88db60741016c4d3ae50deaf6f0b9c40129121162c297"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "959c6d283700b32c56770f2f63519b66d599e00a63ad64b3291c0c776211a302"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "375bd6c904fa5c1d11a6025827797632271263a7a731251afdbedbae5b1fd42b"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "05d1ec4bcf0f1f730fbe6b66c80e301f9afae093289a1dce98272e3b4d5ae803"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "3325227d5e05434a374d7ba9b3d54b949be95acf0cebd5851651c7a13d051728"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "76815fac8e9120ba707413a97be7e4647b97957027aadd138ba60bdd8911e79d"; }
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
