{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, vala
, meson
, ninja
, pkg-config
, pantheon
, python3
, gettext
, glib
, gtk3
, libgee
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appeditor";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "donadigo";
    repo = "appeditor";
    rev = version;
    sha256 = "sha256-0zutz1nnThyF7h44cDxjE53hhAJfJf6DTs9p4HflXr8=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    pantheon.granite
    libgee
  ];

  postPatch = ''
    # Fix build with vala 0.56
    # https://github.com/donadigo/appeditor/pull/122
    substituteInPlace src/Application.vala \
      --replace "private static string? create_exec_filename;" "public static string? create_exec_filename;"

    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Edit the Pantheon desktop application menu";
    homepage = "https://github.com/donadigo/appeditor";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "com.github.donadigo.appeditor";
  };
}
