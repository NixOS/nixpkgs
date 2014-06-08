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
  version = "24.5.0";

  sources = [
    { locale = "ar"; arch = "linux-i686"; sha256 = "a5d7a95ed93277c5e7191f868df343d1a1d14e6c692cac1e6069fd9ee7177273"; }
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "b3100ead31d208968edd5b8545b641d0db9692d31a63e07fa9c391dca61de8a4"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "059ed2a01afabebc7bd28cc79841debcaaa0bf015f28145c719396d4e612f535"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "75874c6fcabb21332095562b9f86b7c6b668efdfb09904b83fa20743e1740790"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "7eda8e02a15284a0e6814072a0212457a25bcfef5058e1c376fc22facb2970f1"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "9fb0150098810b152ecf95e0826a3bac1dbffdfd2f8f2ce400841cb4981e3f3d"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "6929e9c0580e62cffb3bfffb1398f35b7ac59dcc3d76a4a5c49a20cfb72e6d60"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "19e2098131a6e280f1f8e8bae7c623ebe1081b0ea0dea81ebbaea51111774729"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "30f95bf5d5974ab417ff5a24fad78687b88b3f16e2337a3a4a22dd4f1d670c7a"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "85000f577549ccf35b2a43dc3a79264b78d100dce1e0cfd3418a0ec1f87cff90"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "ef31dbfc1cc4528ee762e384d5e12fb6383f57ea34d4d1625975a2341d5004da"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "d2f8330081a203477c6fc6007230f3893290c17aab4ba9e8ed591ddc337dd73c"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "86be66b6f8075cd85470e60a1e278fb7992fbd130b6481f0ebc21e9ad46c647f"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "a2b19e3ce3a747e4b1e5b52d463e3f5822e8e120a7e043d83057746552fa9867"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "632ece525a79537acad192f8ec37fbb1e3423bcf64b1af5d18da34f1410ffbae"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "f45e4701d4b81e4a5a052b5759616540317b9e89e241dc97ad1ffc39b18abaed"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "9befe92c296b57c7a7b97ecb6eb23803c93949056177df72bc111c6e18d497f0"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "343ef548a102a63a96b1a10745ff7866f30ac6524d4f7a2ced1be3cb3bd9f64c"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "010c9225f56a3d9f552f77502daf2e70e88e45f85b39f183907741ad773cf811"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "ed60c8dd0abda8c8cabdf34fcb96d39463cde9cdf1247af44438da7586490120"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "03affa186bb66fabd9b61d0e53cb7f75aa13702a58fd2dd551e6da1b6e9cfd87"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "d60419e5ebeec445e8efc8d9db59d093060be86af140605c8019a8f24680c4bb"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "e1b6c1f3f30ea522410f947c9cf331e3d580a1620af63401186d435707a041d8"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "6d873704a2cbeb2549dd2e55b8c915292b7167ce2f5022defd3bb2c0ad29da58"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "6441f90eda22808c37bca023748efee7735cf9b18b1d21ce75878c10da8baad7"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "a54afdf7dcadb94bfe2bc6ea3d6232d311568a74ed3fd93becff9cd57063ff0c"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "989f400b587a75160a4ef1b6913819e0bd2c8b0689753b233943e61412bdba4d"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "c294e1a4173dd14222d0edba31c529a3f9005412de728b1a17602e2a89c84af8"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "f6eac1108efaaa0c5f34c4856e7db5236c60b8aba7c99558b32b4e60f1df3dea"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "74132bc1e0fbe03c462399860168928bb1bca20ee1b0bf9a80262538ce320f57"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "09fea4be7480ae51d7d68bc4b044c4d4a79e405893c4952ae083a8f417b99b85"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "c8c5d621d975cfeb22695e589dd69a360d1b1dc6a4d0f52afc3b778835fbdb55"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "19af889a9205d99080aa1a0afc7c75d0c43a970f864d4cefb956cc37c618b7d7"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "0074802e84cab6ad21de7d960709ba15531705f4ff60bf141a917edb5295c201"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "ae301f557be17b60290ee0910053fc99ab367fd6a68b4f0c27e1e80316fea95d"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "567009788743148001e842418bfa520275ae6ed39857fd99da90ea37f6635008"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "0491d2760611a5709c23df1a3ae618b4bc069c4af5ce2b2b7ae491bac390c058"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "64e4cfe3e899cbd71ac3c3b6052d742bae4215704eeffb51f27c93f98ec7f3cb"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "9d72a5fdc02ce45030bf44d7d8b31274cfb3579efc93d064824e6909fef2ed81"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "f04d7404ce637abd3d807484422970852db0253da3da0a0654f3bea213f352a3"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "853112a5c6fda45afed60a9c9f2d5f9fe972d21b092ae83cc4a3796f1be90b91"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "36b0cef0ba9e483b13ce5f9fd12e7bc11e2bd0270b5b34e5b2690e79248724b5"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "fcb07754340c2558e94ce44ac6e1577fb4cd155577b6bece74ceb61b2bf204b1"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "cc842860d7abfc114c0db47d832508a70ea1ff0bc726fc58ccb875c245689d2b"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "325e8a27d49b1748ac7b5c2070d32df0d66c8d9b1b651136d500d2bb4bfefe14"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "dd4c6aad88ac32d6175320bd82026ae6b1c4f7b44fe04904743c7e7e3d270642"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "cbf801085b4a7a3b2ac84790b176fbea8e254b13776bd19413d4c5b6522645ea"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "9d60e3a8b5756bc3d3a9148dee458c28bed9bf1fac29587bd7e95318a78f59d8"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "4361a3dc02a0dc8a26716a96aa47f0c529e0942658fcd16b472d03ae1f0f50d7"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "b23b33c823ee55daa5a3f90a9f1f616fb8ea67be912182b6118521541f7039fa"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "3d2e37fbdd5af291bc90666460258b61e4b499007ad9bba5e6e48b3b3f9cb068"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "a7b904317bcf046f9139c415f1c453b66e355b31291211dc8dac76200902ac11"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "8802522b5db21a9230ae856f90013d80a466a8c2caed35079318ece7028120cd"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "43e899856a625d8dea84c79c0c7d1dfa15f286da628cec9f99c351139de1831e"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "6ff994c056189d13a0c36cde5925e45ba3ba52ccab61486b338a1753eafc09c8"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "287e89ba01280eb778b1cf1f2fd9859610b46f2abfe369fe54d4af8cc1f675ac"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "5ee6ea3e48d526af3ef29ef374b40a0cafb299d32c1d6af4684382b8b171f88c"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "aae33e6b2e75a9db69d17d356bc49e026bf39199cd1612ce42aa41a102a1ac03"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "3a54ac3fc738e02c8ed9b7a730624497fab15dee4f9f82e84a526dd5600e300a"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "cc99d99214e6d847fc885af036783fe3c1b2a55b04c758bbb2fd5bd0a39463ff"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "804485d204392b52b4bfdbb28804f729614c53fa692a89e58f97161c89809bf0"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "8bdce5e6f97c2747ff209acee7fad24f2dc0e07801ee30754370bb0450d383f7"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "61ab133865b2c62ea88154917ddf1383a3157b96ac3b073568e392036874f5d7"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "695ef59b94626f03151c8bd68ea799b0ae5e879a57f8185af5557799211bda1f"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "014e8604790af3fa4af504986b86dc0de4bd2e53267548c01bb85e48bc90ffc5"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "8c803b613526d39618c8e82d9f981293ebb6799136697488ef4d10eb2a485808"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "bfc828d3882588a9909fef1d6731a6bc1636eaf53342a57d56e3fbc975133869"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "f25bc7dacd28fd2c907565ab608d504abcc2896118e4cd8813de28c75d26c569"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "cb94f869fa63215686465bb29a8c05f80611cd60a82d7cbded6ddf55577172e1"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "ecb185013de3d55cfafaa156821308453a90a123b99d122ea4ef7a29e7d7fab5"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "8719216b8cc0293d8aa23c04e2d663dfef515a7bc1b6e06a5f03bed3d6fb3b6a"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "f6617cf98b49d28ae7fa8e7d022587c6ed8138c758ff088c5abc78f7bdd52613"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "b0e57d139f359850558f40bad00b2c4e69da8e9d73ec9aa7d180b9f33d970449"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "2efcfe4b366f7ff5dc95c45cb229aeed316315fe4554651e5d0239985cd64fdb"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "3d579ed8e18d98c446a5f069d6d2e94a3ee234c75feffbaf99f561ef7bd45a2e"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "04090e4b4b412f79d1879340c36e36c65e4f23fde5dc545b4d855c8497ca47f7"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "9d202dd10b626ed9753ac5e243c14f6b1eee76e8edd40389f56003c4e8816c83"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "3b82124d8956e83657b30347ef3b5e44cf3813c1b02998b197c817c6528423c0"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "65ebb88e9e544c38a9d85a70a1920ed9c6ec03452762f98cb2fe104912074b44"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "fba7f18daee4832b9851615a0597dbde98a5271c5882d56ab4c1e0cb6d8c4783"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "e0ffc4b23cbf4a92768eff507335dffb92fad26d02662adf77e0ccff4f4b6c8b"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "555e30eaa6942543c7b1cd3569a6480016be5826a474a76c2ba8e2078d6d5b83"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "38bf63ae8365fbe1ca88b683d94c21cd5620a7397b3b344c0e4e938287311ec3"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "328cb7395e61924240f8e29399bf1d64179bce5bb911595cda422b741d9b6f34"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "8df9749d8dbe4218910026a8e4c4145b1f155903e577a16758d15eefbc2715f9"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "99cd036facc18242e5ab5df00a480e5c7c779b50fa95eac191bbebfa7343a270"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "4ce33a17b148329334e596186d274b9c262a779e7190f9777dd0673df12f7b4c"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "c22cd896e651b2e664128411710a80a33471319951f5aff3cfc86ff86de39a86"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "30351a15f43f905bf69e578d9ce14506ade61e805e34097f81bf8ac50f1f9ee9"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "c8930d6ebff4f7429af5daf72648651162543fa000acad0fb63179c2c3f150e6"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "10c61d7e3bc592f23811d5a06fcdc892a088cbef7fc3298e8ed9937dc7518b37"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "81483f6bdc85eb244904d3a8328d81391be24ea2ae7604cb00bbf922025afd89"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "8ac202a6eb0a3f08e9c34502b26b0cf1a85ab43850658cce7042f0afd5f9f50a"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "23fc8634b6dfa984c530292f7f01f9a2d43b196a8092f93cc435abd7a8d131de"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "9c96c0935b7a0124059caea758ba3319cc3a5977e542965f663d2daa54f5a32e"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "2d64f970c70f34bd726296b8aa2db243c245d2c36167a36de7032ae17fc1ccb2"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "1b0d6476248896b9224c5c69a944084677df45e273508bf8d629eb14b57662a9"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "05977173bdd460eab1ff5a7065067b4074417297e38dbc70c6cceedca0c933b5"; }
    { locale = "ta-LK"; arch = "linux-i686"; sha256 = "3ef8950e8aa9f130aa66a1ad2cfdd21c2ba9572ef3e0d868d7a8fbf1ef8e3291"; }
    { locale = "ta-LK"; arch = "linux-x86_64"; sha256 = "be101ca34d96577ccc6ba715235eefa9dd065f04a651e9a35786f9edb6278a98"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "d5b35faa3e0e09af778aebec4b33f39bbce98465a39edb2da15197671b777abe"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "995c1abcd5357cfda831d07ad6e0b762fbabda61601a58122acc2e8942fb944a"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "6c5b0df0a1448fcf1cebc8d82072d5653cb0432e2f787179526bae4cef774352"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "86f3ce21bc863eb8f3e0099d9386e0f38ad8b2c8e29a79e47bfda37acecd991f"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "0a21d13abb629549df74d956cc1c5f99c879980fbee2d269e1532610aebb404c"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "29cbf72f4990eb55d30a85a767d01c8077ab89af69eba3b7299d43871aaa165e"; }
    { locale = "xpi"; arch = "linux-i686"; sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"; }
    { locale = "xpi"; arch = "linux-x86_64"; sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "1527b8e9f245c96d0104f0b7d5c8dc696036fbb80067d14a1eee9a423ddd9368"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "ae294571b8433b646b5d65a0cb1ab7f42295b17369f5ec82c2383c654df28e20"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "98e5c8f912d1a03f5c0a2f14b63f350823d15f1253e15a318b61227ba82fec0e"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "49ee58ad3978113e10de520eb094fc9c0f4d740ca6c0a0e07d5743e313163d0f"; }
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

