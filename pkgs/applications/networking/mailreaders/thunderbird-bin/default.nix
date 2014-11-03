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
  version = "31.2.0";
  sources = [
    { locale = "tr"; arch = "linux-i686"; sha256 = "02dc838606507040c73ddff4a1b60fec7d6e613aa08da2ce1c76e9c367bc29e5"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "a93243ab5b1d64a94bf10833d6b8985a65906d0be24bdcdd7b5babfb1d466bcd"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "d675da8358bf4ed519ee49dcc2c2162075b5e9e0fca244b474322a7614f535da"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "4e8f9e3f9fe851dc38deae42443cf884776e1d93abf34ce6963651a85afdc4a9"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "8a769559e73abfdb610891a23538ef38df3852ffb39d02cba96e6a8ec914f94a"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "e53b95914753b8640b69e104fbf5efb2fddcecc17eded23974c08274378105c2"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "60deb9deb678c9e5233d9c0146aa4fc8a74b9ba9b5be43ed8c5a452039b8307d"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "73e5c984d5d3fa17f93cb947fd63671fba66bab94117db84e187cb9260500101"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "669d825940712d7f10c7303e3e0a0ed9c48e9e5c26b0c035ed58bf8694d5ddc3"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "e60e048af0c965ac6f2adedb58e192d6d4208bf7f57dcef13b899da04ca14420"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "f5f5b653e17b495c3cb4b1a26b39d3fdbeedb22c8d733cb2f3b6e57d46269949"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "653cc18216f5fc156feef73170f903471480612a4de6df4efa3cce79b58fee28"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "5cc87c9c84c205f99dc3fa58be8fedd72b9afccb69c91616f11929e2a7e075fd"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "dc6e8f5dd30a7e2dcfebabfcc508de89cde3754c036811df7168f4f1e53c1477"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "653025d1260db10310f8d689cb4554acf7a6388a99bac977b6f59b683d7e5983"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "1a4623f94b4c68b6b89ec53c512f860388965dc36f2d06272341a194dc85eef6"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "0e0ae13028d5f65a54398c634ed5b4a6685e2dc84b05121e71a0c0ca7a04053e"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "2589909994cfa059d55a75b7d8f756c09f67994034f7f45c7b5b8805302645bf"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "155e79bad6226eb2231a08856415b5e4a15cb02235b0b17ff7c0378c38d2dc93"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "688d3c51645061fda283e2d486de1306f0b457149c82cbd20c7c019e76ed98b2"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "90b3bbc31046daada0ce995108fb9542aeb878220579836ed0e5b14088199795"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "ebd172d4a74ef757ceace8799c752e34fa0fb41dd5f4083d2aad2df4efd0329b"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "c1502e310fd4b0a682fef147b4f5a97db972ed49916012a145ce6d5c4afd6452"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "bac8bfe883d35f3624bae8cd4d831694a8e3f2b319a912ad5007e39483a22e70"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "d0315db23af439e736e02d93d2467c86fe2a186c849aef32e928adb5059fa7fd"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "8d5c5c4ac8865ee233ea10d2c4b153bb47cf4df4047dfae9aa7b5722c293e5cc"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "9bbac5b2d4ada74e6cdc8730997d47043d319a79a61636322038584265001fed"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "ac828318d8ce07332af73b3146f77825e51e8df8e858c0596589dbdfb2c8718f"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "16276607ffd4fa9fac4077cfc6da91ced5d5a4b08d804726d9d4b7e870cc25f2"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "7e1c2f2aaa973b7a19518c62beb43130d7fb95d4c5aecd3370d7ab2fb59f37c5"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "48b27779e6ee95971d72a6be14e69ac1e724f5450126ad2627a9b2f0511b663c"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "ebd551829f7a66b47a82cad5db79a27126719af71ada250dbaedf292077e9c8e"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "8f92e772ce7c54d6210c83fee257c9cc0b2a3542f41ac2059ea377c64d4f59ed"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "b2cec9901318ec0754e8caca2d56e6e4d08deb4aa21db7fb04c555062b84b9be"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "c5a1da56142398fc79b6d356d600f8228b0a4f1ac40d04df4ff5c25564b77a6f"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "5d0308e1c08960a26ac3328eb5be4c237e2320a38a6db077186f1d1a278feb8d"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "d0abb5c4657a4a04999a44f96d00271e8dc3ad79ae0e78cf4b820fc2fd29b266"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "fdde99be62fe6a911711e1ba69a2babcdba53216a5942494ab7e52cada8bf893"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "d0420a7ccd8f4fcd7f56497636baa701c71576d3b88440b609cbb3ebf245d4e4"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "5657eb2a99f7c2cf32297bbb45fab4c0eb2dd48ba4ba98487beed18aa5e85ada"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "fe60d3b13e964bd99730e8082b742729084e87f6a285deb8cd2383dccf881f1c"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "76faee1fd8da11731ece128832997de0f10501040921e6abb46fc0ae4922d568"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "c1ad068c565abb7b3f16c843f6974fcec6f46714c3f9afb193d10ffa3773cbff"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "b5cd4fb82525b67ef199b9eadaebe25f70a29e1dc43b2ad0f0074bf7d01a05f0"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "195cb61263c4c01c345a5effcb5f4f6741a1ee10f716006a614d55721b013e48"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "42447cb7c7689623a34607a0aa1a9866552756576932d45a4721c5fe8541070f"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "6c0f45046e4d1910a20e245f0b69af5b4fb2a9507abd99217bffe68bf213061e"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "408f3b38fc416cc12640af0928fbea1506eae3f4a65b6b3b889bca54bb0a1521"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "330f4546fe50d717fc66b8417405d3c1eef8ca4f312b21563c426739eee4724a"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "283d3e581ebb84059985aad40f72338a77b068e27b8247e0ac16b915ed16f797"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "8068738dbfc0ed5f5a08b1b4a65a5e9e1ac780de43fc5f27c269dcd5e9998f97"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "a101856b6151cae9d33a909d1a0fc11eb26439ca161db55dc262bf86bb457c29"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "5a790cc811d8e392daa83b11feb232092ab97dc8c9fc0bb47b4013751a30f76e"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "7842ceeab524c98387ca6319735bf7c331d34bcfde395078cc32c443e69962ef"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "06ded63a3d09af09ac68b318f79f07e924addb30d4c11903b6a86ba3ef476761"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "53a99f98398b2044866422ca44b496d489c0b78724f28afb4f919eca656d528a"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "4c4da90f383d7b43e97e471656a6cfbbd44d1b80d57b8b2405497678aced46b5"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "41ff22bc9a41aa0e71deebce4894e99f3e3737a57279a1488bf9d2f869cd56ad"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "e11451297f17febcf0057ae02dc15a298aacc865146e1aac363300dac6de57c5"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "0e5d389a2c5b673b423dd2afad375eb6a7e05c8eb0b07ceb4975d658827d6cf5"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "5fc40508e7a6228065084fc91431af3b9231c6ce46ae3e88ef249ad67bf1b545"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "ef365e27b05f4bd0c8211ed9e54ecfa4983111be74261303870a8d22e6093c08"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "9461f7d3953dc6aa5c9d2406331138a5e34d114eb5b48b09b562dade25a38ab7"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "6a0310cc0e0a5d9e1590c735e91e8c1bb85358687f4a6a59219de05bb0cf9d1d"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "b4fd29c1bd06c5d6b85aeb6434746f1fa0af627c5795ce2ebc7d3dddcf78e9e6"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "b24afec0b5de5e872848dfcd609f1cf81fe2eed96cc9ee1a5f17fd1b68750d34"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "a78274174c8c26426d9f7e85589f6143f47fab9ce8eb9bbb91fc6c9444c1470d"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "18c6ee5a732d777d9326593a4edfc30f11acdfef2397aa55c436d54a99de9c3a"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "3e12328500db45ecfb4572c3cad8b75a46d930ec57a426c8fbe6dd8e033f3cfc"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "a76f785c8c0b17f3962a94d4cee5bce9be7b91fd2805133f490ad516ba2d5ad8"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "72e1d888516119a6aa21d077fbe8faefc5cf13e8e422ae26aeed4416700f16af"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "962f0b046ab3f385348022d78ffffdae6137b351c5031453f62b5fa1dd44a9b3"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "b5b11886e19a03e219bb803c7853bded9c5e4a2cde0a33abba4c0665a44ec8f4"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "faa18298e02ecd0eca77f4e68e88ebb91ca8ea3abb6241f53d82e1db7db95076"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "03b23597d55f1db442f8147bcff7108e3b520e0b5d05d819df07915ba6baa35f"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "3dea9adb367958babb54dce3102d43d316088aa6140101d18a59cda20522d78f"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "7b1814286847188ca68b3f24457b3a6ee5cd967833bf789104db0fedd2993941"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "7605776d4a72d82fc65280df0cf9812f134a1dc790e0f60f089f287f38ed5db0"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "da8177ab1912d5a0047dd2f6848a421c8fe32d39bacb64e76e0633ddaca5f4de"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "60b1c2f1f209c5e16c6f29c0a5bcaf46c04bb2ae289925761193387ae65fe18d"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "29e073a8068f7d060cf2818d85d465df3f606aba95e867dc9aa67533d09e4b55"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "8d8ac419650a9cd0b138aa823dcfb67e47f8522a5d51625090c26c45a5c577a7"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "9d537ff70f06a5189296a99126a57ab8664266ec2da673671e60e97678d3ed9d"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "77f30fb2b94fa7cb690c5c0f2fff0ec89c1aa8f8915891d17a66357ddd10d462"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "1b613c1cf303a65c3065fc3edf15c6a051c1a7e347512e39cce425ef02828c3c"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "a02a04bc88efca8523b4af8e4962b205ad13d9eb9879405db57356966b12202b"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "baede1707cca4ff149956884f855fa0077c372275f6be6f59d32e47cc6509b5b"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "e49f0b02d323e2f83d0da2a5ec2e4585693362545e50bfba51e273d0edf52813"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "31691ec0b51d19bdab2efe2ab1813bd3363e71ad62bc4f5a860e017516509ad5"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "c6241fb8cd1d83ac5753518c2cc215ee831fa24b816a5a522029d14cea24b15b"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "aa6c91c15ff9f1769d727883c17720a2732ede4b786c4bff7d42fe25c129246b"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "b940f8ab5b2ad50faedc4520f4a7bd5936debfd70b2fa86b2abf955a22557b20"; }
    { locale = "ta-LK"; arch = "linux-i686"; sha256 = "cc70eb04cbab5bcd674e40c4d58760c07353726c968f766fc749fcd7154fddd9"; }
    { locale = "ta-LK"; arch = "linux-x86_64"; sha256 = "948172b68287b1cd8a1d7a32b3e7fd5494390aefea1683cbad34f12ba5d241a7"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "6b45d36abc8fe1c731baf855866000ffa08671d025ab97b5301b22079765d70c"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "9d619639157c645bc34628b7c31ccfb4e8223b891cf8e99118e7b767f7f5e24b"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "a9176628228c3f3e07d2929caa872b4a24d9f620de79a148c01f0716c9dd058f"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "f067e1f516d639b2cc997019a39b568d6377437d2d6810fb87d23a64e72995a0"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "7b016747c9e9066a8e4383303ee22e600d3b00716c53755c95067dc8b6267046"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "f798804c9aa0eb8fd9cde80acf8a2ebc3b4855588ff14092da935cd77bbc660a"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "7a19e07c52de321f8f182bd14fdaf137b120167d9d2ab4929476f7cf9a94a744"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "b66b2ff31cc778f52ce9e987f38a93f973c04dacbf04559b1872537a083cb98e"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "7599ba2b65fcac92464c2ee480c4c823cd0f35661fa30982575e6f87069d3e58"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "e81f157f75f2eb94f28dc7f2da5c1d0fbb8f8077c28c3afdb2144dd906ce773f"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "bdcafd77469b70a8e02cacab63503e4ba085e3b4230e012313f743a130448cb1"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "2f57c5353e75ec9dd56abf4c4f197af64648e3e2e927b7c868db6f664abb2e14"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "f9d8a77df3e4718260e9235ce09008a224e02bde12efe5a88c9341432637f0c4"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "46a4ae81ecd6fb22aed54a0ca40ddf292adc94b37b38a57e9ab64f5bed8b0a39"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "f03136ad26eb1d5ead82e26e8620e3cd1b7f30ceb552329d008a33bcb2e930c4"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "d2e446dea1db14210da9e1556614a92954c61ce00b24958ea4c2a61b597c0b13"; }
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
