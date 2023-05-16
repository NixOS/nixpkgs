{ lib
, stdenv
, fetchFromGitLab
, fetchpatch2
, docbook-xsl-nons
, docutils
, gi-docgen
, gobject-introspection
, gtk-doc
, libxslt
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook
, glib
, gsound
, json-glib
, libgudev
, dbus
}:

let
  themes = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd-device-themes";
    rev = "v0.1.0";
    sha256 = "sha256-YK9fJ3awmhf1FAhdz95T/POivSO93jsNApm+u4OOZ80=";
  };
in
stdenv.mkDerivation rec {
  pname = "feedbackd";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "feedbackd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-l5rfMx3ElW25A5WVqzfKBp57ebaNC9msqV7mvnwv10s=";
    fetchSubmodules = true;
  };

=======
    hash = "sha256-7H5Ah4zo+wLKd0WoKoOgtIm7HcUSw8PTf/KzBlY75oc=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch2 {
      url = "https://source.puri.sm/Librem5/feedbackd/-/merge_requests/109.patch";
      hash = "sha256-z3Ud6P2GHYOaGA2vJDD3Sz47+M8p0VcYZ5gbYcGydMk=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    docutils # for rst2man
    gi-docgen
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsound
    json-glib
    libgudev
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dman=true"
  ];

  nativeCheckInputs = [
    dbus
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    sed "s|/usr/libexec/|$out/libexec/|" < $src/debian/feedbackd.udev > $out/lib/udev/rules.d/90-feedbackd.rules
    cp ${themes}/data/* $out/share/feedbackd/themes/
  '';

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    if [[ -d "$out/share/doc" ]]; then
        find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
          | while IFS= read -r -d ''' file; do
            moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
        done
    fi
  '';

  meta = with lib; {
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 tomfitzhenry ];
    platforms = platforms.linux;
  };
}
