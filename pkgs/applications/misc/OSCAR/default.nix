{ stdenv, mkDerivation, fetchFromGitLab, qmake, qtbase, qttools, qtserialport, libGLU }:
mkDerivation rec {
  pname = "OSCAR";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "pholy";
    repo = "OSCAR-code";
    rev = "v${version}";
    sha256 = "10r37d8c2avr167n2s9lhld1c9hmckm444fq163z1jsy9jpid6mg";
  };

  buildInputs = [ qtbase qttools qtserialport libGLU ];
  nativeBuildInputs = [ qmake ];
  postPatch = ''
    substituteInPlace oscar/oscar.pro --replace "/bin/bash" "${stdenv.shell}"
  '';

  qmakeFlags = [ "OSCAR_QT.pro" ];

  installPhase = ''
    install -d $out/bin
    install -d $out/share/OSCAR/Help
    install -d $out/share/OSCAR/Html
    install -d $out/share/OSCAR/Translations
    install -d $out/share/icons/OSCAR
    install -d $out/share/applications
    install -T oscar/OSCAR $out/bin/OSCAR
    # help browser was removed 'temporarily' in https://gitlab.com/pholy/OSCAR-code/-/commit/57c3e4c33ccdd2d0eddedbc24c0e4f2969da3841
    # install oscar/Help/* $out/share/OSCAR/Help
    install oscar/Html/* $out/share/OSCAR/Html
    install oscar/Translations/* $out/share/OSCAR/Translations
    install -T Building/Linux/OSCAR.png $out/share/icons/OSCAR/OSCAR.png
    install -T Building/Linux/OSCAR.desktop $out/share/applications/OSCAR.desktop
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.sleepfiles.com/OSCAR/";
    description = "Software for reviewing and exploring data produced by CPAP and related machines used in the treatment of sleep apnea";
    license = licenses.gpl3;
    maintainers = [ maintainers.roconnor ];
    # Someone needs to create a suitable installPhase for Darwin and Windows.
    # See https://gitlab.com/pholy/OSCAR-code/-/tree/master/Building.
    broken = !stdenv.hostPlatform.isLinux;
  };
}
