{ lib, stdenv, fetchFromGitHub, fetchhg, pidgin, glib, json-glib, autoreconfHook }:


let
  pidginHg = fetchhg {
    url = "https://bitbucket.org/pidgin/main";
    # take from VERSION file
    rev = "9ff9acf9fa14";
    sha256 = "06imlhsps4wrjgjb92zpaxprxfxl2pjb2x9pl859c8cryssrz2jv";
  };

in stdenv.mkDerivation rec {
  pname = "purple-facebook";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "dequis";
    repo = "purple-facebook";
    rev = "v${version}-9ff9acf9fa14";
    sha256 = "0a1860bkzrmyxahm9rlxi80z335w491wzdaqaw6j9ccavbymhwhs";
  };

  postPatch = ''
    # we do all patching from update.sh in preAutoreconf
    echo "#!${stdenv.shell}" > update.sh
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
  buildInputs = [ pidgin glib json-glib ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Facebook protocol plugin for libpurple";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davorb ];
  };
}
