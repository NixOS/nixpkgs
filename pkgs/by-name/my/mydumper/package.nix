{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sphinx,
  python3Packages,
  glib,
  pcre,
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
  version = "0.17.1-1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = "v${version}";
    hash = "sha256-PidivIe9zzLeRpn9ECfF6qVmkP/Xd+6kIYQXo64V9fM=";
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
    # for docs
    sphinx
    python3Packages.furo
    python3Packages.sphinx-copybutton
    python3Packages.sphinx-inline-tabs
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  buildInputs =
    [
      glib
      pcre
      pcre2
      util-linux
      libmysqlclient
      libressl
      libsysprof-capture
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.isLinux [
      libselinux
      libsepol
    ];

  cmakeFlags = [
    "-DBUILD_DOCS=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DMYSQL_INCLUDE_DIR=${lib.getDev libmysqlclient}/include/mysql"
  ];

  env.NIX_CFLAGS_COMPILE = (
    if stdenv.isDarwin then
      toString [
        "-Wno-error=deprecated-non-prototype"
        "-Wno-error=format"
      ]
    else
      "-Wno-error=maybe-uninitialized"
  );

  postPatch = ''
    # as of mydumper v0.14.5-1, mydumper tries to install its config to /etc
    substituteInPlace CMakeLists.txt\
      --replace-fail "/etc" "$out/etc"

    # as of mydumper v0.16.5-1, mydumper disables building docs by default
    substituteInPlace CMakeLists.txt\
        --replace-fail "#  add_subdirectory(docs)" "add_subdirectory(docs)"
  '';

  preBuild = ''
    cp -r $src/docs/images ./docs
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

  meta = with lib; {
    description = "High-performance MySQL backup tool";
    homepage = "https://github.com/mydumper/mydumper";
    changelog = "https://github.com/mydumper/mydumper/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [
      izorkin
      michaelglass
    ];
  };
}
