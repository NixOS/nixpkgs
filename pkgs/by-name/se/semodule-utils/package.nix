{
  lib,
  stdenv,
  fetchurl,
  libsepol,
}:

stdenv.mkDerivation rec {
  pname = "semodule-utils";
  version = "3.7";

  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-2wZBrq/v7EZhLHwt3TPvEGC7chzmSELSqWwz3dtesXY=";
  };

  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = with lib; {
    description = "SELinux policy core utilities (packaging additions)";
    license = licenses.gpl2Only;
    inherit (libsepol.meta) homepage platforms;
    maintainers = with maintainers; [ RossComputerGuy ];
  };
}
