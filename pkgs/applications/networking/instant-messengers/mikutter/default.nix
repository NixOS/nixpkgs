{ stdenv, fetchurl
, bundlerEnv, ruby
, alsaUtils, libnotify, which, wrapGAppsHook, gtk2, atk, gobject-introspection
}:

# how to update:
# find latest version at: http://mikutter.hachune.net/download#download
# run these commands:
#
# wget http://mikutter.hachune.net/bin/mikutter.4.0.0.tar.gz
# mkdir mikutter
# cd mikutter
# tar xvf ../mikutter.4.0.0.tar.gz
# find . -not -name Gemfile -exec rm {} \;
# find . -type d -exec rmdir -p --ignore-fail-on-non-empty {} \;
# cd ..
# mv mikutter/* .
# rm mikutter.4.0.0.tar.gz
# rm gemset.nix Gemfile.lock; nix-shell -p bundler bundix --run 'bundle lock && bundix'

stdenv.mkDerivation rec {
  pname = "mikutter";
  version = "4.0.0";

  src = fetchurl {
    url = "https://mikutter.hachune.net/bin/mikutter.${version}.tar.gz";
    sha256 = "0nx14vlp7p69m2vw0s6kbiyymsfq0r2jd4nm0v5c4xb9avkpgc8g";
  };

  buildInputs = [ alsaUtils libnotify which gtk2 ruby atk gobject-introspection ];
  nativeBuildInputs = [ wrapGAppsHook ];

  unpackPhase = ''
    mkdir source
    cd source
    unpackFile $src
    rm -rf vendor
  '';

  installPhase = let
    env = bundlerEnv {
      name = "mikutter-${version}-gems";
      gemdir = ./.;

      inherit ruby;
    };
  in ''
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
      # --prefix GIO_EXTRA_MODULES : "$prefix/lib/gio/modules"

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
    platforms = ruby.meta.platforms;
    license = licenses.mit;
    broken = true;
  };
}
