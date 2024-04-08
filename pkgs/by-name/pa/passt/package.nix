{ stdenv, lib, fetchgit }:

stdenv.mkDerivation {
  pname = "passt";
  version = "0.2023_11_10.5ec3634";
  src = fetchgit {
    url = "git://passt.top/passt";
    rev = "5ec3634b07215337c2e69d88f9b1d74711897d7d";
    hash = "sha256-76CD9PYD/NcBkmRYFSZaYl381QJjuWo0VsNdh31d6/M=";
  };
  nativeBuildInputs = [ ];
  buildInputs = [];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/man/man1
    cp passt pasta qrap $out/bin/
    cp passt.1 pasta.1 qrap.1 $out/share/man/man1/
  '' + (lib.optionalString stdenv.hostPlatform.avx2Support ''
    cp passt.avx2 pasta.avx2 $out/bin/
    runHook postInstall
  '');
  meta = with lib; {
    homepage = "https://passt.top/passt/about/";
    description = "Translation layer between a Layer-2 network interface and native Layer-4 sockets";
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
    license = lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _8aed ];
  };
}
