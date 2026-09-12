{
  stdenv,
  lib,
  makeSetupHook,
  makeWrapper,
  gobject-introspection,
  isGraphical ? false,
  gtk3,
  librsvg,
  dconf,
  withDconf ? !stdenv.targetPlatform.isDarwin && lib.meta.availableOn stdenv.targetPlatform dconf,
  callPackage,
  wrapGAppsHook3,
  targetPackages,
}:

makeSetupHook {
  name = "wrap-gapps-hook";
  propagatedBuildInputs = [
    # We use the wrapProgram function.
    makeWrapper
  ]
  ++ lib.optionals isGraphical [
    # TODO: remove this, packages should depend on GTK explicitly.
    gtk3

    librsvg
  ];

  # depsTargetTargetPropagated will essentially be buildInputs when wrapGAppsHook3 is placed into nativeBuildInputs
  # the librsvg and gtk3 above should be removed but kept to not break anything that implicitly depended on its binaries
  depsTargetTargetPropagated =
    assert (!targetPackages ? raw || throw "wrapGAppsHook3 must be in nativeBuildInputs");
    lib.optionals isGraphical [
      # librsvg provides a module for gdk-pixbuf to allow rendering
      # SVG icons. Most icon themes are SVG-based and so are some
      # graphics in GTK (e.g. cross for closing window in window title bar)
      # so it is pretty much required for applications using GTK.
      librsvg

      # TODO: remove this, packages should depend on GTK explicitly.
      gtk3
    ]
    ++ lib.optionals withDconf [
      # It is highly probable that a program will use GSettings,
      # at minimum through GTK file chooser dialogue.
      # Let’s add a GIO module for “dconf” GSettings backend
      # to avoid falling back to “memory” backend. This is
      # required for GSettings-based settings to be persisted.
      # Unfortunately, it also requires the user to have dconf
      # D-Bus service enabled globally (e.g. through a NixOS module).
      dconf.lib
    ];
  meta.license = lib.licenses.mit;
  passthru = {
    tests =
      let
        sample-project = ./tests/sample-project;

        testLib = callPackage ./tests/lib.nix { };
        inherit (testLib) expectSomeLineContainingYInFileXToMentionZ;
      in
      rec {
        # Simple derivation containing a program and a daemon.
        basic = stdenv.mkDerivation {
          name = "basic";

          src = sample-project;

          strictDeps = true;
          nativeBuildInputs = [ wrapGAppsHook3 ];

          installFlags = [
            "bin-foo"
            "libexec-bar"
          ];
        };

        # Simple derivation containing a program and a daemon, but split over multiple outputs.
        basic-multiple-outputs = stdenv.mkDerivation {
          name = "basic-multiple-outputs";

          src = sample-project;

          outputs = [
            "out"
            "lib"
          ];

          strictDeps = true;
          nativeBuildInputs = [ wrapGAppsHook3 ];

          installFlags = [
            "bin-foo"
            "libexec-bar"
          ];

          postInstall = ''
            mkdir -p $lib
            mv $out/libexec $lib
            # Wrapper will want to append this to XDG_DATA_DIRS, but should not cause a cyclic dependency;
            # i.e. only "out" will be wrapped.
            mkdir -p $out/share
          '';
        };

        # Simple derivation containing a program and a daemon, but using a non-default output
        # Executables in "bin" should be handled correctly automatically
        basic-bin-output = stdenv.mkDerivation {
          name = "basic-bin-output";

          src = sample-project;

          outputs = [
            "bin"
            "dev"
            "lib"
            "out"
          ];

          strictDeps = true;
          nativeBuildInputs = [ wrapGAppsHook3 ];

          installFlags = [
            "bin-foo"
            "libexec-bar"
          ];

          postInstall = ''
            mkdir -p $lib
            mv $out/libexec $lib
            mkdir -p $bin
            mv $out/bin $bin
          '';
        };

        # Simple derivation containing a program and a daemon, but using a non-default output
        basic-other-outputs = stdenv.mkDerivation {
          name = "basic-other-outputs";

          src = sample-project;

          outputs = [
            "dev"
            "lib"
            "out"
          ];

          strictDeps = true;
          nativeBuildInputs = [ wrapGAppsHook3 ];

          installFlags = [
            "bin-foo"
            "libexec-bar"
          ];

          wrapGAppsInOutputs = [
            "dev"
            "lib"
          ];

          postInstall = ''
            mkdir -p $lib
            mv $out/libexec $lib
            mkdir -p $dev
            mv $out/bin $dev
          '';
        };

        # Simple derivation containing a program and a daemon, but using non-default outputs
        # that are explicitly referenced via wrapGAppsInOutputs
        basic-other-outputs-structuredattrs = stdenv.mkDerivation {
          name = "basic-other-outputs-structuredAttrs";

          __structuredAttrs = true;

          src = sample-project;

          outputs = [
            "dev"
            "lib"
            "out"
          ];

          strictDeps = true;
          nativeBuildInputs = [ wrapGAppsHook3 ];

          installFlags = [
            "bin-foo"
            "libexec-bar"
          ];

          wrapGAppsInOutputs = [
            "dev"
            "lib"
          ];

          postInstall = ''
            mkdir -p $lib
            mv $out/libexec $lib
            mkdir -p $dev
            mv $out/bin $dev
          '';
        };

        # Simple derivation containing a program and a daemon, but using non-default outputs
        # that are explicitly referenced via wrapGAppsInOutputs, while structuredAttrs are enabled
        # so that it is a proper array.
        basic-contains-dconf =
          let
            tested = basic;
          in
          testLib.runTest "basic-contains-dconf" (
            testLib.skip stdenv.hostPlatform.isDarwin ''
              ${expectSomeLineContainingYInFileXToMentionZ "${tested}/bin/foo" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
              ${expectSomeLineContainingYInFileXToMentionZ "${tested}/libexec/bar" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
            ''
          );

        # The wrapper for executable files should add path to dconf GIO module.
        basic-multiple-outputs-contains-dconf =
          let
            tested = basic-multiple-outputs;
          in
          testLib.runTest "basic-multiple-outputs-contains-dconf" (
            testLib.skip stdenv.hostPlatform.isDarwin ''
              ${expectSomeLineContainingYInFileXToMentionZ "${tested}/bin/foo" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
            ''
          );

        # The wrapper for executable files should add path to dconf GIO module.
        basic-bin-output-contains-dconf =
          let
            tested = basic-bin-output;
          in
          testLib.runTest "basic-bin-output-contains-dconf" (
            testLib.skip stdenv.hostPlatform.isDarwin ''
              ${expectSomeLineContainingYInFileXToMentionZ "${tested}/bin/foo" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
            ''
          );

        # The wrapper for executable files should add path to dconf GIO module.
        basic-other-outputs-contains-dconf =
          let
            tested = basic-other-outputs;
          in
          testLib.runTest "basic-other-outputs-contains-dconf" (
            testLib.skip stdenv.hostPlatform.isDarwin ''
              ${expectSomeLineContainingYInFileXToMentionZ "${tested.dev}/bin/foo" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
              ${expectSomeLineContainingYInFileXToMentionZ "${tested.lib}/libexec/bar" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
            ''
          );

        # The wrapper for executable files should add path to dconf GIO module.
        basic-other-outputs-contains-dconf-structuredattrs =
          let
            tested = basic-other-outputs-structuredattrs;
          in
          testLib.runTest "basic-other-outputs-structuredattrs-contains-dconf" (
            testLib.skip stdenv.hostPlatform.isDarwin ''
              ${expectSomeLineContainingYInFileXToMentionZ "${tested.dev}/bin/foo" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
              ${expectSomeLineContainingYInFileXToMentionZ "${tested.lib}/libexec/bar" "GIO_EXTRA_MODULES"
                "${dconf.lib}/lib/gio/modules"
              }
            ''
          );

        basic-contains-gdk-pixbuf =
          let
            tested = basic;
          in
          testLib.runTest "basic-contains-gdk-pixbuf" (
            testLib.skip stdenv.hostPlatform.isDarwin ''
              ${expectSomeLineContainingYInFileXToMentionZ "${tested}/bin/foo" "GDK_PIXBUF_MODULE_FILE"
                "${lib.getLib librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
              }
              ${expectSomeLineContainingYInFileXToMentionZ "${tested}/libexec/bar" "GDK_PIXBUF_MODULE_FILE"
                "${lib.getLib librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
              }
            ''
          );

        # Simple derivation containing a gobject-introspection typelib.
        typelib-Mahjong = stdenv.mkDerivation {
          name = "typelib-Mahjong";

          src = sample-project;

          strictDeps = true;

          installFlags = [ "typelib-Mahjong" ];
        };

        # Simple derivation using a typelib.
        typelib-user = stdenv.mkDerivation {
          name = "typelib-user";

          src = sample-project;

          strictDeps = true;
          nativeBuildInputs = [
            gobject-introspection
            wrapGAppsHook3
          ];

          buildInputs = [
            typelib-Mahjong
          ];

          installFlags = [
            "bin-foo"
            "libexec-bar"
          ];
        };

        # Testing cooperation with gobject-introspection setup hook,
        # which should populate GI_TYPELIB_PATH variable with paths
        # to typelibs among the derivation’s dependencies.
        # The resulting GI_TYPELIB_PATH should be picked up by the wrapper.
        typelib-user-has-gi-typelib-path =
          let
            tested = typelib-user;
          in
          testLib.runTest "typelib-user-has-gi-typelib-path" ''
            ${expectSomeLineContainingYInFileXToMentionZ "${tested}/bin/foo" "GI_TYPELIB_PATH"
              "${typelib-Mahjong}/lib/girepository-1.0"
            }
            ${expectSomeLineContainingYInFileXToMentionZ "${tested}/libexec/bar" "GI_TYPELIB_PATH"
              "${typelib-Mahjong}/lib/girepository-1.0"
            }
          '';

        # Simple derivation containing a gobject-introspection typelib in lib output.
        typelib-Bechamel = stdenv.mkDerivation {
          name = "typelib-Bechamel";

          outputs = [
            "out"
            "lib"
          ];

          src = sample-project;

          strictDeps = true;

          makeFlags = [
            "LIBDIR=${placeholder "lib"}/lib"
          ];

          installFlags = [ "typelib-Bechamel" ];
        };

        # Simple derivation using a typelib from non-default output.
        typelib-multiout-user = stdenv.mkDerivation {
          name = "typelib-multiout-user";

          src = sample-project;

          strictDeps = true;
          nativeBuildInputs = [
            gobject-introspection
            wrapGAppsHook3
          ];

          buildInputs = [
            typelib-Bechamel
          ];

          installFlags = [
            "bin-foo"
            "libexec-bar"
          ];
        };

        # Testing cooperation with gobject-introspection setup hook,
        # which should populate GI_TYPELIB_PATH variable with paths
        # to typelibs among the derivation’s dependencies,
        # even when they are not in default output.
        # The resulting GI_TYPELIB_PATH should be picked up by the wrapper.
        typelib-multiout-user-has-gi-typelib-path =
          let
            tested = typelib-multiout-user;
          in
          testLib.runTest "typelib-multiout-user-has-gi-typelib-path" ''
            ${expectSomeLineContainingYInFileXToMentionZ "${tested}/bin/foo" "GI_TYPELIB_PATH"
              "${typelib-Bechamel.lib}/lib/girepository-1.0"
            }
            ${expectSomeLineContainingYInFileXToMentionZ "${tested}/libexec/bar" "GI_TYPELIB_PATH"
              "${typelib-Bechamel.lib}/lib/girepository-1.0"
            }
          '';

        # Simple derivation that contains a typelib as well as a program using it.
        typelib-self-user = stdenv.mkDerivation {
          name = "typelib-self-user";

          src = sample-project;

          strictDeps = true;
          nativeBuildInputs = [
            gobject-introspection
            wrapGAppsHook3
          ];

          installFlags = [
            "typelib-Cow"
            "bin-foo"
            "libexec-bar"
          ];
        };

        # Testing cooperation with gobject-introspection setup hook,
        # which should add the path to derivation’s own typelibs
        # to GI_TYPELIB_PATH variable.
        # The resulting GI_TYPELIB_PATH should be picked up by the wrapper.
        # https://github.com/NixOS/nixpkgs/issues/85515
        typelib-self-user-has-gi-typelib-path =
          let
            tested = typelib-self-user;
          in
          testLib.runTest "typelib-self-user-has-gi-typelib-path" ''
            ${expectSomeLineContainingYInFileXToMentionZ "${tested}/bin/foo" "GI_TYPELIB_PATH"
              "${typelib-self-user}/lib/girepository-1.0"
            }
            ${expectSomeLineContainingYInFileXToMentionZ "${tested}/libexec/bar" "GI_TYPELIB_PATH"
              "${typelib-self-user}/lib/girepository-1.0"
            }
          '';
      };
  };
} ./wrap-gapps-hook.sh
