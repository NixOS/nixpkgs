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
  version = "24.6.0";
  sources = [
    { locale = "id"; arch = "linux-i686"; sha256 = "e19f6f5b8f19178350ec68386afd2ab7e5900b8c1fdb7bf81928fedcfcea5cbe"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "ece7445451150b2776f5debc818e288b9037dac1f2da9c7f7db584b6d2b73d34"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "0ff30ffc7ffe087056b0e72d66d2bc264c1060e3abb65e0c4d53d976855f436f"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "dd41d433644f7790ace1f246ec6703c060456260716710fc4318ca834ecd758b"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "eb6d53c00a6cd912279b56c5322d65b94fdd2a021c9ea2c854f664e476ae89e2"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "b0fdf2dc2de7ba5296f69694908aef4954b24b4c3092bddbec8995bf838bb817"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "71f4f7738540445dc64399368bb63bf48ede79f055d6647ba9ed4d274040d623"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "2be714b598bf8f1a3c6c9a13141d370c4d29bfec3e4053eb6f1c8a6a7988a96b"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "8b2c3b83f4f88e33ac31b07dfb64e83fd1b2cce9ad877c8bb5715a0e6299ce6f"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "93cd2c5c6c2ac05af3bb55a723bf3f02234d55064b5ea7cba6289bd07cca7647"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "2f11b85055fa21b4e2677b92fef34a769ed56bdbd877fefb86599edb5dd39932"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "d47057633c0ec5e785a723c45c5b8b0168e3d3fabe4aaedb4ca1adbff29a4dcd"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "902274548b7308e75c465f71912a7d1e5539e92420ffa17c80a2ac20d02d8630"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "044494d6bfc07b9cbeaa325dab3c1f0c5e554a05f1a050d960c39fbe093d9482"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "e453a06a64c35ed81e661c67fbd4241a7c5494b1f3d2bf5ace7543798feb338c"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "e8006f0e89153424c809de41ec1a714b91011b5a2a9601c1893a6ff30dcbd2ac"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "fed414783f8e9bba5be6d4cb90ef04f274aabab34f3b4351a329d5c5ae7ae8f0"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "e8f0203bf90bc30c89380c417921139f7b92ef1d38b3d95d292acee3be4e93c3"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "0948d002df401b9aaedbf8e3277ce312edeb635baa57b1bdf5de87cc13dd36cb"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "733e09671f00c693e13a726fa597b4705822e693ddce8a0494c57fde1de3cb56"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "c160c17e4b9b0e3d579a01b5973d142c711d4f87b03fd542d073d816ced9a9c9"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "0c281e6430a233aca5c6130e907e08c7d05aed8851214063546aff5a5df82232"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "5d85eb78f01e1d52e733d4abf8d33281ec2c4adf9a9c65f50c6d6e2b6acf3d1d"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "a7bb71bb08ccfc01f8e91b47b6ee0ac4592976e964454304da493e0582d262d1"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "a63e060eac9efb27b4166e05ff6a035afd51cd29d45ddf69e5226e08441ac53c"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "8a5f45352e180e984c7f1bc37f0e7602cbc6085a3dcdcac2d74f493941fd9f0e"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "ef70e1ff3ff3ce2fd9ecbe62ed010c06e63b410b843cdc3aa3c93fda2bf56708"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "af33cba52556057abf17df0e92c11ecbf39382bbf92c66b137113e5503ae170b"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "f87eac6641ebccf018c76275adcba03976b9c62b9fa51533ec67ab0d2a5a91b9"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "009b53f10bd785a799026dab028fbb7fa46c154569eba98db2673af12f6c19c4"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "ae2243346546cc2c768a9c24fc296013a45459637ab65477537f9d08d5ae193c"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "5cb2af1ec854e12b91bdf7f2fe88b56bfb45bf7144cf5cc3f0e307259d767a43"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "bf3a2e4efd86b1e73ac38ef3dc880ce2cee3102d2844b17ebf31aa6528040a92"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "d36f8d321d2952310dcb19a288f36f6496ca24e7f49fb483882c270c1c96571d"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "e05f63d1f978029169a91719551b6e399be0e0d37310921168904d188e41f50d"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "b8025a7a724a0d98c4f706e7ce59aae8c0f7bcd0082733ce6bee73a1d243feef"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "26ded9a3ebea58bcf80ca47759d4fdb86fe91aea8dcf56afdbaf7a32d548ee66"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "fd8321d5d6adaae042651d911df6ef587afda19ee82bdcfce98814144282b54d"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "94b94517072901f34ab28b6cf3a2fd8852867f147ab4b47f34f7d9ae16fbd603"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "e38f493ea1b8c0b183bad2f2627eb166e75e875a62b33704f50f8f831fd552ec"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "319ae8256ecf3d7623195e474040fffffff230cd612571872a38b52b608c0507"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "f776b8a9efad41f5c2f8770452a0bd053a3ba9ed4b74da3e3f24214c69e9779e"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "f6aea954d3ba2334411a7ce9e7e1da926b0039935c5db3a5480f0fbda583b849"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "9fef811764441b2b16e408808f4608e17cd21175cf45774162b3bce8b8612491"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "71df4de89a1eff632339dbaf48ce41182f7a20f7e55a223f6816ef86d3465443"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "076332c97a5c854b2313bd9f2138a6660d8e04fbddc3f8beb89acf071efd4c86"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "1a45f7d1d8817f6c724dff556886edc3f2d0ee62ff45bea8d6b7ef63f7f92928"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "8aa25320126052c9ebc3496e8731224e30fbd45ee2679f4d87f7f2050a01c312"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "83a31a94eeb95e28612eeb1e696ed387b6793da350efda439de11833e0ea1173"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "8c1647f8bfb210f7da8aa164777ef412bf3d4459ce53c95ee2211b4b5df440dc"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "e5bb99de119fd6496674fb9cc8432f146e684afc652dec2861108d1ef20b49d7"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "f35e62031154a32da68ea3d6960da8807f0de7ade7071526fafd6ace48c88976"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "0826595dddc981b64d4f1a59cd71411c34ccd0aeac182925709abeedff8461fc"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "b5b8d30251fc482861518e1c86001aa5eca6b53a65e14a8c6ff9e61eaf651044"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "a9b2138cacc983142353ec09a5c4226fc731501da4c0200cc86026e6b28ca10c"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "6c9a2ce8a8d3b4815475827caf89a3fee8371c422aa6c4984bb03f56728b682c"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "813260cf5ab06e55c563e015e0172ce0192ccdd894a352ef6d4f439252032619"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "c879fe62db6952f91c51ec7c172bc67d5351f55e99ab6df5cdd8639206f3444a"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "33888c19b7e5e57155748d7372ad2b0e61f522ee96913f8846c754c3361fcb4a"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "d5487588cf07cbd2b02b1c566b6515d087cf8fe9d528890b1dd5a0de53ab1d8c"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "72b3a36269de70bd627589bad817e7702a4c83fff9b460e4f787486fa4bf15c7"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "d458ed4b62f65ce7c3787930549cbee42842ae87a846e5d1565c1881b3bc17e8"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "3155a71e847020b2806f6b31acbaa702ccf20f8bd805c2aedb0c9c415f75b88f"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "b56beb864d247685cd9ba6820e5a8a143be28ff95440e38670c8963d2c769738"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "74b7059580a4f389278b1059d80308101ffcfd0a738c6d614e56560ce116db34"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "a351421c230f6629de0125a30767ff10d541264f6249f6fa2568eae76189398f"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "d26ba336a555276c36f9a003df9bc3e0df1c40dd4da7062d1cd8b3a6cba6d52c"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "078e5878f823b2d19568af8bda095e6ab46097a680b209bae9242d7658377abf"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "c9aaab25dabdba0708459a82882b926155b475314d72463633af10c27d9e5dfb"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "9a9fc61875f0427c26107b96ee3a6f7d71717c0d4aa6e41cc7b1b56bff2131e7"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "afc862a2a1054f08cffa0ec4facb2e9098fb042f7e4dab85c2ace7f30a384426"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "50353005857df556840fab0b18e8784dc18cbcdc5c45f4fc1f68f6b78b58048c"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "4876fcda18fd01b51f392a56085ebfcb97cefd69355666f42d58ffe53b9eb8e9"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "ef90a31aa408c6c86f3103d7bc82e3e8b5ac7bc9956d431ef46e1f44156b7dbf"; }
    { locale = "ta-LK"; arch = "linux-i686"; sha256 = "ee4a961e76e63a79d08118e2355e37b1b2a1e0260613532ac6dc7c9a9e86caf1"; }
    { locale = "ta-LK"; arch = "linux-x86_64"; sha256 = "9a1233c0ee7a72f8b1c071a6cd507d870d34bd64c71f7f960c00cf2e840ea5b1"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "00bf471763ca98d7c7e0243f5bbc75230b6cf8cea9c5dab17464c47544d102de"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "61e474bd0c930b9d6bcc553a87c07e415e1fe037dd033a6a97f9137d4fc73f49"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "e93520901aa59938e1c51c9943225dded88c668a91da6660de9f41714114ac8b"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "008156ddb73f4eb91d801d8bc35685e517328b5e5f13a4ed39873df471d01c67"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "20b3b10e12238238737fa0da3dce5e2fdff1161594b415c5872dd7416001482b"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "79f854469ac1a6fb0768934dc20ebc511a01904c71f321ed31ebe400ab88f4d8"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "61cec7fef6e75ecd7d459e973b258c5b62af0dbfd175b7000484594e63ead2e4"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "83b3761bfd949e3890c7006ba9610e858fab25815cd6e2f3f293ca707086a78c"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "f36321189ed80130b9e4a3a6e387531c48745f4c109f35afe928cf2d44e1b424"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "81da71b2ce832788213ed60f801fd79e61205a98c44e9082a35f2195af314de8"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "b759d93d78964eb8b9ce5aaad37d652fa425cfb5d6049f58a31c2492e3aa475d"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "62b32a8a4e7455c42bbf8cc5029919a64ca2ff61e06f535dd628a8dd612a15d9"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "4ad6ede882e973b37627105812619d2e8c804d50d496d96f68554bf75ca093fe"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "9fd6ce0edef1a8c8eb7d811afa39600a2c946f9ed87610a9e98a971d4cf31b08"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "35254ef736865d1a7c368e62c9cba68fa64b7f017aca4d9569aeb18b5f559717"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "6ff8a5b4ebfb9217b37afdfc4d5cab01f1ce66387010d2105a51bed486eea52c"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "eb4af3ff107f6827d0288bd68486b8eef174c5dc6e9b5313099d99b2e695db0d"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "80a6bf800a53af0cc9445c632546ce7cefcf5bd819e6e5e35e662330d58d757c"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "ba35f578095f79582341e988ce7c5e07f489833f7a309756c80caf4f56367987"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "09c193e865e90b6d2c547c17d10add7d43e8b89b630a8a490323d4ed391c924d"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "57610296c564291a8432fdb9215bcfbab6f09792c47e5606c1619bb203c7f5de"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "c702acf69957ffd1c4774f42d4f28dc239a4c5bcf6e003c236952167bf9e7e9f"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "56ae2d38af2988791163e6b118c781d55e2c545097aa5afccc72998705312888"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "c5386f149831aa2f48b65391f31f8f2e0a9c3b7a8bcaae67420a5819e80315ec"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "8409401c0b87be071d081c03eb34e3338cb62e80669045f5d268f8da60d96bce"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "4f93e9b0688e30586b3d372944ae5579f7249220733d6045e6bca3830e7f121a"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "ae1608b9e15862f82d15c5acbcd9f65775efc4368588bc685ebff523ff93e2d6"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "2466f020209de610f429315e0b090b43cf42c9ce540c6bc51e7ad11f5a3449f5"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "76cbcf31388cbe72ebbf3fa3be66a0cfe20cd572febf062f3a58a9c50313aa03"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "e4aa9dd8bb21f3d79ce5f9cfc907fc8a355fef349dcdec30403d534bf3cfbdf6"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "06561fa96d5166bfbe8eb492ebc08b3d2a768a8a7a251b357dec89ad33f3825e"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "85e663261cc6722c25dd36e1c0a15b7a82a3a6aaca54191effe8ea09ccb8c43e"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "d80f116d39e48b42a767fbda5b6e765be4bc3d210cf95d80bb014606785be3e6"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "c2e124736d63581a3034e60fe3d40bfef9458a712853ab5c8c5d391a9d3af6a9"; }
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
