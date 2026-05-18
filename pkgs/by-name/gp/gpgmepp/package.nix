{
  cmake,
  fetchurl,
  gpgme,
  lib,
  libgpg-error,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpgmepp";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://gnupg/gpgmepp/gpgmepp-${finalAttrs.version}.tar.xz";
    hash = "sha256-V/gERo8CBFBLFyxrE5ywUSS0JjvnrVFJMsfExQYqFuI=";
  };

  postPatch = ''
    # remove -unknown suffix from pkgconfig version
    substituteInPlace cmake/modules/G10GetFullVersion.cmake \
      --replace-fail '"''${version}-unknown"' '"''${version}"'
  '';

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./0001-Fix-handling-of-absolute-install-dirs-in-.pc-install.patch
    ./0001-Don-t-hardcode-include-as-includedir.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    gpgme
    libgpg-error
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  meta = {
    changelog = "https://dev.gnupg.org/source/gpgmepp/browse/master/NEWS;gpgmepp-${finalAttrs.version}?as=remarkup";
    description = "C++ bindings/wrapper for GPGME";
    homepage = "https://dev.gnupg.org/source/gpgmepp";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.dotlambda ];
    pkgConfigModules = [ "gpgmepp" ];
    platforms = lib.platforms.unix;
  };
})
