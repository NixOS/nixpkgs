{
  lib,
  stdenv,
  fetchFromGitLab,
  xdg-utils,
}:

stdenv.mkDerivation rec {
  pname = "anarchism";
  version = "15.3-1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = pname;
    rev = "debian/${version}";
    sha256 = "04ylk0y5b3jml2awmyz7m1hnymni8y1n83m0k6ychdh0px8frhm5";
  };

  postPatch = ''
    substituteInPlace debian/anarchism.desktop \
      --replace "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open"
    substituteInPlace debian/anarchism.desktop \
      --replace "file:///usr" "file://$out"
  '';

  installPhase = ''
    mkdir -p $out/share/doc/anarchism $out/share/applications $out/share/icons/hicolor/scalable/apps
    cp -r {html,markdown} $out/share/doc/anarchism
    cp debian/anarchism.svg $out/share/icons/hicolor/scalable/apps
    cp debian/anarchism.desktop $out/share/applications
  '';

  meta = with lib; {
    homepage = "http://www.anarchistfaq.org/";
    changelog = "http://anarchism.pageabode.com/afaq/new.html";
    description = "Exhaustive exploration of Anarchist theory and practice";
    longDescription = ''
      The Anarchist FAQ is an excellent source of information regarding Anarchist
      (libertarian socialist) theory and practice. It covers all major topics,
      from the basics of Anarchism to very specific discussions of politics,
      social organization, and economics.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ davidak ];
    platforms = with platforms; all;
  };
}
