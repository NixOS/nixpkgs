{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "incron";
  version = "0.5.12";
  src = fetchFromGitHub {
    owner = "ar-";
    repo = "incron";
    rev = "${pname}-${version}";
    hash = "sha256-MDbjaxct31ZPncTch17bTmgDtOD5/59g2tEpyVBypYU=";
  };

  patches = [ ./default_path.patch ];

  prePatch = ''
    sed -i "s|/bin/bash|${bash}/bin/bash|g" usertable.cpp
  '';

  installFlags = [ "PREFIX=$(out)" ];
  installTargets = [ "install-man" ];

  preInstall = ''
    mkdir -p $out/bin

    # make install doesn't work because setuid and permissions
    # just manually install the binaries instead
    cp incrond incrontab $out/bin/
  '';

  passthru.tests = { inherit (nixosTests) incron; };

  meta = {
    description = "Cron-like daemon which handles filesystem events";
    homepage = "https://github.com/ar-/incron";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.aanderse ];
    platforms = lib.platforms.linux;
  };
}
