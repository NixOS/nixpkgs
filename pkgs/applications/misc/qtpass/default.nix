{ stdenv, mkDerivation, fetchFromGitHub, fetchpatch
, git, gnupg, pass, qtbase, qtsvg, qttools, qmake, makeWrapper
}:

mkDerivation rec {
  pname = "qtpass";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner  = "IJHack";
    repo   = "QtPass";
    rev    = "v${version}";
    sha256 = "1vfhfyccrxq9snyvayqfzm5rqik8ny2gysyv7nipc91kvhq3bhky";
  };

  buildInputs = [ git gnupg pass qtbase qtsvg qttools ];

  nativeBuildInputs = [ makeWrapper qmake ];

  # Fix missing app icon on Wayland. Has been upstreamed and should be safe to
  # remove in versions > 1.3.0
  patches = [
    (fetchpatch {
      url = "https://github.com/IJHack/QtPass/commit/aba8c4180f0ab3d66c44f88b21f137b19d17bde8.patch";
      sha256 = "009bcq0d75khmaligzd7736xdzy6a8s1m9dgqybn70h801h92fcr";
    })
  ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    "--suffix PATH : ${git}/bin"
    "--suffix PATH : ${gnupg}/bin"
    "--suffix PATH : ${pass}/bin"
  ];

  postInstall = ''
    install -D qtpass.desktop $out/share/applications/qtpass.desktop
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform GUI for pass, the standard unix password manager";
    homepage = https://qtpass.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.all;
  };
}
