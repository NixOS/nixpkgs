{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  libbsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcgi";
  version = "0.10.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = "kcgi";
    tag = "VERSION_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-12MfclQxODEES4RiGVSDO74y0KFatPWKZde4x9bJRkE=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace-fail /usr/local /
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libbsd ];

  dontAddPrefix = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://kristaps.bsd.lv/kcgi";
    changelog = "https://kristaps.bsd.lv/kcgi/archive.html";
    description = "Minimal CGI and FastCGI library for C/C++";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    mainProgram = "kfcgi";
  };
})
