{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  buildGoModule,
  installShellFiles,
  buildPackages,
  zlib,
  zstd,
  sqlite,
  cmake,
  python3,
  ninja,
  perl,
  pkg-config,
  autoconf,
  automake,
  libtool,
  cctools,
  cacert,
  unzip,
  go,
  p11-kit,
}:
stdenv.mkDerivation rec {
  pname = "curl-impersonate-chrome";
  version = "1.2.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "lexiforest";
    repo = "curl-impersonate";
    tag = "v${version}";
    hash = "sha256-tAQdTRGAOD2rpLZvoLQ2YL0wrohXEcmChMZBvYjsMhE=";
  };

  # Disable blanket -Werror to fix build on `gcc-13` related to minor
  # warnings on `boringssl`.
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  strictDeps = true;

  depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # Must come first so that it shadows the 'libtool' command but leaves 'libtoolize'
      cctools
    ]
    ++ [
      installShellFiles
      cmake
      python3
      python3.pythonOnBuildForHost.pkgs.gyp
      ninja
      perl
      pkg-config
      autoconf
      automake
      libtool
      unzip
      go
    ];

  buildInputs = [
    zlib
    zstd
    sqlite
  ];

  configureFlags = [
    "--with-ca-bundle=${
      if stdenv.hostPlatform.isDarwin then "/etc/ssl/cert.pem" else "/etc/ssl/certs/ca-certificates.crt"
    }"
    "--with-ca-path=${cacert}/etc/ssl/certs"
  ];

  buildFlags = [ "build" ];
  checkTarget = "checkbuild";
  installTargets = [ "install" ];

  doCheck = true;

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  postUnpack =
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: dep: "ln -sT ${dep.outPath} ${src.name}/${name}") (
        lib.filterAttrs (n: v: v ? outPath) passthru.deps
      )
    )
    + ''

      curltar=$(realpath -s ${src.name}/curl-*.tar.gz)

      pushd "$(mktemp -d)"

      tar -xf "$curltar"

      pushd curl-curl-*/
      patchShebangs scripts
      popd

      rm "$curltar"
      tar -czf "$curltar" .

      popd
    '';

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail "-lc++" "-lstdc++"
  '';

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=file://${passthru.boringssl-go-modules}
    export GOSUMDB=off

    # Need to get value of $out for this flag
    configureFlagsArray+=("--with-libnssckbi=$out/lib")
  '';

  postInstall = ''
    # Remove vestigial *-config script
    rm $out/bin/curl-impersonate-config

    # Patch all shebangs of installed scripts
    patchShebangs $out/bin

    # Install headers
    make -C curl-*/include install
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Patch completion names
    substituteInPlace curl-*/scripts/Makefile \
      --replace-fail "_curl" "_curl-impersonate" \
      --replace-fail "curl.fish" "curl-impersonate.fish"

    # Install completions
    make -C curl-*/scripts install
  '';

  preFixup =
    let
      libext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      # If libnssckbi.so is needed, link libnssckbi.so without needing nss in closure
      if grep -F nssckbi $out/lib/libcurl-impersonate${libext} &>/dev/null; then
        ln -s ${p11-kit}/lib/pkcs11/p11-kit-trust${libext} $out/lib/libnssckbi${libext}
        ${lib.optionalString stdenv.hostPlatform.isElf ''
          patchelf --add-needed libnssckbi${libext} $out/lib/libcurl-impersonate${libext}
        ''}
      fi
    '';

  disallowedReferences = [ go ];

  passthru = {
    deps = callPackage ./deps.nix { };

    updateScript = ./update.sh;

    # Find the correct boringssl source file
    boringssl-source = builtins.head (
      lib.mapAttrsToList (_: file: file) (
        lib.filterAttrs (name: _: lib.strings.hasPrefix "boringssl-" name) passthru.deps
      )
    );
    boringssl-go-modules =
      (buildGoModule {
        inherit (passthru.boringssl-source) name;

        src = passthru.boringssl-source;
        vendorHash = "sha256-HepiJhj7OsV7iQHlM2yi5BITyAM04QqWRX28Rj7sRKk=";

        nativeBuildInputs = [ unzip ];

        proxyVendor = true;
      }).goModules;
  };

  meta = {
    changelog = "https://github.com/lexiforest/curl-impersonate/releases/tag/${src.tag}";
    description = "Special build of curl that can impersonate Chrome & Firefox";
    homepage = "https://github.com/lexiforest/curl-impersonate";
    license = with lib.licenses; [
      curl
      mit
    ];
    maintainers = with lib.maintainers; [ ggg ];
    platforms = lib.platforms.unix;
    mainProgram = "curl-impersonate";
  };
}
