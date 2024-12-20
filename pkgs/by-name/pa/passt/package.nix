{ lib
, stdenv
, buildPackages
, fetchurl
, getconf
, gitUpdater
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passt";
  version = "2024_11_27.c0fbc7e";

  src = fetchurl {
    url = "https://passt.top/passt/snapshot/passt-${finalAttrs.version}.tar.gz";
    hash = "sha256-S1UlQio4EtyzkJJ8e30+wwo6VFYfcscc6g/S1Qfgp18=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail \
      'PAGE_SIZE=$(shell getconf PAGE_SIZE)' \
      "PAGE_SIZE=$(${stdenv.hostPlatform.emulator buildPackages} ${lib.getExe getconf} PAGE_SIZE)"
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };

    updateScript = gitUpdater {
      url = "https://passt.top/passt";
    };
  };

  meta = with lib; {
    homepage = "https://passt.top/passt/about/";
    description = "Plug A Simple Socket Transport";
    longDescription = ''
      passt implements a translation layer between a Layer-2 network interface
      and native Layer-4 sockets (TCP, UDP, ICMP/ICMPv6 echo) on a host.
      It doesn't require any capabilities or privileges, and it can be used as
      a simple replacement for Slirp.

      pasta (same binary as passt, different command) offers equivalent
      functionality, for network namespaces: traffic is forwarded using a tap
      interface inside the namespace, without the need to create further
      interfaces on the host, hence not requiring any capabilities or
      privileges.
    '';
    license = [ licenses.bsd3 /* and */ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ _8aed ];
    mainProgram = "passt";
  };
})
