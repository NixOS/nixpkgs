{
  lib,
  stdenv,
  fetchFromGitLab,
  python3,
  librsync,
  glib,
  ncftp,
  gnupg,
  gnutar,
  par2cmdline,
  util-linux,
  rsync,
  makeWrapper,
  wrapGAppsNoGuiHook,
  gettext,
  getconf,
  testers,
  nix-update-script,
}:

let
  self = python3.pkgs.buildPythonApplication rec {
    pname = "duplicity";
    version = "3.0.4";

    src = fetchFromGitLab {
      owner = "duplicity";
      repo = "duplicity";
      rev = "rel.${version}";
      hash = "sha256-FoaKuB0mo2RFksMHnIUx984+h/U0tdvk+bvsuYt3r5g=";
    };

    patches = [
      ./keep-pythonpath-in-testing.patch
    ];

    postPatch =
      ''
        patchShebangs duplicity/__main__.py

        # don't try to use gtar on darwin/bsd
        substituteInPlace testing/functional/test_restart.py \
          --replace-fail 'tarcmd = "gtar"' 'tarcmd = "tar"'
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        # tests try to access these files in the sandbox, but can't deal with EPERM
        substituteInPlace testing/unit/test_globmatch.py \
          --replace-fail /var/log /test/log
        substituteInPlace testing/unit/test_selection.py \
          --replace-fail /usr/bin /dev
      '';

    disabledTests = [
      # fails on some unsupported backends, e.g.
      # ************* Module duplicity.backends.swiftbackend
      # duplicity/backends/swiftbackend.py:176: [E0401(import-error), SwiftBackend._put] Unable to import 'swiftclient.service'
      "test_pylint"
    ];

    nativeBuildInputs = [
      makeWrapper
      gettext
      python3.pkgs.wrapPython
      wrapGAppsNoGuiHook
      python3.pkgs.setuptools-scm
      python3.pkgs.pycodestyle
      python3.pkgs.black
      python3.pkgs.pylint
    ];

    buildInputs = [
      librsync
      # For Gio typelib
      glib
    ];

    pythonPath =
      with python3.pkgs;
      [
        b2sdk
        boto3
        cffi
        cryptography
        ecdsa
        idna
        pygobject3
        fasteners
        lockfile
        paramiko
        pyasn1
        pycrypto
        # Currently marked as broken.
        # pydrive2
        future
      ]
      ++ paramiko.optional-dependencies.invoke;

    nativeCheckInputs =
      [
        gnupg # Add 'gpg' to PATH.
        gnutar # Add 'tar' to PATH.
        librsync # Add 'rdiff' to PATH.
        par2cmdline # Add 'par2' to PATH.
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        util-linux # Add 'setsid' to PATH.
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        getconf
      ]
      ++ (with python3.pkgs; [
        lockfile
        mock
        pexpect
        pytestCheckHook
        fasteners
      ]);

    # Prevent double wrapping, let the Python wrapper use the args in preFixup.
    dontWrapGApps = true;

    preFixup =
      let
        binPath = lib.makeBinPath (
          [
            gnupg
            ncftp
            rsync
          ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            getconf
          ]
        );
      in
      ''
        makeWrapperArgsBak=("''${makeWrapperArgs[@]}")
        makeWrapperArgs+=(
          "''${gappsWrapperArgs[@]}"
          --prefix PATH : "${binPath}"
        )
      '';

    postFixup = ''
      # Restore previous value for tests wrapping in preInstallCheck
      makeWrapperArgs=("''${makeWrapperArgsBak[@]}")
    '';

    preCheck = ''
      # tests need writable $HOME
      HOME=$PWD/.home

      wrapPythonProgramsIn "$PWD/testing/overrides/bin" "$pythonPath"
    '';

    doCheck = true;

    passthru = {
      updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "rel\\.(.*)"
        ];
      };

      tests.version = testers.testVersion {
        package = self;
      };
    };

    meta = with lib; {
      changelog = "https://gitlab.com/duplicity/duplicity/-/blob/${src.rev}/CHANGELOG.md";
      description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
      homepage = "https://duplicity.gitlab.io/duplicity-web/";
      license = licenses.gpl2Plus;
      mainProgram = "duplicity";
      maintainers = with maintainers; [ corngood ];
    };
  };

in
self
