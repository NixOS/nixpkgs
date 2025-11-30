{
  lib,
  buildFHSEnv,
  fetchFromGitHub,
  ocl-icd,
  openssl,
  re2,
  libevent,
  git,
  versionCheckHook,
  zlib,
  expat,
  scons,
  stdenv,
  extraPkgs ? [ ],
}:
let
  pname = "fah-client";
  version = "8.5.3";

  cbangSrc = fetchFromGitHub {
    owner = "cauldrondevelopmentllc";
    repo = "cbang";
    tag = "bastet-v${version}";
    hash = "sha256-RU13qT9UQ1uNsRNBaEGSWTgNmE3f72veabl2OmKK6Z0=";
  };

  fah-client = stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "FoldingAtHome";
      repo = "fah-client-bastet";
      tag = "v${version}";
      hash = "sha256-PBguylWnYU5iTzrjWA1B5Iwb57JpoWGPSpjgNJP3aoI=";
    };

    nativeBuildInputs = [
      scons
      re2
      libevent
      git
    ];

    buildInputs = [ openssl ];

    postUnpack = ''
      export CBANG_HOME=$NIX_BUILD_TOP/cbang

      cp -r --no-preserve=mode ${cbangSrc} $CBANG_HOME
    '';

    preBuild = ''
      scons -C $CBANG_HOME
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/applications}

      cp fah-client $out/bin/fah-client

      cp install/lin/fah-client.desktop.in $out/share/applications/fah-client.desktop
      sed \
        -e "s|Icon=.*|Icon=$out/share/feh-client/images/fahlogo.png|g" \
        -e "s|%(PACKAGE_URL)s|https://github.com/FoldingAtHome/fah-client-bastet|g" \
        -i $out/share/applications/fah-client.desktop

      runHook postInstall
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

  };
in
buildFHSEnv {
  inherit pname version;

  targetPkgs =
    _:
    [
      fah-client
      ocl-icd
      zlib
      expat
    ]
    ++ extraPkgs;

  runScript = "/bin/fah-client";

  meta = {
    description = "Folding@home client";
    homepage = "https://foldingathome.org/";
    license = lib.licenses.gpl3;
    mainProgram = "fah-client";
    maintainers = [ lib.maintainers.GaetanLepage ];
    platforms = [ "x86_64-linux" ];
  };
}
