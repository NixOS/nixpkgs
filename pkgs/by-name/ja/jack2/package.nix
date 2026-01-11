{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  python3Packages,
  makeWrapper,
  libsamplerate,
  wafHook,
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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    aften
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    freebsd.libsysinfo
  ];

  patches = [
    (fetchpatch2 {
      # Python 3.12 support
      name = "jack2-waf2.0.26.patch";
      url = "https://github.com/jackaudio/jack2/commit/250420381b1a6974798939ad7104ab1a4b9a9994.patch";
      hash = "sha256-M/H72lLTeddefqth4BSkEfySZRYMIzLErb7nIgVN0u8=";
    })
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
  ) "--platform=${stdenv.hostPlatform.parsed.kernel.name}";

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
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
