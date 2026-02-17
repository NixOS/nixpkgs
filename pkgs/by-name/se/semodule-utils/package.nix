{
  lib,
  stdenv,
  fetchurl,
  libsepol,
}:

stdenv.mkDerivation rec {
  pname = "semodule-utils";
  version = "3.8.1";

  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/semodule-utils-${version}.tar.gz";
    sha256 = "sha256-dwWw2wWcU6IdanfAtQ9sRn2RoOqS/4dfHJNSfNJ2I5U=";
  };

  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = {
    description = "SELinux policy core utilities (packaging additions)";
    license = lib.licenses.gpl2Only;
    inherit (libsepol.meta) homepage platforms;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
