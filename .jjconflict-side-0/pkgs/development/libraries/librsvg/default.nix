{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  meson,
  ninja,
  glib,
  gdk-pixbuf,
  installShellFiles,
  pango,
  freetype,
  cairo,
  libxml2,
  bzip2,
  dav1d,
  rustPlatform,
  rustc,
  cargo-c,
  cargo-auditable-cargo-wrapper,
  gi-docgen,
  python3Packages,
  gnome,
  vala,
  shared-mime-info,
  # Requires building a cdylib.
  withPixbufLoader ? !stdenv.hostPlatform.isStatic,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  mesonEmulatorHook,
  _experimental-update-script-combinators,
  common-updater-scripts,
  jq,
  nix,

  # for passthru.tests
  enlightenment,
  ffmpeg,
  gegl,
  gimp,
  imagemagick,
  imlib2,
  vips,
  xfce,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librsvg";
  version = "2.59.2";

  outputs =
    [
      "out"
      "dev"
    ]
    ++ lib.optionals withIntrospection [
      "devdoc"
    ];

  src = fetchurl {
    url = "mirror://gnome/sources/librsvg/${lib.versions.majorMinor finalAttrs.version}/librsvg-${finalAttrs.version}.tar.xz";
    hash = "sha256-7NKT+wzDOMFwFxu8e8++pnJdBByV8xOF3JNUCZM+RZc=";
  };

  patches = [
    (fetchpatch {
      # merged in 2.60.0-beta.0
      name = "cross-introspection.patch";
      url = "https://gitlab.gnome.org/GNOME/librsvg/-/commit/84f24b1f5767f807f8d0442bbf3f149a0defcf78.patch";
      hash = "sha256-FRyAYCCP3eu7YDUS6g7sKCdbq2nU8yQdbdVaQwLrlhE=";
    })
    (fetchpatch {
      # merged in 2.60.0-beta.0; required for cross-gdk-pixbuf-loader.patch to apply
      name = "Replace-CRLF-with-just-LF-in-a-few-remaining-files-that-had-them";
      url = "https://gitlab.gnome.org/GNOME/librsvg/-/commit/8c93369806283feafd060f4507111344e1110f79.patch";
      hash = "sha256-FU6ZiWhXm8jPhGGuNKqlxDIEXu2bSfq1MWyQoADqLZA=";
    })
    (fetchpatch {
      # merged in 2.60.0-beta.0; required for cross-gdk-pixbuf-loader.patch to apply
      name = "do-not-look-for-gdk-pixbuf-query-loaders-in-cross-builds.patch";
      url = "https://gitlab.gnome.org/GNOME/librsvg/-/commit/ce2957acb7b0b5d7f75f47a3c503f5532aa698a6.patch";
      hash = "sha256-f0Mdt4GjycIkM/k68KRsR0Hv2C+gaieQ4WnhjPbA5vs=";
    })
    (fetchpatch {
      name = "cross-gdk-pixbuf-loader.patch";
      url = "https://gitlab.gnome.org/GNOME/librsvg/-/merge_requests/1095.patch";
      hash = "sha256-4R/DfDkNn7WhgBy526v309FzK6znCt2dV/ooz4LYrVU=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "librsvg-deps-${finalAttrs.version}";
    hash = "sha256-M8iNNWpYgLIm0X3sTjAaRIFYLIHnMyrkcsayFrLg25Y=";
    dontConfigure = true;
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs =
    [
      installShellFiles
      pkg-config
      meson
      ninja
      rustc
      cargo-c
      cargo-auditable-cargo-wrapper
      python3Packages.docutils
      rustPlatform.cargoSetupHook
    ]
    ++ lib.optionals withIntrospection [
      gobject-introspection
      gi-docgen
      vala # vala bindings require GObject introspection
    ]
    ++ lib.optionals (withIntrospection && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs =
    [
      libxml2
      bzip2
      dav1d
      pango
      freetype
    ]
    ++ lib.optionals withIntrospection [
      vala # for share/vala/Makefile.vapigen
    ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    cairo
  ];

  mesonFlags = [
    "-Dtriplet=${stdenv.hostPlatform.rust.rustcTarget}"
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "pixbuf-loader" withPixbufLoader)
    (lib.mesonEnable "vala" withIntrospection)
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  # Probably broken MIME type detection on Darwin.
  # Tests fail with imprecise rendering on i686.
  doCheck = !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isi686;

  env = {
    PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_QUERY_LOADERS = buildPackages.writeShellScript "gdk-pixbuf-loader-loaders-wrapped" ''
      ${lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (stdenv.hostPlatform.emulator buildPackages)} ${lib.getDev gdk-pixbuf}/bin/gdk-pixbuf-query-loaders
    '';
  };

  postPatch = ''
    patchShebangs \
      meson/cargo_wrapper.py \
      meson/makedef.py \

    # Fix thumbnailer path
    substituteInPlace gdk-pixbuf-loader/librsvg.thumbnailer.in \
      --replace-fail '@bindir@/gdk-pixbuf-thumbnailer' '${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer'

    # Fix pkg-config file Requires section.
    # https://gitlab.gnome.org/GNOME/librsvg/-/issues/1150
    substituteInPlace rsvg/meson.build \
      --replace-fail 'requires: library_dependencies_sole,' 'requires: [cairo_dep, gio_dep, glib_dep, pixbuf_dep],'
  '';

  preCheck = ''
    # Tests complain: Fontconfig error: No writable cache directories
    export HOME=$TMPDIR

    # https://gitlab.gnome.org/GNOME/librsvg/-/issues/258#note_251789
    export XDG_DATA_DIRS=${shared-mime-info}/share:$XDG_DATA_DIRS
  '';

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    lib.optionalString withPixbufLoader ''
      # Merge gdkpixbuf and librsvg loaders
      GDK_PIXBUF=$out/${gdk-pixbuf.binaryDir}
      cat ${lib.getLib gdk-pixbuf}/${gdk-pixbuf.binaryDir}/loaders.cache $GDK_PIXBUF/loaders.cache > $GDK_PIXBUF/loaders.cache.tmp
      mv $GDK_PIXBUF/loaders.cache.tmp $GDK_PIXBUF/loaders.cache
    ''
    + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd rsvg-convert \
        --bash <(${emulator} $out/bin/rsvg-convert --completion bash) \
        --fish <(${emulator} $out/bin/rsvg-convert --completion fish) \
        --zsh <(${emulator} $out/bin/rsvg-convert --completion zsh)
    '';

  postFixup = lib.optionalString withIntrospection ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "librsvg";
        };

        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                  jq
                  nix
                ]
              }
              update-source-version librsvg --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
    tests = {
      inherit
        gegl
        gimp
        imagemagick
        imlib2
        vips
        ;
      inherit (enlightenment) efl;
      inherit (xfce) xfwm4;
      ffmpeg = ffmpeg.override { withSvg = true; };
    };
  };

  meta = with lib; {
    description = "Small library to render SVG images to Cairo surfaces";
    homepage = "https://gitlab.gnome.org/GNOME/librsvg";
    license = licenses.lgpl2Plus;
    teams = [ teams.gnome ];
    mainProgram = "rsvg-convert";
    platforms = platforms.unix;
  };
})
