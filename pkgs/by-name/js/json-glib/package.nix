{
  lib,
  stdenv,
  fetchurl,
  docutils,
  glib,
  meson,
  mesonEmulatorHook,
  ninja,
  nixosTests,
  pkg-config,
  gettext,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  gi-docgen,
  libxslt,
  fixDarwinDylibNames,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "json-glib";
  version = "1.10.8";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ]
  ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-VcXBQaVkJFuPj752mGY8h6RaczPCosVvBvgRq3OyEt0=";
  };

  patches = [
    # Add option for changing installation path of installed tests.
    ./meson-add-installed-tests-prefix-option.patch
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    docutils # for rst2man, rst2html5
    meson
    ninja
    pkg-config
    gettext
    glib
    libxslt
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    gi-docgen
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "documentation" withIntrospection)
  ];

  doCheck = true;

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    if [[ -d "$out/share/doc" ]]; then
        find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
          | while IFS= read -r -d ''' file; do
            moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
        done
    fi
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.json-glib;
    };

    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    homepage = "https://gitlab.gnome.org/GNOME/json-glib";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = with platforms; unix;
  };
}
