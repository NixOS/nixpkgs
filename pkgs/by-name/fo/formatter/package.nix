{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  vala,
  pkg-config,
  pantheon,
  python3,
  replaceVars,
  glib,
  gtk3,
  dosfstools,
  e2fsprogs,
  exfat,
  hfsprogs,
  ntfs3g,
  libgee,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "formatter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Djaler";
    repo = "Formatter";
    rev = version;
    sha256 = "sha256-8lZ0jUwHuc3Kntz73Btj6dJvkW2bvShu2KWTSQszbJo=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      ext4 = "${e2fsprogs}/bin/mkfs.ext4";
      exfat = "${exfat}/bin/mkfs.exfat";
      fat = "${dosfstools}/bin/mkfs.fat";
      ntfs = "${ntfs3g}/bin/mkfs.ntfs";
      hfsplus = "${hfsprogs}/bin/mkfs.hfsplus";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    description = "Simple formatter designed for elementary OS";
    homepage = "https://github.com/Djaler/Formatter";
    maintainers = with lib.maintainers; [ xiorcale ];
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2Plus;
=======
  meta = with lib; {
    description = "Simple formatter designed for elementary OS";
    homepage = "https://github.com/Djaler/Formatter";
    maintainers = with maintainers; [ xiorcale ];
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "com.github.djaler.formatter";
  };
}
