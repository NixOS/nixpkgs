{ stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, vala
, pkgconfig
, pantheon
, python3
, gettext
, glib
, gtk3
, libgee
, wrapGAppsHook }:

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
    pkgconfig
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
    substituteInPlace data/com.github.arshubham.cipher.desktop.in \
      --replace "gio" "${glib.bin}/bin/gio"
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A simple application for encoding and decoding text, designed for elementary OS";
    homepage = "https://github.com/arshubham/cipher";
    maintainers = with maintainers; [ xiorcale ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
