{ stdenv, fetchFromGitHub, fetchhg, pidgin, glib, json-glib, mercurial, autoreconfHook } :


let
  pidginHg = fetchhg {
    url = "https://bitbucket.org/pidgin/main";
    # take from VERSION file
    rev = "c9b74a765767";
    sha256 = "07bjz87jpslsb4gdqvcwp79mkahls2mfhlmpaa5w6n4xqhahw4j3";
  };

in stdenv.mkDerivation rec {
  name = "purple-facebook-0.9.3";

  src = fetchFromGitHub {
    owner = "dequis";
    repo = "purple-facebook";
    rev = "v0.9.3-c9b74a765767";
    sha256 = "10ncvg0arcxnd3cpb0nxry1plbws0mw9vhzjrhb40sv2i563dywb";
  };

  postPatch = ''
    # we do all patching from update.sh in preAutoreconf
    echo "#!/bin/sh" > update.sh
  '';

  preAutoreconf = ''
    for FILE in $(cat MANIFEST_PIDGIN); do
        install -Dm644 "${pidginHg}/$FILE" "pidgin/$FILE" || true
    done

    touch $(cat MANIFEST_VOIDS)

    patchdir="$(pwd)/patches"
    pushd pidgin

    for patch in $(ls -1 "$patchdir"); do
      patch -p1 -i "$patchdir/$patch"
    done
    popd

    ./autogen.sh
  '';

  makeFlags = [
    "PLUGIN_DIR_PURPLE=/lib/pidgin/"
    "DATA_ROOT_DIR_PURPLE=/share"
  ];

  installPhase = ''
    mkdir -p $out/lib/purple-2
    cp pidgin/libpurple/protocols/facebook/.libs/*.so $out/lib/purple-2/
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [pidgin glib json-glib mercurial];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Facebook protocol plugin for libpurple";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davorb ];
  };
}
