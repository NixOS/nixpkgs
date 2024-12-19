{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  nss,
  efivar,
  util-linux,
  popt,
  nspr,
  mandoc,
}:

stdenv.mkDerivation rec {
  pname = "pesign";
  version = "116";

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "pesign";
    rev = version;
    hash = "sha256-cuOSD/ZHkilgguDFJviIZCG8kceRWw2JgssQuWN02Do=";
  };

  # nss-util is missing because it is already contained in nss
  # Red Hat seems to be shipping a separate nss-util:
  # https://centos.pkgs.org/7/centos-x86_64/nss-util-devel-3.44.0-4.el7_7.x86_64.rpm.html
  # containing things we already have in `nss`.
  # We can ignore all the errors pertaining to a missing
  # nss-util.pc I suppose.
  buildInputs = [
    efivar
    util-linux
    nss
    popt
    nspr
    mandoc
  ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "INSTALLROOT=$(out)" ];

  postInstall = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/share $out/share

    rm -rf $out/usr
    rm -rf $out/etc
    rm -rf $out/run
  '';

  meta = with lib; {
    description = "Signing tools for PE-COFF binaries. Compliant with the PE and Authenticode specifications";
    homepage = "https://github.com/rhboot/pesign";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raitobezarius ];
    # efivar is currently Linux-only.
    platforms = platforms.linux;
  };
}
