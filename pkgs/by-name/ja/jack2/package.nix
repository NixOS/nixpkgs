{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3Packages,
  makeWrapper,
  db,
  readline,
  libopus,
  libsndfile,
  libsamplerate,
  portaudio,
  wafHook,
  libsystre,
  windows,
  # Darwin Dependencies
  aften,

  # BSD Dependencies
  freebsd,

  # Optional Dependencies
  dbus ? null,
  libffado ? null,
  alsa-lib ? null,

  # Extra options
  prefix ? "",

  testers,
}:

let
  inherit (python3Packages) python dbus-python;
  shouldUsePkg =
    pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  libOnly = prefix == "lib";

  optDbus = if stdenv.hostPlatform.isDarwin then null else shouldUsePkg dbus;
  optPythonDBus = if libOnly then null else shouldUsePkg dbus-python;
  optLibffado = if libOnly then null else shouldUsePkg libffado;
  optAlsaLib = if libOnly then null else shouldUsePkg alsa-lib;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${prefix}jack2";
  version = "1.9.22";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Cslfys5fcZDy0oee9/nM5Bd1+Cg4s/ayXjJJOSQCL4E=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    python
    wafHook
  ]
  ++ lib.optionals (optDbus != null) [ makeWrapper ];
  buildInputs = [
    libsamplerate
    optDbus
    optPythonDBus
    optLibffado
    optAlsaLib
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # MSYS2's mingw-w64-jack2 depends on mingw-w64-portaudio.
    portaudio
    # MSYS2's mingw-w64-jack2 depends on mingw-w64-libsystre (POSIX regex API wrapper).
    libsystre
    # MSYS2's mingw-w64-jack2 depends on mingw-w64-db for JACK metadata support.
    db
    # MSYS2's mingw-w64-jack2 depends on mingw-w64-readline (used by tooling / interactive UX).
    readline
    # MSYS2's mingw-w64-jack2 depends on mingw-w64-opus (NetJACK Opus encoding support).
    libopus
    # MSYS2's mingw-w64-jack2 depends on mingw-w64-libsndfile (optional tooling / file I/O paths).
    libsndfile
    # Some parts of jack2 link against pthreads on MinGW; provide -lpthread and pthread.h.
    windows.pthreads
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    aften
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    freebsd.libsysinfo
  ];

  patches =
    # waf upstream uses the removed `imp` module; fix for Python 3.13+.
    # This is not MinGW-specific; apply unconditionally.
    [ ./mingw/0005-fix-new-python.patch ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      ./mingw/0001-wscript-remove-hardcoded-includedir.patch
      ./mingw/0002-fix-format-security.patch
      ./mingw/0003-relocate-plugins-libdir.patch
      ./mingw/0004-relocate-jackd-path.patch
      ./mingw/0006-missing-dllexport.patch
      ./mingw/0007-unknown-autoimport-option-clang.patch
    ];

  postPatch = ''
    patchShebangs --build svnversion_regenerate.sh
  '';

  wafConfigureFlags = [
    "--classic"
    "--autostart=${if (optDbus != null) then "dbus" else "classic"}"
  ]
  ++ lib.optional (optDbus != null) "--dbus"
  ++ lib.optional (optLibffado != null) "--firewire"
  ++ lib.optional (optAlsaLib != null) "--alsa"
  ++ lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--platform=${
    # MSYS2 uses --platform=win32 for mingw-w64.
    if stdenv.hostPlatform.isMinGW then "win32" else stdenv.hostPlatform.parsed.kernel.name
  }";

  env = {
    # MSYS2 sets WAF_NO_PREFORK=1 for reproducible builds; keep the same behavior.
    WAF_NO_PREFORK = lib.optionalString stdenv.hostPlatform.isMinGW "1";
    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isMinGW "-lpthread";
  };

  postInstall = (
    if libOnly then
      ''
        rm -rf $out/{bin,share}
        rm -rf $out/lib/{jack,libjacknet*,libjackserver*}
      ''
    else
      lib.optionalString (optDbus != null) ''
        wrapProgram $out/bin/jack_control --set PYTHONPATH $PYTHONPATH
      ''
  );

  postFixup = ''
    substituteInPlace "$dev/lib/pkgconfig/jack.pc" \
      --replace-fail "$out/include" "$dev/include"
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "JACK audio connection kit, version 2 with jackdbus";
    homepage = "https://jackaudio.org";
    license = lib.licenses.gpl2Plus;
    pkgConfigModules = [ "jack" ];
    # MSYS2 provides a mingw-w64-jack2 package.
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = [ ];
  };
})
