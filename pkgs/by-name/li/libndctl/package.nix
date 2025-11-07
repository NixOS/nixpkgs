{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  asciidoctor,
  iniparser,
  json_c,
  keyutils,
  kmod,
  udev,
  util-linux,
  libtracefs,
  libtraceevent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libndctl";
  version = "83";

  src = fetchFromGitHub {
    owner = "pmem";
    repo = "ndctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xhTZyRAQNomVyHCPUBwmM0Uuu1sMngTIJm8MF0gnRLk=";
  };

  patches = lib.optionals (!stdenv.hostPlatform.isGnu) [
    # Use POSIX basename on non-glib.
    # Remove when https://github.com/pmem/ndctl/pull/263
    # or equivalent fix is merged and released.
    ./musl-compat.patch
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    asciidoctor
  ];

  buildInputs = [
    iniparser
    json_c
    keyutils
    kmod
    udev
    util-linux
    libtracefs
    libtraceevent
  ];

  mesonFlags = [
    (lib.mesonOption "rootprefix" "${placeholder "out"}")
    (lib.mesonOption "sysconfdir" "${placeholder "out"}/etc/ndctl.conf.d")
    # Use asciidoctor due to xmlto errors
    (lib.mesonEnable "asciidoctor" true)
    (lib.mesonEnable "systemd" false)
    (lib.mesonOption "iniparserdir" "${iniparser}")
  ];

  postPatch = ''
    patchShebangs test

    substituteInPlace git-version --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace git-version-gen --replace-fail /bin/sh ${stdenv.shell}

    echo "m4_define([GIT_VERSION], [${finalAttrs.version}])" > version.m4;
  '';

  meta = {
    description = "Tools for managing the Linux Non-Volatile Memory Device sub-system";
    homepage = "https://github.com/pmem/ndctl";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.linux;
  };
})
