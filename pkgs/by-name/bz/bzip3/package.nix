{
  binutils,
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  testers,
}:

let
  # (same workaround as in capnproto package)
  #
  # HACK: work around https://github.com/NixOS/nixpkgs/issues/177129
  # Though this is an issue between Clang and GCC,
  # so it may not get fixed anytime soon...
  empty-libgcc_eh = stdenv.mkDerivation {
    pname = "empty-libgcc_eh";
    version = "0";
    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out"/lib
      "${binutils}"/bin/ar r "$out"/lib/libgcc_eh.a
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bzip3";
  version = "1.5.3";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "iczelia";
    repo = "bzip3";
    tag = finalAttrs.version;
    hash = "sha256-SOouMUctxsAJdkt84rJBaCbK23GKmXRH9nVgGdDodsk=";
  };

  postPatch = ''
    echo -n "${finalAttrs.version}" > .tarball-version
    patchShebangs build-aux

    # build-aux/ax_subst_man_date.m4 calls git if the file exists
    rm .gitignore
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isStatic [ empty-libgcc_eh ];

  configureFlags = [
    "--disable-arch-native"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--disable-link-time-optimization" ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Better and stronger spiritual successor to BZip2";
    homepage = "https://github.com/iczelia/bzip3";
    changelog = "https://github.com/iczelia/bzip3/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    pkgConfigModules = [ "bzip3" ];
    platforms = lib.platforms.unix;
  };
})
