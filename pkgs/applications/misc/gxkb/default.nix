{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gtk3, libwnck, libxklavier
, appindicatorSupport ? true, libayatana-appindicator-gtk3
}:

stdenv.mkDerivation rec {
  pname = "gxkb";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "zen-tools";
    repo = "gxkb";
    rev = "v${version}";
    sha256 = "sha256-9r1eZl7PgIt2ZpK+QQHaa460imIHT3Lh5mpzcFglyWc=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ gtk3 libwnck libxklavier ] ++ lib.optional appindicatorSupport libayatana-appindicator-gtk3;

  configureFlags = lib.optional appindicatorSupport "--enable-appindicator=yes";
  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "X11 keyboard indicator and switcher";
    homepage = "https://zen-tools.github.io/gxkb/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.omgbebebe ];
    platforms = platforms.linux;
  };
}
