{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  openssh,
  gnutar,
}:

stdenv.mkDerivation rec {
  pname = "rset";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "eradman";
    repo = "rset";
    tag = version;
    hash = "sha256-b797R79aMopiPApTJ4Q3SP2MRjqCcNNO9BIxtuiNZks=";
  };

  patches = [ ./paths.patch ];

  postPatch = ''
    substituteInPlace rset.c \
      --replace-fail @ssh@       ${openssh}/bin/ssh \
      --replace-fail @miniquark@ $out/bin/miniquark \
      --replace-fail @rinstall@  $out/bin/rinstall \
      --replace-fail @rsub@      $out/bin/rsub

    substituteInPlace execute.c \
      --replace-fail @ssh@     ${openssh}/bin/ssh \
      --replace-fail @ssh-add@ ${openssh}/bin/ssh-add \
      --replace-fail @tar@     ${gnutar}/bin/tar

    substituteInPlace rutils.c \
      --replace-fail @install@ ${coreutils}/bin/install
  '';

  # these are to be run on the remote host,
  # so we want to preserve the original shebang.
  postFixup = ''
    sed -i "1s@.*@#!/bin/sh@" $out/bin/rinstall
    sed -i "1s@.*@#!/bin/sh@" $out/bin/rsub
  '';

  dontAddPrefix = true;
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://scriptedconfiguration.org/";
    description = "Configure systems using any scripting language";
    changelog = "https://github.com/eradman/rset/raw/${version}/NEWS";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
