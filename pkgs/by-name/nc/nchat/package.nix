{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  replaceVars,
  rustPlatform,
  file, # for libmagic
  ncurses,
  openssl,
  readline,
  sqlite,
  zlib,
  cmake,
  clang,
  protobuf,
  perl,
  pkg-config,
  git,
  gperf,
  nix-update-script,
  withWhatsApp ? true,
  withSignal ? false,
}:

let
  version = "5.16.9";

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = "nchat";
    tag = "v${version}";
    hash = "sha256-Hl8LzROGn9oAV9G4hnnvDAltPte+2krEEGPNTmMzUoU=";
  };

  libcgowm = buildGoModule {
    pname = "nchat-wmchat-libcgowm";
    inherit version src;

    sourceRoot = "${src.name}/lib/wmchat/go";
    vendorHash = "sha256-t7WG9xce1UC5FB6LFIT7Oacc2rO/BqZ/p5JP0AtPDoo=";

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/
      go build -o $out/ -buildmode=c-archive
      mv $out/go.a $out/libcgowm.a
      ln -s $out/libcgowm.a $out/libref-cgowm.a
      mv $out/go.h $out/libcgowm.h

      runHook postBuild
    '';
  };

  # Go cgo archive for the Signal backend (wraps mautrix-signal).
  # Pattern mirrors libcgowm above.
  libcgosg = buildGoModule {
    pname = "nchat-sgchat-libcgosg";
    inherit version src;

    sourceRoot = "${src.name}/lib/sgchat/go";
    vendorHash = "sha256-gj270rUfqNa3RzOmJrrxuaig2o0rUykFiqopALtyKKY=";

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/
      go build -o $out/ -buildmode=c-archive
      mv $out/go.a $out/libcgosg.a
      ln -s $out/libcgosg.a $out/libref-cgosg.a
      mv $out/go.h $out/libcgosg.h

      runHook postBuild
    '';
  };

  # libsignal_ffi static archive. Version pinned by nchat at
  # lib/sgchat/go/ext/signal/pkg/libsignalgo/version.go. Upstream nchat's
  # build-libsignal.sh downloads or builds this; we build from source so
  # nothing is fetched at build time.
  libsignalFfi = rustPlatform.buildRustPackage {
    pname = "libsignal-ffi";
    version = "0.87.5";

    src = fetchFromGitHub {
      owner = "signalapp";
      repo = "libsignal";
      tag = "v0.87.5";
      hash = "sha256-xffBXvq1ikesIjw6cXfphnTIiyuMiUcY8h0pzSgfD8U=";
    };

    cargoHash = "sha256-MwAtUrLoSi/pjsBWOAd9JoepAueq17hkZCH21q72O3w=";

    cargoBuildFlags = [
      "--package"
      "libsignal-ffi"
    ];

    nativeBuildInputs = [
      cmake
      clang
      protobuf
      perl
      pkg-config
      git # boring-sys' build script runs `git init` on its vendored boringssl
      rustPlatform.bindgenHook # sets LIBCLANG_PATH so bindgen can find libclang.so
    ];

    env = {
      RUSTFLAGS = "-Ctarget-feature=-crt-static";
      PROTOC = "${protobuf}/bin/protoc";
    };

    # boring-sys' build script does `git init && git apply` on its vendored
    # boringssl source. The build sandbox has no global git identity, so any
    # downstream `git commit` would abort. Silence it with explicit env vars.
    preBuild = ''
      export GIT_AUTHOR_NAME=nix
      export GIT_AUTHOR_EMAIL=nix@localhost
      export GIT_COMMITTER_NAME=nix
      export GIT_COMMITTER_EMAIL=nix@localhost
    '';

    doCheck = false;

    # We only need the static library, not the cdylib or test binaries.
    dontCargoInstall = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      cp target/*/release/libsignal_ffi.a $out/lib/
      runHook postInstall
    '';

    meta = {
      description = "FFI static library from signalapp/libsignal, built for nchat";
      homepage = "https://github.com/signalapp/libsignal";
      license = lib.licenses.agpl3Only;
      platforms = lib.platforms.unix;
    };
  };
in
stdenv.mkDerivation {
  pname = "nchat";
  inherit version src;

  patches =
    [
      (replaceVars ./go-libs-build.patch {
        inherit libcgowm;
      })
      # Don't use brew
      ./fix-darwin.patch
    ]
    ++ lib.optional withSignal (
      replaceVars ./go-libs-build-signal.patch {
        inherit libcgosg libsignalFfi;
      }
    );

  nativeBuildInputs = [
    cmake
    gperf
    libcgowm
  ] ++ lib.optional withSignal libcgosg;

  buildInputs = [
    file # for libmagic
    ncurses
    openssl
    readline
    sqlite
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "HAS_WHATSAPP" withWhatsApp)
    (lib.cmakeBool "HAS_SIGNAL" withSignal)
  ];

  passthru =
    {
      inherit libcgowm;
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "libcgowm"
        ];
      };
    }
    // lib.optionalAttrs withSignal {
      inherit libcgosg libsignalFfi;
    };

  meta = {
    description =
      "Terminal-based chat client with support for Telegram"
      + lib.optionalString withWhatsApp ", WhatsApp"
      + lib.optionalString withSignal " and Signal";
    changelog = "https://github.com/d99kris/nchat/releases/tag/v${version}";
    homepage = "https://github.com/d99kris/nchat";
    # nchat itself is MIT. Linking libsignal_ffi (AGPLv3) into the build
    # makes the combined distribution AGPLv3.
    license =
      if withSignal then
        with lib.licenses;
        [
          mit
          agpl3Only
        ]
      else
        lib.licenses.mit;
    mainProgram = "nchat";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      sikmir
    ];
    platforms = lib.platforms.unix;
  };
}
