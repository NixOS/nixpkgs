{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  cmake,
  ninja,
  libarchive,
  libz,
  jdk17,
  libcef,
  luajit,
  xorg,
  mesa,
  glib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  libdrm,
  expat,
  libxkbcommon,
  gtk3,
  pango,
  cairo,
  alsa-lib,
  dbus,
  at-spi2-core,
  cups,
  systemd,
  buildFHSEnv,
}:
let
  cef = libcef.overrideAttrs (oldAttrs: {
    installPhase =
      let
        gl_rpath = lib.makeLibraryPath [
          stdenv.cc.cc.lib
        ];
        rpath = lib.makeLibraryPath [
          glib
          nss
          nspr
          atk
          at-spi2-atk
          libdrm
          expat
          xorg.libxcb
          libxkbcommon
          xorg.libX11
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          mesa
          gtk3
          pango
          cairo
          alsa-lib
          dbus
          at-spi2-core
          cups
          xorg.libxshmfence
          systemd
        ];
      in
      ''
        mkdir -p $out/lib/ $out/share/cef/
        cp libcef_dll_wrapper/libcef_dll_wrapper.a $out/lib/
        cp -r ../Resources/* $out/lib/
        cp -r ../Release/* $out/lib/
        patchelf --set-rpath "${rpath}" $out/lib/libcef.so
        patchelf --set-rpath "${gl_rpath}" $out/lib/libEGL.so
        patchelf --set-rpath "${gl_rpath}" $out/lib/libGLESv2.so
        cp ../Release/*.bin $out/share/cef/
        cp -r ../Resources/* $out/share/cef/
        cp -r ../include $out
        cp -r ../libcef_dll $out
        cp -r ../cmake $out
      '';
  });
in
let
  bolt = stdenv.mkDerivation (finalAttrs: {
    pname = "bolt-launcher";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "AdamCake";
      repo = "bolt";
      rev = finalAttrs.version;
      fetchSubmodules = true;
      hash = "sha256-LIlRDcUWbQwIhFjtqYF+oVpTOPZ7IT0vMgysEVyJ1k8=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      luajit
      makeWrapper
    ];

    buildInputs = [
      mesa
      xorg.libX11
      xorg.libxcb
      libarchive
      libz
      cef
      jdk17
    ];

    cmakeFlags = [
      "-D CMAKE_BUILD_TYPE=Release"
      "-D BOLT_LUAJIT_INCLUDE_DIR=${luajit}/include"
      "-G Ninja"
    ];

    preConfigure = ''
      mkdir -p cef/dist/Release cef/dist/Resources cef/dist/include

      ln -s ${cef}/lib/* cef/dist/Release

      ln -s ${cef}/share/cef/*.pak cef/dist/Resources
      ln -s ${cef}/share/cef/icudtl.dat cef/dist/Resources
      ln -s ${cef}/share/cef/locales cef/dist/Resources

      ln -s ${cef}/include/* cef/dist/include
      ln -s ${cef}/libcef_dll cef/dist/libcef_dll

      ln -s ${cef}/cmake cef/dist/cmake
      ln -s ${cef}/CMakeLists.txt cef/dist
    '';

    postFixup = ''
      makeWrapper "$out/opt/bolt-launcher/bolt" "$out/bin/${finalAttrs.pname}-${finalAttrs.version}" \
      --set JAVA_HOME "${jdk17}"
      ls -al $out/bin
      mkdir -p $out/lib
      cp $out/usr/local/lib/libbolt-plugin.so $out/lib
    '';
  });
in
buildFHSEnv {
  inherit (bolt) name version;

  targetPkgs =
    pkgs:
    [ bolt ]
    ++ (with pkgs; [
      xorg.libSM
      xorg.libXxf86vm
      xorg.libX11
      glib
      pango
      cairo
      gdk-pixbuf
      gtk2-x11
      libz
      libcap
      libsecret
      openssl_1_1
      SDL2
      libGL
    ]);

  runScript = "${bolt.name}";
  meta = {
    homepage = "https://github.com/Adamcake/Bolt";
    description = "An alternative launcher for RuneScape";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ nezia ];
    platforms = lib.platforms.linux;
    mainProgram = "${bolt.name}";
  };
}
