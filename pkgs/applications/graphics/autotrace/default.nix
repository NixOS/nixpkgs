{ stdenv, fetchurl, callPackage, libpng12, imagemagick,
  autoreconfHook, glib, pstoedit, pkgconfig, gettext, gd, darwin }:

# TODO: Figure out why the resultant binary is somehow linked against
# libpng16.so.16 rather than libpng12.

stdenv.mkDerivation rec {
  name = "autotrace-${version}";
  version = "0.31.1";

  src = fetchurl {
    url = "mirror://sourceforge/autotrace/AutoTrace/0.31.1/${name}.tar.gz";
    sha256 = "1xmgja5fv48mdbsa51inf7ksz36nqd6bsaybrk5xgprm6cy946js";
  };

  # The below commented out part is for an identically-named project
  # on GitHub which appears to derive somehow from the Sourceforge
  # version, but I have no idea what the lineage is of this project.
  # It will build, but it segfaults when I attempt to run -centerline.
  # Someone may need this for some reason, so I've left it here.
  #
  #src = fetchFromGitHub {
  #  owner = "autotrace";
  #  repo = "autotrace";
  #  rev = "b3ac8818d86943102cb4f13734e0b527c42dc45a";
  #  sha256 = "0z5h2mvxwckk2msi361zk1nc9fdcvxyimyc2hlyqd6h8k3p7zdi4";
  #};
  #postConfigure = ''
  #  sed -i -e "s/at_string/gchar */g" *.c
  #  sed -i -e "s/at_address/gpointer/g" *.c
  #  sed -i -e "s/at_bitmap_type/struct _at_bitmap/g" *.c
  #  sed -i -e "s/AT_BITMAP_BITS(bitmap)/AT_BITMAP_BITS(\&bitmap)/g" input-magick.c
  #'';

  autofig = callPackage ./autofig.nix {};
  nativeBuildInputs = [ autoreconfHook glib autofig pkgconfig gettext ];
  buildInputs = [ libpng12 imagemagick pstoedit ]
    ++ stdenv.lib.optionals stdenv.isDarwin
       (with darwin.apple_sdk.frameworks; [ gd ApplicationServices ]);

  postUnpack = ''
    pushd $sourceRoot
    autofig autotrace-config.af
    popd
  '';

  # This complains about various m4 files, but it appears to not be an
  # actual error.
  preConfigure = ''
    glib-gettextize --copy --force
    # pstoedit-config no longer exists, it was replaced with pkg-config
    mkdir wrappers
    cat >wrappers/pstoedit-config <<'EOF'
    #!${stdenv.shell}
    # replace --version with --modversion for pkg-config
    args=''${@/--version/--modversion}
    exec pkg-config pstoedit "''${args[@]}"
    EOF
    chmod +x wrappers/pstoedit-config
    export PATH="$PATH:$PWD/wrappers"
  '';

  meta = with stdenv.lib; {
    homepage = http://autotrace.sourceforge.net/;
    description = "Utility for converting bitmap into vector graphics";
    platforms = platforms.unix;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.gpl2;
    knownVulnerabilities = [
      "CVE-2013-1953"
      "CVE-2016-7392"
      "CVE-2017-9151"
      "CVE-2017-9152"
      "CVE-2017-9153"
      "CVE-2017-9154"
      "CVE-2017-9155"
      "CVE-2017-9156"
      "CVE-2017-9157"
      "CVE-2017-9158"
      "CVE-2017-9159"
      "CVE-2017-9160"
      "CVE-2017-9161"
      "CVE-2017-9162"
      "CVE-2017-9163"
      "CVE-2017-9164"
      "CVE-2017-9165"
      "CVE-2017-9166"
      "CVE-2017-9167"
      "CVE-2017-9168"
      "CVE-2017-9169"
      "CVE-2017-9170"
      "CVE-2017-9171"
      "CVE-2017-9172"
      "CVE-2017-9173"
      "CVE-2017-9174"
      "CVE-2017-9175"
      "CVE-2017-9176"
      "CVE-2017-9177"
      "CVE-2017-9178"
      "CVE-2017-9179"
      "CVE-2017-9180"
      "CVE-2017-9181"
      "CVE-2017-9182"
      "CVE-2017-9183"
      "CVE-2017-9184"
      "CVE-2017-9185"
      "CVE-2017-9186"
      "CVE-2017-9187"
      "CVE-2017-9188"
      "CVE-2017-9189"
      "CVE-2017-9190"
      "CVE-2017-9191"
      "CVE-2017-9192"
      "CVE-2017-9193"
      "CVE-2017-9194"
      "CVE-2017-9195"
      "CVE-2017-9196"
      "CVE-2017-9197"
      "CVE-2017-9198"
      "CVE-2017-9199"
      "CVE-2017-9200"
    ];
  };
}
