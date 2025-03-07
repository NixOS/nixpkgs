{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "bpp-core";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ma2cl677l7s0n5sffh66cy9lxp5wycm50f121g8rx85p95vkgwv";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/BioPP/bpp-core/commit/d450e8033b06e80dff9c2236fb7ce1f3ced5dcbb.patch";
      hash = "sha256-9t68mrK7KNs5BxljKMaA+XskCcKDNv8DNCVUYunoNdw=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  postFixup = ''
    substituteInPlace $out/lib/cmake/bpp-core/bpp-core-targets.cmake  \
      --replace 'set(_IMPORT_PREFIX' '#set(_IMPORT_PREFIX'
  '';
  # prevents cmake from exporting incorrect INTERFACE_INCLUDE_DIRECTORIES
  # of form /nix/store/.../nix/store/.../include,
  # probably due to relative vs absolute path issue

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/BioPP/bpp-core";
    changelog = "https://github.com/BioPP/bpp-core/blob/master/ChangeLog";
    description = "C++ bioinformatics libraries and tools";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.cecill20;
  };
}
