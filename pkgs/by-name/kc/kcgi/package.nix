{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  libbsd,
}:

stdenv.mkDerivation rec {
  pname = "kcgi";
  version = "0.10.8";
  underscoreVersion = lib.replaceStrings [ "." ] [ "_" ] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = "kcgi";
    rev = "VERSION_${underscoreVersion}";
    hash = "sha256-12MfclQxODEES4RiGVSDO74y0KFatPWKZde4x9bJRkE=";
  };
  patchPhase = ''
    substituteInPlace configure \
      --replace /usr/local /
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libbsd ];

  dontAddPrefix = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://kristaps.bsd.lv/kcgi";
    description = "Minimal CGI and FastCGI library for C/C++";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    mainProgram = "kfcgi";
  };
}
