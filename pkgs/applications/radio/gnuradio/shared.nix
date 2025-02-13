{
  lib,
  stdenv,
  python,
  qt,
  gtk,
  removeReferencesTo,
  featuresInfo,
  features,
  version,
  sourceSha256,
  # If overridden. No need to set default values, as they are given defaults in
  # the main expressions
  overrideSrc,
  fetchFromGitHub,
}:

let
  # Check if a feature is enabled, while defaulting to true if feat is not
  # specified.
  hasFeature = feat: (if builtins.hasAttr feat features then features.${feat} else true);
  versionAttr = {
    major = builtins.concatStringsSep "." (lib.take 2 (lib.splitVersion version));
    minor = builtins.elemAt (lib.splitVersion version) 2;
    patch = builtins.elemAt (lib.splitVersion version) 3;
  };
in
{
  src =
    if overrideSrc != { } then
      overrideSrc
    else
      fetchFromGitHub {
        repo = "gnuradio";
        owner = "gnuradio";
        rev = "v${version}";
        sha256 = sourceSha256;
      };
  nativeBuildInputs =
    [ removeReferencesTo ]
    ++ lib.flatten (
      lib.mapAttrsToList (
        feat: info:
        (lib.optionals (hasFeature feat) (
          (lib.optionals (builtins.hasAttr "native" info) info.native)
          ++ (lib.optionals (builtins.hasAttr "pythonNative" info) info.pythonNative)
        ))
      ) featuresInfo
    );
  buildInputs = lib.flatten (
    lib.mapAttrsToList (
      feat: info:
      (lib.optionals (hasFeature feat) (
        (lib.optionals (builtins.hasAttr "runtime" info) info.runtime)
        ++ (lib.optionals (builtins.hasAttr "pythonRuntime" info) info.pythonRuntime)
      ))
    ) featuresInfo
  );
  cmakeFlags = lib.mapAttrsToList (
    feat: info:
    (
      if feat == "basic" then
        # Abuse this unavoidable "iteration" to set this flag which we want as
        # well - it means: Don't turn on features just because their deps are
        # satisfied, let only our cmakeFlags decide.
        "-DENABLE_DEFAULT=OFF"
      else if hasFeature feat then
        "-DENABLE_${info.cmakeEnableFlag}=ON"
      else
        "-DENABLE_${info.cmakeEnableFlag}=OFF"
    )
  ) featuresInfo;
  disallowedReferences =
    [
      # TODO: Should this be conditional?
      stdenv.cc
      stdenv.cc.cc
    ]
    # If python-support is disabled, we probably don't want it referenced
    ++ lib.optionals (!hasFeature "python-support") [ python ];
  # Gcc references from examples
  stripDebugList =
    [
      "lib"
      "bin"
    ]
    ++ lib.optionals (hasFeature "gr-audio") [ "share/gnuradio/examples/audio" ]
    ++ lib.optionals (hasFeature "gr-uhd") [ "share/gnuradio/examples/uhd" ]
    ++ lib.optionals (hasFeature "gr-qtgui") [ "share/gnuradio/examples/qt-gui" ];
  postInstall =
    ""
    # Gcc references
    + lib.optionalString (hasFeature "gnuradio-runtime") ''
      remove-references-to -t ${stdenv.cc} $(readlink -f $out/lib/libgnuradio-runtime${stdenv.hostPlatform.extensions.sharedLibrary})
    ''
    # Clang references in InstalledDir
    + lib.optionalString (hasFeature "gnuradio-runtime" && stdenv.hostPlatform.isDarwin) ''
      remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/lib/libgnuradio-runtime${stdenv.hostPlatform.extensions.sharedLibrary})
    '';
  # NOTE: Outputs are disabled due to upstream not using GNU InstallDIrs cmake
  # module. It's not that bad since it's a development package for most
  # purposes. If closure size needs to be reduced, features should be disabled
  # via an override.
  passthru =
    {
      inherit
        hasFeature
        versionAttr
        features
        featuresInfo
        python
        ;
      gnuradioOlder = lib.versionOlder versionAttr.major;
      gnuradioAtLeast = lib.versionAtLeast versionAttr.major;
    }
    // lib.optionalAttrs (hasFeature "gr-qtgui") {
      inherit qt;
    }
    // lib.optionalAttrs (hasFeature "gnuradio-companion") {
      inherit gtk;
    };
  # Wrapping is done with an external wrapper
  dontWrapPythonPrograms = true;
  dontWrapQtApps = true;
  # On darwin, it requires playing with DYLD_FALLBACK_LIBRARY_PATH to make if
  # find libgnuradio-runtim.3.*.dylib .
  doCheck = !stdenv.hostPlatform.isDarwin;
  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_QPA_PLATFORM=offscreen
    export QT_PLUGIN_PATH="${qt.qtbase.bin}/${qt.qtbase.qtPluginPrefix}"
  '';

  meta = {
    description = "Software Defined Radio (SDR) software";
    mainProgram = "gnuradio-config-info";
    longDescription = ''
      GNU Radio is a free & open-source software development toolkit that
      provides signal processing blocks to implement software radios. It can be
      used with readily-available low-cost external RF hardware to create
      software-defined radios, or without hardware in a simulation-like
      environment. It is widely used in hobbyist, academic and commercial
      environments to support both wireless communications research and
      real-world radio systems.
    '';
    homepage = "https://www.gnuradio.org";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      doronbehar
      bjornfor
      fpletz
      jiegec
    ];
  };
}
