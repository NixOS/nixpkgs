{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  undmg,
  autoPatchelfHook,
  wrapGAppsHook3,
  versionCheckHook,
  alsa-lib,
  libgbm,
  zlib,
  glib,
  nss,
  nspr,
  dbus,
  at-spi2-core,
  cups,
  expat,
  pango,
  cairo,
  udev,
  gdk-pixbuf,
  fontconfig,
  freetype,
  libGL,
  gtk3,

  libxkbcommon,
  libxfixes,
  libxcb,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  libxxf86vm,
  libxrandr,
  libxcursor,
  libxcomposite,
  libxdamage,

  cacert,
  jre-generate-cacerts,

  coreutils,
  gnugrep,
  gnused,
}:

let
  pname = "scilab-bin";
  version = "2027.0.0";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}-arm64.dmg";
      hash = "sha256-82+5EBZEl5rUI+VpSPdd2T4hWiydENJgh/G6Mi4t05E=";
    };
    x86_64-linux = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}.bin.x86_64-linux-gnu.tar.xz";
      hash = "sha256-AP3DBo/r7p//419UYLSWFd1RH8epANOrfmWr+AIn1YY=";
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    homepage = "http://www.scilab.org/";
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Only;
    mainProgram = "scilab";
    changelog = "https://help.scilab.org/docs/${version}/en_US/CHANGES.html";
  };

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      src
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      makeWrapper
      undmg
    ];

    sourceRoot = "scilab-${version}.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications/scilab.app,bin}
      cp -R . $out/Applications/scilab.app
      makeWrapper $out/{Applications/scilab.app/Contents/MacOS,bin}/scilab

      runHook postInstall
    '';
  });

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      src
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;
    # bin/ also contains the real ELF binaries (scilab-bin, scilab-cli-bin, ...),
    # so only the launcher scripts are wrapped, manually in postFixup
    dontWrapGApps = true;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook3
    ];

    buildInputs = [
      alsa-lib
      stdenv.cc.cc
      libgbm
      zlib
      glib
      nss
      nspr
      dbus
      at-spi2-core
      cups
      expat
      pango
      cairo
      udev
      gtk3
      gdk-pixbuf
      libGL
      fontconfig
      freetype

      libxkbcommon
      libxfixes
      libxcb
      libx11
      libxext
      libxi
      libxrender
      libxtst
      libxxf86vm
      libxrandr
      libxcursor
      libxcomposite
      libxdamage
    ];

    # Tools the launcher scripts call; needed on PATH at runtime and by
    # versionCheckHook, which runs the script in the build sandbox
    runtimeDeps = [
      coreutils
      gnugrep
      gnused
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      mv -t $out bin include lib share thirdparty

      # The launcher scripts hardcode /bin/ in their command substitutions
      substituteInPlace \
        $out/bin/{scilab,scilab-cli,scilab-adv-cli,scinotes,xcos} \
        --replace-fail '$(/bin/' '$('

      substituteInPlace $out/share/applications/*.desktop \
        --replace-fail 'Exec=' "Exec=$out/bin/"

      runHook postInstall
    '';

    # libGL, fontconfig, freetype and gtk3 are loaded at runtime by the bundled
    # JVM/JCEF, so they must be in RUNPATH even though autoPatchelfHook is
    # already satisfied
    appendRunpaths = [
      (lib.makeLibraryPath finalAttrs.buildInputs)
    ];

    # keytool must already be patched when postFixup regenerates cacerts
    dontAutoPatchelf = true;

    postFixup = ''
      autoPatchelf -- "$out"

      # regenerate the bundled JRE's CA keystore from cacert, as openjdk does
      pushd $out/thirdparty/java/lib/security
      rm cacerts
      JAVA_TOOL_OPTIONS="-Dkeystore.pkcs12.certProtectionAlgorithm=NONE -Dkeystore.pkcs12.macAlgorithm=NONE" \
        ${jre-generate-cacerts} $out/thirdparty/java/bin/keytool ${cacert}/etc/ssl/certs/ca-bundle.crt
      [ -s cacerts ] || { echo "failed to generate cacerts" >&2; exit 1; }
      popd

      for f in scilab scilab-cli scilab-adv-cli scinotes xcos; do
        wrapProgram $out/bin/$f \
          "''${gappsWrapperArgs[@]}" \
          --suffix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}
      done
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    versionCheckProgramArg = "-version";
    doInstallCheck = true;
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
