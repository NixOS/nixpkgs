{
  lib,
  buildGoModule,
  fetchFromSourcehut,
}:

buildGoModule rec {
  pname = "qcal";
  version = "0.9.3";
  src = fetchFromSourcehut {
    owner = "~psic4t";
    repo = "qcal";
    rev = version;
    hash = "sha256-VnUbell8/9nnx+FBfXSV+jwQ4SwaX0kzZsp9MeD8uT4=";
  };
  vendorHash = null;

  # Replace "config-sample.json" in error message with the absolute path
  # to that config file in the nix store
  preBuild = ''
    substituteInPlace helpers.go \
      --replace-fail " config-sample.json " " $out/share/qcal/config-sample.json "
  '';

  postInstall = ''
    mkdir -p $out/share/qcal
    cp config-sample.json $out/share/qcal/
  '';

  meta = with lib; {
    description = "CLI calendar application for CalDAV servers written in Go";
    homepage = "https://git.sr.ht/~psic4t/qcal";
    changelog = "https://git.sr.ht/~psic4t/qcal/refs/${version}";
    license = licenses.gpl3;
    mainProgram = "qcal";
    maintainers = with maintainers; [ antonmosich ];
  };
}
