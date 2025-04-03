{
  stdenv,
  lib,
  fetchFromGitHub,
  nautilus-python,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "code-nautilus";
  version = "0-unstable-2024-09-11";

  src = fetchFromGitHub {
    owner = "harry-cpp";
    repo = "code-nautilus";
    rev = "8ea0ce78f3f1f7a6af5f9e9cf93fc3e70015f61e";
    sha256 = "u10laS3BwUVCJYlQ6WivU7o/sFFv6cTeV+uxBEdD7oA=";
  };

  buildInputs = [
    nautilus-python
    python3.pkgs.pygobject3
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 ./code-nautilus.py -t $out/share/nautilus-python/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "VSCode extension for Nautilus: 'Open in Code'";
    homepage = "https://github.com/harry-cpp/code-nautilus";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berrij ];
  };

}
