{ mkDerivation, lib, fetchFromGitHub
, cmake, qtbase, kdnssd
}:

mkDerivation rec {
  pname = "trebleshot";
  version = "0.1.0-alpha2-15-ga7ac23c";
  # name="${pname}-${version}";

  src = fetchFromGitHub {
    owner = "genonbeta";
    repo = "TrebleShot-Desktop";
    rev = "${version}";
    sha256 = "1k8wagw6arsi1lqkhn1nl6j11mb122vi1qs0q2np6nznwfy7pn1k";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase kdnssd ];

  meta = with lib; {
    description = "Android file transferring tool for desktop";
    homepage = https://github.com/genonbeta/TrebleShot-Desktop;
    license = licenses.gpl2;

    platforms = platforms.linux;
    maintainers = with maintainers; [ woffs ];
  };
}
