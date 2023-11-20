{ lib, mkDerivation, fetchFromGitHub
, git, gnupg, pass, pwgen, qrencode
, fetchpatch
, qtbase, qtsvg, qttools, qmake
}:

mkDerivation rec {
  pname = "qtpass";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner  = "IJHack";
    repo   = "QtPass";
    rev    = "v${version}";
    sha256 = "0748hjvhjrybi33ci3c8hcr74k9pdrf5jv8npf9hrsrmdyy1kr9x";
  };

  postPatch = ''
    substituteInPlace src/qtpass.cpp \
      --replace "/usr/bin/qrencode" "${qrencode}/bin/qrencode"
  '';

  buildInputs = [ git gnupg pass qtbase qtsvg ];

  nativeBuildInputs = [ qmake qttools ];

  patches = [
    # Fix path to pass-otp plugin `/usr/lib/password-store/extensions/otp.bash` being hardcoded.
    # TODO: Remove when https://github.com/IJHack/QtPass/pull/499 is merged and available.
    (fetchpatch {
      name = "qtpass-Dont-hardcode-pass-otp-usr-lib-path.patch";
      url = "https://github.com/IJHack/QtPass/commit/2ca9f0ec5a8d709c97a2433c5cd814040c82d4f3.patch";
      sha256 = "0ljlvqxvarrz2a4j71i66aflrxi84zirb6cg9kvygnvhvm1zbc7d";
    })
  ];

  # HACK `propagatedSandboxProfile` does not appear to actually propagate the sandbox profile from `qt5.qtbase`
  sandboxProfile = toString qtbase.__propagatedSandboxProfile;

  qmakeFlags = [
    # setup hook only sets QMAKE_LRELEASE, set QMAKE_LUPDATE too:
    "QMAKE_LUPDATE=${qttools.dev}/bin/lupdate"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ git gnupg pass pwgen ]}"
  ];

  postInstall = ''
    install -D qtpass.desktop -t $out/share/applications
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
    install -D qtpass.1 -t $out/share/man/man1
  '';

  meta = with lib; {
    description = "A multi-platform GUI for pass, the standard unix password manager";
    homepage = "https://qtpass.org";
    license = licenses.gpl3;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.all;
  };
}
