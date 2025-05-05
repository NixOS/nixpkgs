{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "spdx_licenses";
  version = "1.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/kit-ty-kate/spdx_licenses/releases/download/v${version}/spdx_licenses-${version}.tar.gz";
    hash = "sha256-UkKAJ+MCCKr68p4sgTZ8/6NMJibWGCG6tQruMpMsjzA=";
  };

  meta = {
    homepage = "https://github.com/kit-ty-kate/spdx_licenses";
    description = "A library providing a strict SPDX License Expression parser";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
