{
  stdenv,
  fetchurl,
  dpkg,
  lib,
  perl,
  perlPackages,
  libpng,
  libunwind,
  pixman,
  makeWrapper,
  autoPatchelfHook,
  mesa,
  libXfont2,
  libXau,
  libxshmfence,
  libXdmcp,
  libXtst,
  libXrandr,
  libXcursor,
  libXfixes,
  libwebp,
  libxcrypt-legacy,
  libGL,
  systemdLibs,
  freetype,
  libbsd,
  kasmvnc-xvnc
}:
let
  perlLibs = (ppkgs: with ppkgs; [
    Switch
    ListMoreUtils
    ExporterTiny
    TryTiny
    DateTime
    namespaceautoclean
    namespaceclean
    BHooksEndOfScope
    ModuleImplementation
    ModuleRuntime
    SubExporterProgressive
    PackageStash
    SubIdentify
    Specio
    MROCompat
    RoleTiny
    EvalClosure
    DevelStackTrace
    ParamsValidationCompiler
    ExceptionClass
    ClassDataInheritable
    DateTimeLocale
    FileShareDir
    ClassInspector
    DateTimeTimeZone
    ClassSingleton
    YAMLTiny
    HashMergeSimple
  ]);
in
stdenv.mkDerivation rec {
  pname = "kasmvnc";
  # These two are version linked because they have to be built from the same source, though are different outputs.
  version = kasmvnc-xvnc.version;

  # We do not build from source because kasmvnc only provides a docker build env. This also does not give
  # us static linked builds. Thus it doesn't really matter.
  src = fetchurl {
    url = "https://github.com/kasmtech/KasmVNC/releases/download/v${version}/kasmvncserver_bookworm_${version}_amd64.deb";
    sha256 = "sha256-i8D2IY7qhJv7tOW7euPHA4cJoPaRgcH1VAgsaucVxcA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  buildInputs = [
    (perl.withPackages(perlLibs))
    kasmvnc-xvnc
    freetype
    pixman
    libpng
    libunwind
    libXfont2
    libXau
    libxshmfence
    libXdmcp
    libXtst
    libXrandr
    libXcursor
    libXfixes
    libwebp
    libxcrypt-legacy
    libbsd
    libGL
    systemdLibs
    mesa
  ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/lib $out/lib
    mv $out/usr/share $out/share
    rmdir $out/usr
  '';

  fixupPhase = ''
    patchShebangs $out/bin/kasmvncserver
    wrapProgram $out/bin/kasmvncserver \
      --prefix PERL5LIB : $out/share/perl5

    autoPatchelf $out/bin
  '';

  meta = with lib; {
    homepage = "https://kasmweb.com/kasmvnc";
    description = "Modern web-based VNC Server and Client";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ kekschen ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "vncserver";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
