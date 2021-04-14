{ lib
, stdenv
, fetchurl
, bundlerEnv
, alsaUtils
, atk
, bundix
, bundler
, common-updater-scripts
, curl
, desktop-file-utils
, gobject-introspection
, gtk2
, jq
, ruby
, libnotify
, which
, wrapGAppsHook
, writers
}:

let
  version = "4.1.4";

  gems = bundlerEnv {
    name = "mikutter-${version}-gems";
    gemdir = ./deps;
    groups = [ "default" "plugin" ];
    inherit ruby;

    # Avoid the following error:
    # > `<module:Moneta>': uninitialized constant Moneta::Builder (NameError)
    #
    # Related:
    # https://github.com/NixOS/nixpkgs/pull/76510
    # https://github.com/NixOS/nixpkgs/pull/76765
    # https://github.com/NixOS/nixpkgs/issues/83442
    # https://github.com/NixOS/nixpkgs/issues/106545
    copyGemFiles = true;
  };

  inherit (gems) wrappedRuby;
in
stdenv.mkDerivation rec {
  pname = "mikutter";
  inherit version;

  src = fetchurl {
    url = "https://mikutter.hachune.net/bin/mikutter-${version}.tar.gz";
    sha256 = "05253nz4i1lmnq6czj48qdab2ny4vx2mznj6nsn2l1m2z6zqkwk3";
  };

  nativeBuildInputs = [ desktop-file-utils wrapGAppsHook ];
  buildInputs = lib.optionals stdenv.isLinux [
    atk
    gtk2
    gobject-introspection
    libnotify
    which # some plugins use it at runtime
    wrappedRuby
  ] ++ lib.optionals stdenv.isLinux [ alsaUtils ];

  postUnpack = "rm -rf vendor";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/opt/mikutter

    install -v -D -m644 README $out/share/doc/mikutter/README
    install -v -D -m644 LICENSE $out/share/doc/mikutter/LICENSE
    desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value $out/bin/mikutter \
      --set-key Icon --set-value $out/opt/mikutter/core/skin/data/icon.png \
      deployment/appimage/mikutter.desktop
    rm -rv README LICENSE deployment

    cp -rv . $out/opt/mikutter

    # HACK: wrapGAppsHook wants a file not a symlink. postFixup puts it back
    # where back in place.
    mv $out/opt/mikutter/mikutter.rb $out/bin/mikutter

    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ wrappedRuby alsaUtils libnotify]}"
      --set DISABLE_BUNDLER_SETUP 1
    )

    runHook postInstall
  '';

  postFixup = ''
    mv $out/bin/.mikutter-wrapped $out/opt/mikutter/mikutter.rb
    substituteInPlace $out/bin/mikutter \
      --replace "$out/bin/.mikutter-wrapped" "$out/opt/mikutter/mikutter.rb"
  '';

  passthru.updateScript = import ./update.nix {
    inherit lib pname version writers bundix bundler common-updater-scripts curl
      jq;
  };

  meta = with lib; {
    description = "An extensible Mastodon client";
    homepage = "https://mikutter.hachune.net";
    platforms = ruby.meta.platforms;
    license = licenses.mit;
  };
}
