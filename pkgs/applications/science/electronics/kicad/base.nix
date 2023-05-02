{ lib
, stdenv
, cmake
, libGLU
, libGL
, zlib
, wxGTK
, gtk3
, libX11
, gettext
, glew
, glm
, cairo
, curl
, openssl
, boost
, pkg-config
, doxygen
, graphviz
, pcre
, libpthreadstubs
, libXdmcp
, unixODBC

, util-linux
, libselinux
, libsepol
, libthai
, libdatrie
, libxkbcommon
, libepoxy
, dbus
, at-spi2-core
, libXtst
, pcre2
, libdeflate

, swig4
, python
, wxPython
, opencascade-occt
, libngspice
, valgrind

, stable
, baseName
, kicadSrc
, kicadVersion
, withNgspice
, withScripting
, withI18n
, debug
, sanitizeAddress
, sanitizeThreads
}:

assert lib.assertMsg (!(sanitizeAddress && sanitizeThreads))
  "'sanitizeAddress' and 'sanitizeThreads' are mutually exclusive, use one.";

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  pname = "kicad-base";
  version = if (stable) then kicadVersion else builtins.substring 0 10 src.rev;

  src = kicadSrc;

  patches = [
    # upstream issue 12941 (attempted to upstream, but appreciably unacceptable)
    ./writable.patch
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # See the comment below.
    #
    # This is mostly not necessary (we handle the fixups that are actually
    # required in the `postFixup` hook below).
    ./macos-disable-bundle-fixup.patch

    # An `ld-wrapper` hook takes care of codesigning for us.
    ./macos-disable-codesigning.patch

    # Because we're not copying/symlinking a python interpreter binary + libs
    # into `KiCad.app/Contents/Frameworks/Python.framework/...` we want to avoid
    # setting `$PYTHONHOME` to that location.
    ./macos-dont-set-python-home.patch
  ];

  # tagged releases don't have "unknown"
  # kicad nightlies use git describe --dirty
  # nix removes .git, so its approximated here
  postPatch = lib.optionalString (!stable) ''
    substituteInPlace cmake/KiCadVersion.cmake \
      --replace "unknown" "${builtins.substring 0 10 src.rev}"
  '';

  # Normally `fixup_bundle` would take care of this however we patch out the
  # calls to `fixup_bundle` because CMake seems to runs `otool -l` on every
  # dylib dep prior to consulting `IGNORE_ITEMS` (unclear).
  #
  # This is problematic for us because deps like `/usr/lib/libSystem.B.dylib`
  # don't actually exist on the file system and are instead provided by the dyld
  # cache. Calls to `dlopen`, etc with such paths are rerouted by `otool` does
  # not seem to be aware of this.
  #
  # So, we handle patching the dylib paths ourselves. Currently only the plugins
  # end up having paths relative to the build dir. (though we should probably do
  # something more robust here or scan the rpaths of all the binaries...)

  # `cmake` rewrites the realpath of `/tmp` (i.e. `/private/tmp` on macOS
  # builders) to `/tmp` which means we can't just use `pwd` or `NIX_BUILD_TOP`
  # here:
  #  - https://github.com/Kitware/CMake/blob/3f3c3d3e71f5aa4840932a96cd9ab90cf22cc9d3/Source/kwsys/SystemTools.cxx#L4926-L4927C7
  #
  # So, we ask `otool` for the current path of this dylib.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for lib in $out/KiCad.app/Contents/Plugins/**/*.so $out/KiCad.app/Contents/Plugins/*.kiface; do
      buildLibkicad3dsgPath="$(${stdenv.cc.targetPrefix}otool -L $lib \
        | grep build/kicad/KiCad.app/Contents/Frameworks/libkicad_3dsg \
        | cut -d'(' -f1 \
        | xargs
      )" || :

      if [[ -n "''${buildLibkicad3dsgPath:+x}" ]]; then
        ${stdenv.cc.targetPrefix}install_name_tool \
          -change "''${buildLibkicad3dsgPath}" \
          $out/KiCad.app/Contents/Frameworks/libkicad_3dsg.dylib \
          $lib
      fi
    done
  '';

  makeFlags = optionals (debug) [ "CFLAGS+=-Og" "CFLAGS+=-ggdb" ];

  # some ngspice tests attempt to write to $HOME/.cache/
  XDG_CACHE_HOME = "$TMP";
  # failing tests still attempt to create $HOME though

  cmakeFlags = [
    "-DKICAD_USE_EGL=ON"
    "-DOCC_INCLUDE_DIR=${opencascade-occt}/include/opencascade"
  ]
  ++ optionals (stable) [
    # https://gitlab.com/kicad/code/kicad/-/issues/12491
    # should be resolved in the next release
    "-DCMAKE_CTEST_ARGUMENTS='--exclude-regex;qa_eeschema'"
  ]
  ++ optional (stable && !withNgspice) "-DKICAD_SPICE=OFF"
  ++ optionals (!withScripting) [
    "-DKICAD_SCRIPTING_WXPYTHON=OFF"
  ]
  ++ optionals (withI18n) [
    "-DKICAD_BUILD_I18N=ON"
  ]
  ++ optionals (!doInstallCheck) [
    "-DKICAD_BUILD_QA_TESTS=OFF"
  ]
  ++ optionals (debug) [
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DKICAD_STDLIB_DEBUG=ON"
    "-DKICAD_USE_VALGRIND=ON"
  ]
  ++ optionals (sanitizeAddress) [
    "-DKICAD_SANITIZE_ADDRESS=ON"
  ]
  ++ optionals (sanitizeThreads) [
    "-DKICAD_SANITIZE_THREADS=ON"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ]
  # wanted by configuration on linux, doesn't seem to affect performance
  # no effect on closure size
  ++ optionals (stdenv.isLinux) [
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    libXtst
    pcre2
  ];

  buildInputs = [
    libGLU
    libGL
    zlib
    libX11
    wxGTK
    gtk3
    pcre
    libXdmcp
    gettext
    glew
    glm
    libpthreadstubs
    cairo
    curl
    openssl
    boost
    swig4
    python
    unixODBC
    libdeflate
    opencascade-occt
  ]
  ++ optional (withScripting) wxPython
  ++ optional (withNgspice) libngspice
  ++ optional (debug) valgrind;

  # debug builds fail all but the python test
  doInstallCheck = !(debug);
  installCheckTarget = "test";

  dontStrip = debug;

  meta = {
    description = "Just the built source without the libraries";
    longDescription = ''
      Just the build products, the libraries are passed via an env var in the wrapper, default.nix
    '';
    homepage = "https://www.kicad.org/";
    license = lib.licenses.agpl3;
    platforms = lib.platforms.all;
  };
}
