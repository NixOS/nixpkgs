{
  lib,
  stdenv,
  fetchurl,
  autoconf,
}:

stdenv.mkDerivation rec {
  version = "1.99.21";
  pname = "dd_rescue";

  src = fetchurl {
    hash = "sha256-YB3gyUX/8dsFfIbGUWX5rvRuIa2q9E4LOCtEOz+z/bk=";
    url = "http://www.garloff.de/kurt/linux/ddrescue/dd_rescue-${version}.tar.bz2";
  };

  dd_rhelp_src = fetchurl {
    url = "http://www.kalysto.org/pkg/dd_rhelp-0.3.0.tar.gz";
    sha256 = "0br6fs23ybmic3i5s1w4k4l8c2ph85ax94gfp2lzjpxbvl73cz1g";
  };

  buildInputs = [ autoconf ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "\$(DESTDIR)/usr" "$out" \
      --replace "-o root" "" \
      --replace "-g root" ""
  '';
  makeFlags = [ "LIBDIR=$out" ];

  postInstall = ''
    mkdir -p "$out/share/dd_rescue" "$out/bin"
    tar xf "${dd_rhelp_src}" -C "$out/share/dd_rescue"
    cp "$out/share/dd_rescue"/dd_rhelp*/dd_rhelp "$out/bin"
  '';

  meta = {
    description = "Tool to copy data from a damaged block device";
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.linux;
    homepage = "http://www.garloff.de/kurt/linux/ddrescue/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "dd_rescue";
  };
}
