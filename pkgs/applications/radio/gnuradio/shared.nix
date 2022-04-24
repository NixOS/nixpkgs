{ lib, stdenv
, python
, qt
, gtk
, removeReferencesTo
, featuresInfo
, features
, versionAttr
, sourceSha256
# If overriden. No need to set default values, as they are given defaults in
# the main expressions
, overrideSrc
, fetchFromGitHub
}:

rec {
  version = builtins.concatStringsSep "." (
    lib.attrVals [ "major" "minor" "patch" ] versionAttr
  );
  src = if overrideSrc != {} then
    overrideSrc
  else
    fetchFromGitHub {
      repo = "gnuradio";
      owner = "gnuradio";
      rev = "v${version}";
      sha256 = sourceSha256;
    }
  ;
  # Check if a feature is enabled, while defaulting to true if feat is not
  # specified.
  hasFeature = feat: (
    if builtins.hasAttr feat features then
      features.${feat}
    else
      true
  );
  nativeBuildInputs = lib.flatten (lib.mapAttrsToList (
    feat: info: (
      if hasFeature feat then
        (if builtins.hasAttr "native" info then info.native else []) ++
        (if builtins.hasAttr "pythonNative" info then info.pythonNative else [])
      else
        []
    )
  ) featuresInfo);
  buildInputs = lib.flatten (lib.mapAttrsToList (
    feat: info: (
      if hasFeature feat then
        (if builtins.hasAttr "runtime" info then info.runtime else []) ++
        (if builtins.hasAttr "pythonRuntime" info then info.pythonRuntime else [])
      else
        []
    )
  ) featuresInfo);
  cmakeFlags = lib.mapAttrsToList (
    feat: info: (
      if feat == "basic" then
        # Abuse this unavoidable "iteration" to set this flag which we want as
        # well - it means: Don't turn on features just because their deps are
        # satisfied, let only our cmakeFlags decide.
        "-DENABLE_DEFAULT=OFF"
      else
        if hasFeature feat then
          "-DENABLE_${info.cmakeEnableFlag}=ON"
        else
          "-DENABLE_${info.cmakeEnableFlag}=OFF"
    )) featuresInfo
  ;
  disallowedReferences = [
    # TODO: Should this be conditional?
    stdenv.cc
    stdenv.cc.cc
  ]
    # If python-support is disabled, we probably don't want it referenced
    ++ lib.optionals (!hasFeature "python-support") [ python ]
  ;
  # Gcc references from examples
  stripDebugList = [ "lib" "bin" ]
    ++ lib.optionals (hasFeature "gr-audio") [ "share/gnuradio/examples/audio" ]
    ++ lib.optionals (hasFeature "gr-uhd") [ "share/gnuradio/examples/uhd" ]
    ++ lib.optionals (hasFeature "gr-qtgui") [ "share/gnuradio/examples/qt-gui" ]
  ;
  postInstall = ""
    # Gcc references
    + lib.optionalString (hasFeature "gnuradio-runtime") ''
      ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc} $(readlink -f $out/lib/libgnuradio-runtime.so)
    ''
  ;
  # NOTE: Outputs are disabled due to upstream not using GNU InstallDIrs cmake
  # module. It's not that bad since it's a development package for most
  # purposes. If closure size needs to be reduced, features should be disabled
  # via an override.
  passthru = {
    inherit
      hasFeature
      versionAttr
      features
      featuresInfo
      python
    ;
  } // lib.optionalAttrs (hasFeature "gr-qtgui") {
    inherit qt;
  } // lib.optionalAttrs (hasFeature "gnuradio-companion") {
    inherit gtk;
  };
  # Wrapping is done with an external wrapper
  dontWrapPythonPrograms = true;
  dontWrapQtApps = true;
  # Tests should succeed, but it's hard to get LD_LIBRARY_PATH right in order
  # for it to happen.
  doCheck = false;

  meta = with lib; {
    description = "Software Defined Radio (SDR) software";
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
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ doronbehar bjornfor fpletz ];
  };
}
