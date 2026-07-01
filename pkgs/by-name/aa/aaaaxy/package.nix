{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  alsa-lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxxf86vm,
  go-licenses,
  pkg-config,
  zip,
  advancecomp,
  makeWrapper,
  installShellFiles,
  imagemagick,
  libicns,
  nixosTests,
  strip-nondeterminism,
}:

buildGoModule (finalAttrs: {
  pname = "aaaaxy";
  version = "1.7.61";

  src = fetchFromGitHub {
    owner = "divVerent";
    repo = "aaaaxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LsXZVJ2I6aUHhnOEO+iFAEULtTJ2yEXur0dBYIpilr8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-WfaXUYJsl3UTNNRCB6bfM9lEz4A/3vE6qW8UiJod8hg=";

  buildInputs = [
    libGL
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxxf86vm
  ];

  nativeBuildInputs = [
    go-licenses
    pkg-config
    zip
    advancecomp
    makeWrapper
    strip-nondeterminism
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    imagemagick
    libicns
  ];

  outputs = [
    "out"
    "testing_infra"
  ];

  postPatch = ''
    # Without patching, "go run" fails with the error message:
    # package github.com/google/go-licenses: no Go files in /build/source/vendor/github.com/google/go-licenses
    substituteInPlace scripts/build-licenses.sh --replace-fail \
      '$GO run ''${GO_FLAGS} github.com/google/go-licenses' 'go-licenses'

    patchShebangs scripts/
    substituteInPlace scripts/regression-test-demo.sh \
      --replace-fail 'sh scripts/run-timedemo.sh' "$testing_infra/scripts/run-timedemo.sh"

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace Makefile --replace-fail \
        'CPPFLAGS ?= -DNDEBUG' \
        'CPPFLAGS ?= -DNDEBUG -D_GLFW_GLX_LIBRARY=\"${lib.getLib libGL}/lib/libGL.so\" -D_GLFW_EGL_LIBRARY=\"${lib.getLib libGL}/lib/libEGL.so\"'
    ''}
  '';

  overrideModAttrs = (
    _: {
      # We can't patch in the path to libGL directly because
      # this is a fixed output derivation and when the path to libGL
      # changes, the hash would change.
      # To work around this, use environment variables.
      postBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
        substituteInPlace 'vendor/github.com/hajimehoshi/ebiten/v2/internal/graphicsdriver/opengl/gl/procaddr_linbsd.go' \
          --replace-fail \
          'import (' \
          'import ("os"' \
          --replace-fail \
          '{"libGL.so", "libGL.so.2", "libGL.so.1", "libGL.so.0"}' \
          '{os.Getenv("EBITENGINE_LIBGL")}' \
          --replace-fail \
          '{"libGLESv2.so", "libGLESv2.so.2", "libGLESv2.so.1", "libGLESv2.so.0"}' \
          '{os.Getenv("EBITENGINE_LIBGLESv2")}'
      '';
    }
  );

  makeFlags = [
    "BUILDTYPE=${if stdenv.hostPlatform.isDarwin then "ziprelease" else "release"}"
  ];

  checkPhase = ''
    runHook preCheck
    go test ./internal/m/...
    runHook postCheck
  '';

  buildPhase = ''
    runHook preBuild
    AAAAXY_BUILD_USE_VERSION_FILE=true make $makeFlags
    runHook postBuild
  '';

  postInstall = ''
    install -Dm755 'aaaaxy' -t "$out/bin/"
    install -Dm444 'aaaaxy.svg' -t "$out/share/icons/hicolor/scalable/apps/"
    install -Dm644 'aaaaxy.png' -t "$out/share/icons/hicolor/128x128/apps/"
    install -Dm644 'aaaaxy.desktop' -t "$out/share/applications/"
    install -Dm644 'io.github.divverent.aaaaxy.metainfo.xml' -t "$out/share/metainfo/"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/aaaaxy \
      --set EBITENGINE_LIBGL     '${lib.getLib libGL}/lib/libGL.so' \
      --set EBITENGINE_LIBGLESv2 '${lib.getLib libGL}/lib/libGLESv2.so'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications/aaaaxy.app/Contents/MacOS"
    mkdir -p "$out/Applications/aaaaxy.app/Contents/Resources"
    mv "$out/bin/aaaaxy" "$out/Applications/aaaaxy.app/Contents/MacOS/aaaaxy"
    mv aaaaxy.dat "$out/Applications/aaaaxy.app/Contents/Resources/"
    mv aaaaxy.png "$out/Applications/aaaaxy.app/Contents/Resources/"

    mkdir -p aaaaxy.iconset
    for res in 16 32 128 256 512; do
      convert assets/sprites/riser_small_up_0.png \
        -filter Point -geometry ''${res}x''${res} \
        -define png:bit-depth=8 \
        -define png:color-type=6 \
        -define png:format=png32 \
        aaaaxy.iconset/icon_''${res}x''${res}.png
    done
    png2icns "$out/Applications/aaaaxy.app/Contents/Resources/icon.icns" aaaaxy.iconset/*.png

    sh scripts/Info.plist.sh "${finalAttrs.version}" "$out/Applications/aaaaxy.app"
  ''
  + ''
    install -Dm755 'scripts/run-timedemo.sh' -t "$testing_infra/scripts/"
    install -Dm755 'scripts/regression-test-demo.sh' -t "$testing_infra/scripts/"
    install -Dm644 'assets/demos/benchmark.dem' -t "$testing_infra/assets/demos/"
  '';

  passthru.tests = {
    aaaaxy = nixosTests.aaaaxy;
  };

  strictDeps = true;

  meta = {
    description = "Nonlinear 2D puzzle platformer taking place in impossible spaces";
    mainProgram = "aaaaxy";
    homepage = "https://divverent.github.io/aaaaxy/";
    changelog = "https://github.com/divVerent/aaaaxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Luflosi
      philocalyst
    ];
    platforms = lib.platforms.unix;
  };
})
