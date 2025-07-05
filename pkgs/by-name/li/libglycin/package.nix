{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  rustPlatform,
  vala,
  gi-docgen,
  libseccomp,
  lcms2,
  gtk4,
  gobject-introspection,
  gnome,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libglycin";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "glycin";
    tag = finalAttrs.version;
    hash = "sha256-M4DcWLE40OPB7zIkv4uLj6xTac3LTDcZ2uAO2S/cUz4=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      rustc
      cargo
      rustPlatform.cargoSetupHook
    ]
    ++ lib.optionals withIntrospection [
      vala
      gi-docgen
    ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iNSpLvIi3oZKSRlkwkDJp5i8MdixRvmWIOCzbFHIdHw=";
  };

  buildInputs = [
    libseccomp
    lcms2
    gtk4
  ] ++ lib.optionals withIntrospection [ gobject-introspection ];

  propagatedBuildInputs = [
    libseccomp
    lcms2
  ];

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "libglycin" true)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
    (lib.mesonBool "capi_docs" withIntrospection)
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libglycin";
      packageName = "glycin";
    };
  };

  meta = {
    description = "Sandboxed and extendable image loading library";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    changelog = "https://gitlab.gnome.org/GNOME/glycin/-/tags/${finalAttrs.version}";
    license = with lib.licenses; [
      mpl20 # or
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "glycin-1"
      "glycin-gtk4-1"
    ];
  };
})
