{ stdenv
, qmake
, fetchFromGitHub
, fetchFromGitLab
, libusb1 
, hidapi
, qt5
, wrapQtAppsHook
, makeWrapper
, hicolor-icon-theme
, openrazer-daemon
}:
stdenv.mkDerivation rec {
  pname = "openrgb";
  version = "unstable-${date}";

  date = "2020-03-03";

  src = fetchFromGitHub {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "d7298cafd02232a4da3843a5e6c810cb2ccd99f4";
    sha256 = "0gjj8z3574dxx41d38khhq91c6g2z5jiws5k9hg0lryks97341ak";
    fetchSubmodules = true;
  };

  buildInputs = [ libusb1 hidapi wrapQtAppsHook ];

  propagatedBuildInputs = [ hicolor-icon-theme openrazer-daemon ];

  nativeBuildInputs = [ qmake makeWrapper ];

  postPatch = ''
    substituteInPlace OpenRGB.pro \
      --replace '$$system(git --git-dir $$_PRO_FILE_PWD_/.git --work-tree $$_PRO_FILE_PWD_ rev-parse HEAD)' "${src.rev}" \
      --replace '$$system(git --git-dir $$_PRO_FILE_PWD_/.git --work-tree $$_PRO_FILE_PWD_ show -s --format=%ci HEAD)' "${date}" \
      --replace '$$system(git --git-dir $$_PRO_FILE_PWD_/.git --work-tree $$_PRO_FILE_PWD_ rev-parse --abbrev-ref HEAD)' "master"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 OpenRGB $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Open source RGB lighting control that doesn't depend on manufacturer software.";
    maintainers = with maintainers; [ evanjs ];
    longDescription = ''
      The goal of this project is to create an easy-to-use open source
      software program and library for accessing and controlling
      RGB lights on various PC hardware including motherboards,
      RAM modules, graphics cards, cooling devices, and peripherals.
    '';
  };
}
