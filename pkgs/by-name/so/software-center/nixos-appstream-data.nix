{
  set ? "all",
  stdenv,
  fetchFromGitHub,
  appstream,
}:
stdenv.mkDerivation {
  pname = "nixos-appstream-data";
  version = "0.0.1";

  buildInputs = [
    appstream
  ];

  src = fetchFromGitHub {
    owner = "korfuri";
    repo = "nixos-appstream-data";
    rev = "flake";
    hash = "sha256-XE7gr+zU3N4SHPAhsgk8cVAFp1iBg+Lxxp3y4dUF1vE=";
  };

  installPhase = ''
    runHook	preInstall
    ./build.sh	${set}
    mkdir	-p	$out/share/app-info/{icons/nixos,xmls}
    cp	dest/*.gz	$out/share/app-info/xmls/
    cp	-r	dest/icons/64x64	$out/share/app-info/icons/nixos/
    cp	-r	dest/icons/128x128	$out/share/app-info/icons/nixos/
    runHook	postInstall
  '';
}
