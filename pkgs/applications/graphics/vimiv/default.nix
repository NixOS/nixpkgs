{ lib, python3Packages, fetchFromGitHub, imagemagick, librsvg, gtk3, jhead
, hicolor_icon_theme, defaultIconTheme

# Test requirements
, dbus, xvfb_run, xdotool
}:

python3Packages.buildPythonApplication rec {
  name = "vimiv";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "karlch";
    repo = "vimiv";
    rev = "v${version}";
    sha256 = "18dn81n8hcrqhrqfida34qz7a0ar9rz2rrmzsvyp54zc6nyvv1cn";
  };

  testimages = fetchFromGitHub {
    owner = "karlch";
    repo = "vimiv";
    rev = "6f4d1372b27f2065c56eafdb521d230d9bb8f4e2";
    sha256 = "0a3aybzpms0381dz9japhm4c7j5klhmw91prcac6zaww6x34nmxb";
  };

  postPatch = ''
    patchShebangs scripts/install_icons.sh
    sed -i -e 's,/usr,,g' -e '/setup\.py/d' Makefile scripts/install_icons.sh

    sed -i \
      -e 's,/etc/vimiv/\(vimivrc\|keys\.conf\),'"$out"'&,g' \
      man/* vimiv/parser.py

    sed -i \
      -e 's!"mogrify"!"${imagemagick}/bin/mogrify"!g' \
      -e '/cmd *=/s!"jhead"!"${jhead}/bin/jhead"!g' \
      vimiv/imageactions.py
  '';

  checkInputs = [ python3Packages.nose dbus.daemon xvfb_run xdotool ];
  buildInputs = [ hicolor_icon_theme defaultIconTheme librsvg ];
  propagatedBuildInputs = with python3Packages; [ pillow pygobject3 gtk3 ];

  makeWrapperArgs = [
    "--prefix GI_TYPELIB_PATH : \"$GI_TYPELIB_PATH\""
    "--suffix XDG_DATA_DIRS : \"$XDG_ICON_DIRS:$out/share\""
    "--set GDK_PIXBUF_MODULE_FILE \"$GDK_PIXBUF_MODULE_FILE\""
  ];

  postCheck = ''
    # Some tests assume that the directory only contains one vimiv directory
    rm -rf vimiv.egg-info vimiv.desktop

    # Re-use the wrapper args from the main program
    makeWrapper "$SHELL" run-tests $makeWrapperArgs

    cp -Rd --no-preserve=mode "$testimages/testimages" vimiv/testimages
    HOME="$(mktemp -d)" PATH="$out/bin:$PATH" \
      xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      ./run-tests -c 'python tests/main_test.py && nosetests -vx'
  '';

  postInstall = "make DESTDIR=\"$out\" install";

  meta = {
    homepage = "https://github.com/karlch/vimiv";
    description = "An image viewer with Vim-like keybindings";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    broken = true;
  };
}
