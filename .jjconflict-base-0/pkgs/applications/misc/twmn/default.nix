{ lib, mkDerivation, fetchFromGitHub, qtbase, qtx11extras, qmake, pkg-config, boost }:

mkDerivation {
  pname = "twmn";
  version = "unstable-2018-10-01";

  src = fetchFromGitHub {
    owner = "sboli";
    repo = "twmn";
    rev = "80f48834ef1a07087505b82358308ee2374b6dfb";
    sha256 = "0mpjvp800x07lp9i3hfcc5f4bqj1fj4w3dyr0zwaxc6wqmm0fdqz";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ qtbase qtx11extras boost ];

  postPatch = ''
    sed -i s/-Werror// twmnd/twmnd.pro
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp bin/* "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Notification system for tiling window managers";
    homepage = "https://github.com/sboli/twmn";
    platforms = with lib.platforms; linux;
    maintainers = [ lib.maintainers.matejc ];
    license = lib.licenses.lgpl3;
  };
}
