{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  nix-update-script,
  runCommandCC,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csmapi";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ngageoint";
    repo = "csm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CVaCUvVvAgsYmhXcf0LXFq4vpuI067+MtTQZ9WyOewQ=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  # Build with the generic Makefile and pass the flags the per-platform ones
  # (Makefile.linux64, ...) would set: those force the pre-C++11 libstdc++
  # ABI, and there is none for Darwin.
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}c++"
    "COPTS=-fPIC -O2 -Wall -std=c++11"
    "LDOPTS=-shared${lib.optionalString stdenv.hostPlatform.isElf " -Wl,-soname,libcsmapi.so.${lib.versions.major finalAttrs.version}"}"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "LIBRARY=libcsmapi.dylib";
  installFlags = [ "INSTDIR=${placeholder "out"}" ];

  # The install target always adds .so symlinks.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm $out/lib/libcsmapi.so*
  '';

  passthru = {
    tests.link = runCommandCC "csmapi-test" { buildInputs = [ finalAttrs.finalPackage ]; } ''
      $CXX -std=c++11 ${./test.cpp} -lcsmapi -o test
      ./test
      touch $out
    '';

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Community Sensor Model (CSM) API for photogrammetric sensor models";
    longDescription = ''
      The Community Sensor Model API is a standard C++ interface between
      sensor exploitation tools and sensor model plugins, used for both
      terrestrial and planetary imagery.
    '';
    homepage = "https://github.com/ngageoint/csm";
    changelog = "https://github.com/ngageoint/csm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ arunoruto ];
    platforms = lib.platforms.unix;
  };
})
