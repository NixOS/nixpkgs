{
  lib,
  fetchFromGitHub,
  buildGoModule,
  alsa-lib,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXxf86vm,
  go-licenses,
  pkg-config,
  zip,
  advancecomp,
  makeWrapper,
  nixosTests,
}:

buildGoModule rec {
  pname = "aaaaxy";
  version = "1.5.208";

  src = fetchFromGitHub {
    owner = "divVerent";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VfF8bQP7pFaTezOJpda4N9KbCHr5ST/wCvdNRiojio0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-PBwI3S8ZvmVD57/ICALe+HvgtbPQpJKNPfkWo+uUeSo=";

  buildInputs = [
    alsa-lib
    libGL
    libX11
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXxf86vm
  ];

  nativeBuildInputs = [
    go-licenses
    pkg-config
    zip
    advancecomp
    makeWrapper
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

    substituteInPlace Makefile --replace-fail \
      'CPPFLAGS ?= -DNDEBUG' \
      'CPPFLAGS ?= -DNDEBUG -D_GLFW_GLX_LIBRARY=\"${lib.getLib libGL}/lib/libGL.so\" -D_GLFW_EGL_LIBRARY=\"${lib.getLib libGL}/lib/libEGL.so\"'
  '';

  overrideModAttrs = (
    _: {
      # We can't patch in the path to libGL directly because
      # this is a fixed output derivation and when the path to libGL
      # changes, the hash would change.
      # To work around this, use environment variables.
      postBuild = ''
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
    "BUILDTYPE=release"
  ];

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

    wrapProgram $out/bin/aaaaxy \
      --set EBITENGINE_LIBGL     '${lib.getLib libGL}/lib/libGL.so' \
      --set EBITENGINE_LIBGLESv2 '${lib.getLib libGL}/lib/libGLESv2.so'

    install -Dm755 'scripts/run-timedemo.sh' -t "$testing_infra/scripts/"
    install -Dm755 'scripts/regression-test-demo.sh' -t "$testing_infra/scripts/"
    install -Dm644 'assets/demos/benchmark.dem' -t "$testing_infra/assets/demos/"
  '';

  passthru.tests = {
    aaaaxy = nixosTests.aaaaxy;
  };

  strictDeps = true;

  meta = with lib; {
    description = "Nonlinear 2D puzzle platformer taking place in impossible spaces";
    mainProgram = "aaaaxy";
    homepage = "https://divverent.github.io/aaaaxy/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Luflosi ];
    platforms = platforms.linux;
  };
}
