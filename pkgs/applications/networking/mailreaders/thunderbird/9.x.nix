{ stdenv, fetchurl, pkgconfig, gtk, perl, python, zip, unzip
, libIDL, dbus_glib, bzip2, alsaLib, nspr, yasm, mesa, nss
, libnotify, cairo, pixman, fontconfig
, libjpeg

, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Shredder", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false

}:

let version = "9.0.1";

    # This patch may become necessary when we use a more recent version of libpng
    # for now, it's actually not needed
    # pngPatch = fetchurl {
    #   url = http://www.linuxfromscratch.org/patches/blfs/svn/thunderbird-9.0.1-libpng-1.5-1.patch;
    #   sha256 = "8454bdde3be8dc37c9f5e6f597914f0a585ff4b357d3fc86c6c9f80208b6068d";
    # };
in

stdenv.mkDerivation {
  name = "thunderbird-${version}";

  src = fetchurl {
    url = "http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.bz2";
    sha256 = "4fc392915e22b81ef0bd08e6e2d8d0348e66f0930f35bf8ac47eb49f64453e2d";
  };

  enableParallelBuilding = true;

  buildInputs =
    [ pkgconfig perl python zip unzip bzip2 gtk dbus_glib alsaLib libIDL nspr
      libnotify cairo pixman fontconfig yasm mesa /* nss */
      libjpeg
    ];

  # fix some paths in pngPatch
  # prePatch = ''
  #   substitute ${pngPatch} png.patch --replace "mozilla-release/modules/" "comm-release/mozilla/modules/"
  #   '';

  patches = [
    # "png.patch" # produced by postUnpack

    # Fix weird dependencies such as a so file which depends on "-lpthread".
    # ./thunderbird-build-deps.patch
  ];

  configureFlags =
    [ "--enable-application=mail"
      "--enable-optimize"
      "--with-pthreads"
      "--disable-debug"
      "--enable-strip"
      "--with-pthreads"
      "--with-system-jpeg"
      # "--with-system-png"  # png 1.5.x not merged in nixpkgs yet
      "--with-system-zlib"
      "--with-system-bz2"
      "--with-system-nspr"
      "--enable-system-cairo"
      "--disable-crashreporter"
      "--disable-necko-wifi"
      "--disable-webm"
      "--disable-tests"
      "--enable-calendar"
    ]
    ++ stdenv.lib.optional enableOfficialBranding "--enable-official-branding";

  # The Thunderbird Makefiles refer to the variables LIBXUL_DIST,
  # prefix, and PREFIX in some places where they are not set.  In
  # particular, there are some linker flags like
  # `-rpath-link=$(LIBXUL_DIST)/bin'.  Since this expands to
  # `-rpath-link=/bin', the build fails due to the purity checks in
  # the ld wrapper.  So disable the purity check for now.
  preBuild = "NIX_ENFORCE_PURITY=0";

  # This doesn't work:
  #makeFlags = "LIBXUL_DIST=$(out) prefix=$(out) PREFIX=$(out)";

  postInstall =
    ''
      # Fix some references to /bin paths in the Xulrunner shell script.
      substituteInPlace $out/lib/thunderbird-*/thunderbird \
          --replace /bin/pwd "$(type -tP pwd)" \
          --replace /bin/ls "$(type -tP ls)"

      # Create a desktop item.
      ensureDir $out/share/applications
      cat > $out/share/applications/thunderbird.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/thunderbird
      Icon=$out/lib/thunderbird-${version}/chrome/icons/default/default256.png
      Name=Thunderbird
      GenericName=Mail Reader
      Categories=Application;Network;
      EOF
    '';

  meta = with stdenv.lib; {
    description = "Mozilla Thunderbird, a full-featured email client";
    homepage = http://www.mozilla.org/thunderbird/;
    license =
      # Official branding implies thunderbird name and logo cannot be reuse,
      # see http://www.mozilla.org/foundation/licensing.html
      if enableOfficialBranding then licenses.proprietary else licenses.mpl11;
    maintainers = with maintainers; [ pierron ];
    platforms = with platforms; linux;
  };
}
