{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  installShellFiles,
  pkg-config,
  glib,
  pcre2,
  util-linux,
  libsysprof-capture,
  libmysqlclient,
  libressl,
  zlib,
  zstd,
  libselinux,
  libsepol,
  nix-update-script,
  testers,
  versionCheckHook,
  mydumper,
}:
stdenv.mkDerivation rec {
  pname = "mydumper";
  version = "0.21.1-1";

  src = fetchFromGitHub {
    owner = "mydumper";
    repo = "mydumper";
    tag = "v${version}";
    hash = "sha256-6x0d1Ywgy6kkfDs3KsS6pRK0/3z9Ur7klO8xMTsoDPI=";
    # as of mydumper v0.16.5-1, mydumper extracted its docs into a submodule
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  buildInputs = [
    glib
    pcre2
    util-linux
    libmysqlclient
    libressl
    libsysprof-capture
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libselinux
    libsepol
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DMYSQL_INCLUDE_DIR=${lib.getDev libmysqlclient}/include/mysql"
  ];

  env.NIX_CFLAGS_COMPILE = (
    if stdenv.hostPlatform.isDarwin then
      toString [
        "-Wno-error=format"
        "-Wno-error=sometimes-uninitialized"
      ]
    else
      "-Wno-error=maybe-uninitialized"
  );

  postPatch = ''
    # as of mydumper v0.14.5-1, mydumper tries to install its config to /etc
    substituteInPlace CMakeLists.txt\
      --replace-fail "/etc" "$out/etc" \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
  '';

  # copy man files & docs over
  postInstall = ''
    installManPage $src/docs/man/*
    mkdir -p $doc/share/doc/mydumper
    cp -r $src/docs/html/* $doc/share/doc/mydumper
  '';

  passthru.updateScript = nix-update-script {
    # even patch numbers are pre-releases
    # see https://github.com/mydumper/mydumper/tree/afe0eb9317f1e9cdde45f7b0e463029912c6c981?tab=readme-ov-file#versioning
    extraArgs = [
      "--version-regex"
      "v(\\d+\\.\\d+\\.\\d*[13579]-\\d+)"
    ];
  };

  # mydumper --version is checked in `versionCheckHook`
  passthru.tests = testers.testVersion {
    package = mydumper;
    command = "myloader --version";
    version = "myloader v${version}";
  };

  meta = {
    description = "High-performance MySQL backup tool";
    homepage = "https://github.com/mydumper/mydumper";
    changelog = "https://github.com/mydumper/mydumper/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      izorkin
      michaelglass
    ];
  };
}
