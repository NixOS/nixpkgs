{
  lib,
  autoreconfHook,
  bashNonInteractive,
  libtool,
  fetchFromGitHub,
  nix-update-script,
  perl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxo";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "Juniper";
    repo = "libxo";
    rev = finalAttrs.version;
    hash = "sha256-ElSxegY2ejw7IuIMznfVpl29Wyvpx9k1BdXregzYsoQ=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail LIBTOOL=glibtool 'LIBTOOL=${lib.getExe libtool}'

    # Remove impurities
    substituteInPlace libxo/Makefile.am \
      --replace-fail '-L/opt/local/lib' ""
  '';

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # libxo misdetects malloc and realloc when cross-compiling on Darwin
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    autoreconfHook
    # For patchShebangs in postInstall
    bashNonInteractive
    perl
  ];

  postInstall = ''
    moveToOutput "bin/libxo-config" "$dev"
    patchShebangs --host "$out/bin"
  '';

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library to generate text, XML, JSON, and HTML";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.reckenrode ];
    platforms = lib.platforms.unix;
  };
})
