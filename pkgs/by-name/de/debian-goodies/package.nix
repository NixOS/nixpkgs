{
  lib,
  stdenv,
  fetchFromGitLab,
  curl,
  dialog,
  installShellFiles,
  perl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "debian-goodies";
  version = "0.88.2";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "debian-goodies";
    tag = "debian/${version}";
    sha256 = "sha256-KPPRxYmCEYwlUAR29tc8w4rerXpswO/rbpEjXPoDV4Q=";
  };

  postPatch = ''
    substituteInPlace debmany/debmany \
      --replace "/usr/bin/dialog" "${dialog}/bin/dialog" \
      --replace "/usr/bin/whiptail" "${python3.pkgs.snack}/bin/whiptail"

    substituteInPlace dman \
      --replace "curl" "${curl}/bin/curl"
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    perl
    python3
  ];

  installPhase = ''
    runHook preInstall

    # see https://salsa.debian.org/debian/debian-goodies/-/blob/master/debian/install
    for bin in checkrestart dgrep dglob debget dpigs debman dman popbugs which-pkg-broke which-pkg-broke-build dhomepage debmany/debmany check-enhancements find-dbgsym-packages; do
      install -Dm755 $bin -t $out/bin
    done

    install -Dm644 find-dbgsym-packages-templates/* -t $out/share/debian-goodies/find-dbgsym-packages-templates/

    installShellCompletion --bash \
      debmany/bash_completion/debmany \
      debian/bash-completion

    installManPage \
      *.1 \
      debmany/man/*.1 \
      *.8

    runHook postInstall
  '';

  meta = with lib; {
    description = "Small toolbox-style utilities for Debian systems";
    homepage = "https://salsa.debian.org/debian/debian-goodies";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
