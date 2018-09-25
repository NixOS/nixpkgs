{ stdenv, fetchFromGitHub, fetchpatch, vala, pkgconfig, meson, ninja, python3
, granite, gtk3, desktop-file-utils, gnome3, gtksourceview, webkitgtk, gtkspell3
, discount, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "quilter";
  version = "1.6.3";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "1wa0i6dgg6fgb7q9z33v9qmn1a1dn3ik58v1f3a49dvd5xyf8q6q";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    discount
    granite
    gtk3
    gtksourceview
    gtkspell3
    webkitgtk
    gnome3.libgee
  ];

  patches = [
    # Fix build with vala 0.42 - Drop these in next release
    (fetchpatch {
      url = "https://github.com/lainsce/quilter/commit/a58838213cd7f2d33048c7b34b96dc8875612624.patch";
      sha256 = "1a4w1zql4zfk8scgrrssrm9n3sh5fsc1af5zvrqk8skbv7f2c80n";
    })
    (fetchpatch {
      url = "https://github.com/lainsce/quilter/commit/d1800ce830343a1715bc83da3339816554896be5.patch";
      sha256 = "0xl5iz8bgx5661vbbq8qa1wkfvw9d3da67x564ckjfi05zq1vddz";
    })
    # Correct libMarkdown dependency discovery: See https://github.com/lainsce/quilter/pull/170
    (fetchpatch {
      url = "https://github.com/lainsce/quilter/commit/8b1f3a60bd14cb86c1c62f9917c5f0c12bc4e459.patch";
      sha256 = "1kjc6ygf9yjvqfa4xhzxiava3338swp9wbjhpfaa3pyz3ayh188n";
    })
    # post_install script cleanups: See https://github.com/lainsce/quilter/pull/171
    (fetchpatch {
      url = "https://github.com/lainsce/quilter/commit/55bf3b10cd94fcc40b0867bbdb1931a09f577922.patch";
      sha256 = "1330amichaif2qfrh4qkxwqbcpr87ipik7vzjbjdm2bv3jz9353r";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Focus on your writing - designed for elementary OS";
    homepage    = https://github.com/lainsce/quilter;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
