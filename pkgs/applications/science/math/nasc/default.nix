{ stdenv
, fetchFromGitHub
, fetchpatch
, pkgconfig
, gtk3
, granite
, gnome3
, cmake
, ninja
, vala
, libqalculate
, gobjectIntrospection
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "nasc-${version}";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "parnold-x";
    repo = "nasc";
    rev = version;
    sha256 = "0p74953pdgsijvqj3msssqiwm6sc1hzp68dlmjamqrqirwgqv5aa";
  };

  patches = [
    # Install libqalculatenasc.so
    (fetchpatch {
      url = https://github.com/parnold-x/nasc/commit/93a799f9afb3e32f3f1a54e056b59570aae2e437.patch;
      sha256 = "1m32w2zaswzxnzbr7p3lf8s6fac4mjvfhm8v9k59b4jyzmvrl631";
    })
    (fetchpatch {
      url = https://github.com/parnold-x/nasc/commit/570b49169326de154af2cf43c5f12268fff1dc6d.patch;
      sha256 = "1y3w6rxn0453iscx2xg427wy1bd5kv4z1c41hhbjmg614ycp6bka";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
    vala
    cmake
    ninja
    gobjectIntrospection # for setup-hook
  ];
  buildInputs = [
    libqalculate
    gtk3
    granite
    gnome3.libgee
    gnome3.libsoup
    gnome3.gtksourceview
  ];

  meta = with stdenv.lib; {
    description = "Do maths like a normal person";
    longDescription = ''
      It’s an app where you do maths like a normal person. It lets you
      type whatever you want and smartly figures out what is math and
      spits out an answer on the right pane. Then you can plug those
      answers in to future equations and if that answer changes, so does
      the equations it’s used in.
    '';
    homepage = https://github.com/parnold-x/nasc;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
