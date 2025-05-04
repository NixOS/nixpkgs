{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libtool,
  perl,
  libtermkey,
  unibilium,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libtickit";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "leonerd";
    repo = "libtickit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q8JMNFxmnyOiUso4nXLZjJIBFYR/EF6g45lxVeY0f1s=";
  };

  outputs = [
    "dev"
    "man"
    "out"
  ];

  patches = [
    # Disabled on darwin, since test assumes TERM=linux
    ./001-skip-test-18term-builder-on-macos.patch
    # Make the Makefile use $(PKG_CONFIG) instead of pkg-config, allowing for
    # cross compilation.
    ./002-use-pkg-config-env-var.patch
  ];

  nativeBuildInputs = [
    pkg-config
    libtool
    libtermkey
    unibilium
  ];

  buildInputs = [
    libtermkey
    unibilium
  ];

  nativeCheckInputs = [ perl ];

  makeFlags = [
    "LIBTOOL=${lib.getExe libtool}"
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isStatic;

  meta = with lib; {
    description = "Terminal interface construction kit";
    longDescription = ''
      This library provides an abstracted mechanism for building interactive full-screen terminal
      programs. It provides a full set of output drawing functions, and handles keyboard and mouse
      input events.
    '';
    homepage = "https://www.leonerd.org.uk/code/libtickit/";
    license = licenses.mit;
    maintainers = with maintainers; [ onemoresuza ];
    platforms = platforms.unix;
  };
})
