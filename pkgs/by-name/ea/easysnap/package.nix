{
  lib,
  stdenv,
  fetchFromGitHub,
  zfs,
}:

stdenv.mkDerivation {
  pname = "easysnap";
  version = "unstable-2022-06-03";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "5f961442315a6f7eb8ca5b705bd52fe1e6d7dc42";
    sha256 = "sha256-jiKdpwuw0Oil0sxUr/3KJ6Nbfxh8DvBei0yy0nRM+Vs=";
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
