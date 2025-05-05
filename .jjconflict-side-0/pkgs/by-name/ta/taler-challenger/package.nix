{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  libgcrypt,
  pkg-config,
  texinfo,
  curl,
  gnunet,
  jansson,
  libgnurl,
  libmicrohttpd,
  libsodium,
  libtool,
  libpq,
  taler-exchange,
  taler-merchant,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taler-challenger";
  version = "0.14.3-unstable-2025-02-17";

  src = fetchgit {
    url = "https://git.taler.net/challenger.git";
    rev = "e49e33a13df92c6a1d6f119775baa31778163531";
    hash = "sha256-AOtCx/r6JzwOSF3b3lDeY0/S+dGGNrJELerFoQ/K4tA=";
  };

  # https://git.taler.net/challenger.git/tree/bootstrap
  preAutoreconf = ''
    # Generate Makefile.am in contrib/
    pushd contrib
    rm -f Makefile.am
    find wallet-core/challenger/ -type f -printf '  %p \\\n' | sort > Makefile.am.ext
    # Remove extra '\' at the end of the file
    truncate -s -2 Makefile.am.ext
    cat Makefile.am.in Makefile.am.ext >> Makefile.am
    # Prevent accidental editing of the generated Makefile.am
    chmod -w Makefile.am
    popd
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    libgcrypt
    pkg-config
    texinfo
  ];

  buildInputs = [
    curl
    gnunet
    jansson
    libgcrypt
    libgnurl
    libmicrohttpd
    libpq
    libsodium
    libtool
    taler-exchange
    taler-merchant
  ];

  preFixup = ''
    substituteInPlace $out/bin/challenger-{dbconfig,send-post.sh} \
      --replace-fail "/bin/bash" "${runtimeShell}"
  '';

  meta = {
    description = "OAuth 2.0-based authentication service that validates user can receive messages at a certain address";
    homepage = "https://git.taler.net/challenger.git";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.linux;
  };
})
