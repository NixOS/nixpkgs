{ stdenv, fetchurl
, bundlerEnv, ruby, pkgconfig
, alsaUtils, libnotify, which, wrapGAppsHook, gtk2
}:

stdenv.mkDerivation rec {
  name = "mikutter-${version}";
  version = "3.5.7";

  src = fetchurl {
    url = "https://mikutter.hachune.net/bin/mikutter.${version}.tar.gz";
    sha256 = "1vh5ap92q869j69hmmbznailaflmdp0km4sqdv06cpq7v8pwm28w";
  };

  env = bundlerEnv {
    name = "mikutter-${version}-gems";
    gemdir = ./.;

    inherit ruby;
  };

  buildInputs = [ alsaUtils libnotify which gtk2 ruby ];
  nativeBuildInputs = [ wrapGAppsHook ];

  postUnpack = ''
    rm -rf $sourceRoot/vendor
  '';

  installPhase = ''
    install -v -D -m644 README $out/share/doc/mikutter/README
    install -v -D -m644 LICENSE $out/share/doc/mikutter/LICENSE
    rm -v README LICENSE

    cp -rv . $out
    mkdir $out/bin/
    # hack wrapGAppsHook wants a file not a symlink
    mv $out/mikutter.rb $out/bin/mikutter

    gappsWrapperArgs+=(
      --prefix PATH : "${ruby}/bin:${alsaUtils}/bin:${libnotify}/bin"
      --prefix GEM_HOME : "${env}/${env.ruby.gemPath}"
      --set DISABLE_BUNDLER_SETUP 1
    )

    mkdir -p $out/share/mikutter $out/share/applications
    ln -sv $out/core/skin $out/share/mikutter/skin
    substituteAll ${./mikutter.desktop} $out/share/applications/mikutter.desktop
  '';

  postFixup = ''
    mv $out/bin/.mikutter-wrapped $out/mikutter.rb
    substituteInPlace $out/bin/mikutter \
      --replace "$out/bin/.mikutter-wrapped" "$out/mikutter.rb"
  '';

  meta = with stdenv.lib; {
    description = "An extensible Twitter client";
    homepage = https://mikutter.hachune.net;
    maintainers = with maintainers; [ midchildan ];
    platforms = ruby.meta.platforms;
    license = licenses.mit;
  };
}
