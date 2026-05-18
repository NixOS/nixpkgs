{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  replaceVars,
  pkgs,
  passage,
  age,
  unixtools,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  qrencode ? null,
  wl-clipboard ? null,
  git ? null,
  xclip ? null,
  # Used to pretty-print list of all stored passwords, but is not needed to fetch
  # or store password by its name. Most users would want this dependency.
  tree ? null,
}:
let
  passageExtensions = import ./extensions {
    inherit pkgs;
  };
  env =
    extensions:
    let
      selected = [
        passage
      ]
      ++ (map (
        ext:
        ext.overrideAttrs (
          eold:
          let
            name = lib.last (lib.splitString "-" eold.pname);
          in
          {
            postFixup = ''
              mkdir -p $out/lib/passage/extensions
              mv $out/lib/password-store/extensions/${name}.bash $out/lib/passage/extensions/${name}.bash
              substituteInPlace $out/lib/passage/extensions/${name}.bash \
                --replace '$EXTENSIONS' "$out/lib/passage/extensions/"
              rm $out/lib/password-store -r
            '';
          }
        )
      ) (extensions passageExtensions));
      # ++ lib.optional tombPluginSupport passExtensions.tomb;
    in
    pkgs.buildEnv {
      name = "passage-env";
      paths = selected;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildInputs = lib.concatMap (x: x.buildInputs) selected;

      postBuild = ''
        files=$(find $out/bin/ -type f -exec readlink -f {} \;)
        if [ -L $out/bin ]; then
          rm $out/bin
          mkdir $out/bin
        fi

        for i in $files; do
          if ! [ "$(readlink -f "$out/bin/$(basename $i)")" = "$i" ]; then
            ln -sf $i $out/bin/$(basename $i)
          fi
        done

        wrapProgram $out/bin/passage \
          --set SYSTEM_EXTENSION_DIR "$out/lib/passage/extensions" \
          --set PASSWORD_STORE_ENABLE_EXTENSIONS true \
      '';
      meta.mainProgram = "passage";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "passage";
  version = "1.7.4a2";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "passage";
    rev = "${finalAttrs.version}";
    hash = "sha256-tGHJFzDc2K117r5EMFdKsfw/+EpdZ0qzaExt+RGI4qo=";
  };

  patches = [
    (replaceVars ./darwin-getopt-path.patch {
      getopt = unixtools.getopt;
    })
    ./set-correct-program-name-for-sleep.patch
    ./extension-dir.patch
  ];
  postPatch = ''
    substituteInPlace src/password-store.sh \
      --replace-fail "@out@" "$out"'';

  nativeBuildInputs = [ makeBinaryWrapper ];

  extraPath = lib.makeBinPath (
    [
      age
      coreutils
      findutils
      unixtools.getopt
      git
      gnugrep
      gnused
      qrencode
      tree
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      wl-clipboard
      xclip
    ]
  );

  # Using $0 is bad, it causes --help to mention ".passage-wrapped".
  postInstall = ''
    substituteInPlace $out/bin/passage \
              --replace-fail 'PROGRAM="''${0##*/}"' 'PROGRAM=passage' \
              --replace-fail 'AGE="''${PASSAGE_AGE:-age}"' 'AGE=''${PASSAGE_AGE-${lib.getExe age}}'
    wrapProgram $out/bin/passage --prefix PATH : $extraPath --argv0 $pname
  '';

  installFlags = [
    "PREFIX=$(out)"
    "WITH_ALLCOMP=yes"
  ];
  passthru = {
    extensions = passageExtensions;
    withExtensions = env;
  };

  meta = {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage = "https://github.com/FiloSottile/passage";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      kaction
      ma27
    ];
    platforms = lib.platforms.unix;
    mainProgram = "passage";

    longDescription = ''
      passage is a fork of password-store (https://www.passwordstore.org) that uses
      age (https://age-encryption.org) as a backend instead of GnuPG.

      It keeps passwords inside age(1) encrypted files inside a simple
      directory tree and provides a series of commands for manipulating the
      password store, allowing the user to add, remove, edit and synchronize
      passwords.
    '';
  };
})
