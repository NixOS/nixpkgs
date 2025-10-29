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
    sha256 = "0ha6r7bcgf6pcn5gbd2sl7835givhda1jql49c232f1iair1yqyp";
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
    maintainers = [ lib.maintainers.leenaars ];
    mainProgram = "kfcgi";
  };
}
