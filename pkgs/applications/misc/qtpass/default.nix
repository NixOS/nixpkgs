{ stdenv, lib, mkDerivation, fetchFromGitHub, fetchpatch
, git, gnupg, pass, qtbase, qtsvg, qttools, qmake
}:

mkDerivation rec {
  pname = "qtpass";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner  = "IJHack";
    repo   = "QtPass";
    rev    = "v${version}";
    sha256 = "0v3ca4fdjk6l24vc9wlc0i7r6fdj85kjmnb7jvicd3f8xi9mvhnv";
  };

  buildInputs = [ git gnupg pass qtbase qtsvg qttools ];

  nativeBuildInputs = [ qmake ];

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
    "--suffix PATH : ${lib.makeBinPath [ git gnupg pass ]}"
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
