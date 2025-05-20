{
  lib,
  stdenv,
  fetchFromGitHub,
  zfs,
}:

stdenv.mkDerivation {
  pname = "easysnap";
  version = "unstable-2025-05-20";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "f9b2b65e5469f295bdd9515d464ce709c969c95a";
    sha256 = "sha256-+1zXypl3fcF2Y/VnLBz+T8Mf94Eu7bqnqoHEjIUpy+U=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp easysnap* $out/bin/

    for i in $out/bin/*; do
      substituteInPlace $i \
        --replace zfs ${zfs}/bin/zfs
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/sjau/easysnap";
    description = "Customizable ZFS Snapshotting tool with zfs send/recv pulling";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sjau ];
  };

}
