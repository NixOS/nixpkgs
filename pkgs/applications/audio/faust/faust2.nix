{ lib, stdenv
, coreutils
, fetchFromGitHub
, makeWrapper
, pkg-config
, cmake
, llvm
, emscripten
, openssl
, libsndfile
, libmicrohttpd
, gnutls
, libtasn1
, p11-kit
, vim
, which
}:

with lib.strings;

let

  version = "2.41.1";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    rev = version;
    sha256 = "sha256-x0nBWyILrNJijs7CIvRrgYG6vgB3UlxLj9i7E4cHr9I=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    homepage = "https://faust.grame.fr/";
    downloadPage = "https://github.com/grame-cncm/faust/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon pmahoney ];
  };

  faust = stdenv.mkDerivation {

    pname = "faust";
    inherit version;

    inherit src;

    nativeBuildInputs = [ makeWrapper pkg-config cmake vim which ];
    buildInputs = [ llvm emscripten openssl libsndfile libmicrohttpd gnutls libtasn1 p11-kit ];


    passthru = {
      inherit wrap wrapWithBuildEnv;
    };


    preConfigure = ''
      cd build
    '';

    cmakeFlags = [
      "-C../backends/all.cmake"
      "-C../targets/all.cmake"
    ];

    postInstall = ''
      # syntax error when eval'd directly
      pattern="faust2!(*@(atomsnippets|graph|graphviewer|md|plot|sig|sigviewer|svg))"
      (shopt -s extglob; rm "$out"/bin/$pattern)
    '';

    postFixup = ''
      # The 'faustoptflags' is 'source'd into other faust scripts and
      # not used as an executable, so patch 'uname' usage directly
      # rather than use makeWrapper.
      substituteInPlace "$out"/bin/faustoptflags \
        --replace uname "${coreutils}/bin/uname"

      # wrapper for scripts that don't need faust.wrap*
      for script in "$out"/bin/faust2*; do
        wrapProgram "$script" \
          --prefix PATH : "$out"/bin
      done
    '';

    meta = meta // {
      description = "A functional programming language for realtime audio signal processing";
      longDescription = ''
        FAUST (Functional Audio Stream) is a functional programming
        language specifically designed for real-time signal processing
        and synthesis. FAUST targets high-performance signal processing
        applications and audio plug-ins for a variety of platforms and
        standards.
        The Faust compiler translates DSP specifications into very
        efficient C++ code. Thanks to the notion of architecture,
        FAUST programs can be easily deployed on a large variety of
        audio platforms and plugin formats (jack, alsa, ladspa, maxmsp,
        puredata, csound, supercollider, pure, vst, coreaudio) without
        any change to the FAUST code.

        This package has just the compiler, libraries, and headers.
        Install faust2* for specific faust2appl scripts.
      '';
    };

  };

  # Default values for faust2appl.
  faust2ApplBase =
    { baseName
    , dir ? "tools/faust2appls"
    , scripts ? [ baseName ]
    , ...
    }@args:

    args // {
      name = "${baseName}-${version}";

      inherit src;

      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/bin"
        for script in ${concatStringsSep " " scripts}; do
          cp "${dir}/$script" "$out/bin/"
        done

        runHook postInstall
      '';

      postInstall = ''
        # For the faust2appl script, change 'faustpath' and
        # 'faustoptflags' to absolute paths.
        for script in "$out"/bin/*; do
          substituteInPlace "$script" \
            --replace " error " "echo"
        done
      '';

      meta = meta // {
        description = "The ${baseName} script, part of faust functional programming language for realtime audio signal processing";
      };
    };

  # Some 'faust2appl' scripts, such as faust2alsa, run faust to
  # generate cpp code, then invoke the c++ compiler to build the code.
  # This builder wraps these scripts in parts of the stdenv such that
  # when the scripts are called outside any nix build, they behave as
  # if they were running inside a nix build in terms of compilers and
  # paths being configured (e.g. rpath is set so that compiled
  # binaries link to the libs inside the nix store)
  #
  # The function takes two main args: the appl name (e.g.
  # 'faust2alsa') and an optional list of propagatedBuildInputs. It
  # returns a derivation that contains only the bin/${appl} script,
  # wrapped up so that it will run as if it was inside a nix build
  # with those build inputs.
  #
  # The build input 'faust' is automatically added to the
  # propagatedBuildInputs.
  wrapWithBuildEnv =
    { baseName
    , propagatedBuildInputs ? [ ]
    , ...
    }@args:

    stdenv.mkDerivation ((faust2ApplBase args) // {

      nativeBuildInputs = [ pkg-config makeWrapper ];

      propagatedBuildInputs = [ faust ] ++ propagatedBuildInputs;

      libPath = lib.makeLibraryPath propagatedBuildInputs;

      postFixup = ''

        # export parts of the build environment
        for script in "$out"/bin/*; do
          # e.g. NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
          nix_cc_wrapper_target_host="$(printenv | grep ^NIX_CC_WRAPPER_TARGET_HOST | sed 's/=.*//')"

          # e.g. NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
          nix_bintools_wrapper_target_host="$(printenv | grep ^NIX_BINTOOLS_WRAPPER_TARGET_HOST | sed 's/=.*//')"

          wrapProgram "$script" \
            --set FAUSTLDDIR "${faust}/lib" \
            --set FAUSTLIB "${faust}/share/faust" \
            --set FAUSTINC "${faust}/include/faust" \
            --set FAUSTARCH "${faust}/share/faust" \
            --prefix PATH : "$PATH" \
            --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH" \
            --set NIX_CFLAGS_COMPILE "$NIX_CFLAGS_COMPILE" \
            --set NIX_LDFLAGS "$NIX_LDFLAGS -lpthread" \
            --set "$nix_cc_wrapper_target_host" "''${!nix_cc_wrapper_target_host}" \
            --set "$nix_bintools_wrapper_target_host" "''${!nix_bintools_wrapper_target_host}" \
            --prefix LIBRARY_PATH "$libPath"
        done
      '';
    });

  # Builder for 'faust2appl' scripts, such as faust2firefox that
  # simply need to be wrapped with some dependencies on PATH.
  #
  # The build input 'faust' is automatically added to the PATH.
  wrap =
    { baseName
    , runtimeInputs ? [ ]
    , ...
    }@args:

    let

      runtimePath = concatStringsSep ":" (map (p: "${p}/bin") ([ faust ] ++ runtimeInputs));

    in stdenv.mkDerivation ((faust2ApplBase args) // {

      nativeBuildInputs = [ makeWrapper ];

      postFixup = ''
        for script in "$out"/bin/*; do
          wrapProgram "$script" --prefix PATH : "${runtimePath}"
        done
      '';

    });

in faust
