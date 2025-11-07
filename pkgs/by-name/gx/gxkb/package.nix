{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  git,
  autoreconfHook,
  pkg-config,
  gtk3,
  libwnck,
  libxklavier,
  appindicatorSupport ? true,
  libayatana-appindicator,
}:

stdenv.mkDerivation rec {
  pname = "gxkb";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "zen-tools";
    repo = "gxkb";
    rev = "v${version}";
    sha256 = "sha256-oBIBIkj4p6HlF0PRQtI/K5dhLs7pbPxN7Cgr/YZaI1s=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    gtk3
    libwnck
    libxklavier
  ]
  ++ lib.optional appindicatorSupport libayatana-appindicator;

  configureFlags = lib.optional appindicatorSupport "--enable-appindicator=yes";
  outputs = [
    "out"
    "man"
  ];

  # This patch restore data which was wiped by upstream without any technical reasons
  # https://github.com/omgbebebe/gxkb/commit/727ec8b595a91dbb540e6087750f43b85d0dfbc0
  # NOTE: the `patch` hook cannot be used here due to lack of support for git binary patches
  p1 = fetchurl {
    url = "https://github.com/omgbebebe/gxkb/commit/727ec8b595a91dbb540e6087750f43b85d0dfbc0.patch";
    hash = "sha256-x7x3MHHrOnPivvlzOFqgFAA5BDB2LOXMlalPYbwM/1Q=";
  };

  postPatch = ''
    ${git}/bin/git apply ${p1}
  '';

  meta = with lib; {
    description = "X11 keyboard indicator and switcher";
    homepage = "https://zen-tools.github.io/gxkb/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.omgbebebe ];
    platforms = platforms.linux;
    mainProgram = "gxkb";
  };
}
