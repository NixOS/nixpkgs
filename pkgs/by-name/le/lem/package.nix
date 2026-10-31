{
  lib,
  sbcl,
  autoconf,
  automake,
  libffi,
  libtool,
  openssl,
  makeBinaryWrapper,
  pkg-config,
  stdenvNoCC,
  stdenv,
  which,
  git,
  cacert,
  writeText,
  fetchFromGitHub,
}:
let
  lem = sbcl.buildASDFSystem rec {
    pname = "lem";
    version = "2.2.0";
    systems = [ "lem-fake-interface" ];
    src = fetchFromGitHub {
      owner = "lem-project";
      repo = "lem";
      tag = "v${version}";
      hash = "sha256-aMPyeOXyFSxhh75eiAwMStLc2fO1Dwi2lQsuH0IYMd0=";
    };

    meta = {
      description = "Common Lisp editor/IDE with high extensibility";
      homepage = "https://lem-project.github.io/";
      mainProgram = "lem";
      license = with lib.licenses; [ mit ];
      maintainers = with lib.maintainers; [ justdeeevin ];
      platforms = lib.platforms.unix;
    };

    nativeBuildInputs = [
      autoconf
      automake
      libffi
      libtool
      makeBinaryWrapper
      pkg-config
    ];

    nativeLibs = [
      libffi
      openssl
    ];

    qlBundleLibs = stdenvNoCC.mkDerivation {
      pname = "${pname}-qlot-bundle";
      inherit src version;

      nativeBuildInputs = [
        sbcl.pkgs.qlot-cli
        which
        git
        cacert
      ];

      installPhase = ''
        runHook preInstall

        export HOME=$(mktemp -d)
        qlot install --jobs $NIX_BUILD_CORES --no-deps --no-color
        qlot bundle --no-color

        # Unnecessary and also platform-dependent file
        rm .bundle-libs/bundle-info.sexp

        # Remove vendored .so files
        find .bundle-libs \
          -type f '(' -name '*.so' -o -name '*.dll' ')' -exec rm '{}' ';'

        cp -r .bundle-libs $out

        runHook postInstall
      '';

      dontBuild = true;
      dontFixup = true;
      outputHashMode = "recursive";
      outputHash =
        if stdenv.isDarwin then
          "sha256-BV1m58fUe1zfLH5iKbDP7KTNhv1p+g3W99tFQFYxPqs="
        else
          "sha256-DDFUP/lEkxoCNil23KlSqJb0mWCriAgNzpq8RAF4mFc=";
    };

    configurePhase = ''
      runHook preConfigure
      mkdir -p $out/share/lem
      pushd $out/share/lem
        cp -r $qlBundleLibs .bundle-libs
        chmod -R +w .bundle-libs

        # build async-process native part
        pushd .bundle-libs/software/async-process-*
          chmod +x bootstrap
          ./bootstrap
        popd

        # nixpkgs patch to fix cffi build on darwin
        pushd .bundle-libs/software/cffi-*
          patch -p1 <${./cffi-libffi-darwin-ffi-h.patch}
        popd
      popd

      source ${./setup-hook.sh}
      buildAsdfPath

      runHook postConfigure
    '';

    buildScript = writeText "build-lem.lisp" ''
      (defpackage :nix-cl-user
        (:use :cl))

      (in-package :nix-cl-user)
      (load "${lem.asdfFasl}/asdf.${lem.faslExt}")

      ;; Avoid writing to the global fasl cache
      (asdf:initialize-output-translations
        '(:output-translations :disable-cache
                               :inherit-configuration))

      (defvar *systems* (uiop:split-string (uiop:getenv "systems")))
      (defvar *out-path* (uiop:getenv "out"))
      (defvar *share-path* (concatenate 'string
                            *out-path*
                            "/share/lem"))
      (defvar *bundle-path* (concatenate 'string
                            *share-path*
                            "/.bundle-libs/bundle.lisp"))

      ;; Initial load
      (let ((asdf:*system-definition-search-functions*
               (copy-list asdf:*system-definition-search-functions*)))
        (load *bundle-path*)
        (loop :for system :in *systems*
              :do (asdf:load-system system)))

      ;; Load the bundle on every startup
      (uiop:register-image-restore-hook
        (lambda ()
          (load *bundle-path*))
           nil)

      (setf uiop:*image-entry-point* #'lem:main)
      (uiop:dump-image
        "lem"
        :executable t
        :compression t)
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/lem
      mv lem $out/bin
      wrapProgram $out/bin/lem \
        --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
        --prefix DYLD_LIBRARY_PATH : "$DYLD_LIBRARY_PATH"

      cp -r . $out/share/lem

      runHook postInstall
    '';
  };
in
lem
