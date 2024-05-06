{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, vala
, pkg-config
, pantheon
, python3
, gettext
, glib
, gtk3
, libgee
, wrapGAppsHook3 }:

stdenv.mkDerivation rec {
  pname = "cipher";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "arshubham";
    repo = "cipher";
    rev = version;
    sha256 = "00azc5ck17zkdypfza6x1viknwhimd9fqgk2ybff3mx6aphmla7a";
  };

  nativeBuildInputs = [
    gettext
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
    pantheon.granite
    libgee
  ];

  postPatch = ''
    substituteInPlace data/com.github.arshubham.cipher.desktop.in \
      --replace "gio" "${glib.bin}/bin/gio"
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A simple application for encoding and decoding text, designed for elementary OS";
    homepage = "https://github.com/arshubham/cipher";
    maintainers = with maintainers; [ xiorcale ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "com.github.arshubham.cipher";
  };
}
