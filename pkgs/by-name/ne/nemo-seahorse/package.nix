{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  gtk3,
  python3,
  wrapGAppsHook3,
  gnupg,
  file-roller,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
      pygobject3
      gpg
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nemo-seahorse";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    tag = finalAttrs.version;
    hash = "sha256-dadQnR6YNm6rC6qT0MGssSXu37ST1kZQVGIupB0nA7Q=";
  };

  sourceRoot = "${finalAttrs.src.name}/nemo-seahorse";

  nativeBuildInputs = [
    glib
    meson
    ninja
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    pythonEnv
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ file-roller ]}"
    )
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-seahorse";
    changelog = "https://github.com/linuxmint/nemo-extensions/blob/master/nemo-seahorse/ChangeLog";
    description = "Nemo seahorse action";
    longDescription = ''
      nemo-seahorse is a Nemo action which allows encryption and
      decryption of OpenPGP files using GnuPG.

      To use this, add nemo-seahorse directly to environment.systemPackages
      instead of overriding nemo-with-extensions.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
