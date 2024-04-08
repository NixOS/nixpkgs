{ lib, stdenv, fetchgit, libX11, perl, ... }:

stdenv.mkDerivation rec {
  pname = "xbattbar";
  version = "1.4.9";

  # The current active upstream of xbattbar seems to be the Debian source
  # repository.
  src = fetchgit {
    url = "https://salsa.debian.org/debian/xbattbar.git";
    rev = "upstream/${version}";
    sha256 = "10w7gs0l4hzhdn38yqyr3az7n4ncmfnd6hhhly6lk5dg7k441ck6";
  };

  buildInputs =  [ libX11 ];

  # The following patches are applied:
  # - sys-by-default: remove the APM checker binary, make the sys checker
  #   script the default. Rationale: checking battery status by /proc/apm is
  #   extremely oldschool and does not work on NixOS, while the sysfs script
  #   does.
  # - perl shebang patches for acpi/sys scripts
  # - unhardcode path to checker scripts
  patchPhase = ''
    patch -p1 < ${./sys-by-default.patch}
    sed -i -e "s,/usr/lib/xbattbar/,$out/libexec/," xbattbar.c
    sed -i -e "s,/usr/bin/perl,${perl}/bin/perl," xbattbar-check-acpi
    sed -i -e "s,/usr/bin/perl,${perl}/bin/perl," xbattbar-check-sys
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec
    install -m 0755 xbattbar $out/bin/
    install -m 0755 xbattbar-check-acpi $out/libexec/
    install -m 0755 xbattbar-check-sys $out/libexec/
  '';

  meta = with lib; {
    description = "Display battery status in X11";
    homepage = "https://salsa.debian.org/debian/xbattbar";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.q3k ];
    mainProgram = "xbattbar";
  };
}
