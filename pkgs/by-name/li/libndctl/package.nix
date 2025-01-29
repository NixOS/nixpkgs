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
}:

stdenv.mkDerivation rec {
  pname = "libndctl";
  version = "79";

  src = fetchFromGitHub {
    owner = "pmem";
    repo = "ndctl";
    rev = "v${version}";
    sha256 = "sha256-gG1Rz5AtDLzikGFr8A3l25ypd+VoLw2oWjszy9ogDLk=";
  };

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
  ];

  mesonFlags = [
    (lib.mesonOption "rootprefix" "${placeholder "out"}")
    (lib.mesonOption "sysconfdir" "${placeholder "out"}/etc/ndctl.conf.d")
    (lib.mesonEnable "libtracefs" false)
    # Use asciidoctor due to xmlto errors
    (lib.mesonEnable "asciidoctor" true)
    (lib.mesonEnable "systemd" false)
    (lib.mesonOption "iniparserdir" "${iniparser}")
  ];

  postPatch = ''
    patchShebangs test

    substituteInPlace git-version --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace git-version-gen --replace-fail /bin/sh ${stdenv.shell}

    echo "m4_define([GIT_VERSION], [${version}])" > version.m4;
  '';

  meta = {
    description = "Tools for managing the Linux Non-Volatile Memory Device sub-system";
    homepage = "https://github.com/pmem/ndctl";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.linux;
  };
}
