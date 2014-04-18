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
  version = "24.4.0";

  sources = [
    { locale = "ar"; arch = "linux-x86_64"; sha256 = "dd570da273c047e0b4bf29a7ed4bb4356dcbdd8de62ecb65fcddfecaf156966f"; }
    { locale = "ar"; arch = "linux-i686"; sha256 = "f96c30ad874adf10608f818e0d986070b2a577de4d9aeb6c8dc7ea1ccd6e72f1"; }
    { locale = "ast"; arch = "linux-x86_64"; sha256 = "8a50ff6a4f0d2bf68f989c2d3e0bca75c9fbcfc73c37b6cc16d935c1e3c1a9cf"; }
    { locale = "ast"; arch = "linux-i686"; sha256 = "ace08104be64c038f5337e5178a79cb3f909c233f8722f7d54db04aef87935f9"; }
    { locale = "be"; arch = "linux-x86_64"; sha256 = "793c07b33e861a5e29ce906a9764d980a82238b7c078391b96480592f526f323"; }
    { locale = "be"; arch = "linux-i686"; sha256 = "98f2a5390572df625e0600ab224d5171d0357e187a3743ad72ec94d31533d993"; }
    { locale = "bg"; arch = "linux-i686"; sha256 = "7d2fbb1ecad6e7a81c481a6697429809dc76809bba537ab8bc576b19ba5938f5"; }
    { locale = "bg"; arch = "linux-x86_64"; sha256 = "a0a551d1790969b11ad2dcfc277f487645abff2497f2e9104235e77c45e5120c"; }
    { locale = "bn-BD"; arch = "linux-x86_64"; sha256 = "cb2a5549c3cdc9e159181cb9417c7f53158820f722e48d3ce2e4dcf10dea32d2"; }
    { locale = "bn-BD"; arch = "linux-i686"; sha256 = "e395d07fb7b13443ccc97433d38a8845969cf854ace807950a364319c17861d6"; }
    { locale = "br"; arch = "linux-i686"; sha256 = "8637d47dfb9b685a1034f5449d3481a5c62f74158f1a6318fe94504ad779dbb2"; }
    { locale = "br"; arch = "linux-x86_64"; sha256 = "f36f6d2041a110ffc621249e6d92ec09f3b2bb7a1cf08b7892a0eb998b8a2bb3"; }
    { locale = "ca"; arch = "linux-x86_64"; sha256 = "427a09458fe0d631a360b871db637d33bc0ad443ec443b7193db409321ab72da"; }
    { locale = "ca"; arch = "linux-i686"; sha256 = "8531078cb31cb3035fdfd7397159cd42a6439868e954e1c9bd6eb7f9cd564bdb"; }
    { locale = "cs"; arch = "linux-x86_64"; sha256 = "6fea39c9416357ec2902ed3dff84650a683dbe136790fa83cbca5d8bf869dc48"; }
    { locale = "cs"; arch = "linux-i686"; sha256 = "c9e8d50e04dccd647ef7a566e68a3fe8374f86e9c1b7fe2001e3690270c5e7b9"; }
    { locale = "da"; arch = "linux-x86_64"; sha256 = "41debf8c221063c4a5eafc3b769aabada6f3cebf35a354b7837c2ad737fa9b0f"; }
    { locale = "da"; arch = "linux-i686"; sha256 = "77aa022e8c58dc60595f4600849da795faea4c20da6d5514f57e1b0033cda27c"; }
    { locale = "de"; arch = "linux-x86_64"; sha256 = "05ec3d776de6060a82eea595b022b73c05ab7016419be5989929bd10ae282d27"; }
    { locale = "de"; arch = "linux-i686"; sha256 = "471288d8660536508fe04b236eb72a7c245d27cadd59841a9bab0e73db271005"; }
    { locale = "el"; arch = "linux-x86_64"; sha256 = "901c0097fb8072a37787a77758a0d6a2ced66acdf5a3588a0a6df3584034c309"; }
    { locale = "el"; arch = "linux-i686"; sha256 = "da658a5f18a7162d513f8e0aac8d1648b18404bac7888a2f66c850f2084a54c5"; }
    { locale = "en-GB"; arch = "linux-i686"; sha256 = "61c637e3b63a10d3c3eff91e9dcbd8558887a41d8e359aa637541bc4424a328a"; }
    { locale = "en-GB"; arch = "linux-x86_64"; sha256 = "dcf399192062a7e3075125f550b0889fb4943c595814b8f6e755e9aa7e4656b1"; }
    { locale = "en-US"; arch = "linux-i686"; sha256 = "376ab51e3c424db7e235b2e94494d48ce2fa9a8f1fbf5ef5cf9e367bbaf7422d"; }
    { locale = "en-US"; arch = "linux-x86_64"; sha256 = "57917aa608131da4d569e791fc8167f4df54975b74c64d6df641858400dd4c1b"; }
    { locale = "es-AR"; arch = "linux-x86_64"; sha256 = "47ecdb633bf1b246df84e796395a668fd98ac52a82177507da010b0174aa74d8"; }
    { locale = "es-AR"; arch = "linux-i686"; sha256 = "9155d96fb14795bc5a22e10105ba0226a7b9c87a4d6ffa5cf7835dc77d69fa30"; }
    { locale = "es-ES"; arch = "linux-i686"; sha256 = "3c41656512f1859b28abdf81d356dd90b720efd489d7021270114a9d28c54b38"; }
    { locale = "es-ES"; arch = "linux-x86_64"; sha256 = "bad476b65d71744b9562a8548ca6cd608da92e62f45057688fef29ac77eb060e"; }
    { locale = "et"; arch = "linux-i686"; sha256 = "06fdb2df4bcca189736fc6ae2fee6ba87f6b19d0b64f21bdb2b07e478fe6a0ba"; }
    { locale = "et"; arch = "linux-x86_64"; sha256 = "f110d0940905e2cbe4ab14c1370ff88e533e030fb5a408bf4f06f517351d5979"; }
    { locale = "eu"; arch = "linux-x86_64"; sha256 = "02bbb72fea711772d0dba0137641acb9f0293313a552e554443118324737fba4"; }
    { locale = "eu"; arch = "linux-i686"; sha256 = "3a94fc161e98282691d668b68b3a8e7bf035dc87ec0d07be6eb1844b2a79cd39"; }
    { locale = "fi"; arch = "linux-i686"; sha256 = "3f9c44306991554cf48fee4da86dec6ab06cb863baa8157d7adf29f6f8b0119f"; }
    { locale = "fi"; arch = "linux-x86_64"; sha256 = "9883bfa54e331c17338bdf7e835a0a0f71a9366ad99ddc0fda12fd9d062f071b"; }
    { locale = "fr"; arch = "linux-x86_64"; sha256 = "60e59c9b9ac78cba5604a051784a8721f84bfd10899d9575a4591ae4e5c48afc"; }
    { locale = "fr"; arch = "linux-i686"; sha256 = "d16908d799fe667032d317b01db91cdfcd0b23654061203df84f5cb67d6ae837"; }
    { locale = "fy-NL"; arch = "linux-x86_64"; sha256 = "21e209179135fd97207e878c415d112e6c01bd7686f45eef2891cd8508dd8f9c"; }
    { locale = "fy-NL"; arch = "linux-i686"; sha256 = "c8463a38d5fc454ad80a519a9828c1c8808688aa140b5d5276b53a659ae7bf7d"; }
    { locale = "ga-IE"; arch = "linux-x86_64"; sha256 = "22d6d90cd7490e36ef5df2106ba84bcd49038cecf70a60cebd4bf552a01bfdd7"; }
    { locale = "ga-IE"; arch = "linux-i686"; sha256 = "5a7fcc013bcd09d327e40e5b0001057067f9e509e52f38681893f1a16cf8520a"; }
    { locale = "gd"; arch = "linux-i686"; sha256 = "14c7d9a846a5d2a409089a16afdc97309d6818f97097d73757245b29cdeb73ae"; }
    { locale = "gd"; arch = "linux-x86_64"; sha256 = "e4d3b093da2d80e2a2c02be8d03831c6a89e8969d3261a39f153a6d96f20c7eb"; }
    { locale = "gl"; arch = "linux-i686"; sha256 = "73515b65314f8aa28fdb8708e821c01ba6edab5474e5140266b8ee8c0206807f"; }
    { locale = "gl"; arch = "linux-x86_64"; sha256 = "7dd646cde4969243178237ea7fdf7b3c7c369e735a42f21292e8fcc3bce2c6ac"; }
    { locale = "he"; arch = "linux-x86_64"; sha256 = "3fdf3750727f47628ffe4e7b28e8b7f180194be5985f4a10c703d3322a563e55"; }
    { locale = "he"; arch = "linux-i686"; sha256 = "e4385cded8a13776890320780c6aa265c9562a6301f8f5ee7f4fbeb4aa54acf8"; }
    { locale = "hr"; arch = "linux-x86_64"; sha256 = "ada94d6612f20642e6294a17334afb8d31b419132e725618a376728a6028454e"; }
    { locale = "hr"; arch = "linux-i686"; sha256 = "bcbb85910f983145ff8df79574087cebaac6537600aa9a479f55298a7d6bc1c2"; }
    { locale = "hu"; arch = "linux-i686"; sha256 = "0f41a925ee5c3ad59f24a6b59eed066d1fb37ea8ec81ab4bac70280437be2589"; }
    { locale = "hu"; arch = "linux-x86_64"; sha256 = "9038e0358bb63a147835cacf91a7e7db888fc7b93662cca4919110e2a5daed76"; }
    { locale = "hy-AM"; arch = "linux-i686"; sha256 = "24af2ffa71d5810f8e947de27e77a70310c22dc1cc89640b67416fe74a4a14b3"; }
    { locale = "hy-AM"; arch = "linux-x86_64"; sha256 = "62cfce68247f5afd2c68a97ed230b515c1515ecd279a753bf9c728c552683f6c"; }
    { locale = "id"; arch = "linux-i686"; sha256 = "a5e2d72cb0841848cd5a947d4cda2e84db1eae97a0735974690176ccd966eeea"; }
    { locale = "id"; arch = "linux-x86_64"; sha256 = "f1d539fe69b8121205c5411096554cab41ae4f42a2018af6ba020a2d8fe660dc"; }
    { locale = "is"; arch = "linux-i686"; sha256 = "6eacbd0b4b9f47f67818d6021600b5dddc79d2a38edac5c47f61ac039ed5cdb6"; }
    { locale = "is"; arch = "linux-x86_64"; sha256 = "fcc86ac738b190012d38d32c6cee3c35d57f6a3b80867c0107f4b8a2717961bb"; }
    { locale = "it"; arch = "linux-x86_64"; sha256 = "9b668a501c7da55c630761dbf89ae8fe2e32038af8ce4c10fc646eae7c2d08e2"; }
    { locale = "it"; arch = "linux-i686"; sha256 = "f610b7d4a34635e7c3b5c355873b65558537224d5a241b92605a49499ba4d5e6"; }
    { locale = "ja"; arch = "linux-i686"; sha256 = "185ee26eb9a33ba534805b5b3547b3524bf11c94614adc252f7d17b41279d312"; }
    { locale = "ja"; arch = "linux-x86_64"; sha256 = "1be85c39fa8b09a6bc2b11a47d04f0447628c3ed8a775d27c8e04577627ed63e"; }
    { locale = "ko"; arch = "linux-i686"; sha256 = "e868d431d77b419bae6fcc7e1e137815ca8cbad6673074469005c606023d7983"; }
    { locale = "ko"; arch = "linux-x86_64"; sha256 = "fa4db6ff8047a5e11411e507df4f84baac5511a1709d5685a2a6e8da0d2e1f25"; }
    { locale = "lt"; arch = "linux-i686"; sha256 = "40c1eeabbd9d877750bee7f5f4a6b6f2108aa364ace8eefff26806a5bafca5eb"; }
    { locale = "lt"; arch = "linux-x86_64"; sha256 = "4bdff4418bc0c9acc7d3b00ccc6500d51e65a501c2438e99e22c03bbeb36dfff"; }
    { locale = "nb-NO"; arch = "linux-i686"; sha256 = "541b5f434e6354bb6a4c50abb828a49383b1d1a9fb31d6b99c1f052ef73bc2f2"; }
    { locale = "nb-NO"; arch = "linux-x86_64"; sha256 = "9e954408406762e55fd40487cad589c876285145931f8a12ff6ced29d9583cde"; }
    { locale = "nl"; arch = "linux-i686"; sha256 = "06a57772563456d5283b9a36b9e6cbb5efb4f33e4ea29ac2446055e0a965b8c9"; }
    { locale = "nl"; arch = "linux-x86_64"; sha256 = "42a8d995ac906c7fb4a1952db62d1717aa7c4660a2e7e794da3aae6aaac6f9c9"; }
    { locale = "nn-NO"; arch = "linux-i686"; sha256 = "6fed1e74c6323d2909caf471ca733df46224afcb0c632d5fa0f0d80d6157efd3"; }
    { locale = "nn-NO"; arch = "linux-x86_64"; sha256 = "c29d8ff69ec2a8b5f508b7c56cd8679fe3b322f7e2e87f10303fd8bca1b93230"; }
    { locale = "pa-IN"; arch = "linux-i686"; sha256 = "a69a7ceb4fa85cc43c367f1ddebafa76808e83d3044c158287a5923b82fc3093"; }
    { locale = "pa-IN"; arch = "linux-x86_64"; sha256 = "e38e75976891204fde647d389b6c89c807d378a534d6e04582024755a3cb6139"; }
    { locale = "pl"; arch = "linux-x86_64"; sha256 = "39a0d3f865c462b5d3ae569825befd61dbf3ee5a6b2b81d3b9d31f4c98cf7b72"; }
    { locale = "pl"; arch = "linux-i686"; sha256 = "3ccedf1ad79135d825f762dd09da88be23901591b27ea7e61a887d5398284a46"; }
    { locale = "pt-BR"; arch = "linux-x86_64"; sha256 = "ea29e40d41442ab373855acd7b40927fc5a0408f9d3bb4a0c6a2021cd8b0fca2"; }
    { locale = "pt-BR"; arch = "linux-i686"; sha256 = "f6170909b6527e935584673a17d1245c33142a755a9db45dda2de240871fc6c0"; }
    { locale = "pt-PT"; arch = "linux-i686"; sha256 = "15531f4e4652d533fd8cb8d3be8b5e24717240160d885629eecc7f08d8cd0701"; }
    { locale = "pt-PT"; arch = "linux-x86_64"; sha256 = "9100cdf6ba87959dfbdf756c925f6a2f35fc0c6ed453625a23eccc48f0bdf331"; }
    { locale = "rm"; arch = "linux-x86_64"; sha256 = "9bd00e4e2634e9f922d6c1d4ef82dcba53f88fa6d7d1986037665a42109d39d2"; }
    { locale = "rm"; arch = "linux-i686"; sha256 = "e2ca3832625efa908c6d88627960e1d98255d14095a36033cddaa50065172da0"; }
    { locale = "ro"; arch = "linux-x86_64"; sha256 = "676120061a33c1bbbd381ea1d84b271c6e21d4a531ba776f67f7a02fd91fb99e"; }
    { locale = "ro"; arch = "linux-i686"; sha256 = "c69d6b8a8de474e460c89ba442e25aa39fe761225f7c4b12eb1df88021a6b6c3"; }
    { locale = "ru"; arch = "linux-x86_64"; sha256 = "5a6af10060b8ea8acd3955a4056765574873e9341e4627ddcbf9811724f5eac0"; }
    { locale = "ru"; arch = "linux-i686"; sha256 = "92ce7cb5db9d94e291d7275b8817640c68dc061a3947317cba76ceb263a4b614"; }
    { locale = "si"; arch = "linux-i686"; sha256 = "39849a4d38a96ebca9727b65093c36d8d50cadddcdea7ea404ee4aeff10fec0d"; }
    { locale = "si"; arch = "linux-x86_64"; sha256 = "fa42ef419e173181166c6797e37571df6b7c25797a5caf8ca44c34b4f2faacdb"; }
    { locale = "sk"; arch = "linux-x86_64"; sha256 = "2c9c81db8c15116e6061de0b44dcb34579ce305ca30af284cf9eac52630fef55"; }
    { locale = "sk"; arch = "linux-i686"; sha256 = "b253607b29565169d74c491772ba2887c3e2c0dfcc3a7cedf91afa0bb073ff72"; }
    { locale = "sl"; arch = "linux-x86_64"; sha256 = "03e7781cd0c3fef0596e55ba8a711ef8b8f300e48297ef3cad7885b2b118864f"; }
    { locale = "sl"; arch = "linux-i686"; sha256 = "18fe799b1b675e5513ddf9edbe845bfaaafd67162e9d34250a31d0ee05bc9bba"; }
    { locale = "sq"; arch = "linux-i686"; sha256 = "4fd1be2d2c6a703544b82bf977ea63df3e295c16c9ea97573ee57945e07639ee"; }
    { locale = "sq"; arch = "linux-x86_64"; sha256 = "e96f7302d47897c3fc58a2777aed666aca29641500e912cee1bc59406df8e500"; }
    { locale = "sr"; arch = "linux-x86_64"; sha256 = "ede709c9e6014edbc543511d99a61acfb0d40b796ed5ab42267ae7f8efb6583c"; }
    { locale = "sr"; arch = "linux-i686"; sha256 = "fbfc0d476817c7076a72fd6fe2519c6a347fb062f696a8fe0c969182750d1d11"; }
    { locale = "sv-SE"; arch = "linux-i686"; sha256 = "d30dda991111ae5bbf7252d889cef53258317d3570e56360db3d7676a8fc7602"; }
    { locale = "sv-SE"; arch = "linux-x86_64"; sha256 = "eba61a1417ba4cb4885732d2eb621f5a385b4b433f706d52bd1b401d2298985e"; }
    { locale = "ta-LK"; arch = "linux-i686"; sha256 = "92dc3a2aaf30c5bb16462ee7d73a5df6f8b5d2d1530f5d1fb4b90460e84dc77f"; }
    { locale = "ta-LK"; arch = "linux-x86_64"; sha256 = "e5db15f32c819d3b0e670ac975d7afc118915abeaf4a9f0a02a5b67c490605d7"; }
    { locale = "tr"; arch = "linux-x86_64"; sha256 = "0c689f622a0770a0b0d8f87d35513f9fbc110ca507d0b8b3bd426f763a0f77c4"; }
    { locale = "tr"; arch = "linux-i686"; sha256 = "f49e5f3bf1b4616f52e82c480f9a4752269f393d79de2274fc0562cfe9fef1ea"; }
    { locale = "uk"; arch = "linux-x86_64"; sha256 = "06100c2a82b3c31ea85f1f1d8856db62f2a73142fd1263e3db5df679f8843d8f"; }
    { locale = "uk"; arch = "linux-i686"; sha256 = "8358a935935215fea5eb75c69cf63bb5fc5c22bcce76939cfb804f3ee9f89e54"; }
    { locale = "vi"; arch = "linux-i686"; sha256 = "16a0f71efcf71640234501e3c8a3bd1befe15e1bb0bacc83ff590d6c780a0e5b"; }
    { locale = "vi"; arch = "linux-x86_64"; sha256 = "d5d0371ade5603cb725d6677983df037da06acb13207550b8a1a88c2948e992b"; }
    { locale = "zh-CN"; arch = "linux-x86_64"; sha256 = "287b1fda3bb2d8d27ea22ea4c8c21d7ee0b3a5d439ea32e72dfc882fd64c5765"; }
    { locale = "zh-CN"; arch = "linux-i686"; sha256 = "3bddd9f4e742ad80bb6d35f3db8ea50cd496ad1be06003e67b4fcc290945bab8"; }
    { locale = "zh-TW"; arch = "linux-x86_64"; sha256 = "5a5cb16f45d1c3ccd9e0fd0b21a7b55e90b49f0b37cd550bd89cb6c00d92046c"; }
    { locale = "zh-TW"; arch = "linux-i686"; sha256 = "aea52fd5f8d8d5b720e1fde907b9a7b7638b384b71d01295b08749df06c578bc"; }
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

